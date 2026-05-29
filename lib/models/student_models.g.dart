// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentProfileAdapter extends TypeAdapter<StudentProfile> {
  @override
  final int typeId = 10;

  @override
  StudentProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      phone: fields[2] as String,
      avatar: fields[3] as String,
      classGrade: fields[4] as int,
      schoolName: fields[5] as String,
      stateCode: fields[6] as String,
      stateName: fields[7] as String,
      district: fields[8] as String,
      xp: fields[9] as int,
      streakDays: fields[10] as int,
      classRank: fields[11] as int,
      quizzesCompleted: fields[12] as int,
      badgeIds: (fields[13] as List).cast<String>(),
      language: fields[14] as String,
      accessToken: fields[15] as String,
      consentGiven: fields[16] as bool,
      parentalConsentGiven: fields[17] as bool,
      role: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudentProfile obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.avatar)
      ..writeByte(4)
      ..write(obj.classGrade)
      ..writeByte(5)
      ..write(obj.schoolName)
      ..writeByte(6)
      ..write(obj.stateCode)
      ..writeByte(7)
      ..write(obj.stateName)
      ..writeByte(8)
      ..write(obj.district)
      ..writeByte(9)
      ..write(obj.xp)
      ..writeByte(10)
      ..write(obj.streakDays)
      ..writeByte(11)
      ..write(obj.classRank)
      ..writeByte(12)
      ..write(obj.quizzesCompleted)
      ..writeByte(13)
      ..write(obj.badgeIds)
      ..writeByte(14)
      ..write(obj.language)
      ..writeByte(15)
      ..write(obj.accessToken)
      ..writeByte(16)
      ..write(obj.consentGiven)
      ..writeByte(17)
      ..write(obj.parentalConsentGiven)
      ..writeByte(18)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 11;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      id: fields[0] as String,
      name: fields[1] as String,
      emoji: fields[2] as String,
      colorHex: fields[3] as String,
      totalTopics: fields[4] as int,
      arTopics: fields[5] as int,
      progressPct: fields[6] as double,
      isAvailable: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.emoji)
      ..writeByte(3)
      ..write(obj.colorHex)
      ..writeByte(4)
      ..write(obj.totalTopics)
      ..writeByte(5)
      ..write(obj.arTopics)
      ..writeByte(6)
      ..write(obj.progressPct)
      ..writeByte(7)
      ..write(obj.isAvailable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopicAdapter extends TypeAdapter<Topic> {
  @override
  final int typeId = 12;

  @override
  Topic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Topic(
      id: fields[0] as String,
      name: fields[1] as String,
      subjectId: fields[2] as String,
      chapterName: fields[3] as String,
      hasAr: fields[4] as bool,
      hasQuiz: fields[5] as bool,
      durationMin: fields[6] as int,
      xpReward: fields[7] as int,
      progressPct: fields[8] as double,
      status: fields[9] as String,
      arAssetId: fields[10] as String?,
      quizId: fields[11] as String?,
      isCachedOffline: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Topic obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.subjectId)
      ..writeByte(3)
      ..write(obj.chapterName)
      ..writeByte(4)
      ..write(obj.hasAr)
      ..writeByte(5)
      ..write(obj.hasQuiz)
      ..writeByte(6)
      ..write(obj.durationMin)
      ..writeByte(7)
      ..write(obj.xpReward)
      ..writeByte(8)
      ..write(obj.progressPct)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.arAssetId)
      ..writeByte(11)
      ..write(obj.quizId)
      ..writeByte(12)
      ..write(obj.isCachedOffline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizQuestionAdapter extends TypeAdapter<QuizQuestion> {
  @override
  final int typeId = 13;

  @override
  QuizQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizQuestion(
      id: fields[0] as String,
      questionText: fields[1] as String,
      options: (fields[2] as List).cast<String>(),
      correctIndex: fields[3] as int,
      explanation: fields[4] as String?,
      hintText: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QuizQuestion obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionText)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.correctIndex)
      ..writeByte(4)
      ..write(obj.explanation)
      ..writeByte(5)
      ..write(obj.hintText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizAdapter extends TypeAdapter<Quiz> {
  @override
  final int typeId = 14;

  @override
  Quiz read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quiz(
      id: fields[0] as String,
      title: fields[1] as String,
      topicId: fields[2] as String,
      questions: (fields[3] as List).cast<QuizQuestion>(),
      timeLimitSeconds: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Quiz obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.topicId)
      ..writeByte(3)
      ..write(obj.questions)
      ..writeByte(4)
      ..write(obj.timeLimitSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BadgeAdapter extends TypeAdapter<Badge> {
  @override
  final int typeId = 15;

  @override
  Badge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Badge(
      id: fields[0] as String,
      title: fields[1] as String,
      emoji: fields[2] as String,
      description: fields[3] as String,
      isUnlocked: fields[4] as bool,
      unlockedAt: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Badge obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.emoji)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.isUnlocked)
      ..writeByte(5)
      ..write(obj.unlockedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
