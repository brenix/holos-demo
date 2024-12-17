package holos

import "encoding/yaml"

holos: Component.BuildPlan

// Manage a plain ConfigMap as a way to show how values can be passed through
// the system.
Component: #Kubernetes & {
	Resources: ConfigMap: "values-by-cluster-stage": {
		metadata: labels: "example.com/cluster.scope": ClusterScope
		metadata: labels: "example.com/cluster.stage": ClusterStage
		data: values: yaml.Marshal(ValuesByClusterStage[ClusterStage].Values)
	}
}
