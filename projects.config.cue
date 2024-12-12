package holos

// Projects configures how components are bound to clusters in the Platform
// spec.
Projects: #Projects & {
	experiment: EXPERIMENT.Project
}

// Let alias to access the Project field of the built project.  Let aliases are
// visible within the current scope, the file in this case.
let EXPERIMENT = #ProjectBuilder & {
	name: "experiment"
}

// #ProjectBuilder builds #Project data from field values.
#ProjectBuilder: {
	Name: string | *"default"
	// These are aspects we (you) care about.  They're used kind of like function
	// parameters where the Project field is the return value.  They function to
	// manipulate and orient segments of the platform configuration structure
	// toward us, at least that's how I see it in my mind.  Orienting aspects of
	// the config around to us.
	//
	// Kind of a fancy way of saying they're lookup keys...
	Region: string | *"dev1"
	Zone:   string | *"dev1a"

	Components: #Components

	// Assign the podinfo component to the clusters in the provided Region and
	// Zone.
	for CLUSTER in regions[Region].zones[Zone].clusters {
		// For readability, lots of things have a name.
		let PROJECT = Name

		// We have to construct an arbitrary but unique field name in the next
		// statement, otherwise we won't be able to easily unify this Components
		// structure with other structures.  We want to roll this Components up into
		// Platform.Components, but first we need to roll it into
		// Project.components.
		//
		// Side note: the inconsistent looking, but consistently alternating,
		// capitalization in the previous sentence is to easily reference these
		// fields as we alternate rolling these structures up into the Platform.  I
		// hate it.  It saves a let variable though, which is worth it I guess?
		Components: "project:\(PROJECT):cluster:\(CLUSTER.name):component:podinfo": {
			name: "podinfo"
			path: "components/podinfo"
		}
		// NOTE: We would repeat the above for each component in this project.
	}

	Project: #Project & {
		name:       Name
		components: Components
	}
}
