package holos

// Injected from Platform.spec.components.parameters.EnvironmentName
EnvironmentName: string @tag(EnvironmentName)

Environments: #Environments & {
	"prod-pdx": {
		tier:         "prod"
		jurisdiction: "us"
		state:        "oregon"
	}
	"prod-cmh": {
		tier:         "prod"
		jurisdiction: "us"
		state:        "ohio"
	}
	"prod-ams": {
		tier:         "prod"
		jurisdiction: "eu"
		state:        "netherlands"
	}
	// Nonprod environments are colocated together.
	_nonprod: {
		tier:         "nonprod"
		jurisdiction: "us"
		state:        "oregon"
	}
	dev:   _nonprod
	test:  _nonprod
	stage: _nonprod
}
