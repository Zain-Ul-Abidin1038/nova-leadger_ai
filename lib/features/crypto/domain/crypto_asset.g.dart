// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_asset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CryptoAssetAdapter extends TypeAdapter<CryptoAsset> {
  @override
  final int typeId = 23;

  @override
  CryptoAsset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CryptoAsset(
      id: fields[0] as String,
      userId: fields[1] as String,
      symbol: fields[2] as String,
      name: fields[3] as String,
      quantity: fields[4] as double,
      purchasePrice: fields[5] as double,
      currentPrice: fields[6] as double,
      walletAddress: fields[7] as String?,
      purchaseDate: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CryptoAsset obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.symbol)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.purchasePrice)
      ..writeByte(6)
      ..write(obj.currentPrice)
      ..writeByte(7)
      ..write(obj.walletAddress)
      ..writeByte(8)
      ..write(obj.purchaseDate)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CryptoAssetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
