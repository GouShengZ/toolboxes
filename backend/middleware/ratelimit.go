package middleware

import (
	"net/http"
	"sync"
	"time"
	"golang.org/x/time/rate"
)

type RateLimiter struct {
	limiter *rate.Limiter
	mu      sync.Mutex
}

func NewRateLimiter(capacity int, fillRate float64) *RateLimiter {
	return &RateLimiter{
		limiter: rate.NewLimiter(rate.Limit(fillRate), capacity),
	}
}

func (rl *RateLimiter) RateLimit(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		rl.mu.Lock()
		allow := rl.limiter.Allow()
		rl.mu.Unlock()

		if !allow {
			w.WriteHeader(http.StatusTooManyRequests)
			w.Write([]byte("请求过于频繁，请稍后再试"))
			return
		}

		next.ServeHTTP(w, r)
	})
} 