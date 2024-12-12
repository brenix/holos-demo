package holos

// Use Case: Values based on a given cluster scope (internal clusters,
// management clusters, customer clusters)
//
// We need to set values based on a given scope (or type) of the cluster. Each
// cluster scope will typically have a different set of applications, but for the
// ones that are shared between multiple cluster scopes would have different
// values. An example of this could be enabling specific cluster policies or
// networkpolicies
// https://github.com/brenix/holos-demo/issues/2
//
// This file is located at the root to keep chart-level defaults in one place,
// but the data may be in any directory along the path to the chart that needs
// it.

// The tag value gets injected when we run holos render platform and holos show
// buildplans.  Other than these situations the field does not have a concrete
// value.  For troubleshooting, we can inject a value, for example:
//
//   holos cue eval -e ClusterScope
//   "internal" | "mgmt" | "customer"
//
//   holos cue eval -e ClusterScope -t ClusterScope=mgmt
//   "mgmt"
ClusterScope: #Cluster.#Scope @tag(ClusterScope)

// We leave the struct open because values can take anything.  We can tighten it
// up on a chart by chart basis by importing the default values.yaml.  See:
// https://holos.run/docs/v1alpha5/tutorial/helm-values/#importing-helm-values
#ValuesByClusterScope: [#Cluster.#Scope]: Values: {...}

// Component definitions look up values in this struct by the scope name,
// composing them into the build plan.
ValuesByClusterScope: #ValuesByClusterScope & {
	internal: Values: policies: mutateLBTrafficPolicy: false
	mgmt: Values: policies: mutateLBTrafficPolicy:     true
	customer: Values: policies: mutateLBTrafficPolicy: true
}
