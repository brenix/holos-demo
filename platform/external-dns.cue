package holos

for CLUSTER in ClusterSets.internal.clusters {
	Platform: Components: "\(CLUSTER.name)-external-dns": {
		name: "external-dns"
		path: "components/external-dns"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}

for CLUSTER in ClusterSets.mgmt.clusters {
	Platform: Components: "\(CLUSTER.name)-external-dns": {
		name: "external-dns"
		path: "components/external-dns"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}
