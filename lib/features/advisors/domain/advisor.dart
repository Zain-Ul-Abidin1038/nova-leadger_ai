// Financial advisor domain models

class FinancialAdvisor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final double hourlyRate;
  final String bio;
  final bool isAvailable;
  final List<String> certifications;
  final int yearsExperience;

  FinancialAdvisor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    this.reviewCount = 0,
    required this.hourlyRate,
    required this.bio,
    this.isAvailable = true,
    this.certifications = const [],
    this.yearsExperience = 0,
  });
}

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class AdvisorBooking {
  final String id;
  final String advisorId;
  final String advisorName;
  final String userId;
  final DateTime scheduledAt;
  final DateTime scheduledDate;
  final BookingStatus status;
  final int durationMinutes;
  final String topic;
  final double cost;
  final String meetingLink;

  AdvisorBooking({
    required this.id,
    required this.advisorId,
    required this.advisorName,
    String? userId,
    DateTime? scheduledAt,
    DateTime? scheduledDate,
    required this.status,
    this.durationMinutes = 60,
    this.topic = 'Financial Consultation',
    this.cost = 0.0,
    this.meetingLink = '',
  }) : userId = userId ?? 'current_user',
       scheduledAt = scheduledAt ?? DateTime.now(),
       scheduledDate = scheduledDate ?? (scheduledAt ?? DateTime.now());
}
