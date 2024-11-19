package holos

for CLUSTER in ClusterSets.internal.clusters {
	Platform: Components: "\(CLUSTER.name)-node-feature-discovery": {
		name: "node-feature-discovery"
		path: "components/node-feature-discovery"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}
