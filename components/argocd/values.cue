package holos

import core "k8s.io/api/core/v1"

#Values: {
	//# Argo CD configuration
	//# Ref: https://github.com/argoproj/argo-cd
	//#
	// -- Provide a name in place of `argocd`
	nameOverride: "argocd"
	// -- String to fully override `"argo-cd.fullname"`
	fullnameOverride: ""
	// -- Override the namespace
	// @default -- `.Release.Namespace`
	namespaceOverride: ""
	// -- Override the Kubernetes version, which is used to evaluate certain manifests
	kubeVersionOverride: ""
	// Override APIVersions
	// If you want to template helm charts but cannot access k8s API server
	// you can set api versions here
	apiVersionOverrides: {}

	// -- Create aggregated roles that extend existing cluster roles to interact with argo-cd resources
	//# Ref: https://kubernetes.io/docs/reference/access-authn-authz/rbac/#aggregated-clusterroles
	createAggregateRoles: false
	// -- Create cluster roles for cluster-wide installation.
	//# Used when you manage applications in the same cluster where Argo CD runs
	createClusterRoles: true
	openshift: {
		// -- enables using arbitrary uid for argo repo server
		enabled: false
	}

	//# Custom resource configuration
	crds: {
		// -- Install and upgrade CRDs
		install: true
		// -- Keep CRDs on chart uninstall
		keep: true
		// -- Annotations to be added to all CRDs
		annotations: {}
		// -- Addtional labels to be added to all CRDs
		additionalLabels: {}
	}

	//# Globally shared configuration
	global: {
		// -- Default domain used by all components
		//# Used for ingresses, certificates, SSO, notifications, etc.
		domain: "argocd.example.com"

		// -- Runtime class name for all components
		runtimeClassName: ""

		// -- Common labels for the all resources
		// app: argo-cd
		additionalLabels: {}

		// -- Number of old deployment ReplicaSets to retain. The rest will be garbage collected.
		revisionHistoryLimit: 3

		// Default image used by all components
		image: {
			// -- If defined, a repository applied to all Argo CD deployments
			repository: "quay.io/argoproj/argocd"
			// -- Overrides the global Argo CD image tag whose default is the chart appVersion
			tag: ""
			// -- If defined, a imagePullPolicy applied to all Argo CD deployments
			imagePullPolicy: "IfNotPresent"
		}

		// -- Secrets with credentials to pull images from a private registry
		imagePullSecrets: []

		// Default logging options used by all components
		logging: {
			// -- Set the global logging format. Either: `text` or `json`
			format: "text"
			// -- Set the global logging level. One of: `debug`, `info`, `warn` or `error`
			level: "info"
		}

		// -- Annotations for the all deployed Statefulsets
		statefulsetAnnotations: {}

		// -- Annotations for the all deployed Deployments
		deploymentAnnotations: {}

		// -- Annotations for the all deployed pods
		podAnnotations: {}

		// -- Labels for the all deployed pods
		podLabels: {}

		// -- Add Prometheus scrape annotations to all metrics services. This can be used as an alternative to the ServiceMonitors.
		addPrometheusAnnotations: false

		// -- Toggle and define pod-level security context.
		// @default -- `{}` (See [values.yaml])
		//  runAsUser: 999
		//  runAsGroup: 999
		//  fsGroup: 999
		securityContext: {}

		// -- Mapping between IP and hostnames that will be injected as entries in the pod's hosts files
		// - ip: 10.20.30.40
		//   hostnames:
		//   - git.myhostname
		hostAliases: []

		// Configure dual-stack used by all component services
		dualStack: {
			// -- IP family policy to configure dual-stack see [Configure dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack/#services)
			ipFamilyPolicy: ""
			// -- IP families that should be supported and the order in which they should be applied to ClusterIP as well. Can be IPv4 and/or IPv6.
			ipFamilies: []
		}

		// Default network policy rules used by all components
		networkPolicy: {
			// -- Create NetworkPolicy objects for all components
			create: false
			// -- Default deny all ingress traffic
			defaultDenyIngress: false
		}

		// -- Default priority class for all components
		priorityClassName: ""

		// -- Default node selector for all components
		nodeSelector: {}

		// -- Default tolerations for all components
		tolerations: [...core.#Toleration]

		// Default affinity preset for all components
		affinity: {
			// -- Default pod anti-affinity rules. Either: `none`, `soft` or `hard`
			podAntiAffinity: "none" | *"soft" | "hard"
			// Node affinity rules
			nodeAffinity: {
				// -- Default node affinity rules. Either: `none`, `soft` or `hard`
				type: "none" | "soft" | *"hard"
				// -- Default match expressions for node affinity
				// - key: topology.kubernetes.io/zone
				//   operator: In
				//   values:
				//    - antarctica-east1
				//    - antarctica-west1
				matchExpressions: []
			}
		}

		// -- Default [TopologySpreadConstraints] rules for all components
		//# Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
		//# If labelSelector is left out, it will default to the labelSelector of the component
		// - maxSkew: 1
		//   topologyKey: topology.kubernetes.io/zone
		//   whenUnsatisfiable: DoNotSchedule
		topologySpreadConstraints: []

		// -- Deployment strategy for the all deployed Deployments
		// type: RollingUpdate
		// rollingUpdate:
		//   maxSurge: 25%
		//   maxUnavailable: 25%
		deploymentStrategy: {}

		// -- Environment variables to pass to all deployed Deployments
		env: []

		// -- Annotations for the all deployed Certificates
		certificateAnnotations: {}
	}

	//# Argo Configs
	configs: {
		// General Argo CD configuration
		//# Ref: https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/argocd-cm.yaml
		cm: {
			// -- Create the argocd-cm configmap for [declarative setup]
			create: true

			// -- Annotations to be added to argocd-cm configmap
			annotations: {}

			// -- The name of tracking label used by Argo CD for resource pruning
			"application.instanceLabelKey": "argocd.argoproj.io/instance"

			// -- Enable logs RBAC enforcement
			//# Ref: https://argo-cd.readthedocs.io/en/latest/operator-manual/upgrading/2.3-2.4/#enable-logs-rbac-enforcement
			"server.rbac.log.enforce.enable": false

			// -- Enable exec feature in Argo UI
			//# Ref: https://argo-cd.readthedocs.io/en/latest/operator-manual/rbac/#exec-resource
			"exec.enabled": false

			// -- Enable local admin user
			//# Ref: https://argo-cd.readthedocs.io/en/latest/faq/#how-to-disable-admin-user
			"admin.enabled": true

			// -- Timeout to discover if a new manifests version got published to the repository
			"timeout.reconciliation": "180s"

			// -- Timeout to refresh application data as well as target manifests cache
			"timeout.hard.reconciliation": "0s"

			// -- Enable Status Badge
			//# Ref: https://argo-cd.readthedocs.io/en/stable/user-guide/status-badge/
			// Dex configuration
			// dex.config: |
			//   connectors:
			//     # GitHub example
			//     - type: github
			//       id: github
			//       name: GitHub
			//       config:
			//         clientID: aabbccddeeff00112233
			//         clientSecret: $dex.github.clientSecret # Alternatively $<some_K8S_secret>:dex.github.clientSecret
			//         orgs:
			//         - name: your-github-org
			// OIDC configuration as an alternative to dex (optional).
			// oidc.config: |
			//   name: AzureAD
			//   issuer: https://login.microsoftonline.com/TENANT_ID/v2.0
			//   clientID: CLIENT_ID
			//   clientSecret: $oidc.azuread.clientSecret
			//   rootCA: |
			//     -----BEGIN CERTIFICATE-----
			//     ... encoded certificate data here ...
			//     -----END CERTIFICATE-----
			//   requestedIDTokenClaims:
			//     groups:
			//       essential: true
			//   requestedScopes:
			//     - openid
			//     - profile
			//     - email
			"statusbadge.enabled": false
		}

		// Argo CD configuration parameters
		//# Ref: https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/argocd-cmd-params-cm.yaml
		params: {
			// -- Create the argocd-cmd-params-cm configmap
			// If false, it is expected the configmap will be created by something else.
			create: true

			// -- Annotations to be added to the argocd-cmd-params-cm ConfigMap
			annotations: {}

			//# Generic parameters
			// -- Open-Telemetry collector address: (e.g. "otel-collector:4317")
			"otlp.address": ""

			//# Controller Properties
			// -- Number of application status processors
			"controller.status.processors": 20
			// -- Number of application operation processors
			"controller.operation.processors": 10
			// -- Specifies timeout between application self heal attempts
			"controller.self.heal.timeout.seconds": 5
			// -- Repo server RPC call timeout seconds.
			"controller.repo.server.timeout.seconds": 60

			//# Server properties
			// -- Run server without TLS
			//# NOTE: This value should be set when you generate params by other means as it changes ports used by ingress template.
			"server.insecure": false
			// -- Value for base href in index.html. Used if Argo CD is running behind reverse proxy under subpath different from /
			"server.basehref": "/"
			// -- Used if Argo CD is running behind reverse proxy under subpath different from /
			"server.rootpath": ""
			// -- Directory path that contains additional static assets
			"server.staticassets": "/shared/app"
			// -- Disable Argo CD RBAC for user authentication
			"server.disable.auth": false
			// -- Enable GZIP compression
			"server.enable.gzip": true
			// -- Set X-Frame-Options header in HTTP responses to value. To disable, set to "".
			"server.x.frame.options": "sameorigin"

			//# Repo-server properties
			// -- Limit on number of concurrent manifests generate requests. Any value less the 1 means no limit.
			"reposerver.parallelism.limit": 0

			//# ApplicationSet Properties
			// -- Modify how application is synced between the generator and the cluster. One of: `sync`, `create-only`, `create-update`, `create-delete`
			"applicationsetcontroller.policy": "sync"
			// -- Enables use of the Progressive Syncs capability
			"applicationsetcontroller.enable.progressive.syncs": false

			// -- Enables [Applications in any namespace]
			//# List of additional namespaces where applications may be created in and reconciled from.
			//# The namespace where Argo CD is installed to will always be allowed.
			//# Set comma-separated list. (e.g. app-team-one, app-team-two)
			"application.namespaces": ""

			// -- JQ Path expression timeout
			//# By default, the evaluation of a JQPathExpression is limited to one second.
			//# If you encounter a "JQ patch execution timed out" error message due to a complex JQPathExpression
			//# that requires more time to evaluate, you can extend the timeout period.
			"controller.ignore.normalizer.jq.timeout": "1s"
		}

		// Argo CD RBAC policy configuration
		//# Ref: https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/rbac.md
		rbac: {
			// -- Create the argocd-rbac-cm configmap with ([Argo CD RBAC policy]) definitions.
			// If false, it is expected the configmap will be created by something else.
			// Argo CD will not work if there is no configmap created with the name above.
			create: true

			// -- Annotations to be added to argocd-rbac-cm configmap
			annotations: {}

			// -- The name of the default role which Argo CD will falls back to, when authorizing API requests (optional).
			// If omitted or empty, users may be still be able to login, but will see no apps, projects, etc...
			"policy.default": ""

			// -- File containing user-defined policies and role definitions.
			// @default -- `''` (See [values.yaml])
			// Policy rules are in the form:
			//  p, subject, resource, action, object, effect
			// Role definitions and bindings are in the form:
			//  g, subject, inherited-subject
			// policy.csv: |
			//   p, role:org-admin, applications, *, */*, allow
			//   p, role:org-admin, clusters, get, *, allow
			//   p, role:org-admin, repositories, *, *, allow
			//   p, role:org-admin, logs, get, *, allow
			//   p, role:org-admin, exec, create, */*, allow
			//   g, your-github-org:your-team, role:org-admin
			"policy.csv": ""

			// -- OIDC scopes to examine during rbac enforcement (in addition to `sub` scope).
			// The scope value can be a string, or a list of strings.
			scopes: "[groups]"

			// -- Matcher function for Casbin, `glob` for glob matcher and `regex` for regex matcher.
			"policy.matchMode": "glob"
		}

		// GnuPG public keys for commit verification
		//# Ref: https://argo-cd.readthedocs.io/en/stable/user-guide/gpg-verification/
		gpg: {
			// -- Annotations to be added to argocd-gpg-keys-cm configmap
			annotations: {}

			// -- [GnuPG] public keys to add to the keyring
			// @default -- `{}` (See [values.yaml])
			//# Note: Public keys should be exported with `gpg --export --armor <KEY>`
			// 4AEE18F83AFDEB23: |
			//   -----BEGIN PGP PUBLIC KEY BLOCK-----
			//   ...
			//   -----END PGP PUBLIC KEY BLOCK-----
			keys: {}
		}

		// SSH known hosts for Git repositories
		//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#ssh-known-host-public-keys
		ssh: {
			// -- Annotations to be added to argocd-ssh-known-hosts-cm configmap
			annotations: {}

			// -- Known hosts to be added to the known host list by default.
			// @default -- See [values.yaml]
			knownHosts: """
				[ssh.github.com]:443 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
				[ssh.github.com]:443 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
				[ssh.github.com]:443 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
				bitbucket.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPIQmuzMBuKdWeF4+a2sjSSpBK0iqitSQ+5BM9KhpexuGt20JpTVM7u5BDZngncgrqDMbWdxMWWOGtZ9UgbqgZE=
				bitbucket.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIazEu89wgQZ4bqs3d63QSMzYVa0MuJ2e2gKTKqu+UUO
				bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQeJzhupRu0u0cdegZIa8e86EG2qOCsIsD1Xw0xSeiPDlCr7kq97NLmMbpKTX6Esc30NuoqEEHCuc7yWtwp8dI76EEEB1VqY9QJq6vk+aySyboD5QF61I/1WeTwu+deCbgKMGbUijeXhtfbxSxm6JwGrXrhBdofTsbKRUsrN1WoNgUa8uqN1Vx6WAJw1JHPhglEGGHea6QICwJOAr/6mrui/oB7pkaWKHj3z7d1IC4KWLtY47elvjbaTlkN04Kc/5LFEirorGYVbt15kAUlqGM65pk6ZBxtaO3+30LVlORZkxOh+LKL/BvbZ/iRNhItLqNyieoQj/uh/7Iv4uyH/cV/0b4WDSd3DptigWq84lJubb9t/DnZlrJazxyDCulTmKdOR7vs9gMTo+uoIrPSb8ScTtvw65+odKAlBj59dhnVp9zd7QUojOpXlL62Aw56U4oO+FALuevvMjiWeavKhJqlR7i5n9srYcrNV7ttmDw7kf/97P5zauIhxcjX+xHv4M=
				github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
				github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
				github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
				gitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=
				gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
				gitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9
				ssh.dev.azure.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H
				vs-ssh.visualstudio.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H

				"""

			// -- Additional known hosts for private repositories
			extraHosts: ""
		}

		// Repository TLS certificates
		// Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#repositories-using-self-signed-tls-certificates-or-are-signed-by-custom-ca
		tls: {
			// -- Annotations to be added to argocd-tls-certs-cm configmap
			annotations: {}

			// -- TLS certificates for Git repositories
			// @default -- `{}` (See [values.yaml])
			// server.example.com: |
			//   -----BEGIN CERTIFICATE-----
			//   ...
			//   -----END CERTIFICATE-----
			certificates: {}
		}

		// ConfigMap for Config Management Plugins
		// Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/config-management-plugins/
		// --- Second plugin
		// my-plugin2:
		//   init:
		//     command: [sh]
		//     args: [-c, 'echo "Initializing..."']
		//   generate:
		//     command: [sh, -c]
		//     args:
		//       - |
		//         echo "{\"kind\": \"ConfigMap\", \"apiVersion\": \"v1\", \"metadata\": { \"name\": \"$ARGOCD_APP_NAME\", \"namespace\": \"$ARGOCD_APP_NAMESPACE\", \"annotations\": {\"Foo\": \"$ARGOCD_ENV_FOO\", \"KubeVersion\": \"$KUBE_VERSION\", \"KubeApiVersion\": \"$KUBE_API_VERSIONS\",\"Bar\": \"baz\"}}}"
		//   discover:
		//     fileName: "./subdir/s*.yaml"
		//     find:
		//       glob: "**/Chart.yaml"
		//       command: [sh, -c, find . -name env.yaml]
		cmp: {
			// -- Create the argocd-cmp-cm configmap
			create: false

			// -- Annotations to be added to argocd-cmp-cm configmap
			annotations: {}

			// -- Plugin yaml files to be added to argocd-cmp-cm
			// --- First plugin
			// my-plugin:
			//   init:
			//     command: [sh]
			//     args: [-c, 'echo "Initializing..."']
			//   generate:
			//     command: [sh, -c]
			//     args:
			//       - |
			//         echo "{\"kind\": \"ConfigMap\", \"apiVersion\": \"v1\", \"metadata\": { \"name\": \"$ARGOCD_APP_NAME\", \"namespace\": \"$ARGOCD_APP_NAMESPACE\", \"annotations\": {\"Foo\": \"$ARGOCD_ENV_FOO\", \"KubeVersion\": \"$KUBE_VERSION\", \"KubeApiVersion\": \"$KUBE_API_VERSIONS\",\"Bar\": \"baz\"}}}"
			//   discover:
			//     fileName: "./subdir/s*.yaml"
			//     find:
			//       glob: "**/Chart.yaml"
			//       command: [sh, -c, find . -name env.yaml]
			plugins: {}
		}

		// -- Provide one or multiple [external cluster credentials]
		// @default -- `{}` (See [values.yaml])
		//# Ref:
		//# - https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#clusters
		//# - https://argo-cd.readthedocs.io/en/stable/operator-manual/security/#external-cluster-credentials
		//# - https://argo-cd.readthedocs.io/en/stable/user-guide/projects/#project-scoped-repositories-and-clusters
		// mycluster:
		//   server: https://mycluster.example.com
		//   labels: {}
		//   annotations: {}
		//   config:
		//     bearerToken: "<authentication token>"
		//     tlsClientConfig:
		//       insecure: false
		//       caData: "<base64 encoded certificate>"
		// mycluster2:
		//   server: https://mycluster2.example.com
		//   labels: {}
		//   annotations: {}
		//   namespaces: namespace1,namespace2
		//   clusterResources: true
		//   config:
		//     bearerToken: "<authentication token>"
		//     tlsClientConfig:
		//       insecure: false
		//       caData: "<base64 encoded certificate>"
		// mycluster3-project-scoped:
		//   server: https://mycluster3.example.com
		//   labels: {}
		//   annotations: {}
		//   project: my-project1
		//   config:
		//     bearerToken: "<authentication token>"
		//     tlsClientConfig:
		//       insecure: false
		//       caData: "<base64 encoded certificate>"
		// mycluster4-sharded:
		//   shard: 1
		//   server: https://mycluster4.example.com
		//   labels: {}
		//   annotations: {}
		//   config:
		//     bearerToken: "<authentication token>"
		//     tlsClientConfig:
		//       insecure: false
		//       caData: "<base64 encoded certificate>"
		clusterCredentials: {}

		// -- Repository credentials to be used as Templates for other repos
		//# Creates a secret for each key/value specified below to create repository credentials
		// github-enterprise-creds-1:
		//   url: https://github.com/argoproj
		//   githubAppID: 1
		//   githubAppInstallationID: 2
		//   githubAppEnterpriseBaseUrl: https://ghe.example.com/api/v3
		//   githubAppPrivateKey: |
		//     -----BEGIN OPENSSH PRIVATE KEY-----
		//     ...
		//     -----END OPENSSH PRIVATE KEY-----
		// https-creds:
		//   url: https://github.com/argoproj
		//   password: my-password
		//   username: my-username
		// ssh-creds:
		//  url: git@github.com:argoproj-labs
		//  sshPrivateKey: |
		//    -----BEGIN OPENSSH PRIVATE KEY-----
		//    ...
		//    -----END OPENSSH PRIVATE KEY-----
		credentialTemplates: {}

		// -- Annotations to be added to `configs.credentialTemplates` Secret
		credentialTemplatesAnnotations: {}

		// -- Repositories list to be used by applications
		//# Creates a secret for each key/value specified below to create repositories
		//# Note: the last example in the list would use a repository credential template, configured under "configs.credentialTemplates".
		// istio-helm-repo:
		//   url: https://storage.googleapis.com/istio-prerelease/daily-build/master-latest-daily/charts
		//   name: istio.io
		//   type: helm
		// private-helm-repo:
		//   url: https://my-private-chart-repo.internal
		//   name: private-repo
		//   type: helm
		//   password: my-password
		//   username: my-username
		// private-repo:
		//   url: https://github.com/argoproj/private-repo
		repositories: {}

		// -- Annotations to be added to `configs.repositories` Secret
		repositoriesAnnotations: {}

		// Argo CD sensitive data
		// Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/#sensitive-data-and-sso-client-secrets
		secret: {
			// -- Create the argocd-secret
			createSecret: true
			// -- Labels to be added to argocd-secret
			labels: {}
			// -- Annotations to be added to argocd-secret
			annotations: {}

			// -- Shared secret for authenticating GitHub webhook events
			githubSecret: ""
			// -- Shared secret for authenticating GitLab webhook events
			gitlabSecret: ""
			// -- Shared secret for authenticating BitbucketServer webhook events
			bitbucketServerSecret: ""
			// -- UUID for authenticating Bitbucket webhook events
			bitbucketUUID: ""
			// -- Shared secret for authenticating Gogs webhook events
			gogsSecret: ""
			//# Azure DevOps
			azureDevops: {
				// -- Shared secret username for authenticating Azure DevOps webhook events
				username: ""
				// -- Shared secret password for authenticating Azure DevOps webhook events
				password: ""
			}

			// -- add additional secrets to be added to argocd-secret
			//# Custom secrets. Useful for injecting SSO secrets into environment variables.
			//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/#sensitive-data-and-sso-client-secrets
			//# Note that all values must be non-empty.
			// LDAP_PASSWORD: "mypassword"
			extra: {}

			// -- Bcrypt hashed admin password
			//# Argo expects the password in the secret to be bcrypt hashed. You can create this hash with
			//# `htpasswd -nbBC 10 "" $ARGO_PWD | tr -d ':\n' | sed 's/$2y/$2a/'`
			argocdServerAdminPassword: ""
			// -- Admin password modification time. Eg. `"2006-01-02T15:04:05Z"`
			// @default -- `""` (defaults to current time)
			argocdServerAdminPasswordMtime: ""
		}

		// -- Define custom [CSS styles] for your argo instance.
		// This setting will automatically mount the provided CSS and reference it in the argo configuration.
		// @default -- `""` (See [values.yaml])
		//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/custom-styles/
		// styles: |
		//  .sidebar {
		//    background: linear-gradient(to bottom, #999, #777, #333, #222, #111);
		//  }
		styles: ""
	}

	// -- Array of extra K8s manifests to deploy
	//# Note: Supports use of custom Helm templates
	// - apiVersion: secrets-store.csi.x-k8s.io/v1
	//   kind: SecretProviderClass
	//   metadata:
	//     name: argocd-secrets-store
	//   spec:
	//     provider: aws
	//     parameters:
	//       objects: |
	//         - objectName: "argocd"
	//           objectType: "secretsmanager"
	//           jmesPath:
	//               - path: "client_id"
	//                 objectAlias: "client_id"
	//               - path: "client_secret"
	//                 objectAlias: "client_secret"
	//     secretObjects:
	//     - data:
	//       - key: client_id
	//         objectName: client_id
	//       - key: client_secret
	//         objectName: client_secret
	//       secretName: argocd-secrets-store
	//       type: Opaque
	//       labels:
	//         app.kubernetes.io/part-of: argocd
	extraObjects: []

	//# Application controller
	controller: {
		// -- Application controller name string
		name: "application-controller"

		// -- The number of application controller pods to run.
		// Additional replicas will cause sharding of managed clusters across number of replicas.
		//# With dynamic cluster distribution turned on, sharding of the clusters will gracefully
		//# rebalance if the number of replica's changes or one becomes unhealthy. (alpha)
		replicas: 1

		// -- Enable dynamic cluster distribution (alpha)
		// Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/dynamic-cluster-distribution
		//# This is done using a deployment instead of a statefulSet
		//# When replicas are added or removed, the sharding algorithm is re-run to ensure that the
		//# clusters are distributed according to the algorithm. If the algorithm is well-balanced,
		//# like round-robin, then the shards will be well-balanced.
		dynamicClusterDistribution: false

		// -- Runtime class name for the application controller
		// @default -- `""` (defaults to global.runtimeClassName)
		runtimeClassName: ""

		// -- Application controller heartbeat time
		// Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/dynamic-cluster-distribution/#working-of-dynamic-distribution
		heartbeatTime: 10

		// -- Maximum number of controller revisions that will be maintained in StatefulSet history
		revisionHistoryLimit: 5

		//# Application controller Pod Disruption Budget
		//# Ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
		pdb: {
			// -- Deploy a [PodDisruptionBudget] for the application controller
			enabled: false
			// -- Labels to be added to application controller pdb
			labels: {}
			// -- Annotations to be added to application controller pdb
			annotations: {}
			// -- Number of pods that are available after eviction as number or percentage (eg.: 50%)
			// @default -- `""` (defaults to 0 if not specified)
			minAvailable: ""
			// -- Number of pods that are unavailable after eviction as number or percentage (eg.: 50%).
			//# Has higher precedence over `controller.pdb.minAvailable`
			maxUnavailable: ""
		}

		//# Application controller image
		image: {
			// -- Repository to use for the application controller
			// @default -- `""` (defaults to global.image.repository)
			repository: ""
			// -- Tag to use for the application controller
			// @default -- `""` (defaults to global.image.tag)
			tag: ""
			// -- Image pull policy for the application controller
			// @default -- `""` (defaults to global.image.imagePullPolicy)
			imagePullPolicy: ""
		}

		// -- Secrets with credentials to pull images from a private registry
		// @default -- `[]` (defaults to global.imagePullSecrets)
		imagePullSecrets: []

		// -- Additional command line arguments to pass to application controller
		extraArgs: []

		// -- Environment variables to pass to application controller
		env: []

		// -- envFrom to pass to application controller
		// @default -- `[]` (See [values.yaml])
		// - configMapRef:
		//     name: config-map-name
		// - secretRef:
		//     name: secret-name
		envFrom: []

		// -- Additional containers to be added to the application controller pod
		//# Note: Supports use of custom Helm templates
		extraContainers: []

		// -- Init containers to add to the application controller pod
		//# If your target Kubernetes cluster(s) require a custom credential (exec) plugin
		//# you could use this (and the same in the server pod) to provide such executable
		//# Ref: https://kubernetes.io/docs/reference/access-authn-authz/authentication/#client-go-credential-plugins
		//# Note: Supports use of custom Helm templates
		//  - name: download-tools
		//    image: alpine:3
		//    command: [sh, -c]
		//    args:
		//      - wget -qO kubelogin.zip https://github.com/Azure/kubelogin/releases/download/v0.0.25/kubelogin-linux-amd64.zip &&
		//        unzip kubelogin.zip && mv bin/linux_amd64/kubelogin /custom-tools/
		//    volumeMounts:
		//      - mountPath: /custom-tools
		//        name: custom-tools
		initContainers: []

		// -- Additional volumeMounts to the application controller main container
		//  - mountPath: /usr/local/bin/kubelogin
		//    name: custom-tools
		//    subPath: kubelogin
		volumeMounts: []

		// -- Additional volumes to the application controller pod
		//  - name: custom-tools
		//    emptyDir: {}
		volumes: []

		//# Application controller emptyDir volumes
		emptyDir: {
			// -- EmptyDir size limit for application controller
			// @default -- `""` (defaults not set if not specified i.e. no size limit)
			// sizeLimit: "1Gi"
			sizeLimit: ""
		}

		// -- Annotations for the application controller StatefulSet
		statefulsetAnnotations: {}

		// -- Annotations for the application controller Deployment
		deploymentAnnotations: {}

		// -- Annotations to be added to application controller pods
		podAnnotations: {}

		// -- Labels to be added to application controller pods
		podLabels: {}

		// -- Resource limits and requests for the application controller pods
		//  limits:
		//    cpu: 500m
		//    memory: 512Mi
		//  requests:
		//    cpu: 250m
		//    memory: 256Mi
		resources: {}

		// Application controller container ports
		containerPorts: {
			// -- Metrics container port
			metrics: 8082
		}

		// -- Host Network for application controller pods
		hostNetwork: false

		// -- [DNS configuration]
		dnsConfig: {}
		// -- Alternative DNS policy for application controller pods
		dnsPolicy: "ClusterFirst"

		// -- Application controller container-level security context
		// @default -- See [values.yaml]
		containerSecurityContext: {
			runAsNonRoot:             true
			readOnlyRootFilesystem:   true
			allowPrivilegeEscalation: false
			seccompProfile: type: "RuntimeDefault"
			capabilities: drop: ["ALL"]
		}

		// Readiness probe for application controller
		//# Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
		readinessProbe: {
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
		}

		// -- terminationGracePeriodSeconds for container lifecycle hook
		terminationGracePeriodSeconds: 30

		// -- Priority class for the application controller pods
		// @default -- `""` (defaults to global.priorityClassName)
		priorityClassName: ""

		// -- [Node selector]
		// @default -- `{}` (defaults to global.nodeSelector)
		nodeSelector: {}

		// -- [Tolerations] for use with node taints
		// @default -- `[]` (defaults to global.tolerations)
		tolerations: []

		// -- Assign custom [affinity] rules to the deployment
		// @default -- `{}` (defaults to global.affinity preset)
		affinity: {}

		// -- Assign custom [TopologySpreadConstraints] rules to the application controller
		// @default -- `[]` (defaults to global.topologySpreadConstraints)
		//# Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
		//# If labelSelector is left out, it will default to the labelSelector configuration of the deployment
		// - maxSkew: 1
		//   topologyKey: topology.kubernetes.io/zone
		//   whenUnsatisfiable: DoNotSchedule
		topologySpreadConstraints: []

		// -- Automount API credentials for the Service Account into the pod.
		automountServiceAccountToken: true
		serviceAccount: {
			// -- Create a service account for the application controller
			create: true
			// -- Service account name
			name: "argocd-application-controller"
			// -- Annotations applied to created service account
			annotations: {}
			// -- Labels applied to created service account
			labels: {}
			// -- Automount API credentials for the Service Account
			automountServiceAccountToken: true
		}

		//# Application controller metrics configuration
		metrics: {
			// -- Deploy metrics service
			enabled: false
			// -- Prometheus ServiceMonitor scrapeTimeout. If empty, Prometheus uses the global scrape timeout unless it is less than the target's scrape interval value in which the latter is used.
			scrapeTimeout: ""
			applicationLabels: {
				// -- Enables additional labels in argocd_app_labels metric
				enabled: false
				// -- Additional labels
				labels: []
			}
			service: {
				// -- Metrics service type
				type: "ClusterIP"
				// -- Metrics service clusterIP. `None` makes a "headless service" (no virtual IP)
				clusterIP: ""
				// -- Metrics service annotations
				annotations: {}
				// -- Metrics service labels
				labels: {}
				// -- Metrics service port
				servicePort: 8082
				// -- Metrics service port name
				portName: "http-metrics"
			}
			serviceMonitor: {
				// -- Enable a prometheus ServiceMonitor
				enabled: false
				// -- Prometheus ServiceMonitor interval
				interval: "30s"
				// -- Prometheus [RelabelConfigs] to apply to samples before scraping
				relabelings: []
				// -- Prometheus [MetricRelabelConfigs] to apply to samples before ingestion
				metricRelabelings: []
				// -- Prometheus ServiceMonitor selector
				// prometheus: kube-prometheus
				selector: {}

				// -- Prometheus ServiceMonitor scheme
				scheme: ""
				// -- Prometheus ServiceMonitor tlsConfig
				tlsConfig: {}
				// -- Prometheus ServiceMonitor namespace
				namespace: "" // "monitoring"
				// -- Prometheus ServiceMonitor labels
				additionalLabels: {}
				// -- Prometheus ServiceMonitor annotations
				annotations: {}
			}
			rules: {
				// -- Deploy a PrometheusRule for the application controller
				enabled: false
				// -- PrometheusRule namespace
				namespace: "" // "monitoring"
				// -- PrometheusRule selector
				// prometheus: kube-prometheus
				selector: {}

				// -- PrometheusRule labels
				additionalLabels: {}
				// -- PrometheusRule annotations
				annotations: {}

				// -- PrometheusRule.Spec for the application controller
				// - alert: ArgoAppMissing
				//   expr: |
				//     absent(argocd_app_info) == 1
				//   for: 15m
				//   labels:
				//     severity: critical
				//   annotations:
				//     summary: "[Argo CD] No reported applications"
				//     description: >
				//       Argo CD has not reported any applications data for the past 15 minutes which
				//       means that it must be down or not functioning properly.  This needs to be
				//       resolved for this cloud to continue to maintain state.
				// - alert: ArgoAppNotSynced
				//   expr: |
				//     argocd_app_info{sync_status!="Synced"} == 1
				//   for: 12h
				//   labels:
				//     severity: warning
				//   annotations:
				//     summary: "[{{`{{$labels.name}}`}}] Application not synchronized"
				//     description: >
				//       The application [{{`{{$labels.name}}`}} has not been synchronized for over
				//       12 hours which means that the state of this cloud has drifted away from the
				//       state inside Git.
				spec: []
			}
		}

		//# Enable this and set the rules: to whatever custom rules you want for the Cluster Role resource.
		//# Defaults to off
		clusterRoleRules: {
			// -- Enable custom rules for the application controller's ClusterRole resource
			enabled: false
			// -- List of custom rules for the application controller's ClusterRole resource
			rules: []
		}
	}

	//# Dex
	dex: {
		// -- Enable dex
		enabled: true
		// -- Dex name
		name: "dex-server"

		// -- Additional command line arguments to pass to the Dex server
		extraArgs: []

		// -- Runtime class name for Dex
		// @default -- `""` (defaults to global.runtimeClassName)
		runtimeClassName: ""
		metrics: {
			// -- Deploy metrics service
			enabled: false
			service: {
				// -- Metrics service annotations
				annotations: {}
				// -- Metrics service labels
				labels: {}
				// -- Metrics service port name
				portName: "http-metrics"
			}
			serviceMonitor: {
				// -- Enable a prometheus ServiceMonitor
				enabled: false
				// -- Prometheus ServiceMonitor interval
				interval: "30s"
				// -- Prometheus [RelabelConfigs] to apply to samples before scraping
				relabelings: []
				// -- Prometheus [MetricRelabelConfigs] to apply to samples before ingestion
				metricRelabelings: []
				// -- Prometheus ServiceMonitor selector
				// prometheus: kube-prometheus
				selector: {}

				// -- Prometheus ServiceMonitor scheme
				scheme: ""
				// -- Prometheus ServiceMonitor tlsConfig
				tlsConfig: {}
				// -- Prometheus ServiceMonitor namespace
				namespace: "" // "monitoring"
				// -- Prometheus ServiceMonitor labels
				additionalLabels: {}
				// -- Prometheus ServiceMonitor annotations
				annotations: {}
			}
		}

		//# Dex Pod Disruption Budget
		//# Ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
		pdb: {
			// -- Deploy a [PodDisruptionBudget] for the Dex server
			enabled: false
			// -- Labels to be added to Dex server pdb
			labels: {}
			// -- Annotations to be added to Dex server pdb
			annotations: {}
			// -- Number of pods that are available after eviction as number or percentage (eg.: 50%)
			// @default -- `""` (defaults to 0 if not specified)
			minAvailable: ""
			// -- Number of pods that are unavailble after eviction as number or percentage (eg.: 50%).
			//# Has higher precedence over `dex.pdb.minAvailable`
			maxUnavailable: ""
		}

		//# Dex image
		image: {
			// -- Dex image repository
			repository: "ghcr.io/dexidp/dex"
			// -- Dex image tag
			tag: "v2.38.0"
			// -- Dex imagePullPolicy
			// @default -- `""` (defaults to global.image.imagePullPolicy)
			imagePullPolicy: ""
		}

		// -- Secrets with credentials to pull images from a private registry
		// @default -- `[]` (defaults to global.imagePullSecrets)
		imagePullSecrets: []

		// Argo CD init image that creates Dex config
		initImage: {
			// -- Argo CD init image repository
			// @default -- `""` (defaults to global.image.repository)
			repository: ""
			// -- Argo CD init image tag
			// @default -- `""` (defaults to global.image.tag)
			tag: ""
			// -- Argo CD init image imagePullPolicy
			// @default -- `""` (defaults to global.image.imagePullPolicy)
			imagePullPolicy: ""
			// -- Argo CD init image resources
			// @default -- `{}` (defaults to dex.resources)
			//  requests:
			//    cpu: 5m
			//    memory: 96Mi
			//  limits:
			//    cpu: 10m
			//    memory: 144Mi
			resources: {}
		}

		// -- Environment variables to pass to the Dex server
		env: []

		// -- envFrom to pass to the Dex server
		// @default -- `[]` (See [values.yaml])
		// - configMapRef:
		//     name: config-map-name
		// - secretRef:
		//     name: secret-name
		envFrom: []

		// -- Additional containers to be added to the dex pod
		//# Note: Supports use of custom Helm templates
		extraContainers: []

		// -- Init containers to add to the dex pod
		//# Note: Supports use of custom Helm templates
		initContainers: []

		// -- Additional volumeMounts to the dex main container
		volumeMounts: []

		// -- Additional volumes to the dex pod
		volumes: []

		//# Dex server emptyDir volumes
		emptyDir: {
			// -- EmptyDir size limit for Dex server
			// @default -- `""` (defaults not set if not specified i.e. no size limit)
			// sizeLimit: "1Gi"
			sizeLimit: ""
		}

		// TLS certificate configuration via Secret
		//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/tls/#configuring-tls-to-argocd-dex-server
		//# Note: Issuing certificates via cert-manager in not supported right now because it's not possible to restart Dex automatically without extra controllers.
		certificateSecret: {
			// -- Create argocd-dex-server-tls secret
			enabled: false
			// -- Labels to be added to argocd-dex-server-tls secret
			labels: {}
			// -- Annotations to be added to argocd-dex-server-tls secret
			annotations: {}
			// -- Certificate authority. Required for self-signed certificates.
			ca: ""
			// -- Certificate private key
			key: ""
			// -- Certificate data. Must contain SANs of Dex service (ie: argocd-dex-server, argocd-dex-server.argo-cd.svc)
			crt: ""
		}

		// -- Annotations to be added to the Dex server Deployment
		deploymentAnnotations: {}

		// -- Annotations to be added to the Dex server pods
		podAnnotations: {}

		// -- Labels to be added to the Dex server pods
		podLabels: {}

		// -- Resource limits and requests for dex
		//  limits:
		//    cpu: 50m
		//    memory: 64Mi
		//  requests:
		//    cpu: 10m
		//    memory: 32Mi
		resources: {}

		// Dex container ports
		// NOTE: These ports are currently hardcoded and cannot be changed
		containerPorts: {
			// -- HTTP container port
			http: 5556
			// -- gRPC container port
			grpc: 5557
			// -- Metrics container port
			metrics: 5558
		}

		// -- [DNS configuration]
		dnsConfig: {}
		// -- Alternative DNS policy for Dex server pods
		dnsPolicy: "ClusterFirst"

		// -- Dex container-level security context
		// @default -- See [values.yaml]
		containerSecurityContext: {
			runAsNonRoot:             true
			readOnlyRootFilesystem:   true
			allowPrivilegeEscalation: false
			seccompProfile: type: "RuntimeDefault"
			capabilities: drop: ["ALL"]
		}

		//# Probes for Dex server
		//# Supported from Dex >= 2.28.0
		livenessProbe: {
			// -- Enable Kubernetes liveness probe for Dex >= 2.28.0
			enabled: false
			// -- Http path to use for the liveness probe
			httpPath: "/healthz/live"
			// -- Http port to use for the liveness probe
			httpPort: "metrics"
			// -- Scheme to use for for the liveness probe (can be HTTP or HTTPS)
			httpScheme: "HTTP"
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
		}
		readinessProbe: {
			// -- Enable Kubernetes readiness probe for Dex >= 2.28.0
			enabled: false
			// -- Http path to use for the readiness probe
			httpPath: "/healthz/ready"
			// -- Http port to use for the readiness probe
			httpPort: "metrics"
			// -- Scheme to use for for the liveness probe (can be HTTP or HTTPS)
			httpScheme: "HTTP"
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
		}

		// -- terminationGracePeriodSeconds for container lifecycle hook
		terminationGracePeriodSeconds: 30

		// -- Automount API credentials for the Service Account into the pod.
		automountServiceAccountToken: true
		serviceAccount: {
			// -- Create dex service account
			create: true
			// -- Dex service account name
			name: "argocd-dex-server"
			// -- Annotations applied to created service account
			annotations: {}
			// -- Automount API credentials for the Service Account
			automountServiceAccountToken: true
		}

		// -- Service port for HTTP access
		servicePortHttp: 5556
		// -- Service port name for HTTP access
		servicePortHttpName: "http"
		// -- Service port for gRPC access
		servicePortGrpc: 5557
		// -- Service port name for gRPC access
		servicePortGrpcName: "grpc"
		// -- Service port for metrics access
		servicePortMetrics: 5558

		// -- Priority class for the dex pods
		// @default -- `""` (defaults to global.priorityClassName)
		priorityClassName: ""

		// -- [Node selector]
		// @default -- `{}` (defaults to global.nodeSelector)
		nodeSelector: {}

		// -- [Tolerations] for use with node taints
		// @default -- `[]` (defaults to global.tolerations)
		tolerations: []

		// -- Assign custom [affinity] rules to the deployment
		// @default -- `{}` (defaults to global.affinity preset)
		affinity: {}

		// -- Assign custom [TopologySpreadConstraints] rules to dex
		// @default -- `[]` (defaults to global.topologySpreadConstraints)
		//# Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
		//# If labelSelector is left out, it will default to the labelSelector configuration of the deployment
		// - maxSkew: 1
		//   topologyKey: topology.kubernetes.io/zone
		//   whenUnsatisfiable: DoNotSchedule
		topologySpreadConstraints: []

		// -- Deployment strategy to be added to the Dex server Deployment
		// type: RollingUpdate
		// rollingUpdate:
		//   maxSurge: 25%
		//   maxUnavailable: 25%
		deploymentStrategy: {}

		// -- Dex log format. Either `text` or `json`
		// @default -- `""` (defaults to global.logging.format)
		logFormat: ""
		// -- Dex log level. One of: `debug`, `info`, `warn`, `error`
		// @default -- `""` (defaults to global.logging.level)
		logLevel: ""
	}

	//# Redis
	redis: {
		// -- Enable redis
		enabled: true
		// -- Redis name
		name: "redis"

		// -- Runtime class name for redis
		// @default -- `""` (defaults to global.runtimeClassName)
		runtimeClassName: ""

		//# Redis Pod Disruption Budget
		//# Ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
		pdb: {
			// -- Deploy a [PodDisruptionBudget] for the Redis
			enabled: false
			// -- Labels to be added to Redis pdb
			labels: {}
			// -- Annotations to be added to Redis pdb
			annotations: {}
			// -- Number of pods that are available after eviction as number or percentage (eg.: 50%)
			// @default -- `""` (defaults to 0 if not specified)
			minAvailable: ""
			// -- Number of pods that are unavailble after eviction as number or percentage (eg.: 50%).
			//# Has higher precedence over `redis.pdb.minAvailable`
			maxUnavailable: ""
		}

		//# Redis image
		image: {
			// -- Redis repository
			repository: "public.ecr.aws/docker/library/redis"
			// -- Redis tag
			tag: "7.2.4-alpine"
			// -- Redis image pull policy
			// @default -- `""` (defaults to global.image.imagePullPolicy)
			imagePullPolicy: ""
		}

		//# Prometheus redis-exporter sidecar
		exporter: {
			// -- Enable Prometheus redis-exporter sidecar
			enabled: false
			// -- Environment variables to pass to the Redis exporter
			env: []
			//# Prometheus redis-exporter image
			image: {
				// -- Repository to use for the redis-exporter
				repository: "public.ecr.aws/bitnami/redis-exporter"
				// -- Tag to use for the redis-exporter
				tag: "1.58.0"
				// -- Image pull policy for the redis-exporter
				// @default -- `""` (defaults to global.image.imagePullPolicy)
				imagePullPolicy: ""
			}

			// -- Redis exporter security context
			// @default -- See [values.yaml]
			containerSecurityContext: {
				runAsNonRoot:             true
				readOnlyRootFilesystem:   true
				allowPrivilegeEscalation: false
				seccompProfile: type: "RuntimeDefault"
				capabilities: drop: ["ALL"]
			}

			//# Probes for Redis exporter (optional)
			//# Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
			readinessProbe: {
				// -- Enable Kubernetes liveness probe for Redis exporter (optional)
				enabled: false
				// -- Number of seconds after the container has started before [probe] is initiated
				initialDelaySeconds: 30
				// -- How often (in seconds) to perform the [probe]
				periodSeconds: 15
				// -- Number of seconds after which the [probe] times out
				timeoutSeconds: 15
				// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
				successThreshold: 1
				// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
				failureThreshold: 5
			}
			livenessProbe: {
				// -- Enable Kubernetes liveness probe for Redis exporter
				enabled: false
				// -- Number of seconds after the container has started before [probe] is initiated
				initialDelaySeconds: 30
				// -- How often (in seconds) to perform the [probe]
				periodSeconds: 15
				// -- Number of seconds after which the [probe] times out
				timeoutSeconds: 15
				// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
				successThreshold: 1
				// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
				failureThreshold: 5
			}

			// -- Resource limits and requests for redis-exporter sidecar
			// limits:
			//   cpu: 50m
			//   memory: 64Mi
			// requests:
			//   cpu: 10m
			//   memory: 32Mi
			resources: {}
		}

		// -- Secrets with credentials to pull images from a private registry
		// @default -- `[]` (defaults to global.imagePullSecrets)
		imagePullSecrets: []

		// -- Additional command line arguments to pass to redis-server
		// - --bind
		// - "0.0.0.0"
		extraArgs: []

		// -- Environment variables to pass to the Redis server
		env: []

		// -- envFrom to pass to the Redis server
		// @default -- `[]` (See [values.yaml])
		// - configMapRef:
		//     name: config-map-name
		// - secretRef:
		//     name: secret-name
		envFrom: []

		//# Probes for Redis server (optional)
		//# Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
		readinessProbe: {
			// -- Enable Kubernetes liveness probe for Redis server
			enabled: false
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 30
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 15
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 15
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 5
		}
		livenessProbe: {
			// -- Enable Kubernetes liveness probe for Redis server
			enabled: false
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 30
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 15
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 15
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 5
		}

		// -- Additional containers to be added to the redis pod
		//# Note: Supports use of custom Helm templates
		extraContainers: []

		// -- Init containers to add to the redis pod
		//# Note: Supports use of custom Helm templates
		initContainers: []

		// -- Additional volumeMounts to the redis container
		volumeMounts: []

		// -- Additional volumes to the redis pod
		volumes: []

		// -- Annotations to be added to the Redis server Deployment
		deploymentAnnotations: {}

		// -- Annotations to be added to the Redis server pods
		podAnnotations: {}

		// -- Labels to be added to the Redis server pods
		podLabels: {}

		// -- Resource limits and requests for redis
		//  limits:
		//    cpu: 200m
		//    memory: 128Mi
		//  requests:
		//    cpu: 100m
		//    memory: 64Mi
		resources: {}

		// -- Redis pod-level security context
		// @default -- See [values.yaml]
		securityContext: {
			runAsNonRoot: true
			runAsUser:    999
			seccompProfile: type: "RuntimeDefault"
		}

		// Redis container ports
		containerPorts: {
			// -- Redis container port
			redis: 6379
			// -- Metrics container port
			metrics: 9121
		}

		// -- [DNS configuration]
		dnsConfig: {}
		// -- Alternative DNS policy for Redis server pods
		dnsPolicy: "ClusterFirst"

		// -- Redis container-level security context
		// @default -- See [values.yaml]
		containerSecurityContext: {
			readOnlyRootFilesystem:   true
			allowPrivilegeEscalation: false
			capabilities: drop: ["ALL"]
		}

		// -- Redis service port
		servicePort: 6379

		// -- Priority class for redis pods
		// @default -- `""` (defaults to global.priorityClassName)
		priorityClassName: ""

		// -- [Node selector]
		// @default -- `{}` (defaults to global.nodeSelector)
		nodeSelector: {}

		// -- [Tolerations] for use with node taints
		// @default -- `[]` (defaults to global.tolerations)
		tolerations: []

		// -- Assign custom [affinity] rules to the deployment
		// @default -- `{}` (defaults to global.affinity preset)
		affinity: {}

		// -- Assign custom [TopologySpreadConstraints] rules to redis
		// @default -- `[]` (defaults to global.topologySpreadConstraints)
		//# Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
		//# If labelSelector is left out, it will default to the labelSelector configuration of the deployment
		// - maxSkew: 1
		//   topologyKey: topology.kubernetes.io/zone
		//   whenUnsatisfiable: DoNotSchedule
		topologySpreadConstraints: []

		// -- terminationGracePeriodSeconds for container lifecycle hook
		terminationGracePeriodSeconds: 30

		// -- Automount API credentials for the Service Account into the pod.
		automountServiceAccountToken: true
		serviceAccount: {
			// -- Create a service account for the redis pod
			create: false
			// -- Service account name for redis pod
			name: ""
			// -- Annotations applied to created service account
			annotations: {}
			// -- Automount API credentials for the Service Account
			automountServiceAccountToken: false
		}
		service: {
			// -- Redis service annotations
			annotations: {}
			// -- Additional redis service labels
			labels: {}
		}
		metrics: {
			// -- Deploy metrics service
			enabled: false

			// Redis metrics service configuration
			service: {
				// -- Metrics service type
				type: "ClusterIP"
				// -- Metrics service clusterIP. `None` makes a "headless service" (no virtual IP)
				clusterIP: "None"
				// -- Metrics service annotations
				annotations: {}
				// -- Metrics service labels
				labels: {}
				// -- Metrics service port
				servicePort: 9121
				// -- Metrics service port name
				portName: "http-metrics"
			}
			serviceMonitor: {
				// -- Enable a prometheus ServiceMonitor
				enabled: false
				// -- Interval at which metrics should be scraped
				interval: "30s"
				// -- Prometheus [RelabelConfigs] to apply to samples before scraping
				relabelings: []
				// -- Prometheus [MetricRelabelConfigs] to apply to samples before ingestion
				metricRelabelings: []
				// -- Prometheus ServiceMonitor selector
				// prometheus: kube-prometheus
				selector: {}

				// -- Prometheus ServiceMonitor scheme
				scheme: ""
				// -- Prometheus ServiceMonitor tlsConfig
				tlsConfig: {}
				// -- Prometheus ServiceMonitor namespace
				namespace: "" // "monitoring"
				// -- Prometheus ServiceMonitor labels
				additionalLabels: {}
				// -- Prometheus ServiceMonitor annotations
				annotations: {}
			}
		}
	}

	//# Redis-HA subchart replaces custom redis deployment when `redis-ha.enabled=true`
	// Ref: https://github.com/DandyDeveloper/charts/blob/master/charts/redis-ha/values.yaml
	"redis-ha": {
		// -- Enables the Redis HA subchart and disables the custom Redis single node deployment
		enabled: false
		//# Redis image
		image: {
			// -- Redis repository
			repository: "public.ecr.aws/docker/library/redis"
			// -- Redis tag
			tag: "7.2.4-alpine"
		}
		//# Prometheus redis-exporter sidecar
		exporter: {
			// -- Enable Prometheus redis-exporter sidecar
			enabled: false
			// -- Repository to use for the redis-exporter
			image: "public.ecr.aws/bitnami/redis-exporter"
			// -- Tag to use for the redis-exporter
			tag: "1.58.0"
		}
		persistentVolume: {
			// -- Configures persistence on Redis nodes
			enabled: false
		}
		//# Redis specific configuration options
		redis: {
			// -- Redis convention for naming the cluster group: must match `^[\\w-\\.]+$` and can be templated
			masterGroupName: "argocd"
			// -- Any valid redis config options in this section will be applied to each server (see `redis-ha` chart)
			// @default -- See [values.yaml]
			config: {
				// -- Will save the DB if both the given number of seconds and the given number of write operations against the DB occurred. `""`  is disabled
				// @default -- `'""'`
				save: "\"\""
			}
		}
		//# Enables a HA Proxy for better LoadBalancing / Sentinel Master support. Automatically proxies to Redis master.
		haproxy: {
			// -- Enabled HAProxy LoadBalancing/Proxy
			enabled: true
			// --  Custom labels for the haproxy pod. This is relevant for Argo CD CLI.
			labels: {
				"app.kubernetes.io/name": "argocd-redis-ha-haproxy"
			}
			metrics: {
				// -- HAProxy enable prometheus metric scraping
				enabled: true
			}
			// -- Whether the haproxy pods should be forced to run on separate nodes.
			hardAntiAffinity: true
			// -- Additional affinities to add to the haproxy pods.
			additionalAffinities: {}
			// -- Assign custom [affinity] rules to the haproxy pods.
			affinity: ""

			// -- [Tolerations] for use with node taints for haproxy pods.
			tolerations: []
			// -- HAProxy container-level security context
			// @default -- See [values.yaml]
			containerSecurityContext: {
				readOnlyRootFilesystem: true
			}
		}

		// -- Configures redis-ha with AUTH
		auth: true
		// -- Existing Secret to use for redis-ha authentication.
		// By default the redis-secret-init Job is generating this Secret.
		existingSecret: "argocd-redis"

		// -- Whether the Redis server pods should be forced to run on separate nodes.
		hardAntiAffinity: true

		// -- Additional affinities to add to the Redis server pods.
		additionalAffinities: {}

		// -- Assign custom [affinity] rules to the Redis pods.
		affinity: ""

		// -- [Tolerations] for use with node taints for Redis pods.
		tolerations: []

		// -- Assign custom [TopologySpreadConstraints] rules to the Redis pods.
		//# https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
		topologySpreadConstraints: {
			// -- Enable Redis HA topology spread constraints
			enabled: false
			// -- Max skew of pods tolerated
			// @default -- `""` (defaults to `1`)
			maxSkew: ""
			// -- Topology key for spread
			// @default -- `""` (defaults to `topology.kubernetes.io/zone`)
			topologyKey: ""
			// -- Enforcement policy, hard or soft
			// @default -- `""` (defaults to `ScheduleAnyway`)
			whenUnsatisfiable: ""
		}
		// -- Redis HA statefulset container-level security context
		// @default -- See [values.yaml]
		containerSecurityContext: {
			readOnlyRootFilesystem: true
		}
	}

	// External Redis parameters
	externalRedis: {
		// -- External Redis server host
		host: ""
		// -- External Redis username
		username: ""
		// -- External Redis password
		password: ""
		// -- External Redis server port
		port: 6379
		// -- The name of an existing secret with Redis (must contain key `redis-password`) and Sentinel credentials.
		// When it's set, the `externalRedis.password` parameter is ignored
		existingSecret: ""
		// -- External Redis Secret annotations
		secretAnnotations: {}
	}
	redisSecretInit: {
		// -- Enable Redis secret initialization. If disabled, secret must be provisioned by alternative methods
		enabled: true
		// -- Redis secret-init name
		name: "redis-secret-init"
		image: {
			// -- Repository to use for the Redis secret-init Job
			// @default -- `""` (defaults to global.image.repository)
			repository: "" // defaults to global.image.repository
			// -- Tag to use for the Redis secret-init Job
			// @default -- `""` (defaults to global.image.tag)
			tag: "" // defaults to global.image.tag
			// -- Image pull policy for the Redis secret-init Job
			// @default -- `""` (defaults to global.image.imagePullPolicy)
			imagePullPolicy: "" // IfNotPresent
		}

		// -- Secrets with credentials to pull images from a private registry
		// @default -- `[]` (defaults to global.imagePullSecrets)
		imagePullSecrets: []

		// -- Annotations to be added to the Redis secret-init Job
		jobAnnotations: {}

		// -- Annotations to be added to the Redis secret-init Job
		podAnnotations: {}

		// -- Labels to be added to the Redis secret-init Job
		podLabels: {}

		// -- Resource limits and requests for Redis secret-init Job
		//  limits:
		//    cpu: 200m
		//    memory: 128Mi
		//  requests:
		//    cpu: 100m
		//    memory: 64Mi
		resources: {}

		// -- Application controller container-level security context
		// @default -- See [values.yaml]
		containerSecurityContext: {
			allowPrivilegeEscalation: false
			capabilities: drop: ["ALL"]
			readOnlyRootFilesystem: true
			runAsNonRoot:           true
			seccompProfile: type: "RuntimeDefault"
		}

		// -- Redis secret-init Job pod-level security context
		securityContext: {}
		serviceAccount: {
			// -- Create a service account for the redis pod
			create: true
			// -- Service account name for redis pod
			name: ""
			// -- Annotations applied to created service account
			annotations: {}
			// -- Automount API credentials for the Service Account
			automountServiceAccountToken: true
		}

		// -- Priority class for Redis secret-init Job
		// @default -- `""` (defaults to global.priorityClassName)
		priorityClassName: ""

		// -- Node selector to be added to the Redis secret-init Job
		// @default -- `{}` (defaults to global.nodeSelector)
		nodeSelector: {}

		// -- Tolerations to be added to the Redis secret-init Job
		// @default -- `[]` (defaults to global.tolerations)
		tolerations: []
	}

	//# Server
	server: {
		// -- Argo CD server name
		name: "server"

		// -- The number of server pods to run
		replicas: 1

		// -- Runtime class name for the Argo CD server
		// @default -- `""` (defaults to global.runtimeClassName)
		runtimeClassName: ""

		//# Argo CD server Horizontal Pod Autoscaler
		autoscaling: {
			// -- Enable Horizontal Pod Autoscaler ([HPA]) for the Argo CD server
			enabled: false
			// -- Minimum number of replicas for the Argo CD server [HPA]
			minReplicas: 1
			// -- Maximum number of replicas for the Argo CD server [HPA]
			maxReplicas: 5
			// -- Average CPU utilization percentage for the Argo CD server [HPA]
			targetCPUUtilizationPercentage: 50
			// -- Average memory utilization percentage for the Argo CD server [HPA]
			targetMemoryUtilizationPercentage: 50
			// -- Configures the scaling behavior of the target in both Up and Down directions.
			behavior: {}
			// scaleDown:
			//  stabilizationWindowSeconds: 300
			//  policies:
			//   - type: Pods
			//     value: 1
			//     periodSeconds: 180
			// scaleUp:
			//   stabilizationWindowSeconds: 300
			//   policies:
			//   - type: Pods
			//     value: 2
			//     periodSeconds: 60
			// -- Configures custom HPA metrics for the Argo CD server
			// Ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
			metrics: []
		}

		//# Argo CD server Pod Disruption Budget
		//# Ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
		pdb: {
			// -- Deploy a [PodDisruptionBudget] for the Argo CD server
			enabled: false
			// -- Labels to be added to Argo CD server pdb
			labels: {}
			// -- Annotations to be added to Argo CD server pdb
			annotations: {}
			// -- Number of pods that are available after eviction as number or percentage (eg.: 50%)
			// @default -- `""` (defaults to 0 if not specified)
			minAvailable: ""
			// -- Number of pods that are unavailable after eviction as number or percentage (eg.: 50%).
			//# Has higher precedence over `server.pdb.minAvailable`
			maxUnavailable: ""
		}

		//# Argo CD server image
		image: {
			// -- Repository to use for the Argo CD server
			// @default -- `""` (defaults to global.image.repository)
			repository: "" // defaults to global.image.repository
			// -- Tag to use for the Argo CD server
			// @default -- `""` (defaults to global.image.tag)
			tag: "" // defaults to global.image.tag
			// -- Image pull policy for the Argo CD server
			// @default -- `""` (defaults to global.image.imagePullPolicy)
			imagePullPolicy: "" // IfNotPresent
		}

		// -- Secrets with credentials to pull images from a private registry
		// @default -- `[]` (defaults to global.imagePullSecrets)
		imagePullSecrets: []

		// -- Additional command line arguments to pass to Argo CD server
		extraArgs: []

		// -- Environment variables to pass to Argo CD server
		env: []

		// -- envFrom to pass to Argo CD server
		// @default -- `[]` (See [values.yaml])
		// - configMapRef:
		//     name: config-map-name
		// - secretRef:
		//     name: secret-name
		envFrom: []

		// -- Specify postStart and preStop lifecycle hooks for your argo-cd-server container
		lifecycle: {}

		//# Argo CD extensions
		//# This function in tech preview stage, do expect instability or breaking changes in newer versions.
		//# Ref: https://github.com/argoproj-labs/argocd-extension-installer
		//# When you enable extensions, you need to configure RBAC of logged in Argo CD user.
		//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/#the-extensions-resource
		extensions: {
			// -- Enable support for Argo CD extensions
			enabled: false

			//# Argo CD extension installer image
			image: {
				// -- Repository to use for extension installer image
				repository: "quay.io/argoprojlabs/argocd-extension-installer"
				// -- Tag to use for extension installer image
				tag: "v0.0.5"
				// -- Image pull policy for extensions
				// @default -- `""` (defaults to global.image.imagePullPolicy)
				imagePullPolicy: ""
			}

			// -- Extensions for Argo CD
			// @default -- `[]` (See [values.yaml])
			//# Ref: https://github.com/argoproj-labs/argocd-extension-metrics#install-ui-extension
			//  - name: extension-metrics
			//    env:
			//      - name: EXTENSION_URL
			//        value: https://github.com/argoproj-labs/argocd-extension-metrics/releases/download/v1.0.0/extension.tar.gz
			//      - name: EXTENSION_CHECKSUM_URL
			//        value: https://github.com/argoproj-labs/argocd-extension-metrics/releases/download/v1.0.0/extension_checksums.txt
			extensionList: []

			// -- Server UI extensions container-level security context
			// @default -- See [values.yaml]
			containerSecurityContext: {
				runAsNonRoot:             true
				readOnlyRootFilesystem:   true
				allowPrivilegeEscalation: false
				runAsUser:                1000
				seccompProfile: type: "RuntimeDefault"
				capabilities: drop: ["ALL"]
			}

			// -- Resource limits and requests for the argocd-extensions container
			//  limits:
			//    cpu: 50m
			//    memory: 128Mi
			//  requests:
			//    cpu: 10m
			//    memory: 64Mi
			resources: {}
		}

		// -- Additional containers to be added to the server pod
		//# Note: Supports use of custom Helm templates
		// - name: my-sidecar
		//   image: nginx:latest
		// - name: lemonldap-ng-controller
		//   image: lemonldapng/lemonldap-ng-controller:0.2.0
		//   args:
		//     - /lemonldap-ng-controller
		//     - --alsologtostderr
		//     - --configmap=$(POD_NAMESPACE)/lemonldap-ng-configuration
		//   env:
		//     - name: POD_NAME
		//       valueFrom:
		//         fieldRef:
		//           fieldPath: metadata.name
		//     - name: POD_NAMESPACE
		//       valueFrom:
		//         fieldRef:
		//           fieldPath: metadata.namespace
		//   volumeMounts:
		//   - name: copy-portal-skins
		//     mountPath: /srv/var/lib/lemonldap-ng/portal/skins
		extraContainers: []

		// -- Init containers to add to the server pod
		//# If your target Kubernetes cluster(s) require a custom credential (exec) plugin
		//# you could use this (and the same in the application controller pod) to provide such executable
		//# Ref: https://kubernetes.io/docs/reference/access-authn-authz/authentication/#client-go-credential-plugins
		//  - name: download-tools
		//    image: alpine:3
		//    command: [sh, -c]
		//    args:
		//      - wget -qO kubelogin.zip https://github.com/Azure/kubelogin/releases/download/v0.0.25/kubelogin-linux-amd64.zip &&
		//        unzip kubelogin.zip && mv bin/linux_amd64/kubelogin /custom-tools/
		//    volumeMounts:
		//      - mountPath: /custom-tools
		//        name: custom-tools
		initContainers: []

		// -- Additional volumeMounts to the server main container
		//  - mountPath: /usr/local/bin/kubelogin
		//    name: custom-tools
		//    subPath: kubelogin
		volumeMounts: []

		// -- Additional volumes to the server pod
		//  - name: custom-tools
		//    emptyDir: {}
		volumes: []

		//# Argo CD server emptyDir volumes
		emptyDir: {
			// -- EmptyDir size limit for the Argo CD server
			// @default -- `""` (defaults not set if not specified i.e. no size limit)
			// sizeLimit: "1Gi"
			sizeLimit: ""
		}

		// -- Annotations to be added to server Deployment
		deploymentAnnotations: {}

		// -- Annotations to be added to server pods
		podAnnotations: {}

		// -- Labels to be added to server pods
		podLabels: {}

		// -- Resource limits and requests for the Argo CD server
		//  limits:
		//    cpu: 100m
		//    memory: 128Mi
		//  requests:
		//    cpu: 50m
		//    memory: 64Mi
		resources: {}

		// Server container ports
		containerPorts: {
			// -- Server container port
			server: 8080
			// -- Metrics container port
			metrics: 8083
		}

		// -- Host Network for Server pods
		hostNetwork: false

		// -- [DNS configuration]
		dnsConfig: {}
		// -- Alternative DNS policy for Server pods
		dnsPolicy: "ClusterFirst"

		// -- Server container-level security context
		// @default -- See [values.yaml]
		containerSecurityContext: {
			runAsNonRoot:             true
			readOnlyRootFilesystem:   true
			allowPrivilegeEscalation: false
			seccompProfile: type: "RuntimeDefault"
			capabilities: drop: ["ALL"]
		}

		//# Readiness and liveness probes for default backend
		//# Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
		readinessProbe: {
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
		}
		livenessProbe: {
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
		}

		// -- terminationGracePeriodSeconds for container lifecycle hook
		terminationGracePeriodSeconds: 30

		// -- Priority class for the Argo CD server pods
		// @default -- `""` (defaults to global.priorityClassName)
		priorityClassName: ""

		// -- [Node selector]
		// @default -- `{}` (defaults to global.nodeSelector)
		nodeSelector: {}

		// -- [Tolerations] for use with node taints
		// @default -- `[]` (defaults to global.tolerations)
		tolerations: []

		// -- Assign custom [affinity] rules to the deployment
		// @default -- `{}` (defaults to global.affinity preset)
		affinity: {}

		// -- Assign custom [TopologySpreadConstraints] rules to the Argo CD server
		// @default -- `[]` (defaults to global.topologySpreadConstraints)
		//# Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
		//# If labelSelector is left out, it will default to the labelSelector configuration of the deployment
		// - maxSkew: 1
		//   topologyKey: topology.kubernetes.io/zone
		//   whenUnsatisfiable: DoNotSchedule
		topologySpreadConstraints: []

		// -- Deployment strategy to be added to the server Deployment
		// type: RollingUpdate
		// rollingUpdate:
		//   maxSurge: 25%
		//   maxUnavailable: 25%
		deploymentStrategy: {}

		// TLS certificate configuration via cert-manager
		//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/tls/#tls-certificates-used-by-argocd-server
		certificate: {
			// -- Deploy a Certificate resource (requires cert-manager)
			enabled: false
			// -- Certificate primary domain (commonName)
			// @default -- `""` (defaults to global.domain)
			domain: ""
			// -- Certificate Subject Alternate Names (SANs)
			additionalHosts: []
			// -- The requested 'duration' (i.e. lifetime) of the certificate.
			// @default -- `""` (defaults to 2160h = 90d if not specified)
			//# Ref: https://cert-manager.io/docs/usage/certificate/#renewal
			duration: ""
			// -- How long before the expiry a certificate should be renewed.
			// @default -- `""` (defaults to 360h = 15d if not specified)
			//# Ref: https://cert-manager.io/docs/usage/certificate/#renewal
			renewBefore: ""
			// Certificate issuer
			//# Ref: https://cert-manager.io/docs/concepts/issuer
			issuer: {
				// -- Certificate issuer group. Set if using an external issuer. Eg. `cert-manager.io`
				group: ""
				// -- Certificate issuer kind. Either `Issuer` or `ClusterIssuer`
				kind: ""
				// -- Certificate issuer name. Eg. `letsencrypt`
				name: ""
			}
			// Private key of the certificate
			privateKey: {
				// -- Rotation policy of private key when certificate is re-issued. Either: `Never` or `Always`
				rotationPolicy: "Never"
				// -- The private key cryptography standards (PKCS) encoding for private key. Either: `PCKS1` or `PKCS8`
				encoding: "PKCS1"
				// -- Algorithm used to generate certificate private key. One of: `RSA`, `Ed25519` or `ECDSA`
				algorithm: "RSA"
				// -- Key bit size of the private key. If algorithm is set to `Ed25519`, size is ignored.
				size: 2048
			}
			// -- Annotations to be applied to the Server Certificate
			annotations: {}
			// -- Usages for the certificate
			//## Ref: https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.KeyUsage
			usages: []
			// -- Annotations that allow the certificate to be composed from data residing in existing Kubernetes Resources
			secretTemplateAnnotations: {}
		}

		// TLS certificate configuration via Secret
		//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/tls/#tls-certificates-used-by-argocd-server
		certificateSecret: {
			// -- Create argocd-server-tls secret
			enabled: false
			// -- Annotations to be added to argocd-server-tls secret
			annotations: {}
			// -- Labels to be added to argocd-server-tls secret
			labels: {}
			// -- Private Key of the certificate
			key: ""
			// -- Certificate data
			crt: ""
		}

		//# Server service configuration
		service: {
			// -- Server service annotations
			annotations: {}
			// -- Server service labels
			labels: {}
			// -- Server service type
			type: "ClusterIP"
			// -- Server service http port for NodePort service type (only if `server.service.type` is set to "NodePort")
			nodePortHttp: 30080
			// -- Server service https port for NodePort service type (only if `server.service.type` is set to "NodePort")
			nodePortHttps: 30443
			// -- Server service http port
			servicePortHttp: 80
			// -- Server service https port
			servicePortHttps: 443
			// -- Server service http port name, can be used to route traffic via istio
			servicePortHttpName: "http"
			// -- Server service https port name, can be used to route traffic via istio
			servicePortHttpsName: "https"
			// -- Server service https port appProtocol
			//# Ref: https://kubernetes.io/docs/concepts/services-networking/service/#application-protocol
			servicePortHttpsAppProtocol: ""
			// -- The class of the load balancer implementation
			loadBalancerClass: ""
			// -- LoadBalancer will get created with the IP specified in this field
			loadBalancerIP: ""
			// -- Source IP ranges to allow access to service from
			//# Ref: https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
			loadBalancerSourceRanges: []
			// -- Server service external IPs
			externalIPs: []
			// -- Denotes if this Service desires to route external traffic to node-local or cluster-wide endpoints
			//# Ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
			externalTrafficPolicy: "Cluster"
			// -- Used to maintain session affinity. Supports `ClientIP` and `None`
			//# Ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
			sessionAffinity: "None"
		}

		//# Server metrics service configuration
		metrics: {
			// -- Deploy metrics service
			enabled: false
			service: {
				// -- Metrics service type
				type: "ClusterIP"
				// -- Metrics service clusterIP. `None` makes a "headless service" (no virtual IP)
				clusterIP: ""
				// -- Metrics service annotations
				annotations: {}
				// -- Metrics service labels
				labels: {}
				// -- Metrics service port
				servicePort: 8083
				// -- Metrics service port name
				portName: "http-metrics"
			}
			serviceMonitor: {
				// -- Enable a prometheus ServiceMonitor
				enabled: false
				// -- Prometheus ServiceMonitor interval
				interval: "30s"
				// -- Prometheus ServiceMonitor scrapeTimeout. If empty, Prometheus uses the global scrape timeout unless it is less than the target's scrape interval value in which the latter is used.
				scrapeTimeout: ""
				// -- Prometheus [RelabelConfigs] to apply to samples before scraping
				relabelings: []
				// -- Prometheus [MetricRelabelConfigs] to apply to samples before ingestion
				metricRelabelings: []
				// -- Prometheus ServiceMonitor selector
				// prometheus: kube-prometheus
				selector: {}

				// -- Prometheus ServiceMonitor scheme
				scheme: ""
				// -- Prometheus ServiceMonitor tlsConfig
				tlsConfig: {}
				// -- Prometheus ServiceMonitor namespace
				namespace: "" // monitoring
				// -- Prometheus ServiceMonitor labels
				additionalLabels: {}
				// -- Prometheus ServiceMonitor annotations
				annotations: {}
			}
		}

		// -- Automount API credentials for the Service Account into the pod.
		automountServiceAccountToken: true
		serviceAccount: {
			// -- Create server service account
			create: true
			// -- Server service account name
			name: "argocd-server"
			// -- Annotations applied to created service account
			annotations: {}
			// -- Labels applied to created service account
			labels: {}
			// -- Automount API credentials for the Service Account
			automountServiceAccountToken: true
		}

		// Argo CD server ingress configuration
		ingress: {
			// -- Enable an ingress resource for the Argo CD server
			enabled: false
			// -- Specific implementation for ingress controller. One of `generic`, `aws` or `gke`
			//# Additional configuration might be required in related configuration sections
			controller: "generic"
			// -- Additional ingress labels
			labels: {}
			// -- Additional ingress annotations
			//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-1-ssl-passthrough
			// nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
			// nginx.ingress.kubernetes.io/ssl-passthrough: "true"
			annotations: {}

			// -- Defines which ingress controller will implement the resource
			ingressClassName: ""

			// -- Argo CD server hostname
			// @default -- `""` (defaults to global.domain)
			hostname: ""

			// -- The path to Argo CD server
			path: "/"

			// -- Ingress path type. One of `Exact`, `Prefix` or `ImplementationSpecific`
			pathType: "Prefix"

			// -- Enable TLS configuration for the hostname defined at `server.ingress.hostname`
			//# TLS certificate will be retrieved from a TLS secret `argocd-server-tls`
			//# You can create this secret via `certificate` or `certificateSecret` option
			tls: false

			// -- The list of additional hostnames to be covered by ingress record
			// @default -- `[]` (See [values.yaml])
			// - name: argocd.example.com
			//   path: /
			extraHosts: []

			// -- Additional ingress paths
			// @default -- `[]` (See [values.yaml])
			//# Note: Supports use of custom Helm templates
			// - path: /*
			//   pathType: Prefix
			//   backend:
			//     service:
			//       name: ssl-redirect
			//       port:
			//         name: use-annotation
			extraPaths: []

			// -- Additional ingress rules
			// @default -- `[]` (See [values.yaml])
			//# Note: Supports use of custom Helm templates
			// - http:
			//     paths:
			//     - path: /
			//       pathType: Prefix
			//       backend:
			//         service:
			//           name: '{{ include "argo-cd.server.fullname" . }}'
			//           port:
			//             name: '{{ .Values.server.service.servicePortHttpsName }}'
			extraRules: []

			// -- Additional TLS configuration
			// @default -- `[]` (See [values.yaml])
			// - hosts:
			//   - argocd.example.com
			//   secretName: your-certificate-name
			extraTls: []

			// AWS specific options for Application Load Balancer
			// Applies only when `serv.ingress.controller` is set to `aws`
			//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#aws-application-load-balancers-albs-and-classic-elb-http-mode
			aws: {
				// -- Backend protocol version for the AWS ALB gRPC service
				//# This tells AWS to send traffic from the ALB using gRPC.
				//# For more information: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html#health-check-settings
				backendProtocolVersion: "GRPC"
				// -- Service type for the AWS ALB gRPC service
				//# Can be of type NodePort or ClusterIP depending on which mode you are running.
				//# Instance mode needs type NodePort, IP mode needs type ClusterIP
				//# Ref: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/how-it-works/#ingress-traffic
				serviceType: "NodePort"
			}

			// Google specific options for Google Application Load Balancer
			// Applies only when `server.ingress.controller` is set to `gke`
			//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#google-cloud-load-balancers-with-kubernetes-ingress
			gke: {
				// -- Google [BackendConfig] resource, for use with the GKE Ingress Controller
				// @default -- `{}` (See [values.yaml])
				//# Ref: https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features#configuring_ingress_features_through_frontendconfig_parameters
				// iap:
				//  enabled: true
				//  oauthclientCredentials:
				//    secretName: argocd-secret
				backendConfig: {}

				// -- Google [FrontendConfig] resource, for use with the GKE Ingress Controller
				// @default -- `{}` (See [values.yaml])
				//# Ref: https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features#configuring_ingress_features_through_frontendconfig_parameters
				// redirectToHttps:
				//   enabled: true
				//   responseCodeName: RESPONSE_CODE
				frontendConfig: {}

				// Managed GKE certificate for ingress hostname
				managedCertificate: {
					// -- Create ManagedCertificate resource and annotations for Google Load balancer
					//# Ref: https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs
					create: true
					// -- Additional domains for ManagedCertificate resource
					// - argocd.example.com
					extraDomains: []
				}
			}
		}

		// Dedicated gRPC ingress for ingress controllers that supports only single backend protocol per Ingress resource
		// Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-2-multiple-ingress-objects-and-hosts
		ingressGrpc: {
			// -- Enable an ingress resource for the Argo CD server for dedicated [gRPC-ingress]
			enabled: false
			// -- Additional ingress annotations for dedicated [gRPC-ingress]
			annotations: {}
			// -- Additional ingress labels for dedicated [gRPC-ingress]
			labels: {}
			// -- Defines which ingress controller will implement the resource [gRPC-ingress]
			ingressClassName: ""

			// -- Argo CD server hostname for dedicated [gRPC-ingress]
			// @default -- `""` (defaults to grpc.`server.ingress.hostname`)
			hostname: ""

			// -- Argo CD server ingress path for dedicated [gRPC-ingress]
			path: "/"

			// -- Ingress path type for dedicated [gRPC-ingress]. One of `Exact`, `Prefix` or `ImplementationSpecific`
			pathType: "Prefix"

			// -- Enable TLS configuration for the hostname defined at `server.ingressGrpc.hostname`
			//# TLS certificate will be retrieved from a TLS secret with name: `argocd-server-grpc-tls`
			tls: false

			// -- The list of additional hostnames to be covered by ingress record
			// @default -- `[]` (See [values.yaml])
			// - name: grpc.argocd.example.com
			//   path: /
			extraHosts: []

			// -- Additional ingress paths for dedicated [gRPC-ingress]
			// @default -- `[]` (See [values.yaml])
			//# Note: Supports use of custom Helm templates
			// - path: /*
			//   pathType: Prefix
			//   backend:
			//     service:
			//       name: ssl-redirect
			//       port:
			//         name: use-annotation
			extraPaths: []

			// -- Additional ingress rules
			// @default -- `[]` (See [values.yaml])
			//# Note: Supports use of custom Helm templates
			// - http:
			//     paths:
			//     - path: /
			//       pathType: Prefix
			//       backend:
			//         service:
			//           name: '{{ include "argo-cd.server.fullname" . }}'
			//           port:
			//             name: '{{ .Values.server.service.servicePortHttpName }}'
			extraRules: []

			// -- Additional TLS configuration for dedicated [gRPC-ingress]
			// @default -- `[]` (See [values.yaml])
			// - secretName: your-certificate-name
			//   hosts:
			//     - argocd.example.com
			extraTls: []
		}

		// Create a OpenShift Route with SSL passthrough for UI and CLI
		// Consider setting 'hostname' e.g. https://argocd.apps-crc.testing/ using your Default Ingress Controller Domain
		// Find your domain with: kubectl describe --namespace=openshift-ingress-operator ingresscontroller/default | grep Domain:
		// If 'hostname' is an empty string "" OpenShift will create a hostname for you.
		route: {
			// -- Enable an OpenShift Route for the Argo CD server
			enabled: false
			// -- Openshift Route annotations
			annotations: {}
			// -- Hostname of OpenShift Route
			hostname: ""
			// -- Termination type of Openshift Route
			termination_type: "passthrough"
			// -- Termination policy of Openshift Route
			termination_policy: "None"
		}

		//# Enable this and set the rules: to whatever custom rules you want for the Cluster Role resource.
		//# Defaults to off
		clusterRoleRules: {
			// -- Enable custom rules for the server's ClusterRole resource
			enabled: false
			// -- List of custom rules for the server's ClusterRole resource
			rules: []
		}
	}

	//# Repo Server
	repoServer: {
		// -- Repo server name
		name: "repo-server"

		// -- The number of repo server pods to run
		replicas: 1

		// -- Runtime class name for the repo server
		// @default -- `""` (defaults to global.runtimeClassName)
		runtimeClassName: ""

		//# Repo server Horizontal Pod Autoscaler
		autoscaling: {
			// -- Enable Horizontal Pod Autoscaler ([HPA]) for the repo server
			enabled: false
			// -- Minimum number of replicas for the repo server [HPA]
			minReplicas: 1
			// -- Maximum number of replicas for the repo server [HPA]
			maxReplicas: 5
			// -- Average CPU utilization percentage for the repo server [HPA]
			targetCPUUtilizationPercentage: 50
			// -- Average memory utilization percentage for the repo server [HPA]
			targetMemoryUtilizationPercentage: 50
			// -- Configures the scaling behavior of the target in both Up and Down directions.
			behavior: {}
			// scaleDown:
			//  stabilizationWindowSeconds: 300
			//  policies:
			//   - type: Pods
			//     value: 1
			//     periodSeconds: 180
			// scaleUp:
			//   stabilizationWindowSeconds: 300
			//   policies:
			//   - type: Pods
			//     value: 2
			//     periodSeconds: 60
			// -- Configures custom HPA metrics for the Argo CD repo server
			// Ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
			metrics: []
		}

		//# Repo server Pod Disruption Budget
		//# Ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
		pdb: {
			// -- Deploy a [PodDisruptionBudget] for the repo server
			enabled: false
			// -- Labels to be added to repo server pdb
			labels: {}
			// -- Annotations to be added to repo server pdb
			annotations: {}
			// -- Number of pods that are available after eviction as number or percentage (eg.: 50%)
			// @default -- `""` (defaults to 0 if not specified)
			minAvailable: ""
			// -- Number of pods that are unavailable after eviction as number or percentage (eg.: 50%).
			//# Has higher precedence over `repoServer.pdb.minAvailable`
			maxUnavailable: ""
		}

		//# Repo server image
		image: {
			// -- Repository to use for the repo server
			// @default -- `""` (defaults to global.image.repository)
			repository: ""
			// -- Tag to use for the repo server
			// @default -- `""` (defaults to global.image.tag)
			tag: ""
			// -- Image pull policy for the repo server
			// @default -- `""` (defaults to global.image.imagePullPolicy)
			imagePullPolicy: ""
		}

		// -- Secrets with credentials to pull images from a private registry
		// @default -- `[]` (defaults to global.imagePullSecrets)
		imagePullSecrets: []

		// -- Additional command line arguments to pass to repo server
		extraArgs: []

		// -- Environment variables to pass to repo server
		env: []

		// -- envFrom to pass to repo server
		// @default -- `[]` (See [values.yaml])
		// - configMapRef:
		//     name: config-map-name
		// - secretRef:
		//     name: secret-name
		envFrom: []

		// -- Specify postStart and preStop lifecycle hooks for your argo-repo-server container
		lifecycle: {}

		// -- Additional containers to be added to the repo server pod
		//# Ref: https://argo-cd.readthedocs.io/en/stable/user-guide/config-management-plugins/
		//# Note: Supports use of custom Helm templates
		// - name: cmp-my-plugin
		//   command:
		//     - "/var/run/argocd/argocd-cmp-server"
		//   image: busybox
		//   securityContext:
		//     runAsNonRoot: true
		//     runAsUser: 999
		//   volumeMounts:
		//     - mountPath: /var/run/argocd
		//       name: var-files
		//     - mountPath: /home/argocd/cmp-server/plugins
		//       name: plugins
		//     # Remove this volumeMount if you've chosen to bake the config file into the sidecar image.
		//     - mountPath: /home/argocd/cmp-server/config/plugin.yaml
		//       subPath: my-plugin.yaml
		//       name: argocd-cmp-cm
		//     # Starting with v2.4, do NOT mount the same tmp volume as the repo-server container. The filesystem separation helps
		//     # mitigate path traversal attacks.
		//     - mountPath: /tmp
		//       name: cmp-tmp
		// - name: cmp-my-plugin2
		//   command:
		//     - "/var/run/argocd/argocd-cmp-server"
		//   image: busybox
		//   securityContext:
		//     runAsNonRoot: true
		//     runAsUser: 999
		//   volumeMounts:
		//     - mountPath: /var/run/argocd
		//       name: var-files
		//     # Remove this volumeMount if you've chosen to bake the config file into the sidecar image.
		//     - mountPath: /home/argocd/cmp-server/plugins
		//       name: plugins
		//     - mountPath: /home/argocd/cmp-server/config/plugin.yaml
		//       subPath: my-plugin2.yaml
		//       name: argocd-cmp-cm
		//     # Starting with v2.4, do NOT mount the same tmp volume as the repo-server container. The filesystem separation helps
		//     # mitigate path traversal attacks.
		//     - mountPath: /tmp
		//       name: cmp-tmp
		extraContainers: []

		// -- Init containers to add to the repo server pods
		initContainers: []

		// -- Additional volumeMounts to the repo server main container
		volumeMounts: []

		// -- Additional volumes to the repo server pod
		//  - name: argocd-cmp-cm
		//    configMap:
		//      name: argocd-cmp-cm
		//  - name: cmp-tmp
		//    emptyDir: {}
		volumes: []

		// -- Volumes to be used in replacement of emptydir on default volumes
		//  gpgKeyring:
		//    persistentVolumeClaim:
		//      claimName: pvc-argocd-repo-server-keyring
		//  helmWorkingDir:
		//    persistentVolumeClaim:
		//      claimName: pvc-argocd-repo-server-workdir
		//  tmp:
		//    persistentVolumeClaim:
		//      claimName: pvc-argocd-repo-server-tmp
		//  varFiles:
		//    persistentVolumeClaim:
		//      claimName: pvc-argocd-repo-server-varfiles
		//  plugins:
		//    persistentVolumeClaim:
		//      claimName: pvc-argocd-repo-server-plugins
		existingVolumes: {}

		//# RepoServer emptyDir volumes
		emptyDir: {
			// -- EmptyDir size limit for repo server
			// @default -- `""` (defaults not set if not specified i.e. no size limit)
			// sizeLimit: "1Gi"
			sizeLimit: ""
		}

		// -- Toggle the usage of a ephemeral Helm working directory
		useEphemeralHelmWorkingDir: true

		// -- Annotations to be added to repo server Deployment
		deploymentAnnotations: {}

		// -- Annotations to be added to repo server pods
		podAnnotations: {}

		// -- Labels to be added to repo server pods
		podLabels: {}

		// -- Resource limits and requests for the repo server pods
		//  limits:
		//    cpu: 50m
		//    memory: 128Mi
		//  requests:
		//    cpu: 10m
		//    memory: 64Mi
		resources: {}

		// Repo server container ports
		containerPorts: {
			// -- Repo server container port
			server: 8081
			// -- Metrics container port
			metrics: 8084
		}

		// -- Host Network for Repo server pods
		hostNetwork: false

		// -- [DNS configuration]
		dnsConfig: {}
		// -- Alternative DNS policy for Repo server pods
		dnsPolicy: "ClusterFirst"

		// -- Repo server container-level security context
		// @default -- See [values.yaml]
		containerSecurityContext: {
			runAsNonRoot:             true
			readOnlyRootFilesystem:   true
			allowPrivilegeEscalation: false
			seccompProfile: type: "RuntimeDefault"
			capabilities: drop: ["ALL"]
		}

		//# Readiness and liveness probes for default backend
		//# Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
		readinessProbe: {
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
		}
		livenessProbe: {
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
		}

		// -- terminationGracePeriodSeconds for container lifecycle hook
		terminationGracePeriodSeconds: 30

		// -- [Node selector]
		// @default -- `{}` (defaults to global.nodeSelector)
		nodeSelector: {}

		// -- [Tolerations] for use with node taints
		// @default -- `[]` (defaults to global.tolerations)
		tolerations: []

		// -- Assign custom [affinity] rules to the deployment
		// @default -- `{}` (defaults to global.affinity preset)
		affinity: {}

		// -- Assign custom [TopologySpreadConstraints] rules to the repo server
		// @default -- `[]` (defaults to global.topologySpreadConstraints)
		//# Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
		//# If labelSelector is left out, it will default to the labelSelector configuration of the deployment
		// - maxSkew: 1
		//   topologyKey: topology.kubernetes.io/zone
		//   whenUnsatisfiable: DoNotSchedule
		topologySpreadConstraints: []

		// -- Deployment strategy to be added to the repo server Deployment
		// type: RollingUpdate
		// rollingUpdate:
		//   maxSurge: 25%
		//   maxUnavailable: 25%
		deploymentStrategy: {}

		// -- Priority class for the repo server pods
		// @default -- `""` (defaults to global.priorityClassName)
		priorityClassName: ""

		// TLS certificate configuration via Secret
		//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/tls/#configuring-tls-to-argocd-repo-server
		//# Note: Issuing certificates via cert-manager in not supported right now because it's not possible to restart repo server automatically without extra controllers.
		certificateSecret: {
			// -- Create argocd-repo-server-tls secret
			enabled: false
			// -- Annotations to be added to argocd-repo-server-tls secret
			annotations: {}
			// -- Labels to be added to argocd-repo-server-tls secret
			labels: {}
			// -- Certificate authority. Required for self-signed certificates.
			ca: ""
			// -- Certificate private key
			key: ""
			// -- Certificate data. Must contain SANs of Repo service (ie: argocd-repo-server, argocd-repo-server.argo-cd.svc)
			crt: ""
		}

		//# Repo server service configuration
		service: {
			// -- Repo server service annotations
			annotations: {}
			// -- Repo server service labels
			labels: {}
			// -- Repo server service port
			port: 8081
			// -- Repo server service port name
			portName: "tcp-repo-server"
		}

		//# Repo server metrics service configuration
		metrics: {
			// -- Deploy metrics service
			enabled: false
			service: {
				// -- Metrics service type
				type: "ClusterIP"
				// -- Metrics service clusterIP. `None` makes a "headless service" (no virtual IP)
				clusterIP: ""
				// -- Metrics service annotations
				annotations: {}
				// -- Metrics service labels
				labels: {}
				// -- Metrics service port
				servicePort: 8084
				// -- Metrics service port name
				portName: "http-metrics"
			}
			serviceMonitor: {
				// -- Enable a prometheus ServiceMonitor
				enabled: false
				// -- Prometheus ServiceMonitor interval
				interval: "30s"
				// -- Prometheus ServiceMonitor scrapeTimeout. If empty, Prometheus uses the global scrape timeout unless it is less than the target's scrape interval value in which the latter is used.
				scrapeTimeout: ""
				// -- Prometheus [RelabelConfigs] to apply to samples before scraping
				relabelings: []
				// -- Prometheus [MetricRelabelConfigs] to apply to samples before ingestion
				metricRelabelings: []
				// -- Prometheus ServiceMonitor selector
				// prometheus: kube-prometheus
				selector: {}

				// -- Prometheus ServiceMonitor scheme
				scheme: ""
				// -- Prometheus ServiceMonitor tlsConfig
				tlsConfig: {}
				// -- Prometheus ServiceMonitor namespace
				namespace: "" // "monitoring"
				// -- Prometheus ServiceMonitor labels
				additionalLabels: {}
				// -- Prometheus ServiceMonitor annotations
				annotations: {}
			}
		}

		//# Enable Custom Rules for the Repo server's Cluster Role resource
		//# Enable this and set the rules: to whatever custom rules you want for the Cluster Role resource.
		//# Defaults to off
		clusterRoleRules: {
			// -- Enable custom rules for the Repo server's Cluster Role resource
			enabled: false
			// -- List of custom rules for the Repo server's Cluster Role resource
			rules: []
		}

		// -- Automount API credentials for the Service Account into the pod.
		automountServiceAccountToken: true

		//# Repo server service account
		//# If create is set to true, make sure to uncomment the name and update the rbac section below
		serviceAccount: {
			// -- Create repo server service account
			create: true
			// -- Repo server service account name
			name: "" // "argocd-repo-server"
			// -- Annotations applied to created service account
			annotations: {}
			// -- Labels applied to created service account
			labels: {}
			// -- Automount API credentials for the Service Account
			automountServiceAccountToken: true
		}

		// -- Repo server rbac rules
		//   - apiGroups:
		//     - argoproj.io
		//     resources:
		//     - applications
		//     verbs:
		//     - get
		//     - list
		//     - watch
		rbac: []
	}

	//# ApplicationSet controller
	applicationSet: {
		// -- ApplicationSet controller name string
		name: "applicationset-controller"

		// -- The number of ApplicationSet controller pods to run
		replicas: 1

		// -- Runtime class name for the ApplicationSet controller
		// @default -- `""` (defaults to global.runtimeClassName)
		runtimeClassName: ""

		//# ApplicationSet controller Pod Disruption Budget
		//# Ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
		pdb: {
			// -- Deploy a [PodDisruptionBudget] for the ApplicationSet controller
			enabled: false
			// -- Labels to be added to ApplicationSet controller pdb
			labels: {}
			// -- Annotations to be added to ApplicationSet controller pdb
			annotations: {}
			// -- Number of pods that are available after eviction as number or percentage (eg.: 50%)
			// @default -- `""` (defaults to 0 if not specified)
			minAvailable: ""
			// -- Number of pods that are unavailable after eviction as number or percentage (eg.: 50%).
			//# Has higher precedence over `applicationSet.pdb.minAvailable`
			maxUnavailable: ""
		}

		//# ApplicationSet controller image
		image: {
			// -- Repository to use for the ApplicationSet controller
			// @default -- `""` (defaults to global.image.repository)
			repository: ""
			// -- Tag to use for the ApplicationSet controller
			// @default -- `""` (defaults to global.image.tag)
			tag: ""
			// -- Image pull policy for the ApplicationSet controller
			// @default -- `""` (defaults to global.image.imagePullPolicy)
			imagePullPolicy: ""
		}

		// -- If defined, uses a Secret to pull an image from a private Docker registry or repository.
		// @default -- `[]` (defaults to global.imagePullSecrets)
		imagePullSecrets: []

		// -- ApplicationSet controller command line flags
		extraArgs: []

		// -- Environment variables to pass to the ApplicationSet controller
		// - name: "MY_VAR"
		//   value: "value"
		extraEnv: []

		// -- envFrom to pass to the ApplicationSet controller
		// @default -- `[]` (See [values.yaml])
		// - configMapRef:
		//     name: config-map-name
		// - secretRef:
		//     name: secret-name
		extraEnvFrom: []

		// -- Additional containers to be added to the ApplicationSet controller pod
		//# Note: Supports use of custom Helm templates
		extraContainers: []

		// -- Init containers to add to the ApplicationSet controller pod
		//# Note: Supports use of custom Helm templates
		initContainers: []

		// -- List of extra mounts to add (normally used with extraVolumes)
		extraVolumeMounts: []

		// -- List of extra volumes to add
		extraVolumes: []

		//# ApplicationSet controller emptyDir volumes
		emptyDir: {
			// -- EmptyDir size limit for applicationSet controller
			// @default -- `""` (defaults not set if not specified i.e. no size limit)
			// sizeLimit: "1Gi"
			sizeLimit: ""
		}

		//# Metrics service configuration
		metrics: {
			// -- Deploy metrics service
			enabled: false
			service: {
				// -- Metrics service type
				type: "ClusterIP"
				// -- Metrics service clusterIP. `None` makes a "headless service" (no virtual IP)
				clusterIP: ""
				// -- Metrics service annotations
				annotations: {}
				// -- Metrics service labels
				labels: {}
				// -- Metrics service port
				servicePort: 8080
				// -- Metrics service port name
				portName: "http-metrics"
			}
			serviceMonitor: {
				// -- Enable a prometheus ServiceMonitor
				enabled: false
				// -- Prometheus ServiceMonitor interval
				interval: "30s"
				// -- Prometheus ServiceMonitor scrapeTimeout. If empty, Prometheus uses the global scrape timeout unless it is less than the target's scrape interval value in which the latter is used.
				scrapeTimeout: ""
				// -- Prometheus [RelabelConfigs] to apply to samples before scraping
				relabelings: []
				// -- Prometheus [MetricRelabelConfigs] to apply to samples before ingestion
				metricRelabelings: []
				// -- Prometheus ServiceMonitor selector
				// prometheus: kube-prometheus
				selector: {}

				// -- Prometheus ServiceMonitor scheme
				scheme: ""
				// -- Prometheus ServiceMonitor tlsConfig
				tlsConfig: {}
				// -- Prometheus ServiceMonitor namespace
				namespace: "" // monitoring
				// -- Prometheus ServiceMonitor labels
				additionalLabels: {}
				// -- Prometheus ServiceMonitor annotations
				annotations: {}
			}
		}

		//# ApplicationSet service configuration
		service: {
			// -- ApplicationSet service annotations
			annotations: {}
			// -- ApplicationSet service labels
			labels: {}
			// -- ApplicationSet service type
			type: "ClusterIP"
			// -- ApplicationSet service port
			port: 7000
			// -- ApplicationSet service port name
			portName: "http-webhook"
		}

		// -- Automount API credentials for the Service Account into the pod.
		automountServiceAccountToken: true
		serviceAccount: {
			// -- Create ApplicationSet controller service account
			create: true
			// -- ApplicationSet controller service account name
			name: "argocd-applicationset-controller"
			// -- Annotations applied to created service account
			annotations: {}
			// -- Labels applied to created service account
			labels: {}
			// -- Automount API credentials for the Service Account
			automountServiceAccountToken: true
		}

		// -- Annotations to be added to ApplicationSet controller Deployment
		deploymentAnnotations: {}

		// -- Annotations for the ApplicationSet controller pods
		podAnnotations: {}

		// -- Labels for the ApplicationSet controller pods
		podLabels: {}

		// -- Resource limits and requests for the ApplicationSet controller pods.
		// limits:
		//   cpu: 100m
		//   memory: 128Mi
		// requests:
		//   cpu: 100m
		//   memory: 128Mi
		resources: {}

		// ApplicationSet controller container ports
		containerPorts: {
			// -- Metrics container port
			metrics: 8080
			// -- Probe container port
			probe: 8081
			// -- Webhook container port
			webhook: 7000
		}

		// -- [DNS configuration]
		dnsConfig: {}
		// -- Alternative DNS policy for ApplicationSet controller pods
		dnsPolicy: "ClusterFirst"

		// -- ApplicationSet controller container-level security context
		// @default -- See [values.yaml]
		containerSecurityContext: {
			runAsNonRoot:             true
			readOnlyRootFilesystem:   true
			allowPrivilegeEscalation: false
			seccompProfile: type: "RuntimeDefault"
			capabilities: drop: ["ALL"]
		}

		//# Probes for ApplicationSet controller (optional)
		//# Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
		readinessProbe: {
			// -- Enable Kubernetes liveness probe for ApplicationSet controller
			enabled: false
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
		}
		livenessProbe: {
			// -- Enable Kubernetes liveness probe for ApplicationSet controller
			enabled: false
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
		}

		// -- terminationGracePeriodSeconds for container lifecycle hook
		terminationGracePeriodSeconds: 30

		// -- [Node selector]
		// @default -- `{}` (defaults to global.nodeSelector)
		nodeSelector: {}

		// -- [Tolerations] for use with node taints
		// @default -- `[]` (defaults to global.tolerations)
		tolerations: []

		// -- Assign custom [affinity] rules
		// @default -- `{}` (defaults to global.affinity preset)
		affinity: {}

		// -- Assign custom [TopologySpreadConstraints] rules to the ApplicationSet controller
		// @default -- `[]` (defaults to global.topologySpreadConstraints)
		//# Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
		//# If labelSelector is left out, it will default to the labelSelector configuration of the deployment
		// - maxSkew: 1
		//   topologyKey: topology.kubernetes.io/zone
		//   whenUnsatisfiable: DoNotSchedule
		topologySpreadConstraints: []

		// -- Deployment strategy to be added to the ApplicationSet controller Deployment
		// type: RollingUpdate
		// rollingUpdate:
		//   maxSurge: 25%
		//   maxUnavailable: 25%
		deploymentStrategy: {}

		// -- Priority class for the ApplicationSet controller pods
		// @default -- `""` (defaults to global.priorityClassName)
		priorityClassName: ""

		// TLS certificate configuration via cert-manager
		//# Ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/tls/#tls-configuration
		certificate: {
			// -- Deploy a Certificate resource (requires cert-manager)
			enabled: false
			// -- Certificate primary domain (commonName)
			// @default -- `""` (defaults to global.domain)
			domain: ""
			// -- Certificate Subject Alternate Names (SANs)
			additionalHosts: []
			// -- The requested 'duration' (i.e. lifetime) of the certificate.
			// @default -- `""` (defaults to 2160h = 90d if not specified)
			//# Ref: https://cert-manager.io/docs/usage/certificate/#renewal
			duration: ""
			// -- How long before the expiry a certificate should be renewed.
			// @default -- `""` (defaults to 360h = 15d if not specified)
			//# Ref: https://cert-manager.io/docs/usage/certificate/#renewal
			renewBefore: ""
			// Certificate issuer
			//# Ref: https://cert-manager.io/docs/concepts/issuer
			issuer: {
				// -- Certificate issuer group. Set if using an external issuer. Eg. `cert-manager.io`
				group: ""
				// -- Certificate issuer kind. Either `Issuer` or `ClusterIssuer`
				kind: ""
				// -- Certificate issuer name. Eg. `letsencrypt`
				name: ""
			}
			// Private key of the certificate
			privateKey: {
				// -- Rotation policy of private key when certificate is re-issued. Either: `Never` or `Always`
				rotationPolicy: "Never"
				// -- The private key cryptography standards (PKCS) encoding for private key. Either: `PCKS1` or `PKCS8`
				encoding: "PKCS1"
				// -- Algorithm used to generate certificate private key. One of: `RSA`, `Ed25519` or `ECDSA`
				algorithm: "RSA"
				// -- Key bit size of the private key. If algorithm is set to `Ed25519`, size is ignored.
				size: 2048
			}
			// -- Annotations to be applied to the ApplicationSet Certificate
			annotations: {}
		}

		//# Ingress for the Git Generator webhook
		//# Ref: https://argocd-applicationset.readthedocs.io/en/master/Generators-Git/#webhook-configuration)
		ingress: {
			// -- Enable an ingress resource for ApplicationSet webhook
			enabled: false
			// -- Additional ingress labels
			labels: {}
			// -- Additional ingress annotations
			annotations: {}

			// -- Defines which ingress ApplicationSet controller will implement the resource
			ingressClassName: ""

			// -- Argo CD ApplicationSet hostname
			// @default -- `""` (defaults to global.domain)
			hostname: ""

			// -- List of ingress paths
			path: "/api/webhook"

			// -- Ingress path type. One of `Exact`, `Prefix` or `ImplementationSpecific`
			pathType: "Prefix"

			// -- Enable TLS configuration for the hostname defined at `applicationSet.webhook.ingress.hostname`
			//# TLS certificate will be retrieved from a TLS secret with name:`argocd-applicationset-controller-tls`
			tls: false

			// -- The list of additional hostnames to be covered by ingress record
			// @default -- `[]` (See [values.yaml])
			// - name: argocd.example.com
			//   path: /
			extraHosts: []

			// -- Additional ingress paths
			// @default -- `[]` (See [values.yaml])
			// - path: /*
			//   pathType: Prefix
			//   backend:
			//     service:
			//       name: ssl-redirect
			//       port:
			//         name: use-annotation
			extraPaths: []

			// -- Additional ingress rules
			// @default -- `[]` (See [values.yaml])
			//# Note: Supports use of custom Helm templates
			// - http:
			//    paths:
			//    - path: /api/webhook
			//      pathType: Prefix
			//      backend:
			//        service:
			//          name: '{{ include "argo-cd.applicationSet.fullname" . }}'
			//          port:
			//            name: '{{ .Values.applicationSet.service.portName }}'
			extraRules: []

			// -- Additional ingress TLS configuration
			// @default -- `[]` (See [values.yaml])
			// - secretName: argocd-applicationset-tls
			//   hosts:
			//     - argocd-applicationset.example.com
			extraTls: []
		}

		// -- Enable ApplicationSet in any namespace feature
		allowAnyNamespace: false
	}
	//# Notifications controller
	notifications: {
		// -- Enable notifications controller
		enabled: true

		// -- Notifications controller name string
		name: "notifications-controller"

		// -- Argo CD dashboard url; used in place of {{.context.argocdUrl}} in templates
		// @default -- `""` (defaults to https://`global.domain`)
		argocdUrl: ""

		// -- Runtime class name for the notifications controller
		// @default -- `""` (defaults to global.runtimeClassName)
		runtimeClassName: ""

		//# Notifications controller Pod Disruption Budget
		//# Ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
		pdb: {
			// -- Deploy a [PodDisruptionBudget] for the notifications controller
			enabled: false
			// -- Labels to be added to notifications controller pdb
			labels: {}
			// -- Annotations to be added to notifications controller pdb
			annotations: {}
			// -- Number of pods that are available after eviction as number or percentage (eg.: 50%)
			// @default -- `""` (defaults to 0 if not specified)
			minAvailable: ""
			// -- Number of pods that are unavailable after eviction as number or percentage (eg.: 50%).
			//# Has higher precedence over `notifications.pdb.minAvailable`
			maxUnavailable: ""
		}

		//# Notifications controller image
		image: {
			// -- Repository to use for the notifications controller
			// @default -- `""` (defaults to global.image.repository)
			repository: ""
			// -- Tag to use for the notifications controller
			// @default -- `""` (defaults to global.image.tag)
			tag: ""
			// -- Image pull policy for the notifications controller
			// @default -- `""` (defaults to global.image.imagePullPolicy)
			imagePullPolicy: ""
		}

		// -- Secrets with credentials to pull images from a private registry
		// @default -- `[]` (defaults to global.imagePullSecrets)
		imagePullSecrets: []

		// -- Notifications controller log format. Either `text` or `json`
		// @default -- `""` (defaults to global.logging.format)
		logFormat: ""
		// -- Notifications controller log level. One of: `debug`, `info`, `warn`, `error`
		// @default -- `""` (defaults to global.logging.level)
		logLevel: ""

		// -- Extra arguments to provide to the notifications controller
		extraArgs: []

		// -- Additional container environment variables
		extraEnv: []

		// -- envFrom to pass to the notifications controller
		// @default -- `[]` (See [values.yaml])
		// - configMapRef:
		//     name: config-map-name
		// - secretRef:
		//     name: secret-name
		extraEnvFrom: []

		// -- Additional containers to be added to the notifications controller pod
		//# Note: Supports use of custom Helm templates
		extraContainers: []

		// -- Init containers to add to the notifications controller pod
		//# Note: Supports use of custom Helm templates
		initContainers: []

		// -- List of extra mounts to add (normally used with extraVolumes)
		extraVolumeMounts: []

		// -- List of extra volumes to add
		extraVolumes: []

		// -- Define user-defined context
		//# For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/templates/#defining-user-defined-context
		// region: east
		// environmentName: staging
		context: {}
		// grafana-apiKey:
		//   # For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/services/grafana/
		// webhooks-github-token:
		// email-username:
		// email-password:
		// For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/services/email/
		secret: {
			// -- Whether helm chart creates notifications controller secret
			//# If true, will create a secret with the name below. Otherwise, will assume existence of a secret with that name.
			create: true

			// -- notifications controller Secret name
			name: "argocd-notifications-secret"

			// -- key:value pairs of annotations to be added to the secret
			annotations: {}

			// -- key:value pairs of labels to be added to the secret
			labels: {}

			// -- Generic key:value pairs to be inserted into the secret
			//# Can be used for templates, notification services etc. Some examples given below.
			//# For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/services/overview/
			// slack-token:
			//   # For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/services/slack/
			items: {}
		}
		metrics: {
			// -- Enables prometheus metrics server
			enabled: false
			// -- Metrics port
			port: 9001
			service: {
				// -- Metrics service type
				type: "ClusterIP"
				// -- Metrics service clusterIP. `None` makes a "headless service" (no virtual IP)
				clusterIP: ""
				// -- Metrics service annotations
				annotations: {}
				// -- Metrics service labels
				labels: {}
				// -- Metrics service port name
				portName: "http-metrics"
			}
			serviceMonitor: {
				// -- Enable a prometheus ServiceMonitor
				enabled: false
				// -- Prometheus ServiceMonitor selector
				selector: {}
				// prometheus: kube-prometheus
				// -- Prometheus ServiceMonitor labels
				additionalLabels: {}
				// -- Prometheus ServiceMonitor annotations
				annotations: {}
				// namespace: monitoring
				// interval: 30s
				// scrapeTimeout: 10s
				// -- Prometheus ServiceMonitor scheme
				scheme: ""
				// -- Prometheus ServiceMonitor tlsConfig
				tlsConfig: {}
				// -- Prometheus [RelabelConfigs] to apply to samples before scraping
				relabelings: []
				// -- Prometheus [MetricRelabelConfigs] to apply to samples before ingestion
				metricRelabelings: []
			}
		}

		// -- Configures notification services such as slack, email or custom webhook
		// @default -- See [values.yaml]
		//# For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/services/overview/
		// service.slack: |
		//   token: $slack-token
		notifiers: {}

		// -- Annotations to be applied to the notifications controller Deployment
		deploymentAnnotations: {}

		// -- Annotations to be applied to the notifications controller Pods
		podAnnotations: {}

		// -- Labels to be applied to the notifications controller Pods
		podLabels: {}

		// -- Resource limits and requests for the notifications controller
		// limits:
		//   cpu: 100m
		//   memory: 128Mi
		// requests:
		//   cpu: 100m
		//   memory: 128Mi
		resources: {}

		// Notification controller container ports
		containerPorts: {
			// -- Metrics container port
			metrics: 9001
		}

		// -- [DNS configuration]
		dnsConfig: {}
		// -- Alternative DNS policy for notifications controller Pods
		dnsPolicy: "ClusterFirst"

		// -- Notification controller container-level security Context
		// @default -- See [values.yaml]
		containerSecurityContext: {
			runAsNonRoot:             true
			readOnlyRootFilesystem:   true
			allowPrivilegeEscalation: false
			seccompProfile: type: "RuntimeDefault"
			capabilities: drop: ["ALL"]
		}

		//# Probes for notifications controller Pods (optional)
		//# Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
		readinessProbe: {
			// -- Enable Kubernetes liveness probe for notifications controller Pods
			enabled: false
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
		}
		livenessProbe: {
			// -- Enable Kubernetes liveness probe for notifications controller Pods
			enabled: false
			// -- Number of seconds after the container has started before [probe] is initiated
			initialDelaySeconds: 10
			// -- How often (in seconds) to perform the [probe]
			periodSeconds: 10
			// -- Number of seconds after which the [probe] times out
			timeoutSeconds: 1
			// -- Minimum consecutive successes for the [probe] to be considered successful after having failed
			successThreshold: 1
			// -- Minimum consecutive failures for the [probe] to be considered failed after having succeeded
			failureThreshold: 3
		}

		// -- terminationGracePeriodSeconds for container lifecycle hook
		terminationGracePeriodSeconds: 30

		// -- [Node selector]
		// @default -- `{}` (defaults to global.nodeSelector)
		nodeSelector: {}

		// -- [Tolerations] for use with node taints
		// @default -- `[]` (defaults to global.tolerations)
		tolerations: []

		// -- Assign custom [affinity] rules
		// @default -- `{}` (defaults to global.affinity preset)
		affinity: {}

		// -- Assign custom [TopologySpreadConstraints] rules to the application controller
		// @default -- `[]` (defaults to global.topologySpreadConstraints)
		//# Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
		//# If labelSelector is left out, it will default to the labelSelector configuration of the deployment
		// - maxSkew: 1
		//   topologyKey: topology.kubernetes.io/zone
		//   whenUnsatisfiable: DoNotSchedule
		topologySpreadConstraints: []

		// -- Deployment strategy to be added to the notifications controller Deployment
		deploymentStrategy: {
			type: "Recreate"
		}

		// -- Priority class for the notifications controller pods
		// @default -- `""` (defaults to global.priorityClassName)
		priorityClassName: ""

		// -- Automount API credentials for the Service Account into the pod.
		automountServiceAccountToken: true
		serviceAccount: {
			// -- Create notifications controller service account
			create: true
			// -- Notification controller service account name
			name: "argocd-notifications-controller"
			// -- Annotations applied to created service account
			annotations: {}
			// -- Labels applied to created service account
			labels: {}
			// -- Automount API credentials for the Service Account
			automountServiceAccountToken: true
		}
		cm: {
			// -- Whether helm chart creates notifications controller config map
			create: true
		}

		//# Enable this and set the rules: to whatever custom rules you want for the Cluster Role resource.
		//# Defaults to off
		clusterRoleRules: {
			// -- List of custom rules for the notifications controller's ClusterRole resource
			rules: []}

		// -- Contains centrally managed global application subscriptions
		//# For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/subscriptions/
		// # subscription for on-sync-status-unknown trigger notifications
		// - recipients:
		//   - slack:test2
		//   - email:test@gmail.com
		//   triggers:
		//   - on-sync-status-unknown
		// # subscription restricted to applications with matching labels only
		// - recipients:
		//   - slack:test3
		//   selector: test=true
		//   triggers:
		//   - on-sync-status-unknown
		subscriptions: []

		// -- The notification template is used to generate the notification content
		//# For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/templates/
		// template.app-deployed: |
		//   email:
		//     subject: New version of an application {{.app.metadata.name}} is up and running.
		//   message: |
		//     {{if eq .serviceType "slack"}}:white_check_mark:{{end}} Application {{.app.metadata.name}} is now running new version of deployments manifests.
		//   slack:
		//     attachments: |
		//       [{
		//         "title": "{{ .app.metadata.name}}",
		//         "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
		//         "color": "#18be52",
		//         "fields": [
		//         {
		//           "title": "Sync Status",
		//           "value": "{{.app.status.sync.status}}",
		//           "short": true
		//         },
		//         {
		//           "title": "Repository",
		//           "value": "{{.app.spec.source.repoURL}}",
		//           "short": true
		//         },
		//         {
		//           "title": "Revision",
		//           "value": "{{.app.status.sync.revision}}",
		//           "short": true
		//         }
		//         {{range $index, $c := .app.status.conditions}}
		//         {{if not $index}},{{end}}
		//         {{if $index}},{{end}}
		//         {
		//           "title": "{{$c.type}}",
		//           "value": "{{$c.message}}",
		//           "short": true
		//         }
		//         {{end}}
		//         ]
		//       }]
		// template.app-health-degraded: |
		//   email:
		//     subject: Application {{.app.metadata.name}} has degraded.
		//   message: |
		//     {{if eq .serviceType "slack"}}:exclamation:{{end}} Application {{.app.metadata.name}} has degraded.
		//     Application details: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}.
		//   slack:
		//     attachments: |-
		//       [{
		//         "title": "{{ .app.metadata.name}}",
		//         "title_link": "{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
		//         "color": "#f4c030",
		//         "fields": [
		//         {
		//           "title": "Sync Status",
		//           "value": "{{.app.status.sync.status}}",
		//           "short": true
		//         },
		//         {
		//           "title": "Repository",
		//           "value": "{{.app.spec.source.repoURL}}",
		//           "short": true
		//         }
		//         {{range $index, $c := .app.status.conditions}}
		//         {{if not $index}},{{end}}
		//         {{if $index}},{{end}}
		//         {
		//           "title": "{{$c.type}}",
		//           "value": "{{$c.message}}",
		//           "short": true
		//         }
		//         {{end}}
		//         ]
		//       }]
		// template.app-sync-failed: |
		//   email:
		//     subject: Failed to sync application {{.app.metadata.name}}.
		//   message: |
		//     {{if eq .serviceType "slack"}}:exclamation:{{end}}  The sync operation of application {{.app.metadata.name}} has failed at {{.app.status.operationState.finishedAt}} with the following error: {{.app.status.operationState.message}}
		//     Sync operation details are available at: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}?operation=true .
		//   slack:
		//     attachments: |-
		//       [{
		//         "title": "{{ .app.metadata.name}}",
		//         "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
		//         "color": "#E96D76",
		//         "fields": [
		//         {
		//           "title": "Sync Status",
		//           "value": "{{.app.status.sync.status}}",
		//           "short": true
		//         },
		//         {
		//           "title": "Repository",
		//           "value": "{{.app.spec.source.repoURL}}",
		//           "short": true
		//         }
		//         {{range $index, $c := .app.status.conditions}}
		//         {{if not $index}},{{end}}
		//         {{if $index}},{{end}}
		//         {
		//           "title": "{{$c.type}}",
		//           "value": "{{$c.message}}",
		//           "short": true
		//         }
		//         {{end}}
		//         ]
		//       }]
		// template.app-sync-running: |
		//   email:
		//     subject: Start syncing application {{.app.metadata.name}}.
		//   message: |
		//     The sync operation of application {{.app.metadata.name}} has started at {{.app.status.operationState.startedAt}}.
		//     Sync operation details are available at: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}?operation=true .
		//   slack:
		//     attachments: |-
		//       [{
		//         "title": "{{ .app.metadata.name}}",
		//         "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
		//         "color": "#0DADEA",
		//         "fields": [
		//         {
		//           "title": "Sync Status",
		//           "value": "{{.app.status.sync.status}}",
		//           "short": true
		//         },
		//         {
		//           "title": "Repository",
		//           "value": "{{.app.spec.source.repoURL}}",
		//           "short": true
		//         }
		//         {{range $index, $c := .app.status.conditions}}
		//         {{if not $index}},{{end}}
		//         {{if $index}},{{end}}
		//         {
		//           "title": "{{$c.type}}",
		//           "value": "{{$c.message}}",
		//           "short": true
		//         }
		//         {{end}}
		//         ]
		//       }]
		// template.app-sync-status-unknown: |
		//   email:
		//     subject: Application {{.app.metadata.name}} sync status is 'Unknown'
		//   message: |
		//     {{if eq .serviceType "slack"}}:exclamation:{{end}} Application {{.app.metadata.name}} sync is 'Unknown'.
		//     Application details: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}.
		//     {{if ne .serviceType "slack"}}
		//     {{range $c := .app.status.conditions}}
		//         * {{$c.message}}
		//     {{end}}
		//     {{end}}
		//   slack:
		//     attachments: |-
		//       [{
		//         "title": "{{ .app.metadata.name}}",
		//         "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
		//         "color": "#E96D76",
		//         "fields": [
		//         {
		//           "title": "Sync Status",
		//           "value": "{{.app.status.sync.status}}",
		//           "short": true
		//         },
		//         {
		//           "title": "Repository",
		//           "value": "{{.app.spec.source.repoURL}}",
		//           "short": true
		//         }
		//         {{range $index, $c := .app.status.conditions}}
		//         {{if not $index}},{{end}}
		//         {{if $index}},{{end}}
		//         {
		//           "title": "{{$c.type}}",
		//           "value": "{{$c.message}}",
		//           "short": true
		//         }
		//         {{end}}
		//         ]
		//       }]
		// template.app-sync-succeeded: |
		//   email:
		//     subject: Application {{.app.metadata.name}} has been successfully synced.
		//   message: |
		//     {{if eq .serviceType "slack"}}:white_check_mark:{{end}} Application {{.app.metadata.name}} has been successfully synced at {{.app.status.operationState.finishedAt}}.
		//     Sync operation details are available at: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}?operation=true .
		//   slack:
		//     attachments: |-
		//       [{
		//         "title": "{{ .app.metadata.name}}",
		//         "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
		//         "color": "#18be52",
		//         "fields": [
		//         {
		//           "title": "Sync Status",
		//           "value": "{{.app.status.sync.status}}",
		//           "short": true
		//         },
		//         {
		//           "title": "Repository",
		//           "value": "{{.app.spec.source.repoURL}}",
		//           "short": true
		//         }
		//         {{range $index, $c := .app.status.conditions}}
		//         {{if not $index}},{{end}}
		//         {{if $index}},{{end}}
		//         {
		//           "title": "{{$c.type}}",
		//           "value": "{{$c.message}}",
		//           "short": true
		//         }
		//         {{end}}
		//         ]
		//       }]
		templates: {}

		// -- The trigger defines the condition when the notification should be sent
		//# For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/triggers/
		// trigger.on-deployed: |
		//   - description: Application is synced and healthy. Triggered once per commit.
		//     oncePer: app.status.sync.revision
		//     send:
		//     - app-deployed
		//     when: app.status.operationState.phase in ['Succeeded'] and app.status.health.status == 'Healthy'
		// trigger.on-health-degraded: |
		//   - description: Application has degraded
		//     send:
		//     - app-health-degraded
		//     when: app.status.health.status == 'Degraded'
		// trigger.on-sync-failed: |
		//   - description: Application syncing has failed
		//     send:
		//     - app-sync-failed
		//     when: app.status.operationState.phase in ['Error', 'Failed']
		// trigger.on-sync-running: |
		//   - description: Application is being synced
		//     send:
		//     - app-sync-running
		//     when: app.status.operationState.phase in ['Running']
		// trigger.on-sync-status-unknown: |
		//   - description: Application status is 'Unknown'
		//     send:
		//     - app-sync-status-unknown
		//     when: app.status.sync.status == 'Unknown'
		// trigger.on-sync-succeeded: |
		//   - description: Application syncing has succeeded
		//     send:
		//     - app-sync-succeeded
		//     when: app.status.operationState.phase in ['Succeeded']
		//
		// For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/triggers/#default-triggers
		// defaultTriggers: |
		//   - on-sync-status-unknown
		triggers: {}
	}
}