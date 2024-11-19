package holos

holos: Kustomize.BuildPlan

Kustomize: #Kustomize & {
	KustomizeConfig: {
		Kustomization: namespace: "eventrouter"
		Files: {
			"resources/namespace.yaml": _
			"resources/configmap.yaml": _
			"resources/deployment.yaml": _
			"resources/rbac.yaml": _
			"resources/serviceaccount.yaml": _
		}
	}	
}
			

