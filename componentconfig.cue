package holos

// Configure how components produce build plans here, by mixing data into the
// definition all components share.
#ComponentConfig: {
	// The output base directory is injected from the platform spec using a parameter.
	OutputBaseDir: string @tag(outputBaseDir)
}
