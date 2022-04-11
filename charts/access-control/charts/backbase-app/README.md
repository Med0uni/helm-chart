# backbase-app

![Version: 0.18.2](https://img.shields.io/badge/Version-0.18.2-informational?style=flat-square)

A Common Helm Chart that represents typical Backbase Java Application based on Spring Boot.
This chart should be used in other [umbrella](https://helm.sh/docs/charts_tips_and_tricks/#complex-charts-with-many-dependencies) charts as a [dependency](https://helm.sh/docs/developing_charts/#chart-dependencies) with [alias](https://helm.sh/docs/developing_charts/#alias-field-in-requirements-yaml).
This chart is highly dependent on Helm [global values](https://helm.sh/docs/developing_charts/#global-values) functionality.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| BaaS Team | baas@backbase.com |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| activemq | object | `{}` |  |
| activemqEnvVarsMap | object | `{}` |  |
| additionalContainers | list | `[]` |  |
| app.image.tagFrom | string | `""` |  |
| app.metadata | object | `{}` |  |
| app.name | string | `"backbase-application"` |  |
| app.ports[0].name | string | `"http"` |  |
| app.ports[0].port | int | `8080` |  |
| app.resources.cpu.maxShares | int | `1000` |  |
| app.resources.cpu.minShares | int | `100` |  |
| app.resources.memory.containerReserve | int | `25` |  |
| app.resources.memory.ram | int | `512` |  |
| customFiles | object | `{}` |  |
| customFilesPath | string | `"/customfiles/"` |  |
| database | object | `{}` |  |
| databaseEnvVarsMap | object | `{}` |  |
| debug | object | `{}` |  |
| env | object | `{}` |  |
| global.activemq.checkEnabled | bool | `false` |  |
| global.activemq.checkType | string | `"netcat"` |  |
| global.activemq.enabled | bool | `false` |  |
| global.activemq.existingSecret | string | `""` |  |
| global.activemq.existingSecretKey | string | `"ACTIVEMQ_PASSWORD"` |  |
| global.activemq.host | string | `"activemq"` |  |
| global.activemq.password | string | `"CHANGEME"` |  |
| global.activemq.port | int | `61616` |  |
| global.activemq.urlTemplate | string | `""` |  |
| global.activemq.username | string | `"admin"` |  |
| global.activemqEnvVarsMap.PASSWORD | string | `"SPRING_ACTIVEMQ_PASSWORD"` |  |
| global.activemqEnvVarsMap.URL | string | `"SPRING_ACTIVEMQ_BROKER_URL"` |  |
| global.activemqEnvVarsMap.USERNAME | string | `"SPRING_ACTIVEMQ_USER"` |  |
| global.affinity | object | `{}` |  |
| global.app.image.pullPolicy | string | `"IfNotPresent"` |  |
| global.app.image.registry | string | `""` |  |
| global.app.image.repository | string | `""` |  |
| global.app.image.tag | string | `""` |  |
| global.app.metadata | object | `{}` |  |
| global.chartName | string | `""` |  |
| global.database.checkEnabled | bool | `false` |  |
| global.database.checkType | string | `"netcat"` |  |
| global.database.enabled | bool | `false` |  |
| global.database.existingSecret | string | `""` |  |
| global.database.existingSecretKey | string | `"mysql-password"` |  |
| global.database.host | string | `"mysql"` |  |
| global.database.password | string | `"CHANGEME"` |  |
| global.database.port | int | `3306` |  |
| global.database.sid | string | `""` |  |
| global.database.type | string | `"mysql"` |  |
| global.database.urlTemplate | string | `""` |  |
| global.database.username | string | `"backbase"` |  |
| global.databaseEnvVarsMap.DRIVER_CLASS_NAME | string | `"SPRING_DATASOURCE_DRIVER_CLASS_NAME"` |  |
| global.databaseEnvVarsMap.PASSWORD | string | `"SPRING_DATASOURCE_PASSWORD"` |  |
| global.databaseEnvVarsMap.URL | string | `"SPRING_DATASOURCE_URL"` |  |
| global.databaseEnvVarsMap.USERNAME | string | `"SPRING_DATASOURCE_USERNAME"` |  |
| global.debug.enabled | bool | `false` |  |
| global.debug.javaOpts[0] | string | `"-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address={{.Values.global.debug.port}}"` |  |
| global.debug.port | int | `5005` |  |
| global.defaultAffinity | bool | `false` |  |
| global.env | object | `{}` |  |
| global.hostAliases | list | `[]` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.ingress.annotations | object | `{}` |  |
| global.ingress.baseDomain | string | `""` |  |
| global.initContainers | list | `[]` |  |
| global.javaOpts.base[0] | string | `"-XX:MaxRAMPercentage=99.0"` |  |
| global.javaOpts.base[1] | string | `"-XX:+UseContainerSupport"` |  |
| global.javaOpts.envVarName | string | `"JAVA_TOOL_OPTIONS"` |  |
| global.javaOpts.extra[0] | string | `"-Dlogging.level.root=WARN"` |  |
| global.javaOpts.extra[1] | string | `"-Dlogging.level.com.backbase=WARN"` |  |
| global.jmx.enabled | bool | `false` |  |
| global.jmx.javaOpts[0] | string | `"-Dcom.sun.management.jmxremote"` |  |
| global.jmx.javaOpts[1] | string | `"-Dcom.sun.management.jmxremote.authenticate=false"` |  |
| global.jmx.javaOpts[2] | string | `"-Dcom.sun.management.jmxremote.ssl=false"` |  |
| global.jmx.javaOpts[3] | string | `"-Dcom.sun.management.jmxremote.local.only=false"` |  |
| global.jmx.javaOpts[4] | string | `"-Dcom.sun.management.jmxremote.port={{.Values.global.jmx.port}}"` |  |
| global.jmx.javaOpts[5] | string | `"-Dcom.sun.management.jmxremote.rmi.port={{.Values.global.jmx.port}}"` |  |
| global.jmx.javaOpts[6] | string | `"-Djava.rmi.server.hostname=127.0.0.1"` |  |
| global.jmx.port | int | `1098` |  |
| global.jwt.EXTERNAL_ENC_SECRET_KEY_fromSecret | bool | `false` |  |
| global.jwt.EXTERNAL_ENC_SECRET_KEY_value | string | `""` |  |
| global.jwt.EXTERNAL_SIG_SECRET_KEY_fromSecret | bool | `false` |  |
| global.jwt.EXTERNAL_SIG_SECRET_KEY_value | string | `""` |  |
| global.jwt.SIG_SECRET_KEY_fromSecret | bool | `false` |  |
| global.jwt.SIG_SECRET_KEY_value | string | `""` |  |
| global.jwt.USERCTX_KEY_fromSecret | bool | `false` |  |
| global.jwt.USERCTX_KEY_value | string | `""` |  |
| global.jwt.enabled | bool | `false` |  |
| global.jwt.existingSecret | string | `""` |  |
| global.livenessProbe.enabled | bool | `false` |  |
| global.livenessProbe.failureThreshold | int | `3` |  |
| global.livenessProbe.initialDelaySeconds | int | `90` |  |
| global.livenessProbe.path | string | `"/actuator/health/liveness"` |  |
| global.livenessProbe.periodSeconds | int | `15` |  |
| global.livenessProbe.port | string | `"http"` |  |
| global.livenessProbe.scheme | string | `"HTTP"` |  |
| global.livenessProbe.timeoutSeconds | int | `5` |  |
| global.nodeSelector | object | `{}` |  |
| global.persistence.storageClass | string | `""` |  |
| global.podDisruptionBudget | object | `{}` |  |
| global.podExtraAnnotations | object | `{}` |  |
| global.podExtraLabels | object | `{}` |  |
| global.podSecurityContext | object | `{}` |  |
| global.priorityClassName | string | `""` |  |
| global.rbac.create | bool | `true` |  |
| global.rbac.role.rules[0].apiGroups[0] | string | `""` |  |
| global.rbac.role.rules[0].resources[0] | string | `"configmaps"` |  |
| global.rbac.role.rules[0].resources[1] | string | `"pods"` |  |
| global.rbac.role.rules[0].resources[2] | string | `"services"` |  |
| global.rbac.role.rules[0].resources[3] | string | `"endpoints"` |  |
| global.rbac.role.rules[0].verbs[0] | string | `"get"` |  |
| global.rbac.role.rules[0].verbs[1] | string | `"list"` |  |
| global.rbac.role.rules[0].verbs[2] | string | `"watch"` |  |
| global.readinessProbe.enabled | bool | `false` |  |
| global.readinessProbe.failureThreshold | int | `3` |  |
| global.readinessProbe.initialDelaySeconds | int | `90` |  |
| global.readinessProbe.path | string | `"/actuator/health/readiness"` |  |
| global.readinessProbe.periodSeconds | int | `15` |  |
| global.readinessProbe.port | string | `"http"` |  |
| global.readinessProbe.scheme | string | `"HTTP"` |  |
| global.readinessProbe.timeoutSeconds | int | `5` |  |
| global.registry.checkEnabled | bool | `false` |  |
| global.registry.checkType | string | `"curl"` |  |
| global.registry.enabled | bool | `false` |  |
| global.registry.envVarNameDefaultZone | string | `"eureka.client.serviceUrl.defaultZone"` |  |
| global.registry.envVarNamePreferIpAddress | string | `"EUREKA_INSTANCE_PREFERIPADDRESS"` |  |
| global.registry.host | string | `"registry"` |  |
| global.registry.path | string | `"/eureka/"` |  |
| global.registry.port | int | `8080` |  |
| global.registry.preferIpAddress | bool | `true` |  |
| global.registry.protocol | string | `"http"` |  |
| global.replicaCount | int | `1` |  |
| global.service.additionalPorts | list | `[]` |  |
| global.service.enabled | bool | `false` |  |
| global.service.nameOverride | string | `""` |  |
| global.service.port | int | `8080` |  |
| global.service.portName | string | `"http"` |  |
| global.service.targetPort | string | `"http"` |  |
| global.service.type | string | `"ClusterIP"` |  |
| global.serviceAccount.create | bool | `false` |  |
| global.serviceAccount.name | string | `""` |  |
| global.startupProbe.enabled | bool | `false` |  |
| global.startupProbe.failureThreshold | int | `40` |  |
| global.startupProbe.initialDelaySeconds | int | `30` |  |
| global.startupProbe.path | string | `"/actuator/health/liveness"` |  |
| global.startupProbe.periodSeconds | int | `15` |  |
| global.startupProbe.port | string | `"http"` |  |
| global.startupProbe.scheme | string | `"HTTP"` |  |
| global.startupProbe.timeoutSeconds | int | `5` |  |
| global.strategy | object | `{}` |  |
| global.volumeMounts | list | `[]` |  |
| global.volumes | list | `[]` |  |
| hostAliases | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].customPaths | list | `[]` |  |
| ingress.hosts[0].host | string | `"backbase.local"` |  |
| ingress.hosts[0].paths | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| initContainers | list | `[]` |  |
| javaOpts.extra | list | `[]` |  |
| jmx | object | `{}` |  |
| jwt | object | `{}` |  |
| livenessProbe | object | `{}` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.existingClaim | string | `""` |  |
| persistence.mountPath | string | `"/data"` |  |
| persistence.mountSubPath | string | `""` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podExtraAnnotations | object | `{}` |  |
| podExtraLabels | object | `{}` |  |
| priorityClassName | string | `""` |  |
| rbac.create | string | `nil` |  |
| rbac.role.rules | list | `[]` |  |
| readinessProbe | object | `{}` |  |
| registry | object | `{}` |  |
| replicaCount | int | `1` |  |
| securityContext | object | `{}` |  |
| service | object | `{}` |  |
| serviceAccount.create | string | `nil` |  |
| serviceAccount.name | string | `""` |  |
| startupProbe | object | `{}` |  |
| strategy | object | `{}` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
