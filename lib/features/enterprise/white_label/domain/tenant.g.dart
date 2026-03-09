// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TenantAdapter extends TypeAdapter<Tenant> {
  @override
  final int typeId = 42;

  @override
  Tenant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tenant(
      id: fields[0] as String,
      name: fields[1] as String,
      domain: fields[2] as String,
      branding: fields[3] as BrandConfig,
      enabledFeatures: (fields[4] as List).cast<String>(),
      createdAt: fields[5] as DateTime,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Tenant obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.domain)
      ..writeByte(3)
      ..write(obj.branding)
      ..writeByte(4)
      ..write(obj.enabledFeatures)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TenantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BrandConfigAdapter extends TypeAdapter<BrandConfig> {
  @override
  final int typeId = 43;

  @override
  BrandConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrandConfig(
      logoUrl: fields[0] as String,
      primaryColor: fields[1] as String,
      secondaryColor: fields[2] as String,
      appName: fields[3] as String,
      tagline: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BrandConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.logoUrl)
      ..writeByte(1)
      ..write(obj.primaryColor)
      ..writeByte(2)
      ..write(obj.secondaryColor)
      ..writeByte(3)
      ..write(obj.appName)
      ..writeByte(4)
      ..write(obj.tagline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
