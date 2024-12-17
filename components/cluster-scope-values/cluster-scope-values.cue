package holos

import "encoding/yaml"

holos: Component.BuildPlan

// Manage a plain ConfigMap as a way to show how values can be passed through
// the system.
Component: #Kubernetes & {
	Resources: ConfigMap: foo: {
		metadata: labels: "example.com/cluster.scope": ClusterScope
		data: values: yaml.Marshal(ValuesByClusterScope[ClusterScope].Values)
	}
}
