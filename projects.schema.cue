package holos

import "github.com/holos-run/holos/api/core/v1alpha5:core"

// #ProjectBuilder builds #Project data from field values.
//
// The Holos Authors (Jeff mostly, but he's been talking with Gary and Nate
// about this for years now and they don't seem to object) thinks of a Project
// as a thing that binds other things together, usually by business
// requirements.  This roughly translates to security boundaries and
// who-is-responsible-for-what-where-and-when, so it's quite loose and varies
// from business to business.
//
// I picked up the concept from Google Cloud projects in 2018, which didn't make
// any sense at the time because they were foreign.  The security bit comes from
// AWS accounts being the rough equivalent to a GCP project, IAM policies being
// bound by project/account respectively, plus ZITADEL making it explicit in the
// domain of identity and access management.
//
// What is a project?  The idea of projects is to have a vessel for all
// components who are closely related to each other. Multiple projects can exist
// within an organization.
// Attribution: https://zitadel.com/docs/guides/manage/console/projects
//
// With all that said, here's an attempt to define a project in the context of
// your organization / business.  It binds varying components to clusters,
// oriented to the aspects important to you.
#ProjectBuilder: {
	Name: string | *"default"
	// These are aspects we (you) care about.  They're used kind of like function
	// parameters where the Project field is the return value.  They function to
	// manipulate and orient segments of the platform configuration structure
	// toward us, at least that's how I see it in my mind.  Orienting aspects of
	// the config around to us.
	//
	// Kind of a fancy way of saying they're lookup keys...
	Region: string
	Zone:   string

	Components: #Components

	// Assign the podinfo component to the clusters in the provided Region and
	// Zone.
	for CLUSTER in regions[Region].zones[Zone].clusters {
		// For readability, lots of things have a name.
		let PROJECT = Name

		// Compose components coming from multiple structures into one.  This is an
		// example of struct embedding.
		let COMPONENTS = {
			ComponentsOnAllClusters
			ComponentsByScopes[CLUSTER.scope].components
		}

		// Look up the components associated with the cluster scope, and compose
		// them into the project, which will then roll up to the platform.
		for COMPONENT in COMPONENTS {
			// We have to construct an arbitrary but unique field name in the next
			// statement, otherwise we won't be able to easily unify this Components
			// structure with other structures.  We want to roll this Components up into
			// Platform.Components, but first we need to roll it into
			// Project.components.
			let PREFIX = "project:\(PROJECT):cluster:\(CLUSTER.name)"

			// Mix the component into the project for the specific cluster.
			Components: "\(PREFIX):component:\(COMPONENT.name)": COMPONENT & {
				// repeated here so we can refer to the field in this scope.
				name: string
				labels: "app.holos.run/name": name

				// Write to the cluster specific path.
				let BASE_DIR = "clusters/\(CLUSTER.name)/projects/\(PROJECT)"

				parameters: {
					outputBaseDir: BASE_DIR
					// For the Values based on a given cluster scope use case.
					ClusterScope: CLUSTER.scope
					// For the Values based on a given cluster stage use case.
					ClusterStage: CLUSTER.stage
				}

				let DESCRIPTION = "\(name) for project \(PROJECT) on cluster \(CLUSTER.name)"
				annotations: "app.holos.run/description": DESCRIPTION
			}
		}
	}

	Project: #Project & {
		name:       Name
		components: Components
	}
}

// #Project defines a structure to model the infrastructure and helm values
// across clusters within it.
#Project: {
	name:       string
	components: #Components
}

// #Projects defines a collection of projects, useful to roll them up to the
// Platform spec.
#Projects: [string]: #Project

// #Components represents a collection of components, useful to assign them to a
// cluster.
#Components: [string]: core.#Component

// #ComponentsByScopes composes components cluster scope.  Useful to compose
// components into a cluster given the cluster's scope as a lookup key.
#ComponentsByScopes: [SCOPE=string]: #ComponentsByScope & {scope: SCOPE}

#ComponentsByScope: {
	scope:      #Cluster.#Scope
	components: #Components
}
