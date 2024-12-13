package holos

// Use case: Values for a specific cluster.
//
// Each cluster has a specific network CIDR and other values that are only specific
// to that cluster, which need to be fed into charts
//
//   networkAllocations:
//     podCIDRs: ["172.26.0.0/20"]
//     serviceCIDRs: ["172.26.64.0/23"]
// 
//   prometheus:
//     prometheusSpec:
//       externalLabels:
//         cluster: us-east-02-internal

ClusterName: #Cluster.#Name @tag(ClusterName)

#ClusterValues: [#Cluster.#Name]: Values: {...}

// Component definitions look up values in this struct by the stage name,
// composing them into the build plan.
ClusterValues: #ClusterValues & {
	"us-west-01a-internal": Values: {
		networkAllocations: {
			podCIDRs: ["172.26.0.0/20"]
			serviceCIDRs: ["172.26.64.0/23"]
		}
	}

	"us-west-01a-mgmt": Values: {
		networkAllocations: {
			podCIDRs: ["172.26.16.0/20"]
			serviceCIDRs: ["172.26.66.0/23"]
		}
	}

	"us-west-01a-customer": Values: {
		networkAllocations: {
			podCIDRs: ["172.26.32.0/20"]
			serviceCIDRs: ["172.26.68.0/23"]
		}
	}
}
