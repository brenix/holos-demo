package holos

for CLUSTER in ClusterSets.internal.clusters {
	Platform: Components: "\(CLUSTER.name)-cert-manager": {
		name: "cert-manager"
		path: "components/cert-manager"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}

for CLUSTER in ClusterSets.mgmt.clusters {
	Platform: Components: "\(CLUSTER.name)-cert-manager": {
		name: "cert-manager"
		path: "components/cert-manager"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}

for CLUSTER in ClusterSets.customer.clusters {
	Platform: Components: "\(CLUSTER.name)-cert-manager": {
		name: "cert-manager"
		path: "components/cert-manager"
		parameters: outputBaseDir: "\(CLUSTER.name)"
	}
}
