package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/junjun1212/proveit/internal/config"
	"github.com/junjun1212/proveit/internal/handler"
)

func main() {
	// 設定読み込み
	cfg := config.Load()

	// Gin初期化
	r := gin.Default()

	// ハンドラ初期化
	authHandler := handler.NewAuthHandler(cfg.JWTSecret)

	// ヘルスチェック
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "ok",
		})
	})

	// API グループ
	api := r.Group("/api")
	{
		// 認証
		auth := api.Group("/auth")
		{
			auth.POST("/register", authHandler.Register)
			auth.POST("/login", authHandler.Login)
		}
	}

	// サーバー起動
	r.Run(":" + cfg.Port)
}
