// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advisor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinancialAdvisorAdapter extends TypeAdapter<FinancialAdvisor> {
  @override
  final int typeId = 44;

  @override
  FinancialAdvisor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinancialAdvisor(
      id: fields[0] as String,
      name: fields[1] as String,
      specialty: fields[2] as String,
      bio: fields[3] as String,
      rating: fields[4] as double,
      reviewCount: fields[5] as int,
      hourlyRate: fields[6] as double,
      certifications: (fields[7] as List).cast<String>(),
      yearsExperience: fields[8] as int,
      isAvailable: fields[9] as bool,
      profileImage: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FinancialAdvisor obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.specialty)
      ..writeByte(3)
      ..write(obj.bio)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.reviewCount)
      ..writeByte(6)
      ..write(obj.hourlyRate)
      ..writeByte(7)
      ..write(obj.certifications)
      ..writeByte(8)
      ..write(obj.yearsExperience)
      ..writeByte(9)
      ..write(obj.isAvailable)
      ..writeByte(10)
      ..write(obj.profileImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialAdvisorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdvisorBookingAdapter extends TypeAdapter<AdvisorBooking> {
  @override
  final int typeId = 45;

  @override
  AdvisorBooking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdvisorBooking(
      id: fields[0] as String,
      advisorId: fields[1] as String,
      advisorName: fields[2] as String,
      scheduledDate: fields[3] as DateTime,
      durationMinutes: fields[4] as int,
      topic: fields[5] as String,
      status: fields[6] as BookingStatus,
      cost: fields[7] as double,
      meetingLink: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AdvisorBooking obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.advisorId)
      ..writeByte(2)
      ..write(obj.advisorName)
      ..writeByte(3)
      ..write(obj.scheduledDate)
      ..writeByte(4)
      ..write(obj.durationMinutes)
      ..writeByte(5)
      ..write(obj.topic)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.cost)
      ..writeByte(8)
      ..write(obj.meetingLink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdvisorBookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingStatusAdapter extends TypeAdapter<BookingStatus> {
  @override
  final int typeId = 46;

  @override
  BookingStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookingStatus.scheduled;
      case 1:
        return BookingStatus.completed;
      case 2:
        return BookingStatus.cancelled;
      case 3:
        return BookingStatus.noShow;
      default:
        return BookingStatus.scheduled;
    }
  }

  @override
  void write(BinaryWriter writer, BookingStatus obj) {
    switch (obj) {
      case BookingStatus.scheduled:
        writer.writeByte(0);
        break;
      case BookingStatus.completed:
        writer.writeByte(1);
        break;
      case BookingStatus.cancelled:
        writer.writeByte(2);
        break;
      case BookingStatus.noShow:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
