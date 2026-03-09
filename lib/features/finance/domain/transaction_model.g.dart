// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinancialTransactionAdapter extends TypeAdapter<FinancialTransaction> {
  @override
  final int typeId = 2;

  @override
  FinancialTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinancialTransaction(
      id: fields[0] as String,
      amount: fields[1] as double,
      type: fields[2] as String,
      category: fields[3] as String,
      description: fields[4] as String?,
      personName: fields[5] as String?,
      date: fields[6] as DateTime,
      isPaid: fields[7] as bool,
      receiptId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FinancialTransaction obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.personName)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.isPaid)
      ..writeByte(8)
      ..write(obj.receiptId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
