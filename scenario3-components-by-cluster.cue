package holos

// #ComponentsByClusters composes components by cluster name.
#ComponentsByClusters: [CLUSTER=#Cluster.#Name]: #ComponentsByCluster & {cluster: CLUSTER}

#ComponentsByCluster: {
	cluster:    #Cluster.#Name
	components: #Components
}

// ComponentsByClusters manages components with varying helm chart
// versions on various clusters identified by cluster name.
ComponentsByClusters: #ComponentsByClusters & {
	"us-west-01a-customer": components: podinfo: {
		name: "podinfo"
		path: "components/podinfo"
		parameters: ChartVersion: "6.6.0"
	}
	"us-east-02a-customer": components: podinfo: {
		name: "podinfo"
		path: "components/podinfo"
		parameters: ChartVersion: "6.6.1"
	}
}
