-- user_pinned_predictions テーブル削除
DROP TABLE IF EXISTS user_pinned_predictions;

-- users から X連携カラム削除
ALTER TABLE users DROP COLUMN IF EXISTS x_linked_at;
ALTER TABLE users DROP COLUMN IF EXISTS x_verified;
ALTER TABLE users DROP COLUMN IF EXISTS x_username;
ALTER TABLE users DROP COLUMN IF EXISTS x_id;
