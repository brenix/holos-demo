package holos

// #Cluster represents one cluster
#Cluster: {
	// name represents the cluster name
	name: #Name

	// scope represents the clusters scope
	scope: #Scope
	// stage represents the clusters lifecycle stage
	stage: #Stage

	// Definitions for use elsewhere in the configuration as #Cluster.#Scope
	#Scope: "internal" | "mgmt" | "customer"
	#Stage: "prod" | "dev" | "test" | "nonprod"

	// You could constrain this definition to match your cluster naming
	// convention, but might be getting way too fancy / clever.
	#Name: string
}

// #Zone represents an availability zone within a region
#Zone: {
	// name represents the name of the zone
	name: string
	// clusters represents a set of clusters within the zone
	clusters: [string]: #Cluster
}

// #Region represents an geographical region, which is isolated from other regions
#Region: {
	// name represents the name of the region
	name: string
	// clusters represents a set of zones within the region
	zones: [NAME=string]: #Zone & {name: NAME}
}

// #Regions represents a set of regions
#Regions: {
	[NAME=string]: #Region & {
		name: NAME
	}
}
