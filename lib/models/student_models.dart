// lib/models/student_models.dart
// ════════════════════════════════════════════════════════════
// All domain models for the student-facing MITRA app
// ════════════════════════════════════════════════════════════

import 'package:hive/hive.dart';

part 'student_models.g.dart';

// ── Student Profile ───────────────────────────────────────────
@HiveType(typeId: 10)
class StudentProfile extends HiveObject {
  @HiveField(0)  String id;
  @HiveField(1)  String name;
  @HiveField(2)  String phone;
  @HiveField(3)  String avatar;       // emoji
  @HiveField(4)  int    classGrade;   // 6-12
  @HiveField(5)  String schoolName;
  @HiveField(6)  String stateCode;
  @HiveField(7)  String stateName;
  @HiveField(8)  String district;
  @HiveField(9)  int    xp;
  @HiveField(10) int    streakDays;
  @HiveField(11) int    classRank;
  @HiveField(12) int    quizzesCompleted;
  @HiveField(13) List<String> badgeIds;
  @HiveField(14) String language;     // 'hi' | 'en' | 'ta' ...
  @HiveField(15) String accessToken;
  @HiveField(16) bool   consentGiven;
  @HiveField(17) bool   parentalConsentGiven;
  @HiveField(18) String role;         // 'student' | 'teacher'

  StudentProfile({
    required this.id,
    required this.name,
    required this.phone,
    this.avatar = '👦',
    this.classGrade = 9,
    this.schoolName = '',
    required this.stateCode,
    required this.stateName,
    this.district = '',
    this.xp = 0,
    this.streakDays = 0,
    this.classRank = 0,
    this.quizzesCompleted = 0,
    this.badgeIds = const [],
    this.language = 'en',
    this.accessToken = '',
    this.consentGiven = false,
    this.parentalConsentGiven = false,
    this.role = 'student',
  });

  factory StudentProfile.fromJson(Map<String, dynamic> j) => StudentProfile(
    id:                    j['id']                      ?? '',
    name:                  j['name']                    ?? '',
    phone:                 j['phone']                   ?? '',
    avatar:                j['avatar']                  ?? '👦',
    classGrade:            j['class_grade']             ?? 9,
    schoolName:            j['school_name']             ?? '',
    stateCode:             j['state_code']              ?? '',
    stateName:             j['state_name']              ?? '',
    district:              j['district']                ?? '',
    xp:                    j['xp']                      ?? 0,
    streakDays:            j['streak_days']             ?? 0,
    classRank:             j['class_rank']              ?? 0,
    quizzesCompleted:      j['quizzes_completed']       ?? 0,
    badgeIds:              List<String>.from(j['badge_ids'] ?? []),
    language:              j['language']                ?? 'en',
    accessToken:           j['access_token']            ?? '',
    consentGiven:          j['consent_given']           ?? false,
    parentalConsentGiven:  j['parental_consent_given']  ?? false,
    role:                  j['role']                    ?? 'student',
  );

  Map<String, dynamic> toJson() => {
    'id':                     id,
    'name':                   name,
    'phone':                  phone,
    'avatar':                 avatar,
    'class_grade':            classGrade,
    'school_name':            schoolName,
    'state_code':             stateCode,
    'state_name':             stateName,
    'district':               district,
    'xp':                     xp,
    'streak_days':            streakDays,
    'class_rank':             classRank,
    'quizzes_completed':      quizzesCompleted,
    'badge_ids':              badgeIds,
    'language':               language,
    'access_token':           accessToken,
    'consent_given':          consentGiven,
    'parental_consent_given': parentalConsentGiven,
    'role':                   role,
  };

  String get greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  String get rankLabel {
    if (classRank == 1) return '🥇 #1';
    if (classRank == 2) return '🥈 #2';
    if (classRank == 3) return '🥉 #3';
    return '#$classRank';
  }
}

// ── Subject ───────────────────────────────────────────────────
@HiveType(typeId: 11)
class Subject extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String emoji;
  @HiveField(3) String colorHex;
  @HiveField(4) int    totalTopics;
  @HiveField(5) int    arTopics;
  @HiveField(6) double progressPct;   // 0.0 – 1.0
  @HiveField(7) bool   isAvailable;   // feature-toggled by backend

  Subject({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorHex,
    required this.totalTopics,
    this.arTopics = 0,
    this.progressPct = 0.0,
    this.isAvailable = true,
  });

  factory Subject.fromJson(Map<String, dynamic> j) => Subject(
    id:          j['id']          ?? '',
    name:        j['name']        ?? '',
    emoji:       j['emoji']       ?? '📚',
    colorHex:    j['color_hex']   ?? '#6366F1',
    totalTopics: j['total_topics'] ?? 0,
    arTopics:    j['ar_topics']   ?? 0,
    progressPct: (j['progress_pct'] ?? 0.0).toDouble(),
    isAvailable: j['is_available'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id':             id,
    'name':           name,
    'emoji':          emoji,
    'color_hex':      colorHex,
    'total_topics':   totalTopics,
    'ar_topics':      arTopics,
    'progress_pct':   progressPct,
    'is_available':   isAvailable,
  };
}

// ── Topic ─────────────────────────────────────────────────────
@HiveType(typeId: 12)
class Topic extends HiveObject {
  @HiveField(0)  String  id;
  @HiveField(1)  String  name;
  @HiveField(2)  String  subjectId;
  @HiveField(3)  String  chapterName;
  @HiveField(4)  bool    hasAr;
  @HiveField(5)  bool    hasQuiz;
  @HiveField(6)  int     durationMin;
  @HiveField(7)  int     xpReward;
  @HiveField(8)  double  progressPct;
  @HiveField(9)  String  status;      // 'locked' | 'active' | 'done'
  @HiveField(10) String? arAssetId;
  @HiveField(11) String? quizId;
  @HiveField(12) bool    isCachedOffline;

  Topic({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.chapterName,
    this.hasAr         = false,
    this.hasQuiz       = false,
    this.durationMin   = 10,
    this.xpReward      = 100,
    this.progressPct   = 0.0,
    this.status        = 'locked',
    this.arAssetId,
    this.quizId,
    this.isCachedOffline = false,
  });

  factory Topic.fromJson(Map<String, dynamic> j) => Topic(
    id:              j['id']                ?? '',
    name:            j['name']              ?? '',
    subjectId:       j['subject_id']        ?? '',
    chapterName:     j['chapter_name']      ?? '',
    hasAr:           j['has_ar']            ?? false,
    hasQuiz:         j['has_quiz']          ?? false,
    durationMin:     j['duration_min']      ?? 10,
    xpReward:        j['xp_reward']         ?? 100,
    progressPct:     (j['progress_pct']     ?? 0.0).toDouble(),
    status:          j['status']            ?? 'locked',
    arAssetId:       j['ar_asset_id'],
    quizId:          j['quiz_id'],
    isCachedOffline: j['is_cached_offline'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id':                id,
    'name':              name,
    'subject_id':        subjectId,
    'chapter_name':      chapterName,
    'has_ar':            hasAr,
    'has_quiz':          hasQuiz,
    'duration_min':      durationMin,
    'xp_reward':         xpReward,
    'progress_pct':      progressPct,
    'status':            status,
    'ar_asset_id':       arAssetId,
    'quiz_id':           quizId,
    'is_cached_offline': isCachedOffline,
  };
}

// ── Quiz & Questions ──────────────────────────────────────────
@HiveType(typeId: 13)
class QuizQuestion extends HiveObject {
  @HiveField(0) String        id;
  @HiveField(1) String        questionText;
  @HiveField(2) List<String>  options;
  @HiveField(3) int           correctIndex;
  @HiveField(4) String?       explanation;
  @HiveField(5) String?       hintText;

  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.hintText,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> j) => QuizQuestion(
    id:           j['id']            ?? '',
    questionText: j['question_text'] ?? '',
    options:      List<String>.from(j['options'] ?? []),
    correctIndex: j['correct_index'] ?? 0,
    explanation:  j['explanation'],
    hintText:     j['hint_text'],
  );

  Map<String, dynamic> toJson() => {
    'id':            id,
    'question_text': questionText,
    'options':       options,
    'correct_index': correctIndex,
    'explanation':   explanation,
    'hint_text':     hintText,
  };
}

@HiveType(typeId: 14)
class Quiz extends HiveObject {
  @HiveField(0) String            id;
  @HiveField(1) String            title;
  @HiveField(2) String            topicId;
  @HiveField(3) List<QuizQuestion> questions;
  @HiveField(4) int               timeLimitSeconds;

  Quiz({
    required this.id,
    required this.title,
    required this.topicId,
    required this.questions,
    this.timeLimitSeconds = 30,
  });

  factory Quiz.fromJson(Map<String, dynamic> j) => Quiz(
    id:               j['id']                    ?? '',
    title:            j['title']                 ?? '',
    topicId:          j['topic_id']              ?? '',
    questions:        ((j['questions'] as List?) ?? [])
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList(),
    timeLimitSeconds: j['time_limit_seconds']    ?? 30,
  );

  Map<String, dynamic> toJson() => {
    'id':                 id,
    'title':              title,
    'topic_id':           topicId,
    'questions':          questions.map((e) => e.toJson()).toList(),
    'time_limit_seconds': timeLimitSeconds,
  };
}

// ── Quiz Result ───────────────────────────────────────────────
class QuizResult {
  final String quizId;
  final int    correct;
  final int    total;
  final int    xpEarned;
  final int    secondsTaken;
  final String? badgeUnlockedId;
  final String? badgeUnlockedTitle;

  const QuizResult({
    required this.quizId,
    required this.correct,
    required this.total,
    required this.xpEarned,
    required this.secondsTaken,
    this.badgeUnlockedId,
    this.badgeUnlockedTitle,
  });

  double get scorePct => total > 0 ? correct / total : 0;
  String get scoreLabel => '$correct/$total';
  String get timeLabel {
    final m = secondsTaken ~/ 60;
    final s = secondsTaken % 60;
    return '${m}:${s.toString().padLeft(2, '0')}';
  }
}

// ── Badge / Achievement ───────────────────────────────────────
@HiveType(typeId: 15)
class Badge extends HiveObject {
  @HiveField(0) String  id;
  @HiveField(1) String  title;
  @HiveField(2) String  emoji;
  @HiveField(3) String  description;
  @HiveField(4) bool    isUnlocked;
  @HiveField(5) String? unlockedAt;

  Badge({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory Badge.fromJson(Map<String, dynamic> j) => Badge(
    id:          j['id']          ?? '',
    title:       j['title']       ?? '',
    emoji:       j['emoji']       ?? '🏅',
    description: j['description'] ?? '',
    isUnlocked:  j['is_unlocked'] ?? false,
    unlockedAt:  j['unlocked_at'],
  );

  Map<String, dynamic> toJson() => {
    'id':          id,
    'title':       title,
    'emoji':       emoji,
    'description': description,
    'is_unlocked': isUnlocked,
    'unlocked_at': unlockedAt,
  };
}

// ── Leaderboard Entry ─────────────────────────────────────────
class LeaderboardEntry {
  final int    rank;
  final String name;
  final String avatar;
  final int    xp;
  final bool   isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.avatar,
    required this.xp,
    this.isCurrentUser = false,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> j) => LeaderboardEntry(
    rank:          j['rank']            ?? 0,
    name:          j['name']            ?? '',
    avatar:        j['avatar']          ?? '👦',
    xp:            j['xp']             ?? 0,
    isCurrentUser: j['is_current_user'] ?? false,
  );

  String get rankEmoji {
    if (rank == 1) return '🥇';
    if (rank == 2) return '🥈';
    if (rank == 3) return '🥉';
    return '#$rank';
  }
}

// ── Ad Content ────────────────────────────────────────────────
class AdContent {
  final String id;
  final String brandName;
  final String brandEmoji;
  final String tagline;
  final String videoUrl;
  final int    xpReward;
  final int    durationSeconds;
  final String ctaLabel;
  final String ctaUrl;

  const AdContent({
    required this.id,
    required this.brandName,
    required this.brandEmoji,
    required this.tagline,
    required this.videoUrl,
    this.xpReward       = 50,
    this.durationSeconds = 15,
    this.ctaLabel       = 'Learn More',
    this.ctaUrl         = '',
  });

  factory AdContent.fromJson(Map<String, dynamic> j) => AdContent(
    id:              j['id']               ?? '',
    brandName:       j['brand_name']       ?? '',
    brandEmoji:      j['brand_emoji']      ?? '📚',
    tagline:         j['tagline']          ?? '',
    videoUrl:        j['video_url']        ?? '',
    xpReward:        j['xp_reward']        ?? 50,
    durationSeconds: j['duration_seconds'] ?? 15,
    ctaLabel:        j['cta_label']        ?? 'Learn More',
    ctaUrl:          j['cta_url']          ?? '',
  );
}

// ── Indian States Reference ───────────────────────────────────
class IndianState {
  final String code;
  final String name;
  final String flag;

  const IndianState({required this.code, required this.name, required this.flag});
}

const kIndianStates = [
  IndianState(code: 'AN', name: 'Andaman & Nicobar Islands', flag: '🏝️'),
  IndianState(code: 'AP', name: 'Andhra Pradesh',            flag: '🌶️'),
  IndianState(code: 'AR', name: 'Arunachal Pradesh',         flag: '🏔️'),
  IndianState(code: 'AS', name: 'Assam',                     flag: '🫖'),
  IndianState(code: 'BR', name: 'Bihar',                     flag: '🪔'),
  IndianState(code: 'CH', name: 'Chandigarh',                flag: '🌹'),
  IndianState(code: 'CG', name: 'Chhattisgarh',              flag: '🌿'),
  IndianState(code: 'DD', name: 'Dadra & Nagar Haveli',      flag: '🌊'),
  IndianState(code: 'DL', name: 'Delhi',                     flag: '🏛️'),
  IndianState(code: 'GA', name: 'Goa',                       flag: '🏖️'),
  IndianState(code: 'GJ', name: 'Gujarat',                   flag: '🎪'),
  IndianState(code: 'HR', name: 'Haryana',                   flag: '🌾'),
  IndianState(code: 'HP', name: 'Himachal Pradesh',          flag: '⛰️'),
  IndianState(code: 'JK', name: 'Jammu & Kashmir',           flag: '❄️'),
  IndianState(code: 'JH', name: 'Jharkhand',                 flag: '🌲'),
  IndianState(code: 'KA', name: 'Karnataka',                 flag: '🌺'),
  IndianState(code: 'KL', name: 'Kerala',                    flag: '🌴'),
  IndianState(code: 'LA', name: 'Ladakh',                    flag: '🏔️'),
  IndianState(code: 'LD', name: 'Lakshadweep',               flag: '🏝️'),
  IndianState(code: 'MP', name: 'Madhya Pradesh',            flag: '🐯'),
  IndianState(code: 'MH', name: 'Maharashtra',               flag: '🦁'),
  IndianState(code: 'MN', name: 'Manipur',                   flag: '🌸'),
  IndianState(code: 'ML', name: 'Meghalaya',                 flag: '🌧️'),
  IndianState(code: 'MZ', name: 'Mizoram',                   flag: '🌿'),
  IndianState(code: 'NL', name: 'Nagaland',                  flag: '🦅'),
  IndianState(code: 'OR', name: 'Odisha',                    flag: '🛕'),
  IndianState(code: 'PY', name: 'Puducherry',                flag: '🌊'),
  IndianState(code: 'PB', name: 'Punjab',                    flag: '🌾'),
  IndianState(code: 'RJ', name: 'Rajasthan',                 flag: '🐪'),
  IndianState(code: 'SK', name: 'Sikkim',                    flag: '🏔️'),
  IndianState(code: 'TN', name: 'Tamil Nadu',                flag: '🏯'),
  IndianState(code: 'TS', name: 'Telangana',                 flag: '🕌'),
  IndianState(code: 'TR', name: 'Tripura',                   flag: '🌸'),
  IndianState(code: 'UP', name: 'Uttar Pradesh',             flag: '🪔'),
  IndianState(code: 'UK', name: 'Uttarakhand',               flag: '⛰️'),
  IndianState(code: 'WB', name: 'West Bengal',               flag: '🐟'),
];
