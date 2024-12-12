package holos

// Projects configures how components are bound to clusters in the Platform
// spec.
Projects: #Projects & {
	experiment: _EXPERIMENT.Project
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
