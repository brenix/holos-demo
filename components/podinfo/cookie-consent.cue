package holos

// Schema definition for our configuration.
#Values: {
	ui: enableCookieConsent: *true | false
	ui: message:             string
}

// Map jurisdiction to helm values
JurisdictionValues: {
	// Enable cookie consent by default in any jurisdiction.
	[_]: #Values
	// Disable in the US.
	us: ui: enableCookieConsent: false
	eu: ui: enableCookieConsent: true
}

// Look up the configuration values associated with the environment name.
Component: Values: JurisdictionValues[Environments[EnvironmentName].jurisdiction]
