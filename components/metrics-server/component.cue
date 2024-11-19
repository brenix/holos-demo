package holos

import "encoding/yaml"

holos: Component.BuildPlan

Component: #Helm & {
	Name:      "metrics-server"
	Namespace: "metrics-server"
	Chart: {
		name: "metrics-server"
		version: "3.12.2"
		repository: {
			name: "metrics-server"
			url: "https://kubernetes-sigs.github.io/metrics-server/"
		}
	}

	Resources: Namespace: (Name): metadata: name: Name
	KustomizeConfig: Kustomization: namespace: Namespace
	KustomizeConfig: Kustomization: patches: [
		{
			target: kind: "Service"
			patch: yaml.Marshal([{
				op:    "replace"
				path:  "/spec/externalTrafficPolicy"
				value: "Local"
			}])
		}
	]
}
