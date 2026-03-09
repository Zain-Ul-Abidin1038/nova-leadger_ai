import 'package:hive/hive.dart';

part 'advisor.g.dart';

@HiveType(typeId: 44)
class FinancialAdvisor extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String specialty;

  @HiveField(3)
  final String bio;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  final int reviewCount;

  @HiveField(6)
  final double hourlyRate;

  @HiveField(7)
  final List<String> certifications;

  @HiveField(8)
  final int yearsExperience;

  @HiveField(9)
  final bool isAvailable;

  @HiveField(10)
  final String profileImage;

  FinancialAdvisor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.bio,
    required this.rating,
    required this.reviewCount,
    required this.hourlyRate,
    required this.certifications,
    required this.yearsExperience,
    required this.isAvailable,
    this.profileImage = '',
  });
}

@HiveType(typeId: 45)
class AdvisorBooking extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String advisorId;

  @HiveField(2)
  final String advisorName;

  @HiveField(3)
  final DateTime scheduledDate;

  @HiveField(4)
  final int durationMinutes;

  @HiveField(5)
  final String topic;

  @HiveField(6)
  final BookingStatus status;

  @HiveField(7)
  final double cost;

  @HiveField(8)
  final String? meetingLink;

  AdvisorBooking({
    required this.id,
    required this.advisorId,
    required this.advisorName,
    required this.scheduledDate,
    required this.durationMinutes,
    required this.topic,
    required this.status,
    required this.cost,
    this.meetingLink,
  });
}

@HiveType(typeId: 46)
enum BookingStatus {
  @HiveField(0)
  scheduled,
  @HiveField(1)
  completed,
  @HiveField(2)
  cancelled,
  @HiveField(3)
  noShow,
}
