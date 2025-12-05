-- ロールバック用: 追加カラムを削除

-- インデックス削除
DROP INDEX IF EXISTS predictions_user_id_is_correct_idx;
DROP INDEX IF EXISTS questions_visibility_idx;
DROP INDEX IF EXISTS follows_source_type_source_id_idx;
DROP INDEX IF EXISTS question_views_question_id_viewed_at_idx;
DROP INDEX IF EXISTS question_views_referrer_idx;

-- prediction_reactions のユニークインデックスを元に戻す
DROP INDEX IF EXISTS prediction_reactions_prediction_id_user_id_target_type_idx;
CREATE UNIQUE INDEX ON prediction_reactions (prediction_id, user_id);

-- follows テーブル
ALTER TABLE follows
DROP COLUMN IF EXISTS source_type,
DROP COLUMN IF EXISTS source_id;

-- question_stats テーブル
ALTER TABLE question_stats
DROP COLUMN IF EXISTS share_count,
DROP COLUMN IF EXISTS unique_viewers;

-- question_views テーブル
ALTER TABLE question_views
DROP COLUMN IF EXISTS referrer,
DROP COLUMN IF EXISTS device;

-- prediction_reactions テーブル
ALTER TABLE prediction_reactions
DROP COLUMN IF EXISTS target_type;

-- predictions テーブル
ALTER TABLE predictions
DROP COLUMN IF EXISTS post_mortem,
DROP COLUMN IF EXISTS post_mortem_at;

-- questions テーブル
ALTER TABLE questions
DROP COLUMN IF EXISTS result_source_url,
DROP COLUMN IF EXISTS result_description,
DROP COLUMN IF EXISTS visibility;
