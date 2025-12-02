-- name: CreateUser :one
INSERT INTO users (
  email, username, display_name, password_hash, created_at
) VALUES (
  $1, $2, $3, $4, now()
)
RETURNING *;

-- name: GetUserByID :one
SELECT * FROM users WHERE id = $1;

-- name: GetUserByEmail :one
SELECT * FROM users WHERE email = $1;

-- name: GetUserByUsername :one
SELECT * FROM users WHERE username = $1;
