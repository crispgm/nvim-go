package lint

func someError() error {
	return nil
}

func NeedCheck() {
	someError()
}
