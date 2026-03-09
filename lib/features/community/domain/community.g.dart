// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommunityPostAdapter extends TypeAdapter<CommunityPost> {
  @override
  final int typeId = 47;

  @override
  CommunityPost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommunityPost(
      id: fields[0] as String,
      authorName: fields[1] as String,
      title: fields[2] as String,
      content: fields[3] as String,
      category: fields[4] as PostCategory,
      createdAt: fields[5] as DateTime,
      likes: fields[6] as int,
      comments: fields[7] as int,
      isAnonymous: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CommunityPost obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.authorName)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.likes)
      ..writeByte(7)
      ..write(obj.comments)
      ..writeByte(8)
      ..write(obj.isAnonymous);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommunityPostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinancialBenchmarkAdapter extends TypeAdapter<FinancialBenchmark> {
  @override
  final int typeId = 49;

  @override
  FinancialBenchmark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinancialBenchmark(
      category: fields[0] as String,
      userValue: fields[1] as double,
      communityAverage: fields[2] as double,
      percentile: fields[3] as double,
      insight: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FinancialBenchmark obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.userValue)
      ..writeByte(2)
      ..write(obj.communityAverage)
      ..writeByte(3)
      ..write(obj.percentile)
      ..writeByte(4)
      ..write(obj.insight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialBenchmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeAdapter extends TypeAdapter<Challenge> {
  @override
  final int typeId = 50;

  @override
  Challenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Challenge(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as ChallengeType,
      targetAmount: fields[4] as double,
      durationDays: fields[5] as int,
      startDate: fields[6] as DateTime,
      participants: fields[7] as int,
      isJoined: fields[8] as bool,
      currentProgress: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Challenge obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.targetAmount)
      ..writeByte(5)
      ..write(obj.durationDays)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.participants)
      ..writeByte(8)
      ..write(obj.isJoined)
      ..writeByte(9)
      ..write(obj.currentProgress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostCategoryAdapter extends TypeAdapter<PostCategory> {
  @override
  final int typeId = 48;

  @override
  PostCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PostCategory.budgeting;
      case 1:
        return PostCategory.investing;
      case 2:
        return PostCategory.taxes;
      case 3:
        return PostCategory.debt;
      case 4:
        return PostCategory.savings;
      case 5:
        return PostCategory.general;
      default:
        return PostCategory.budgeting;
    }
  }

  @override
  void write(BinaryWriter writer, PostCategory obj) {
    switch (obj) {
      case PostCategory.budgeting:
        writer.writeByte(0);
        break;
      case PostCategory.investing:
        writer.writeByte(1);
        break;
      case PostCategory.taxes:
        writer.writeByte(2);
        break;
      case PostCategory.debt:
        writer.writeByte(3);
        break;
      case PostCategory.savings:
        writer.writeByte(4);
        break;
      case PostCategory.general:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeTypeAdapter extends TypeAdapter<ChallengeType> {
  @override
  final int typeId = 51;

  @override
  ChallengeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChallengeType.savings;
      case 1:
        return ChallengeType.noSpend;
      case 2:
        return ChallengeType.debtPayoff;
      case 3:
        return ChallengeType.budgetStreak;
      default:
        return ChallengeType.savings;
    }
  }

  @override
  void write(BinaryWriter writer, ChallengeType obj) {
    switch (obj) {
      case ChallengeType.savings:
        writer.writeByte(0);
        break;
      case ChallengeType.noSpend:
        writer.writeByte(1);
        break;
      case ChallengeType.debtPayoff:
        writer.writeByte(2);
        break;
      case ChallengeType.budgetStreak:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
