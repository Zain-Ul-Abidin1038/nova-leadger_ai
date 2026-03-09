// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LedgerEntryAdapter extends TypeAdapter<LedgerEntry> {
  @override
  final int typeId = 13;

  @override
  LedgerEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LedgerEntry(
      id: fields[0] as String,
      amount: fields[1] as double,
      personOrCompany: fields[2] as String,
      description: fields[3] as String,
      createdAt: fields[4] as DateTime,
      dueDate: fields[5] as DateTime?,
      type: fields[6] as LedgerType,
      isPaid: fields[7] as bool,
      paidAt: fields[8] as DateTime?,
      notes: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LedgerEntry obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.personOrCompany)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.isPaid)
      ..writeByte(8)
      ..write(obj.paidAt)
      ..writeByte(9)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LedgerEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LedgerTypeAdapter extends TypeAdapter<LedgerType> {
  @override
  final int typeId = 12;

  @override
  LedgerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LedgerType.receivable;
      case 1:
        return LedgerType.payable;
      default:
        return LedgerType.receivable;
    }
  }

  @override
  void write(BinaryWriter writer, LedgerType obj) {
    switch (obj) {
      case LedgerType.receivable:
        writer.writeByte(0);
        break;
      case LedgerType.payable:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LedgerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
