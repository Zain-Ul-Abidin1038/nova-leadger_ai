// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamAdapter extends TypeAdapter<Team> {
  @override
  final int typeId = 36;

  @override
  Team read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Team(
      id: fields[0] as String,
      businessEntityId: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      memberIds: (fields[4] as List).cast<String>(),
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Team obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessEntityId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.memberIds)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamMemberAdapter extends TypeAdapter<TeamMember> {
  @override
  final int typeId = 37;

  @override
  TeamMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamMember(
      id: fields[0] as String,
      teamId: fields[1] as String,
      userId: fields[2] as String,
      name: fields[3] as String,
      role: fields[4] as TeamRole,
      joinedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TeamMember obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.teamId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.joinedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamRoleAdapter extends TypeAdapter<TeamRole> {
  @override
  final int typeId = 38;

  @override
  TeamRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TeamRole.owner;
      case 1:
        return TeamRole.admin;
      case 2:
        return TeamRole.member;
      case 3:
        return TeamRole.viewer;
      default:
        return TeamRole.owner;
    }
  }

  @override
  void write(BinaryWriter writer, TeamRole obj) {
    switch (obj) {
      case TeamRole.owner:
        writer.writeByte(0);
        break;
      case TeamRole.admin:
        writer.writeByte(1);
        break;
      case TeamRole.member:
        writer.writeByte(2);
        break;
      case TeamRole.viewer:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
