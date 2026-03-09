// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportAdapter extends TypeAdapter<Report> {
  @override
  final int typeId = 39;

  @override
  Report read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Report(
      id: fields[0] as String,
      businessEntityId: fields[1] as String,
      name: fields[2] as String,
      type: fields[3] as ReportType,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      createdBy: fields[6] as String,
      createdAt: fields[7] as DateTime,
      data: (fields[8] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Report obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessEntityId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.createdBy)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReportTypeAdapter extends TypeAdapter<ReportType> {
  @override
  final int typeId = 40;

  @override
  ReportType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReportType.expense;
      case 1:
        return ReportType.income;
      case 2:
        return ReportType.profitLoss;
      case 3:
        return ReportType.cashFlow;
      case 4:
        return ReportType.tax;
      case 5:
        return ReportType.custom;
      default:
        return ReportType.expense;
    }
  }

  @override
  void write(BinaryWriter writer, ReportType obj) {
    switch (obj) {
      case ReportType.expense:
        writer.writeByte(0);
        break;
      case ReportType.income:
        writer.writeByte(1);
        break;
      case ReportType.profitLoss:
        writer.writeByte(2);
        break;
      case ReportType.cashFlow:
        writer.writeByte(3);
        break;
      case ReportType.tax:
        writer.writeByte(4);
        break;
      case ReportType.custom:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
