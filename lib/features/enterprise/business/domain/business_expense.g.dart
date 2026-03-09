// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessExpenseAdapter extends TypeAdapter<BusinessExpense> {
  @override
  final int typeId = 34;

  @override
  BusinessExpense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessExpense(
      id: fields[0] as String,
      businessEntityId: fields[1] as String,
      department: fields[2] as String,
      project: fields[3] as String,
      category: fields[4] as String,
      amount: fields[5] as double,
      description: fields[6] as String,
      submittedBy: fields[7] as String,
      status: fields[8] as ApprovalStatus,
      submittedAt: fields[9] as DateTime,
      receiptUrl: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessExpense obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessEntityId)
      ..writeByte(2)
      ..write(obj.department)
      ..writeByte(3)
      ..write(obj.project)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.submittedBy)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.submittedAt)
      ..writeByte(10)
      ..write(obj.receiptUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApprovalStatusAdapter extends TypeAdapter<ApprovalStatus> {
  @override
  final int typeId = 35;

  @override
  ApprovalStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ApprovalStatus.pending;
      case 1:
        return ApprovalStatus.approved;
      case 2:
        return ApprovalStatus.rejected;
      case 3:
        return ApprovalStatus.needsReview;
      default:
        return ApprovalStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, ApprovalStatus obj) {
    switch (obj) {
      case ApprovalStatus.pending:
        writer.writeByte(0);
        break;
      case ApprovalStatus.approved:
        writer.writeByte(1);
        break;
      case ApprovalStatus.rejected:
        writer.writeByte(2);
        break;
      case ApprovalStatus.needsReview:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApprovalStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
