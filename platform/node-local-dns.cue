package holos

for CLUSTER in ClusterSets.internal.clusters {
	Platform: Components: "\(CLUSTER.name)-node-local-dns": {
		name: "node-local-dns"
		path: "components/node-local-dns"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}
