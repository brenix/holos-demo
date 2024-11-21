package holos

holos: Component.BuildPlan

Component: #Helm & {
	Chart: {
		name:    "podinfo"
		version: "6.6.2"
		repository: {
			name: "podinfo"
			url:  "https://stefanprodan.github.io/podinfo"
		}
	}
	Values: ui: {
		message: string | *"Hello World" @tag(message, type=string)
	}
}
