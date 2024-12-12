package holos

// Use Case: Chart-level defaults
//
// Setting something such as a common affinity or tolerations that all
// deployments of the chart will use by default (but can be overwritten as
// needed)
// https://github.com/brenix/holos-demo/issues/2
//
// This file is located at the root to keep chart-level defaults in one place,
// but the data may be in any directory along the path to the chart that needs
// it.

// For readability
#ChartName: string

// We leave the struct open because values can take anything.  We can tighten it
// up on a chart by chart basis.
#ValuesByChart: [#ChartName]: Values: {...}

// Component definitions will look up values in this struct by their chart name,
// composing them into the build plan.
ValuesByChart: {
	"argo-cd": Values: {
		global: {
			affinity: nodeAffinity: {}
			tolerations: [{
				key:      "foo"
				operator: "Equal"
				value:    "bar"
			}]
		}
	}
}
