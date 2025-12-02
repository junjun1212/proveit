CREATE TABLE "users" (
  "id" serial PRIMARY KEY,
  "email" varchar UNIQUE NOT NULL,
  "username" varchar UNIQUE NOT NULL,
  "display_name" varchar NOT NULL,
  "avatar_url" varchar,
  "bio" text,
  "password_hash" varchar NOT NULL,
  "is_verified" boolean DEFAULT false,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp
);

CREATE TABLE "user_profiles" (
  "user_id" int PRIMARY KEY,
  "age_group" varchar,
  "gender" varchar,
  "region" varchar,
  "occupation" varchar,
  "interests" jsonb,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp
);

CREATE TABLE "categories" (
  "id" serial PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL,
  "slug" varchar UNIQUE NOT NULL,
  "description" text,
  "icon" varchar,
  "sort_order" int DEFAULT 0,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp
);

CREATE TABLE "questions" (
  "id" serial PRIMARY KEY,
  "author_id" int,
  "category_id" int,
  "title" varchar NOT NULL,
  "description" text,
  "choices" jsonb NOT NULL,
  "choice_count" int NOT NULL,
  "deadline_at" timestamp NOT NULL,
  "result" int,
  "correct_rate" float,
  "difficulty_weight" float DEFAULT 1,
  "status" varchar DEFAULT 'open',
  "view_count" int DEFAULT 0,
  "judged_at" timestamp,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp
);

CREATE TABLE "predictions" (
  "id" serial PRIMARY KEY,
  "user_id" int,
  "question_id" int,
  "answer" int NOT NULL,
  "reason" text,
  "is_intuition" boolean NOT NULL,
  "is_correct" boolean,
  "predict_order" int NOT NULL,
  "choice_distribution_snapshot" jsonb,
  "modification_count" int DEFAULT 0,
  "is_modified" boolean DEFAULT false,
  "weighted_score" float,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "judged_at" timestamp
);

CREATE TABLE "question_views" (
  "id" serial PRIMARY KEY,
  "question_id" int,
  "user_id" int,
  "session_id" varchar,
  "viewed_at" timestamp DEFAULT (now())
);

CREATE TABLE "question_stats" (
  "question_id" int PRIMARY KEY,
  "total_views" int DEFAULT 0,
  "total_predictions" int DEFAULT 0,
  "total_correct" int DEFAULT 0,
  "total_modified" int DEFAULT 0,
  "hourly_views" jsonb,
  "hourly_predictions" jsonb,
  "choice_distribution" jsonb,
  "updated_at" timestamp
);

CREATE TABLE "user_view_history" (
  "id" serial PRIMARY KEY,
  "user_id" int,
  "question_id" int,
  "view_count" int DEFAULT 1,
  "first_viewed_at" timestamp DEFAULT (now()),
  "last_viewed_at" timestamp DEFAULT (now()),
  "is_deleted" boolean DEFAULT false
);

CREATE TABLE "prediction_changes" (
  "id" serial PRIMARY KEY,
  "prediction_id" int,
  "old_answer" int NOT NULL,
  "new_answer" int NOT NULL,
  "old_is_intuition" boolean,
  "new_is_intuition" boolean,
  "changed_at" timestamp DEFAULT (now())
);

CREATE TABLE "prediction_reactions" (
  "id" serial PRIMARY KEY,
  "prediction_id" int,
  "user_id" int,
  "stance" varchar,
  "is_helpful" boolean DEFAULT false,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp
);

CREATE TABLE "comments" (
  "id" serial PRIMARY KEY,
  "prediction_id" int,
  "user_id" int,
  "parent_comment_id" int,
  "comment_type" varchar NOT NULL,
  "content" text NOT NULL,
  "is_deleted" boolean DEFAULT false,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp
);

CREATE TABLE "comment_reactions" (
  "id" serial PRIMARY KEY,
  "comment_id" int,
  "user_id" int,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "follows" (
  "id" serial PRIMARY KEY,
  "follower_id" int,
  "following_id" int,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "notifications" (
  "id" serial PRIMARY KEY,
  "user_id" int,
  "type" varchar NOT NULL,
  "target_type" varchar,
  "target_id" int,
  "actor_id" int,
  "is_read" boolean DEFAULT false,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "user_notification_settings" (
  "user_id" int PRIMARY KEY,
  "notify_result" boolean DEFAULT true,
  "notify_reaction" boolean DEFAULT true,
  "notify_comment" boolean DEFAULT true,
  "notify_follow" boolean DEFAULT true,
  "notify_deadline" boolean DEFAULT true,
  "email_enabled" boolean DEFAULT false,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp
);

CREATE TABLE "user_bookmarks" (
  "id" serial PRIMARY KEY,
  "user_id" int,
  "question_id" int,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "user_blocks" (
  "id" serial PRIMARY KEY,
  "user_id" int,
  "blocked_user_id" int,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "user_mutes" (
  "id" serial PRIMARY KEY,
  "user_id" int,
  "muted_user_id" int,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "reports" (
  "id" serial PRIMARY KEY,
  "reporter_id" int,
  "target_type" varchar NOT NULL,
  "target_id" int NOT NULL,
  "reason" varchar NOT NULL,
  "description" text,
  "status" varchar DEFAULT 'pending',
  "resolved_at" timestamp,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "badges" (
  "id" serial PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL,
  "description" text,
  "icon" varchar,
  "category" varchar NOT NULL,
  "rarity" varchar DEFAULT 'common',
  "condition_type" varchar NOT NULL,
  "condition_value" jsonb,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "user_badges" (
  "id" serial PRIMARY KEY,
  "user_id" int,
  "badge_id" int,
  "is_displayed" boolean DEFAULT false,
  "acquired_at" timestamp DEFAULT (now())
);

CREATE UNIQUE INDEX ON "predictions" ("user_id", "question_id");

CREATE UNIQUE INDEX ON "user_view_history" ("user_id", "question_id");

CREATE UNIQUE INDEX ON "prediction_reactions" ("prediction_id", "user_id");

CREATE UNIQUE INDEX ON "comment_reactions" ("comment_id", "user_id");

CREATE UNIQUE INDEX ON "follows" ("follower_id", "following_id");

CREATE UNIQUE INDEX ON "user_bookmarks" ("user_id", "question_id");

CREATE UNIQUE INDEX ON "user_blocks" ("user_id", "blocked_user_id");

CREATE UNIQUE INDEX ON "user_mutes" ("user_id", "muted_user_id");

CREATE UNIQUE INDEX ON "user_badges" ("user_id", "badge_id");

ALTER TABLE "user_profiles" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "questions" ADD FOREIGN KEY ("author_id") REFERENCES "users" ("id");

ALTER TABLE "questions" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("id");

ALTER TABLE "predictions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "predictions" ADD FOREIGN KEY ("question_id") REFERENCES "questions" ("id");

ALTER TABLE "question_views" ADD FOREIGN KEY ("question_id") REFERENCES "questions" ("id");

ALTER TABLE "question_views" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "question_stats" ADD FOREIGN KEY ("question_id") REFERENCES "questions" ("id");

ALTER TABLE "user_view_history" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "user_view_history" ADD FOREIGN KEY ("question_id") REFERENCES "questions" ("id");

ALTER TABLE "prediction_changes" ADD FOREIGN KEY ("prediction_id") REFERENCES "predictions" ("id");

ALTER TABLE "prediction_reactions" ADD FOREIGN KEY ("prediction_id") REFERENCES "predictions" ("id");

ALTER TABLE "prediction_reactions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "comments" ADD FOREIGN KEY ("prediction_id") REFERENCES "predictions" ("id");

ALTER TABLE "comments" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "comments" ADD FOREIGN KEY ("parent_comment_id") REFERENCES "comments" ("id");

ALTER TABLE "comment_reactions" ADD FOREIGN KEY ("comment_id") REFERENCES "comments" ("id");

ALTER TABLE "comment_reactions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "follows" ADD FOREIGN KEY ("follower_id") REFERENCES "users" ("id");

ALTER TABLE "follows" ADD FOREIGN KEY ("following_id") REFERENCES "users" ("id");

ALTER TABLE "notifications" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "notifications" ADD FOREIGN KEY ("actor_id") REFERENCES "users" ("id");

ALTER TABLE "user_notification_settings" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "user_bookmarks" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "user_bookmarks" ADD FOREIGN KEY ("question_id") REFERENCES "questions" ("id");

ALTER TABLE "user_blocks" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "user_blocks" ADD FOREIGN KEY ("blocked_user_id") REFERENCES "users" ("id");

ALTER TABLE "user_mutes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "user_mutes" ADD FOREIGN KEY ("muted_user_id") REFERENCES "users" ("id");

ALTER TABLE "reports" ADD FOREIGN KEY ("reporter_id") REFERENCES "users" ("id");

ALTER TABLE "user_badges" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "user_badges" ADD FOREIGN KEY ("badge_id") REFERENCES "badges" ("id");
