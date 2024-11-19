package holos

for CLUSTER in ClusterSets.internal.clusters {
	Platform: Components: "\(CLUSTER.name)-metrics-server": {
		name: "metrics-server"
		path: "components/metrics-server"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}
