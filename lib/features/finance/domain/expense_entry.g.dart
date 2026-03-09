// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseEntryAdapter extends TypeAdapter<ExpenseEntry> {
  @override
  final int typeId = 11;

  @override
  ExpenseEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseEntry(
      id: fields[0] as String,
      amount: fields[1] as double,
      vendor: fields[2] as String,
      description: fields[3] as String,
      timestamp: fields[4] as DateTime,
      category: fields[5] as String,
      notes: fields[6] as String?,
      location: fields[7] as String?,
      receiptImagePath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseEntry obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.vendor)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.receiptImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
