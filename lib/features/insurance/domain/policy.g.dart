// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsurancePolicyAdapter extends TypeAdapter<InsurancePolicy> {
  @override
  final int typeId = 26;

  @override
  InsurancePolicy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsurancePolicy(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as PolicyType,
      provider: fields[3] as String,
      policyNumber: fields[4] as String,
      premium: fields[5] as double,
      coverage: fields[6] as double,
      expiryDate: fields[7] as DateTime,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, InsurancePolicy obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.provider)
      ..writeByte(4)
      ..write(obj.policyNumber)
      ..writeByte(5)
      ..write(obj.premium)
      ..writeByte(6)
      ..write(obj.coverage)
      ..writeByte(7)
      ..write(obj.expiryDate)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsurancePolicyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PolicyTypeAdapter extends TypeAdapter<PolicyType> {
  @override
  final int typeId = 27;

  @override
  PolicyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PolicyType.life;
      case 1:
        return PolicyType.health;
      case 2:
        return PolicyType.auto;
      case 3:
        return PolicyType.home;
      case 4:
        return PolicyType.travel;
      default:
        return PolicyType.life;
    }
  }

  @override
  void write(BinaryWriter writer, PolicyType obj) {
    switch (obj) {
      case PolicyType.life:
        writer.writeByte(0);
        break;
      case PolicyType.health:
        writer.writeByte(1);
        break;
      case PolicyType.auto:
        writer.writeByte(2);
        break;
      case PolicyType.home:
        writer.writeByte(3);
        break;
      case PolicyType.travel:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolicyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
