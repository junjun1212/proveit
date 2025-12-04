package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/junjun1212/proveit/internal/config"
	"github.com/junjun1212/proveit/internal/handler"
	"github.com/junjun1212/proveit/internal/middleware"
	"github.com/junjun1212/proveit/internal/repository"
	"github.com/junjun1212/proveit/internal/repository/db"
)

func main() {
	// 設定読み込み
	cfg := config.Load()

	// DB接続
	pool, err := repository.NewConnection(cfg.DatabaseURL)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	defer pool.Close()
	log.Println("Connected to database")

	// クエリ初期化
	queries := db.New(pool)

	// Gin初期化
	r := gin.Default()

	// ハンドラ初期化
	authHandler := handler.NewAuthHandler(cfg.JWTSecret, queries)
	userHandler := handler.NewUserHandler(queries)

	// ヘルスチェック
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "ok",
		})
	})

	// APIグループ
	api := r.Group("/api")
	{
		// 認証(ログイン不要)
		auth := api.Group("/auth")
		{
			auth.POST("/register", authHandler.Register)
			auth.POST("/login", authHandler.Login)
		}

		// 認証が必要なAPI
		protected := api.Group("/")
		protected.Use(middleware.AuthMiddleware(cfg.JWTSecret))
		{
			protected.GET("/users/me", userHandler.GetMe)
		}
	}

	// サーバー起動
	log.Println("Server starting on port", cfg.Port)
	r.Run(":" + cfg.Port)

}
