package models

import (
	"gorm.io/gorm"
	"time"
)

type CheckIn struct {
	gorm.Model
	UserID uint
	Date   time.Time
} 