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
