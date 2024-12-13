package holos

// Use case: Values based on a given cluster stage (e.g prod, dev, staging)
//
// For the different stages of a cluster, we may want to set various values to
// size things properly. An example can be replicas for a deployment:
//
//   # dev clusters
//   replicas: 1
//   dopplerConfig: dev
//
//   # prod clusters
//   replicas: 3
//   dopplerConfig: prod

ClusterStage: #Cluster.#Stage @tag(ClusterStage)

// We leave the struct open because values can take anything.  We can tighten it
// up on a chart by chart basis by importing the default values.yaml.  See:
// https://holos.run/docs/v1alpha5/tutorial/helm-values/#importing-helm-values
#ValuesByClusterStage: [#Cluster.#Stage]: Values: {...}

// Component definitions look up values in this struct by the stage name,
// composing them into the build plan.
ValuesByClusterStage: #ValuesByClusterStage & {

	prod: Values: replicas:    3
	nonprod: Values: replicas: 1
	// Also harder to read, but unifies the value.
	dev: Values: replicas:  nonprod.Values.replicas
	test: Values: replicas: nonprod.Values.replicas

	// This is a bit too clever, but worth showing how it's possible to DRY this
	// sort of thing up at the cost of making it harder to read.
	[STAGE=string]: Values: dopplerConfig: STAGE
}
