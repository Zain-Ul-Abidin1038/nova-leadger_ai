// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FamilyAccountAdapter extends TypeAdapter<FamilyAccount> {
  @override
  final int typeId = 28;

  @override
  FamilyAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FamilyAccount(
      id: fields[0] as String,
      name: fields[1] as String,
      createdBy: fields[2] as String,
      memberIds: (fields[3] as List).cast<String>(),
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FamilyAccount obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.createdBy)
      ..writeByte(3)
      ..write(obj.memberIds)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FamilyMemberAdapter extends TypeAdapter<FamilyMember> {
  @override
  final int typeId = 29;

  @override
  FamilyMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FamilyMember(
      id: fields[0] as String,
      familyAccountId: fields[1] as String,
      userId: fields[2] as String,
      name: fields[3] as String,
      role: fields[4] as FamilyRole,
      allowance: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, FamilyMember obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.familyAccountId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.allowance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FamilyRoleAdapter extends TypeAdapter<FamilyRole> {
  @override
  final int typeId = 30;

  @override
  FamilyRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FamilyRole.admin;
      case 1:
        return FamilyRole.parent;
      case 2:
        return FamilyRole.child;
      case 3:
        return FamilyRole.viewer;
      default:
        return FamilyRole.admin;
    }
  }

  @override
  void write(BinaryWriter writer, FamilyRole obj) {
    switch (obj) {
      case FamilyRole.admin:
        writer.writeByte(0);
        break;
      case FamilyRole.parent:
        writer.writeByte(1);
        break;
      case FamilyRole.child:
        writer.writeByte(2);
        break;
      case FamilyRole.viewer:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
