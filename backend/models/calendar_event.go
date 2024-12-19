package models

import (
	"gorm.io/gorm"
	"time"
)

type CalendarEvent struct {
	gorm.Model
	UserID    uint
	Title     string
	StartTime time.Time
	EndTime   time.Time
} 