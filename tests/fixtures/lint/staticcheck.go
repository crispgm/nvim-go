package lint

func someStaticError(x bool) error {
	if x == true {}
	return nil
}
