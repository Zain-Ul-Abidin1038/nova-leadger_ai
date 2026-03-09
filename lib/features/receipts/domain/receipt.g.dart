// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceiptAdapter extends TypeAdapter<Receipt> {
  @override
  final int typeId = 4;

  @override
  Receipt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Receipt(
      id: fields[0] as String,
      vendor: fields[1] as String,
      total: fields[2] as double,
      tax: fields[3] as double,
      currency: fields[4] as String,
      category: fields[5] as String,
      alcoholAmount: fields[6] as double,
      deductibleAmount: fields[7] as double,
      confidence: fields[8] as double,
      createdAt: fields[9] as DateTime,
      requiresReview: fields[10] as bool,
      notes: fields[11] as String?,
      imagePath: fields[12] as String?,
      isApproved: fields[13] as bool,
      thoughtSignature: fields[14] as String?,
      thoughtSummary: fields[15] as String?,
      verificationSteps: (fields[16] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Receipt obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.vendor)
      ..writeByte(2)
      ..write(obj.total)
      ..writeByte(3)
      ..write(obj.tax)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.alcoholAmount)
      ..writeByte(7)
      ..write(obj.deductibleAmount)
      ..writeByte(8)
      ..write(obj.confidence)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.requiresReview)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.imagePath)
      ..writeByte(13)
      ..write(obj.isApproved)
      ..writeByte(14)
      ..write(obj.thoughtSignature)
      ..writeByte(15)
      ..write(obj.thoughtSummary)
      ..writeByte(16)
      ..write(obj.verificationSteps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
