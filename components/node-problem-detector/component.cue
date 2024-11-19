package holos

import "encoding/yaml"

holos: Component.BuildPlan

Component: #Helm & {
	Name:      "node-problem-detector"
	Namespace: "node-problem-detector"
	Chart: {
		name: "node-problem-detector"
		version: "2.3.15"
		// FIXME: OCI images not working
		repository: {
			name: "node-problem-detector"
			url: "oci://ghcr.io/deliveryhero/helm-charts"
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
