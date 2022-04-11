# backbase-app

## Description

`backbase-app` Helm Chart represents typical Backbase Java Application based on Spring Boot.

## How to use

This chart should be used in other [umbrella](https://helm.sh/docs/charts_tips_and_tricks/#complex-charts-with-many-dependencies) charts as a [dependency](https://helm.sh/docs/developing_charts/#chart-dependencies) with [alias](https://helm.sh/docs/developing_charts/#alias-field-in-requirements-yaml).

This chart is highly dependent on Helm [global values](https://helm.sh/docs/developing_charts/#global-values) functionality.

## Configuration

Check comments in values.yaml

## Changelog

- 0.1.3: ability to mount custom files
- 0.1.4: extra labels and annotations for Pods
- 0.1.5: common env vars for jwt/activemq/database things
- 0.2.0:
  - big refactoring
  - flatten many values
  - subservice overrides for capability chart globals, values supported:
    - `application.metadata`
    - `application.image.tag`
    - `env`
    - `podExtraLabels`
    - `podExtraAnnotations`
    - `javaOpts.extra`
    - `jmx`
    - `debug`
    - `jwt`
    - `registry`
    - `activemq`
    - `database`
  - `envFrom` support removed
  - `env` now dict (was list)
  - `application.metadata.name` moved to `application.name`
- 0.2.1:
  - new `application.repository` property (global and local)
  - ability to remap database/activemq environment variables to different names (`databaseEnvVarsMap/activemqEnvVarsMap`)
- 0.2.2:
  - refactoring
  - README.md update
  - NOTES.txt update
  - default values.yaml documentation
  - global nodeSelector
  - removed '?useSSL=false' for mysql database url
  - added mssql database type
  - new database.urlTemplate value
  - fix for check initContainers names
- 0.2.3:
  - application.image.tagFrom support
- 0.2.4:
  - chartnameOverride
- 0.2.5:
  - urlTemplate for activemq
- 0.2.6:
  - MariaDB support
- 0.3.0:
  - `application` property renamed to just `app`
  - `resources` property removed, now calculated based on new `app.resources` property
  - fix for Oracle database connect string
  - better Java memory management (Xms/Xmx/MaxRam)
  - persistant storage support (PVC)
- 0.3.1:
  - `chartnameOverride`removed
  - changed logic of `fullname` generation
- 0.4.0:
  - `global.service`
  - `global.volumes` and `global.volumeMounts` (will not merge with locals)
  - `global.initContainers` (will not merge with locals)
  - dicts can be used as values for Environment Variables
  - imagePullSecrets bug fixed (use `global.imagePullSecrets`)
- 0.4.1:
  - global `livenessProbe`/`readinessProbe`
  - configurable `schema` and `failureThreshold` for probes
- 0.4.2:
  - Updates health check from production-support to actuator
- 0.5.0:
  - proper Ingress apiVersion for later k8s versions
  - global `ingress.annotations`
  - global `ingress.baseDomain`
  - `ingress.hosts.*.customPaths` support
- 0.6.0:
  - Changed environment variables for the following variables:  
    - eureka.client.serviceUrl.defaultZone
      - EUREKA_CLIENT_SERVICEURL_DEFAULTZONE
    - eureka.instance.preferIpAddress
      - EUREKA_INSTANCE_PREFERIPADDRESS
- 0.6.1:
  - Added possibility to change the eureka default zone environment variable 
  - Added possibility to change the javaOpts variable
  - Changed default to be JAVA_TOOL_OPTIONS (from JAVA_OPT)
- 0.7.0
  - Removed the memory configuration in favor of the -XX:MaxRAMPercentage option in combination with -XX:+UseContainerSupport
  - For upgrading: change your `app.resources.memory.xmx` to `app.resources.memory.ram`. You can remove any xmx/xms related configuration.
- 0.8.0
  - Kubernetes RBAC support (service account, role, role binding)
- 0.8.1
  - Main deployment container now have fixed name `main`
- 0.9.0
  - Added possibility to add more containers to a pod using the property `additionalContainers`
- 0.10.0
  - Pod PriorityClass support
- 0.11.0
  - probes paths adjusted to `/actuator/health/liveness` and `/actuator/health/readiness` to reflect latest SSDK changes
  - bug with wrong PersistentVolumeClaim name fixed
- 0.12.0
  - Deployment Strategy support
- 0.12.1
  - bug with extra whitespace template, PersistentVolumeClaim name fixed
- 0.12.2
  - bug with rendering NOTES.txt when using Loadbalancer service type
- 0.13.0
  - Add additional service ports
