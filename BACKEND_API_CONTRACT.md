# MITRA Student App — Backend API Contract

## Base URL
```
https://api.mitra.gov.in/v1
```
Replace this in `lib/services/api_service.dart` → `ApiK.base`

---

## Request Headers (Auto-attached by app)
Every request automatically sends:
```
Authorization:   Bearer <jwt_access_token>
X-State-ID:      GJ                        ← user's saved state code
Accept-Language: hi                        ← user's saved language
Content-Type:    application/json
```

---

## Auth Endpoints

### POST /auth/otp/request
```json
// Request
{ "phone": "9876543210", "role": "student" }

// Response
{ "message": "OTP sent via WhatsApp" }
```

### POST /auth/otp/verify
```json
// Request
{ "phone": "9876543210", "otp": "123456", "role": "student" }

// Response
{
  "access_token":  "eyJ...",
  "refresh_token": "eyJ...",
  "is_new_user":   true,
  "expires_in":    900
}
```

### POST /auth/refresh
```json
// Request
{ "refresh_token": "eyJ..." }
// Response — same as verify
```

### POST /auth/device-token
```json
// Request
{ "fcm_token": "fcm-device-token-string" }
```

---

## App Config (SDUI)

### GET /app-config?state_code=GJ
```json
{
  "state_code": "GJ",
  "state_name": "Gujarat",
  "curriculum_board": "NCERT",
  "min_class_grade": 6,
  "max_class_grade": 12,
  "default_language": "gu",
  "supported_languages": ["en", "hi", "gu"],
  "device_tier": "mid",
  "emergency_alert": "",
  "synced_at": "2024-04-10T09:00:00Z",

  "features": {
    "is_ar_enabled": true,
    "is_quiz_enabled": true,
    "is_leaderboard_enabled": true,
    "is_ads_enabled": false,
    "is_offline_enabled": true,
    "is_teacher_mode_enabled": false,
    "is_parental_consent_required": true,
    "is_bilingual_enabled": true,
    "is_rental_booking_active": false,
    "is_expedition_video_active": false
  },

  "branding": {
    "primary_color": "#FF6B35",
    "secondary_color": "#7C5CDD",
    "logo_url": "https://cdn.mitra.gov.in/logos/gj.png",
    "app_name": "MITRA",
    "tagline": "AR Learning Platform"
  },

  "nav_items": [
    { "id": "home",    "label_key": "navHome",    "icon": "🏠", "order": 0 },
    { "id": "learn",   "label_key": "navLearn",   "icon": "📚", "order": 1 },
    { "id": "ar",      "label_key": "navAR",      "icon": "🥽", "order": 2 },
    { "id": "ranks",   "label_key": "navRanks",   "icon": "🏆", "order": 3 },
    { "id": "profile", "label_key": "navProfile", "icon": "👤", "order": 4 }
  ]
}
```

---

## Student Endpoints

### GET /student/profile
```json
{
  "id": "uuid",
  "name": "Arjun Sharma",
  "phone": "9876543210",
  "avatar": "🦸",
  "class_grade": 9,
  "school_name": "Govt High School Ahmedabad",
  "state_code": "GJ",
  "state_name": "Gujarat",
  "district": "Ahmedabad",
  "xp": 2840,
  "streak_days": 7,
  "class_rank": 3,
  "quizzes_completed": 12,
  "badge_ids": ["b1", "b2", "b3"],
  "language": "hi",
  "consent_given": true,
  "parental_consent_given": true,
  "role": "student"
}
```

### POST /student/profile/setup
```json
// Request
{
  "name": "Arjun Sharma",
  "avatar": "🦸",
  "class_grade": 9,
  "state_code": "GJ",
  "school_name": "Govt High School",
  "district": "Ahmedabad"
}
// Response — same as GET profile
```

---

## Curriculum Endpoints

### GET /curriculum/subjects?class_grade=9
```json
[
  {
    "id": "s1",
    "name": "Science",
    "emoji": "🔬",
    "color_hex": "#6366F1",
    "total_topics": 20,
    "ar_topics": 14,
    "progress_pct": 0.68,
    "is_available": true
  }
]
```

### GET /curriculum/topics?subject_id=s1&class_grade=9
```json
[
  {
    "id": "t1",
    "name": "Cell Structure & Functions",
    "subject_id": "s1",
    "chapter_name": "Chapter 3",
    "has_ar": true,
    "has_quiz": true,
    "duration_min": 15,
    "xp_reward": 120,
    "progress_pct": 0.65,
    "status": "active",
    "ar_asset_id": "ar1",
    "quiz_id": "q1",
    "is_cached_offline": false
  }
]
```

---

## Quiz Endpoints

### GET /quiz/topic/{topicId}
```json
{
  "id": "q1",
  "title": "Cell Biology Quiz",
  "topic_id": "t1",
  "time_limit_seconds": 30,
  "questions": [
    {
      "id": "qq1",
      "question_text": "What is the powerhouse of the cell?",
      "options": ["Nucleus", "Mitochondria", "Ribosome", "Golgi"],
      "correct_index": 1,
      "explanation": "Mitochondria produce ATP via cellular respiration.",
      "hint_text": "Think about energy production"
    }
  ]
}
```

### POST /quiz/submit
```json
// Request
{
  "quiz_id": "q1",
  "answers": [1, 2, 1, 1, 2],
  "seconds_taken": 87
}

// Response
{
  "correct": 4,
  "total": 5,
  "xp_earned": 240,
  "badge_unlocked_id": "b1",
  "badge_unlocked_title": "Science Star"
}
```

---

## Leaderboard

### GET /leaderboard/class
```json
[
  {
    "rank": 1,
    "name": "Rahul Gupta",
    "avatar": "😎",
    "xp": 3200,
    "is_current_user": false
  },
  {
    "rank": 3,
    "name": "Priya Sharma",
    "avatar": "👧",
    "xp": 2840,
    "is_current_user": true
  }
]
```

---

## Ads (Optional)

### GET /ads/next
```json
{
  "id": "ad1",
  "brand_name": "Byju's",
  "brand_emoji": "📚",
  "tagline": "India's #1 Learning App",
  "video_url": "https://cdn.mitra.gov.in/ads/byjus.mp4",
  "xp_reward": 50,
  "duration_seconds": 15,
  "cta_label": "Learn More",
  "cta_url": "https://byjus.com"
}
```

### POST /ads/impression
```json
{ "ad_id": "ad1", "completed": true }
```

---

## Database Tables (PostgreSQL 16)

```sql
-- users
CREATE TABLE users (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone            TEXT UNIQUE NOT NULL,
  name             TEXT,
  role             TEXT DEFAULT 'student',    -- 'student' | 'teacher' | 'parent'
  avatar           TEXT DEFAULT '👦',
  class_grade      INTEGER,
  school_name      TEXT,
  state_code       TEXT NOT NULL,
  district         TEXT,
  language         TEXT DEFAULT 'en',
  xp               INTEGER DEFAULT 0,
  streak_days      INTEGER DEFAULT 0,
  consent_given    BOOLEAN DEFAULT FALSE,
  parental_consent BOOLEAN DEFAULT FALSE,
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  last_login       TIMESTAMPTZ
);

-- curriculum_nodes (replaces admin's curriculum tables)
CREATE TABLE curriculum_nodes (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type         TEXT NOT NULL,                -- 'subject' | 'topic'
  name         TEXT NOT NULL,
  parent_id    UUID REFERENCES curriculum_nodes(id),
  state_code   TEXT NOT NULL,
  class_grade  INTEGER,
  emoji        TEXT,
  color_hex    TEXT,
  has_ar       BOOLEAN DEFAULT FALSE,
  has_quiz     BOOLEAN DEFAULT FALSE,
  ar_asset_id  UUID,
  quiz_id      UUID,
  status       TEXT DEFAULT 'live',
  xp_reward    INTEGER DEFAULT 100,
  sort_order   INTEGER DEFAULT 0
);

-- unity_assets
CREATE TABLE unity_assets (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id     UUID REFERENCES curriculum_nodes(id),
  state_code   TEXT NOT NULL,
  bundle_url   TEXT NOT NULL,
  bundle_size  BIGINT,
  version      TEXT DEFAULT '1.0',
  status       TEXT DEFAULT 'live',
  uploaded_at  TIMESTAMPTZ DEFAULT NOW()
);

-- quizzes
CREATE TABLE quizzes (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id      UUID REFERENCES curriculum_nodes(id),
  title         TEXT NOT NULL,
  time_limit_s  INTEGER DEFAULT 30,
  status        TEXT DEFAULT 'live'
);

-- quiz_questions
CREATE TABLE quiz_questions (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id        UUID REFERENCES quizzes(id) ON DELETE CASCADE,
  question_text  TEXT NOT NULL,
  options        JSONB NOT NULL,            -- ["A","B","C","D"]
  correct_index  INTEGER NOT NULL,
  explanation    TEXT,
  hint_text      TEXT,
  sort_order     INTEGER DEFAULT 0
);

-- user_progress
CREATE TABLE user_progress (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID REFERENCES users(id) ON DELETE CASCADE,
  topic_id     UUID REFERENCES curriculum_nodes(id),
  progress_pct FLOAT DEFAULT 0,
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, topic_id)
);

-- quiz_attempts
CREATE TABLE quiz_attempts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID REFERENCES users(id),
  quiz_id       UUID REFERENCES quizzes(id),
  answers       JSONB,
  correct       INTEGER,
  total         INTEGER,
  xp_earned     INTEGER,
  seconds_taken INTEGER,
  attempted_at  TIMESTAMPTZ DEFAULT NOW()
);

-- badges
CREATE TABLE badges (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title       TEXT NOT NULL,
  emoji       TEXT NOT NULL,
  description TEXT,
  trigger     TEXT          -- 'first_ar' | 'perfect_quiz' | 'streak_7' etc.
);

-- user_badges
CREATE TABLE user_badges (
  user_id     UUID REFERENCES users(id),
  badge_id    UUID REFERENCES badges(id),
  unlocked_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, badge_id)
);

-- state_apps (geofencing config — read-only for student app)
CREATE TABLE state_apps (
  state_code       TEXT PRIMARY KEY,
  state_name       TEXT NOT NULL,
  is_ar_enabled    BOOLEAN DEFAULT TRUE,
  is_quiz_enabled  BOOLEAN DEFAULT TRUE,
  is_ads_enabled   BOOLEAN DEFAULT FALSE,
  primary_color    TEXT DEFAULT '#FF6B35',
  secondary_color  TEXT DEFAULT '#7C5CDD',
  default_language TEXT DEFAULT 'en',
  device_tier      TEXT DEFAULT 'mid',
  updated_at       TIMESTAMPTZ DEFAULT NOW()
);

-- geofences
CREATE TABLE geofences (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  state_code     TEXT REFERENCES state_apps(state_code),
  school_count   INTEGER DEFAULT 0,
  ar_apps_count  INTEGER DEFAULT 0,
  completion_pct FLOAT DEFAULT 0
);

-- telemetry
CREATE TABLE telemetry (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID REFERENCES users(id),
  event_type   TEXT NOT NULL,               -- 'ar_session' | 'quiz_start' | 'page_view'
  topic_id     UUID,
  duration_s   INTEGER,
  metadata     JSONB,
  recorded_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ad_impressions
CREATE TABLE ad_impressions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES users(id),
  ad_id       UUID,
  completed   BOOLEAN DEFAULT FALSE,
  xp_awarded  INTEGER DEFAULT 0,
  shown_at    TIMESTAMPTZ DEFAULT NOW()
);
```
