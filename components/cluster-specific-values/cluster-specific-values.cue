package holos

import "encoding/yaml"

holos: Component.BuildPlan

_ClusterValues: {}

// Guard check, _|_ is bottom, or error.
if ClusterValues[ClusterName] != _|_ {
	_ClusterValues: ClusterValues[ClusterName].Values
}

// Manage a plain ConfigMap as a way to show how values can be passed through
// the system.
Component: #Kubernetes & {
	Resources: ConfigMap: "cluster-specific-values": {
		metadata: labels: "example.com/cluster.scope": ClusterScope
		metadata: labels: "example.com/cluster.stage": ClusterStage
		metadata: labels: "example.com/cluster.name":  ClusterName
		data: ClusterValues: yaml.Marshal(_ClusterValues)
		data: ScopeValues:   yaml.Marshal(ValuesByClusterScope[ClusterScope].Values)
		data: StageValues:   yaml.Marshal(ValuesByClusterStage[ClusterStage].Values)
	}
}
