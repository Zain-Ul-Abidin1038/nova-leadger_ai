// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiKeyAdapter extends TypeAdapter<ApiKey> {
  @override
  final int typeId = 41;

  @override
  ApiKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiKey(
      id: fields[0] as String,
      businessEntityId: fields[1] as String,
      name: fields[2] as String,
      keyHash: fields[3] as String,
      permissions: (fields[4] as List).cast<String>(),
      createdAt: fields[5] as DateTime,
      expiresAt: fields[6] as DateTime?,
      isActive: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ApiKey obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessEntityId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.keyHash)
      ..writeByte(4)
      ..write(obj.permissions)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.expiresAt)
      ..writeByte(7)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
