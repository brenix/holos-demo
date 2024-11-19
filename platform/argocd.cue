package holos

for CLUSTER in ClusterSets.internal.clusters {
	Platform: Components: "\(CLUSTER.name)-argocd": {
		name: "argocd"
		path: "components/argocd"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}
