package holos

// Projects configures how components are bound to clusters in the Platform
// spec.
Projects: #Projects

for REGION in regions {
	for ZONE in REGION.zones {
		// TODO(jeff) this use of let does not complain like it should if we unify
		// undefined fields.  Link to the bug that's causing this and figure out a
		// work around.  Marcel posted a work around somewhere but I'm having
		// trouble finding it now.  The let is handy because we're in the scope of a
		// nested loop.
		let PROJECT = #ProjectBuilder & {
			Name:   "setup"
			Region: REGION.name
			Zone:   ZONE.name
		}

		// We need a unique key (label)
		let KEY = "region:\(REGION.name):zone:\(ZONE.name):project:\(PROJECT.Name)"

		Projects: (KEY): PROJECT.Project
	}
}

// ComponentsByScopes composes components by cluster scope.
ComponentsByScopes: #ComponentsByScopes & {
	mgmt: {
		components: argocd: {
			name: "argocd"
			path: "components/argocd"
		}
	}
	internal: {}
	customer: {}
}

// ComponentsOnAllClusters represents components components composed into all
// clusters.
ComponentsOnAllClusters: #Components & {
	ClusterScopeValues: {
		name: "cluster-scope-values"
		path: "components/cluster-scope-values"
	}
}
