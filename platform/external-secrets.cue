package holos

for CLUSTER in ClusterSets.internal.clusters {
	Platform: Components: "\(CLUSTER.name)-external-secrets": {
		name: "external-secrets"
		path: "components/external-secrets"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}
