package holos

for CLUSTER in ClusterSets.internal.clusters {
	Platform: Components: "\(CLUSTER.name)-coredns": {
		name: "coredns"
		path: "components/coredns"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}
