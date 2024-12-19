package middleware

import (
	"github.com/gin-gonic/gin"
	"github.com/opentracing/opentracing-go"
	"github.com/uber/jaeger-client-go"
	"github.com/uber/jaeger-client-go/config"
)

func InitTracer(serviceName string) (opentracing.Tracer, error) {
	cfg := &config.Configuration{
		ServiceName: serviceName,
		Sampler: &config.SamplerConfig{
			Type:  jaeger.SamplerTypeConst,
			Param: 1,
		},
		Reporter: &config.ReporterConfig{
			LogSpans: true,
		},
	}

	tracer, _, err := cfg.NewTracer()
	if err != nil {
		return nil, err
	}

	opentracing.SetGlobalTracer(tracer)
	return tracer, nil
}

func Tracer() gin.HandlerFunc {
	return func(c *gin.Context) {
		span := opentracing.GlobalTracer().StartSpan(c.Request.URL.Path)
		defer span.Finish()

		// 将 span 注入到 context 中
		c.Set("span", span)
		c.Next()
	}
} 