package test

import (
	"os"
	"testing"
)

func TestHello(t *testing.T) {
	t.Log(hello())
}

func TestHello2(t *testing.T) {
	t.Log(hello())
}

func TestWithEnv(t *testing.T) {
	t.Log(os.Getenv("ENV_TEST"))
}
