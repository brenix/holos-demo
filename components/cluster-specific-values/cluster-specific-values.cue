package holos

import "encoding/yaml"

holos: Component.BuildPlan

_Patches: {}
// Guard check, _|_ represents error, called bottom in the language of cue.
if PatchesByCluster[ClusterName] != _|_ {
	_Patches: PatchesByCluster[ClusterName].Patches
}

// Manage a plain ConfigMap as a way to show how values can be passed through
// the system.
Component: #Kubernetes & {

	// Here's the Scenario 2 Solution.  We convert the struct to a list.
	KustomizeConfig: Kustomization: patches: [for x in _Patches {x}]

	Resources: {
		ConfigMap: "cluster-specific-values": {
			metadata: {
				labels: "example.com/cluster.scope": ClusterScope
				labels: "example.com/cluster.stage": ClusterStage
				labels: "example.com/cluster.name":  ClusterName
				annotations: "example.com/scenario": "Modeling the infrastructure and helm values across clusters within it"
				annotations: "example.com/use-case": "Values for a specific cluster"
			}
			data: ClusterValues: yaml.Marshal(_ClusterValues)
			data: ScopeValues:   yaml.Marshal(_ClusterScopeValues)
			data: StageValues:   yaml.Marshal(_ClusterStageValues)
		}

		// For Scenario 2 - See scenario2-kustomize-knockout-patches.cue
		ExternalSecret: "secret-that-is-not-needed": {
			metadata: {
				labels: {
					"example.com/cluster.stage": ClusterStage
					"example.com/cluster.name":  ClusterName
				}
				annotations: {
					"jeff.holos.run/description": "This resource should be knocked out of the manifests for clusters us-west-01a-customer and us-east-02a-customer"
				}
				namespace: "kube-system"
			}
			spec: {}
		}
	}

}

// Guard checks: _|_ represents an error, called "bottom" in CUE.
_ClusterValues: {}
if ClusterValues[ClusterName] != _|_ {
	_ClusterValues: ClusterValues[ClusterName].Values
}

_ClusterScopeValues: {}
if ValuesByClusterScope[ClusterScope] != _|_ {
	_ClusterScopeValues: ValuesByClusterScope[ClusterScope].Values
}

_ClusterStageValues: {}
if ValuesByClusterStage[ClusterStage] != _|_ {
	_ClusterStageValues: ValuesByClusterStage[ClusterStage].Values
}
