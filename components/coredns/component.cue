package holos

holos: Component.BuildPlan

Component: #Helm & {
	Name:      "coredns"
	Namespace: "kube-system"
	Chart: {
		name: "coredns"
		version: "1.36.1"
		repository: {
			name: "coredns"
			url:  "https://coredns.github.io/helm"
		}
	}

	KustomizeConfig: Kustomization: namespace: Namespace
}
