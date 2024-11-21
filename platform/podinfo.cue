package holos

Platform: Components: {
	podinfoPDX: ProdPodinfo & {_city: "pdx"}
	podinfoCMH: ProdPodinfo & {_city: "cmh"}
	podinfoAMS: ProdPodinfo & {_city: "ams"}
	podinfoDEV: {
		name: "podinfo-dev"
		path: "components/podinfo"
		labels: "app.holos.run/component": "podinfo"
		parameters: EnvironmentName:       "dev"
	}
}

let ProdPodinfo = {
	_city: string
	name:  "podinfo-\(_city)"
	path:  "components/podinfo"
	labels: "app.holos.run/component": "podinfo"
	labels: "app.holos.run/tier":      "prod"
	labels: "app.holos.run/city":      _city
	parameters: EnvironmentName:       "prod-\(_city)"
}
