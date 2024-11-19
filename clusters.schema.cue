package holos

// import "strings"

// #Cluster represents one cluster
#Cluster: {
	name: string
	region: string
	zone: string
	type: string
}

// #Clusters represents a cluster collection structure
#Clusters: {
	[NAME=string]: #Cluster & {
		name: NAME
	}
}

// #ClusterSet represents a set of clusters.
#ClusterSet: {
	name: string
	clusters: #Clusters & {
		// Constrain the cluster set to clusters having the same set.  Ensures
		// clusters are never mis-categorized.
		[_]: type: name
	}
}

// #ClusterSets represents a cluster set collection.
#ClusterSets: {
	// name is the lookup key for the collection.
	[NAME=string]: #ClusterSet & {
		// name must match the struct field name.
		name: NAME
	}
}
