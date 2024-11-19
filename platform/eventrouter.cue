package holos

for CLUSTER in ClusterSets.internal.clusters {
	Platform: Components: "\(CLUSTER.name)-eventrouter": {
		name: "eventrouter"
		path: "components/eventrouter"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}
