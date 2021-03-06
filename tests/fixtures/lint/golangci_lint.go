package lint

func someError() error {
	return nil

	if true {
	}

	return nil
}

func NeedCheck() { // this should not a issue by golangci-lint
	someError() // should be errcheck
}
