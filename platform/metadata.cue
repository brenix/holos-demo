package holos

Platform: Components: [NAME=string]: {
	name:       _
	parameters: _

	labels: "app.holos.run/name": name
	// Include the cluster name in the `holos render platform` info log
	// messages for clarity.
	if parameters.outputBaseDir != _|_ {
		annotations: "app.holos.run/description": "\(parameters.outputBaseDir)/\(name)"
	}
}
