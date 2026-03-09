// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedGoalAdapter extends TypeAdapter<SharedGoal> {
  @override
  final int typeId = 31;

  @override
  SharedGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedGoal(
      id: fields[0] as String,
      familyAccountId: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      targetAmount: fields[4] as double,
      currentAmount: fields[5] as double,
      deadline: fields[6] as DateTime,
      createdAt: fields[7] as DateTime,
      contributorIds: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SharedGoal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.familyAccountId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.targetAmount)
      ..writeByte(5)
      ..write(obj.currentAmount)
      ..writeByte(6)
      ..write(obj.deadline)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.contributorIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
