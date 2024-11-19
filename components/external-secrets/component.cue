package holos

import "encoding/yaml"

holos: Component.BuildPlan

Component: #Helm & {
	Name:      "external-secrets"
	Namespace: "external-secrets"
	Chart: {
		name: "external-secrets"
		version: "0.10.5"
		repository: {
			name: "external-secrets"
			url:  "https://charts.external-secrets.io"
		}
	}
	// Needed to render the ServiceMonitor
	APIVersions: [ "monitoring.coreos.com/v1" ]

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
