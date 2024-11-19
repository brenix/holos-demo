package holos

import "encoding/yaml"

holos: Component.BuildPlan

Component: #Helm & {
	Name:      "external-dns"
	Namespace: "external-dns"
	EnableHooks: true
	Chart: {
		name: "external-dns"
		version: "1.15.0"
		repository: {
			name: "external-dns"
			url:  "https://kubernetes-sigs.github.io/external-dns/"
		}
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
