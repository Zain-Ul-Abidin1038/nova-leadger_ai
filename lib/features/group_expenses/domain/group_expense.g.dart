// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupExpenseAdapter extends TypeAdapter<GroupExpense> {
  @override
  final int typeId = 32;

  @override
  GroupExpense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupExpense(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      totalAmount: fields[3] as double,
      createdBy: fields[4] as String,
      participants: (fields[5] as List).cast<ExpenseParticipant>(),
      createdAt: fields[6] as DateTime,
      isSettled: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GroupExpense obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.participants)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.isSettled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenseParticipantAdapter extends TypeAdapter<ExpenseParticipant> {
  @override
  final int typeId = 33;

  @override
  ExpenseParticipant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseParticipant(
      userId: fields[0] as String,
      name: fields[1] as String,
      shareAmount: fields[2] as double,
      paid: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseParticipant obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.shareAmount)
      ..writeByte(3)
      ..write(obj.paid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseParticipantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
