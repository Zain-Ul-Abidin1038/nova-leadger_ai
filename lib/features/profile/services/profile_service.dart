import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Profile model
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String company;
  final String taxId;

  UserProfile({
    required this.name,
    required this.email,
    this.phone = '',
    this.company = '',
    this.taxId = '',
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'company': company,
    'taxId': taxId,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] ?? 'Ghost User',
    email: json['email'] ?? 'user@example.com',
    phone: json['phone'] ?? '',
    company: json['company'] ?? '',
    taxId: json['taxId'] ?? '',
  );

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? company,
    String? taxId,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      taxId: taxId ?? this.taxId,
    );
  }
}

// Profile service provider
final profileServiceProvider = NotifierProvider<ProfileService, UserProfile>(() {
  return ProfileService();
});

class ProfileService extends Notifier<UserProfile> {
  static const String _boxName = 'profile';
  static const String _profileKey = 'user_profile';

  @override
  UserProfile build() {
    _loadProfile();
    return UserProfile(
      name: 'Ghost User',
      email: 'user@example.com',
    );
  }

  Future<void> _loadProfile() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_profileKey);
      if (data != null && data is Map) {
        state = UserProfile.fromJson(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      // Keep default profile if loading fails
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? company,
    String? taxId,
  }) async {
    state = state.copyWith(
      name: name,
      email: email,
      phone: phone,
      company: company,
      taxId: taxId,
    );
    await _saveProfile();
  }

  Future<void> _saveProfile() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_profileKey, state.toJson());
    } catch (e) {
      // Silently fail if save fails
    }
  }

  Future<void> clearProfile() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.delete(_profileKey);
      state = UserProfile(
        name: 'Ghost User',
        email: 'user@example.com',
      );
    } catch (e) {
      // Silently fail
    }
  }
}
