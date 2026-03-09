// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_audit_logger.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AIAuditRecordAdapter extends TypeAdapter<AIAuditRecord> {
  @override
  final int typeId = 5;

  @override
  AIAuditRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AIAuditRecord(
      timestamp: fields[0] as DateTime,
      action: fields[1] as String,
      model: fields[2] as String,
      inputSummary: fields[3] as String,
      outputSummary: fields[4] as String,
      tokenCount: fields[5] as int,
      cost: fields[6] as double,
      thoughtSignature: fields[7] as String?,
      success: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AIAuditRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.action)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.inputSummary)
      ..writeByte(4)
      ..write(obj.outputSummary)
      ..writeByte(5)
      ..write(obj.tokenCount)
      ..writeByte(6)
      ..write(obj.cost)
      ..writeByte(7)
      ..write(obj.thoughtSignature)
      ..writeByte(8)
      ..write(obj.success);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIAuditRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
