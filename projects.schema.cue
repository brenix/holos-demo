package holos

import "github.com/holos-run/holos/api/core/v1alpha5:core"

// #Project defines a structure to model the infrastructure and helm values
// across clusters within it.
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
#Project: {
	name:       string
	clusters:   #Clusters
	components: #Components
}

// #Projects defines a collection of projects, useful to roll them up to the
// Platform spec.
#Projects: [NAME=string]: #Project & {name: NAME}

// #Clusters represents a collection of clusters.
#Clusters: [NAME=string]: #Cluster & {name: NAME}

// #Components represents a collection of components, useful to assign them to a
// cluster.
#Components: [string]: core.#Component
