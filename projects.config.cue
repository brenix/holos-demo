package holos

// Projects configures how components are bound to clusters in the Platform
// spec.
Projects: #Projects

for REGION in regions {
	for ZONE in REGION.zones {
		// TODO(jeff) this use of let does not complain if we unify undefined
		// fields.  Link to the bug that's causing this and figure out a work
		// around.  Marcel posted a work around somewhere but I'm having trouble
		// finding it now.  The let is handy because we're in the scope of a nested
		// loop.
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

// We use a hidden field instead of a let alias because a bug in CUE.  If we use
// a let alias unknown fields are allowed and we want CUE to complain if we
// accidentally pass an unknown field.
//
// For example, previous I used name instead of Name and the let alias didn't
// complain.
_EXPERIMENT: #ProjectBuilder & {
	Name: "experiment"
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
