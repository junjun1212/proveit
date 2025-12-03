-- users に X連携カラム追加
ALTER TABLE users ADD COLUMN x_id varchar;
ALTER TABLE users ADD COLUMN x_username varchar;
ALTER TABLE users ADD COLUMN x_verified boolean DEFAULT false;
ALTER TABLE users ADD COLUMN x_linked_at timestamp;

-- user_pinned_predictions テーブル作成
CREATE TABLE user_pinned_predictions (
  id serial PRIMARY KEY,
  user_id int REFERENCES users(id),
  prediction_id int REFERENCES predictions(id),
  title varchar NOT NULL,
  sort_order int DEFAULT 0,
  created_at timestamp DEFAULT now()
);

CREATE UNIQUE INDEX ON user_pinned_predictions (user_id, prediction_id);
