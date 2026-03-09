// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyAdapter extends TypeAdapter<Property> {
  @override
  final int typeId = 24;

  @override
  Property read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Property(
      id: fields[0] as String,
      userId: fields[1] as String,
      address: fields[2] as String,
      type: fields[3] as PropertyType,
      purchasePrice: fields[4] as double,
      currentValue: fields[5] as double,
      mortgageBalance: fields[6] as double?,
      rentalIncome: fields[7] as double?,
      purchaseDate: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Property obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.purchasePrice)
      ..writeByte(5)
      ..write(obj.currentValue)
      ..writeByte(6)
      ..write(obj.mortgageBalance)
      ..writeByte(7)
      ..write(obj.rentalIncome)
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
      other is PropertyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PropertyTypeAdapter extends TypeAdapter<PropertyType> {
  @override
  final int typeId = 25;

  @override
  PropertyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PropertyType.residential;
      case 1:
        return PropertyType.commercial;
      case 2:
        return PropertyType.land;
      case 3:
        return PropertyType.rental;
      default:
        return PropertyType.residential;
    }
  }

  @override
  void write(BinaryWriter writer, PropertyType obj) {
    switch (obj) {
      case PropertyType.residential:
        writer.writeByte(0);
        break;
      case PropertyType.commercial:
        writer.writeByte(1);
        break;
      case PropertyType.land:
        writer.writeByte(2);
        break;
      case PropertyType.rental:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
