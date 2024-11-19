package holos

import (
	"path"
	app "argoproj.io/application/v1alpha1"
)

#ComponentConfig: {
	Name:          _
	OutputBaseDir: _

	let ArtifactPath = path.Join([OutputBaseDir, "gitops", "\(Name).application.gen.yaml"], path.Unix)
	let ResourcesPath = path.Join(["deploy", OutputBaseDir, "components", Name], path.Unix)

	Artifacts: "\(Name)-application": {
		artifact: ArtifactPath
		generators: [{
			kind:   "Resources"
			output: artifact
			resources: Application: (Name): app.#Application & {
				metadata: name:      Name
				metadata: namespace: "argocd"
				spec: {
					destination: server: "https://kubernetes.default.svc"
					project: "default"
					source: {
						path:           ResourcesPath
						repoURL:        "https://github.com/brenix/holos-demo.git"
						targetRevision: "main"
					}
				}
			}
		}]
	}
}
