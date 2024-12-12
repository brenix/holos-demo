package holos

import "encoding/yaml"

holos: Component.BuildPlan

Component: #Helm & {
	Name:      "argocd"
	Namespace: "argocd"
	Chart: {
		name:    "argo-cd"
		version: "7.6.1"
		repository: {
			name: "argocd"
			url:  "https://argoproj.github.io/argo-helm"
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
		},
	]

	// Use Case: Chart-level defaults
	//
	// Setting something such as a common affinity or tolerations that all
	// deployments of the chart will use by default (but can be overwritten as
	// needed)
	// https://github.com/brenix/holos-demo/issues/2
	Values: ValuesByChart[Chart.name].Values
}
