package holos

import (
	"encoding/yaml"
	kustomize "sigs.k8s.io/kustomize/api/types"
)

// Use case: Omitting some rendered resources for a particular environment.
//
// > In some environments, we have a rare use case to omit resources from the
// rendered output.  How do we do this at different levels of our environment
// (e.g per cluster).
//
// Response: With CUE and Holos, there isn't a difference between Helm Values
// and any other kind of data, like a Kustomize patch. This scenario and use
// case is therefore another variation of the "Values for a specific cluster"
// use case from Scenario 1.

// We don't care about the field name, we'll convert the collection to a list
// later and the field name doesn't matter
#ArbitraryUniqueLabel: string

// #Patches represents kustomize patches
#Patches: [#ArbitraryUniqueLabel]: kustomize.#Patch

// We leave the struct open because values can take anything.  We can tighten it
// up on a chart by chart basis by importing the default values.yaml.  See:
// https://holos.run/docs/v1alpha5/tutorial/helm-values/#importing-helm-values
#PatchesByCluster: [#Cluster.#Name]: Patches: #Patches

// Component definitions look up values in this struct by cluster name.
PatchesByCluster: #PatchesByCluster & {
	"us-west-01a-customer": Patches: DELETE_UNWANTED_SECRET
	"us-east-02a-customer": Patches: DELETE_UNWANTED_SECRET
}

// Let variable so we can re-use the patch in multiple places in this scope.  If
// we needed it in other scopes we could bind it to a hidden field instead.
let DELETE_UNWANTED_SECRET = {
	DeleteUnwantedSecret: {
		target: {
			kind:      "ExternalSecret"
			name:      "secret-that-is-not-needed"
			namespace: "kube-system"
		}
		patch: yaml.Marshal({
			"$patch":   "delete"
			apiVersion: "external-secrets.io/v1beta1"
			kind:       "ExternalSecret"
			metadata: name: target.name
		})
	}
}
