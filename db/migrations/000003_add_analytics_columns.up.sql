-- 追加カラム: 分析・振り返り機能用
-- 2024年12月 追加

-- ==========================================
-- questions テーブル: 正解判定のソース、公開範囲
-- ==========================================

ALTER TABLE questions
ADD COLUMN result_source_url varchar,
ADD COLUMN result_description text,
ADD COLUMN visibility varchar DEFAULT 'public';

COMMENT ON COLUMN questions.result_source_url IS '正解判定時のソースURL';
COMMENT ON COLUMN questions.result_description IS '正解判定の理由・説明';
COMMENT ON COLUMN questions.visibility IS '公開範囲: public / private / followers';


-- ==========================================
-- predictions テーブル: 振り返り機能
-- ==========================================

ALTER TABLE predictions
ADD COLUMN post_mortem text,
ADD COLUMN post_mortem_at timestamp;

COMMENT ON COLUMN predictions.post_mortem IS '結果発表後の振り返りコメント';
COMMENT ON COLUMN predictions.post_mortem_at IS '振り返り投稿日時';


-- ==========================================
-- prediction_reactions テーブル: 評価対象の分離
-- ==========================================

ALTER TABLE prediction_reactions
ADD COLUMN target_type varchar DEFAULT 'reason';

COMMENT ON COLUMN prediction_reactions.target_type IS '評価対象: reason(根拠) / post_mortem(振り返り)';

-- ユニークインデックスを更新（target_type を含める）
DROP INDEX IF EXISTS prediction_reactions_prediction_id_user_id_idx;
CREATE UNIQUE INDEX ON prediction_reactions (prediction_id, user_id, target_type);


-- ==========================================
-- question_views テーブル: 流入元・デバイス追跡
-- ==========================================

ALTER TABLE question_views
ADD COLUMN referrer varchar,
ADD COLUMN device varchar;

COMMENT ON COLUMN question_views.referrer IS '流入元: x / feed / profile / direct / search';
COMMENT ON COLUMN question_views.device IS 'デバイス: ios / android / web';

-- 分析用インデックス
CREATE INDEX ON question_views (question_id, viewed_at);
CREATE INDEX ON question_views (referrer);


-- ==========================================
-- question_stats テーブル: シェア数・ユニーク閲覧者
-- ==========================================

ALTER TABLE question_stats
ADD COLUMN share_count int DEFAULT 0,
ADD COLUMN unique_viewers int DEFAULT 0;

COMMENT ON COLUMN question_stats.share_count IS 'シェアされた回数';
COMMENT ON COLUMN question_stats.unique_viewers IS 'ユニーク閲覧者数';


-- ==========================================
-- follows テーブル: フォロー元の追跡
-- ==========================================

ALTER TABLE follows
ADD COLUMN source_type varchar,
ADD COLUMN source_id int;

COMMENT ON COLUMN follows.source_type IS 'フォロー元: question / prediction / profile / search / suggestion';
COMMENT ON COLUMN follows.source_id IS 'フォロー元のID（question_id または prediction_id）';

-- 分析用インデックス
CREATE INDEX ON follows (source_type, source_id);


-- ==========================================
-- 追加インデックス
-- ==========================================

CREATE INDEX ON predictions (user_id, is_correct);
CREATE INDEX ON questions (visibility);
