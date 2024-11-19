package holos

Clusters: #Clusters & {
    "us-west-01-internal": {
        name: "us-west-01-internal"
        region: "us-west-01"
        zone: "us-west-01a"
        type: "internal"
    }
    "us-west-01-mgmt": {
        name: "us-west-01-mgmt"
        region: "us-west-01"
        zone: "us-west-01a"
        type: "mgmt"
    }
    "us-west-01-customer": {
        name: "us-west-01-customer"
        region: "us-west-01"
        zone: "us-west-01a"
        type: "customer"
    }
    "us-east-02-internal": {
        name: "us-east-02-internal"
        region: "us-east-02"
        zone: "us-east-02a"
        type: "internal"
    }
    "us-east-02-mgmt": {
        name: "us-east-02-mgmt"
        region: "us-east-02"
        zone: "us-east-02a"
        type: "mgmt"
    }
    "us-east-02-customer": {
        name: "us-east-02-customer"
        region: "us-east-02"
        zone: "us-east-02a"
        type: "customer"
    }
}

// ClusterSets is dynamically built from the Clusters structure.
ClusterSets: #ClusterSets & {
	// Map every cluster into the correct type
	for CLUSTER in Clusters {
		(CLUSTER.type): clusters: (CLUSTER.name): CLUSTER
	}
}
