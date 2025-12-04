package handler

import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/junjun1212/proveit/internal/repository/db"
)

type UserHandler struct {
	queries *db.Queries
}

func NewUserHandler(queries *db.Queries) *UserHandler {
	return &UserHandler{
		queries: queries,
	}
}

func (h *UserHandler) GetMe(c *gin.Context) {
	// ミドルウェアが設定した user_id を取得
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found in context"})
		return
	}

	// DBからユーザー情報を取得
	user, err := h.queries.GetUserByID(context.Background(), userID.(int32))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// レスポンス
	c.JSON(http.StatusOK, gin.H{
		"id":           user.ID,
		"email":        user.Email,
		"username":     user.Username,
		"display_name": user.DisplayName,
		"bio":          user.Bio.String,
		"avatar_url":   user.AvatarUrl.String,
		"is_verified":  user.IsVerified.Bool,
		"created_at":   user.CreatedAt.Time,
	})
}
