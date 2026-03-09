import 'package:hive_flutter/hive_flutter.dart';

part 'receipt.g.dart';

@HiveType(typeId: 4)
class Receipt {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String vendor;

  @HiveField(2)
  final double total;

  @HiveField(3)
  final double tax;

  @HiveField(4)
  final String currency;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final double alcoholAmount;

  @HiveField(7)
  final double deductibleAmount;

  @HiveField(8)
  final double confidence;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final bool requiresReview;

  @HiveField(11)
  final String? notes;

  @HiveField(12)
  final String? imagePath;

  @HiveField(13)
  final bool isApproved;

  @HiveField(14)
  final String? thoughtSignature;

  @HiveField(15)
  final String? thoughtSummary;

  @HiveField(16)
  final List<Map<String, dynamic>>? verificationSteps;

  // Alias for createdAt to support timestamp usage
  DateTime get timestamp => createdAt;

  Receipt({
    required this.id,
    required this.vendor,
    required this.total,
    required this.tax,
    required this.currency,
    required this.category,
    required this.alcoholAmount,
    required this.deductibleAmount,
    required this.confidence,
    required this.createdAt,
    required this.requiresReview,
    this.notes,
    this.imagePath,
    this.isApproved = false,
    this.thoughtSignature,
    this.thoughtSummary,
    this.verificationSteps,
  });

  Receipt copyWith({
    String? id,
    String? vendor,
    double? total,
    double? tax,
    String? currency,
    String? category,
    double? alcoholAmount,
    double? deductibleAmount,
    double? confidence,
    DateTime? createdAt,
    bool? requiresReview,
    String? notes,
    String? imagePath,
    bool? isApproved,
    String? thoughtSignature,
    String? thoughtSummary,
    List<Map<String, dynamic>>? verificationSteps,
  }) {
    return Receipt(
      id: id ?? this.id,
      vendor: vendor ?? this.vendor,
      total: total ?? this.total,
      tax: tax ?? this.tax,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      alcoholAmount: alcoholAmount ?? this.alcoholAmount,
      deductibleAmount: deductibleAmount ?? this.deductibleAmount,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      requiresReview: requiresReview ?? this.requiresReview,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      isApproved: isApproved ?? this.isApproved,
      thoughtSignature: thoughtSignature ?? this.thoughtSignature,
      thoughtSummary: thoughtSummary ?? this.thoughtSummary,
      verificationSteps: verificationSteps ?? this.verificationSteps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor': vendor,
      'total': total,
      'tax': tax,
      'currency': currency,
      'category': category,
      'alcoholAmount': alcoholAmount,
      'deductibleAmount': deductibleAmount,
      'confidence': confidence,
      'createdAt': createdAt.toIso8601String(),
      'requiresReview': requiresReview,
      'notes': notes,
      'imagePath': imagePath,
      'isApproved': isApproved,
      'thoughtSignature': thoughtSignature,
      'thoughtSummary': thoughtSummary,
      'verificationSteps': verificationSteps,
    };
  }

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'] as String,
      vendor: json['vendor'] as String,
      total: (json['total'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      currency: json['currency'] as String,
      category: json['category'] as String,
      alcoholAmount: (json['alcoholAmount'] as num).toDouble(),
      deductibleAmount: (json['deductibleAmount'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      requiresReview: json['requiresReview'] as bool,
      notes: json['notes'] as String?,
      imagePath: json['imagePath'] as String?,
      isApproved: json['isApproved'] as bool? ?? false,
      thoughtSignature: json['thoughtSignature'] as String?,
      thoughtSummary: json['thoughtSummary'] as String?,
      verificationSteps: (json['verificationSteps'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }
}
