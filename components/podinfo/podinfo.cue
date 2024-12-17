package holos

holos: Component.BuildPlan

Component: #Helm & {
	Chart: {
		name:    "podinfo"
		version: string | *"6.6.2" @tag(ChartVersion)
		repository: {
			name: "podinfo"
			url:  "https://stefanprodan.github.io/podinfo"
		}
	}
	Values: ui: {
		message: string | *"Hello World" @tag(message, type=string)
	}

	Resources: {
		ConfigMap: "cluster-specific-values": {
			metadata: {
				labels: "example.com/cluster.scope": ClusterScope
				labels: "example.com/cluster.stage": ClusterStage
				labels: "example.com/cluster.name":  ClusterName
				labels: "example.com/chart.version": Chart.version
				annotations: {
					"example.com/scenario":       "3 - Excluding or pinning components on a per-environment basis"
					"example.com/use-case":       "Values for a specific cluster"
					"jeff.holos.run/description": "Version 6.6.0 should be deployed on cluster us-west-01a-customer, version 6.6.1 on us-east-02a-customer.  Should not be deployed on any other cluster.  THe default version is 6.6.2."
				}
			}
			data: message: "Some clusters may or may not need a particular component deployed to them. In some cases, we also have to pin a specific version of the chart for the given cluster."
		}
	}
}
