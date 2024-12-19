package models

type User struct {
    gorm.Model
    Username string `gorm:"unique"`
    Password string
    Email    string
} 