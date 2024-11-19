package holos

import "encoding/yaml"

holos: Component.BuildPlan

Component: #Helm & {
	Name:      "cert-manager"
	Namespace: "cert-manager"
	EnableHooks: true
	Chart: {
		name: "cert-manager"
		version: "1.16.1"
		repository: {
			name: "jetstack"
			url:  "https://charts.jetstack.io"
		}
	}

	Values: {
		// https://github.com/cert-manager/cert-manager/issues/6716
		global: leaderElection: namespace: Namespace
	}

	Resources: Namespace: (Name): metadata: name: Name
	KustomizeConfig: Kustomization: namespace: Namespace
	KustomizeConfig: Kustomization: patches: [
		{
			target: kind: "CustomResourceDefinition"
			patch: yaml.Marshal([{
				op:    "add"
				path:  "/metadata/annotations/argocd.argoproj.io~1sync-wave"
				value: "-10"
			}])
		},
		{
			target: kind: "CustomResourceDefinition"
			patch: yaml.Marshal([{
				op:    "add"
				path:  "/metadata/annotations/argocd.argoproj.io~1sync-options"
				value: "Delete=false"
			}])
		}
	]
}
