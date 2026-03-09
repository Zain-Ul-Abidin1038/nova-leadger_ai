// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvestmentAdapter extends TypeAdapter<Investment> {
  @override
  final int typeId = 21;

  @override
  Investment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Investment(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as InvestmentType,
      symbol: fields[3] as String,
      name: fields[4] as String,
      quantity: fields[5] as double,
      purchasePrice: fields[6] as double,
      currentPrice: fields[7] as double,
      purchaseDate: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
      notes: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Investment obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.symbol)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.purchasePrice)
      ..writeByte(7)
      ..write(obj.currentPrice)
      ..writeByte(8)
      ..write(obj.purchaseDate)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvestmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InvestmentTypeAdapter extends TypeAdapter<InvestmentType> {
  @override
  final int typeId = 22;

  @override
  InvestmentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InvestmentType.stock;
      case 1:
        return InvestmentType.mutualFund;
      case 2:
        return InvestmentType.bond;
      case 3:
        return InvestmentType.etf;
      case 4:
        return InvestmentType.commodity;
      default:
        return InvestmentType.stock;
    }
  }

  @override
  void write(BinaryWriter writer, InvestmentType obj) {
    switch (obj) {
      case InvestmentType.stock:
        writer.writeByte(0);
        break;
      case InvestmentType.mutualFund:
        writer.writeByte(1);
        break;
      case InvestmentType.bond:
        writer.writeByte(2);
        break;
      case InvestmentType.etf:
        writer.writeByte(3);
        break;
      case InvestmentType.commodity:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvestmentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
