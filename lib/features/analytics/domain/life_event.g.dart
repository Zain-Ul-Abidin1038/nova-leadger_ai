// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LifeEventAdapter extends TypeAdapter<LifeEvent> {
  @override
  final int typeId = 7;

  @override
  LifeEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LifeEvent(
      id: fields[0] as String,
      type: fields[1] as String,
      description: fields[2] as String,
      detectedAt: fields[3] as DateTime,
      confidence: fields[4] as double,
      metadata: (fields[5] as Map).cast<String, dynamic>(),
      acknowledged: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LifeEvent obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.detectedAt)
      ..writeByte(4)
      ..write(obj.confidence)
      ..writeByte(5)
      ..write(obj.metadata)
      ..writeByte(6)
      ..write(obj.acknowledged);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LifeEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
