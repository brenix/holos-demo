package holos

holos: Component.BuildPlan

Component: #Helm & {
	Name:      "node-local-dns"
	Namespace: "kube-system"
	Chart: {
		name: "node-local-dns"
		version: "2.1.0"
		repository: {
			name: "node-local-dns"
			url: "https://lablabs.github.io/k8s-nodelocaldns-helm"
		}
	}

	KustomizeConfig: Kustomization: namespace: Namespace
}
