package main

import (
	"log"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"your-project/config"
	"your-project/middleware"
)

func main() {
	// 初始化配置
	if err := config.Init(); err != nil {
		log.Fatalf("init config failed: %v", err)
	}

	// 初始化日志
	logger, _ := zap.NewProduction()
	defer logger.Sync()
	zap.ReplaceGlobals(logger)

	// 初始化数据库
	db, err := config.InitDB()
	if err != nil {
		log.Fatalf("init database failed: %v", err)
	}

	// 初始化链路追踪
	tracer, err := middleware.InitTracer("uul-service")
	if err != nil {
		log.Fatalf("init tracer failed: %v", err)
	}

	// 设置gin模式
	gin.SetMode(config.GlobalConfig.Server.Mode)

	r := gin.New()

	// 使用中间件
	r.Use(gin.Recovery())
	r.Use(middleware.Logger())
	r.Use(middleware.Tracer())

	// 创建令牌桶限流器
	rateLimiter := middleware.NewRateLimiter(
		config.RateLimit.Capacity,
		config.RateLimit.Rate,
	)

	// 添加到中间件链中
	r.Use(rateLimiter.RateLimit)

	// 注册路由
	api := r.Group("/api")
	{
		api.POST("/register", handlers.Register)
		api.POST("/login", handlers.Login)
		
		auth := api.Group("/").Use(middleware.Auth())
		{
			auth.POST("/checkin", handlers.CheckIn)
			auth.POST("/calendar/generate", handlers.GenerateICS)
		}
	}

	// 启动服务器
	addr := fmt.Sprintf(":%d", config.GlobalConfig.Server.Port)
	if err := r.Run(addr); err != nil {
		log.Fatalf("start server failed: %v", err)
	}
} 