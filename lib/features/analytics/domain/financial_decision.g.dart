// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_decision.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinancialDecisionAdapter extends TypeAdapter<FinancialDecision> {
  @override
  final int typeId = 6;

  @override
  FinancialDecision read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinancialDecision(
      id: fields[0] as String,
      type: fields[1] as String,
      message: fields[2] as String,
      priority: fields[3] as int,
      timestamp: fields[4] as DateTime,
      metadata: (fields[5] as Map).cast<String, dynamic>(),
      dismissed: fields[6] as bool,
      accepted: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FinancialDecision obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.metadata)
      ..writeByte(6)
      ..write(obj.dismissed)
      ..writeByte(7)
      ..write(obj.accepted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialDecisionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
