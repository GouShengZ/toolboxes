package config

import (
    "fmt"
    "time"
    "gorm.io/gorm"
    "gorm.io/driver/mysql"
)

func InitDB() (*gorm.DB, error) {
    cfg := GlobalConfig.Database
    dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=%s&parseTime=True&loc=Local",
        cfg.Username,
        cfg.Password,
        cfg.Host,
        cfg.Port,
        cfg.DBName,
        cfg.Charset,
    )

    db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
    if err != nil {
        return nil, fmt.Errorf("connect database failed: %v", err)
    }

    sqlDB, err := db.DB()
    if err != nil {
        return nil, err
    }

    // 设置连接池
    sqlDB.SetMaxIdleConns(cfg.MaxIdleConns)
    sqlDB.SetMaxOpenConns(cfg.MaxOpenConns)
    sqlDB.SetConnMaxLifetime(time.Duration(cfg.ConnMaxLifetime) * time.Second)

    return db, nil
} 