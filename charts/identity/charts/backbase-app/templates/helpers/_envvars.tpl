{{/*
JWT specific environment variables
*/}}
{{- define "backbase-app.jwt.env-vars" -}}
{{- $jwtSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.jwt) (mergeOverwrite (dict) .Values.jwt) -}}
{{- if $jwtSettings.enabled -}}
{{- if or $jwtSettings.SIG_SECRET_KEY_value $jwtSettings.SIG_SECRET_KEY_fromSecret -}}
- name: SIG_SECRET_KEY
{{- if $jwtSettings.SIG_SECRET_KEY_fromSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ required "A valid jwt.existingSecret entry required!" $jwtSettings.existingSecret }}
      key: jwt-internal-secretkey
{{- else }}
  value: {{ $jwtSettings.SIG_SECRET_KEY_value }}
{{- end -}}
{{- end -}}
{{- if or $jwtSettings.EXTERNAL_SIG_SECRET_KEY_value $jwtSettings.EXTERNAL_SIG_SECRET_KEY_fromSecret }}
- name: EXTERNAL_SIG_SECRET_KEY
{{- if $jwtSettings.EXTERNAL_SIG_SECRET_KEY_fromSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ required "A valid jwt.existingSecret entry required!" $jwtSettings.existingSecret }}
      key: jwt-external-secretkey
{{- else }}
  value: {{ $jwtSettings.EXTERNAL_SIG_SECRET_KEY_value }}
{{- end -}}
{{- end -}}
{{- if or $jwtSettings.EXTERNAL_ENC_SECRET_KEY_value $jwtSettings.EXTERNAL_ENC_SECRET_KEY_fromSecret }}
- name: EXTERNAL_ENC_SECRET_KEY
{{- if $jwtSettings.EXTERNAL_ENC_SECRET_KEY_fromSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ required "A valid jwt.existingSecret entry required!" $jwtSettings.existingSecret }}
      key: jwt-external-enc-secretkey
{{- else }}
  value: {{ $jwtSettings.EXTERNAL_ENC_SECRET_KEY_value }}
{{- end -}}
{{- end -}}
{{- if or $jwtSettings.USERCTX_KEY_value $jwtSettings.USERCTX_KEY_fromSecret }}
- name: USERCTX_KEY
{{- if $jwtSettings.USERCTX_KEY_fromSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ required "A valid jwt.existingSecret entry required!" $jwtSettings.existingSecret  }}
      key: userctx-key
{{- else }}
  value: {{ $jwtSettings.USERCTX_KEY_value }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Registry/Eureka specific environment variables
*/}}
{{- define "backbase-app.registry.env-vars" -}}
{{- $registrySettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.registry) (mergeOverwrite (dict) .Values.registry) -}}
{{- if $registrySettings.enabled -}}
- name: "{{ $registrySettings.envVarNameDefaultZone }}"
  value: "{{ $registrySettings.protocol }}://{{ $registrySettings.host }}:{{ $registrySettings.port }}{{ $registrySettings.path }}"
{{- if $registrySettings.preferIpAddress }}
- name: "{{ $registrySettings.envVarNamePreferIpAddress }}"
  value: "true"
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Activemq URL Template
*/}}
{{- define "backbase-app.activemq.url" -}}
{{- $fakeRootContext := $ -}}
{{- $activemqSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.activemq) (mergeOverwrite (dict) .Values.activemq) -}}
{{- $_ := set $fakeRootContext "activemq" $activemqSettings -}}
{{- $activemqUrlTemplate := "" -}}
{{- if $activemqSettings.urlTemplate -}}
{{- $activemqUrlTemplate = $activemqSettings.urlTemplate }}
{{- else }}
{{- $activemqUrlTemplate = "tcp://{{.activemq.host}}:{{.activemq.port}}" -}}
{{- end -}}
{{- printf "%s" (tpl $activemqUrlTemplate $fakeRootContext) -}}
{{- end -}}

{{/*
ActiveMQ specific environment variables
*/}}
{{- define "backbase-app.activemq.env-vars" -}}
{{- $activemqSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.activemq) (mergeOverwrite (dict) .Values.activemq) -}}
{{- $activemqEnvVarsMap := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.activemqEnvVarsMap) (mergeOverwrite (dict) .Values.activemqEnvVarsMap) -}}
{{- if $activemqSettings.enabled -}}
- name: {{ $activemqEnvVarsMap.URL }}
  value: {{ include "backbase-app.activemq.url" . | quote }}
- name: {{ $activemqEnvVarsMap.USERNAME }}
  value: {{ $activemqSettings.username | quote }}
- name: {{ $activemqEnvVarsMap.PASSWORD }}
{{- if $activemqSettings.existingSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ $activemqSettings.existingSecret }}
      key: {{ $activemqSettings.existingSecretKey }}
{{- else }}
  value: {{ required "A valid activemq.password entry required!" $activemqSettings.password | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Database URL Template
*/}}
{{- define "backbase-app.database.url" -}}
{{- $fakeRootContext := $ -}}
{{- $databaseSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.database) (mergeOverwrite (dict) .Values.database) -}}
{{- $_ := set $fakeRootContext "database" $databaseSettings -}}
{{- $databaseUrlTemplate := "" -}}
{{- if $databaseSettings.urlTemplate -}}
{{- $databaseUrlTemplate = $databaseSettings.urlTemplate }}
{{- else }}
{{- if eq $databaseSettings.type "mysql" }}
{{- $databaseUrlTemplate = "jdbc:mysql://{{.database.host}}:{{.database.port}}/{{.database.sid}}" -}}
{{- else if eq $databaseSettings.type "mariadb" }}
{{- $databaseUrlTemplate = "jdbc:mariadb://{{.database.host}}:{{.database.port}}/{{.database.sid}}" -}}
{{- else if eq $databaseSettings.type "oracle" }}
{{- $databaseUrlTemplate = "jdbc:oracle:thin:@{{.database.host}}:{{.database.port}}/{{.database.sid}}" -}}
{{- else if eq $databaseSettings.type "mssql" }}
{{- $databaseUrlTemplate = "jdbc:sqlserver://{{.database.host}}:{{.database.port}};databaseName={{.database.sid}}" -}}
{{- else -}}
{{- fail "Unsupported database type!" -}}
{{- end -}}
{{- end -}}
{{- printf "%s" (tpl $databaseUrlTemplate $fakeRootContext) -}}
{{- end -}}

{{/*
Database Driver Class Name
*/}}
{{- define "backbase-app.database.driver-class-name" -}}
{{- $databaseType := coalesce .Values.database.type .Values.global.database.type -}}
{{- if eq $databaseType "mysql" -}}
{{- printf "%s" "com.mysql.jdbc.Driver" -}}
{{- else if eq $databaseType "mariadb" -}}
{{- printf "%s" "org.mariadb.jdbc.Driver" -}}
{{- else if eq $databaseType "oracle" -}}
{{- printf "%s" "oracle.jdbc.driver.OracleDriver" -}}
{{- else if eq $databaseType "mssql" -}}
{{- printf "%s" "com.microsoft.sqlserver.jdbc.SQLServerDriver" -}}
{{- else -}}
{{ fail "Unsupported database type!" }}
{{- end -}}
{{- end -}}

{{/*
Database specific environment variables
*/}}
{{- define "backbase-app.database.env-vars" -}}
{{- $databaseEnabled := coalesce .Values.database.enabled .Values.global.database.enabled false -}}
{{- if $databaseEnabled -}}
{{- $databaseSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.database) (mergeOverwrite (dict) .Values.database) -}}
{{- $databaseEnvVarsMap := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.databaseEnvVarsMap) (mergeOverwrite (dict) .Values.databaseEnvVarsMap) -}}
- name: {{ $databaseEnvVarsMap.URL }}
  value: {{ include "backbase-app.database.url" . | quote }}
- name: {{ $databaseEnvVarsMap.DRIVER_CLASS_NAME }}
  value: {{ include "backbase-app.database.driver-class-name" . | quote }}
- name: {{ $databaseEnvVarsMap.USERNAME }}
  value: {{ $databaseSettings.username | quote }}
- name: {{ $databaseEnvVarsMap.PASSWORD }}
{{- if $databaseSettings.existingSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ $databaseSettings.existingSecret }}
      key: {{ $databaseSettings.existingSecretKey }}
{{- else }}
  value: {{ required "A valid database.password entry required!" $databaseSettings.password | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Custom environment variables
*/}}
{{- define "backbase-app.env-vars" -}}
{{- $envVars := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.env) (mergeOverwrite (dict) .Values.env) -}}
{{- range $envVarName, $envVarValue := $envVars }}
{{- if typeIs "string" $envVarValue }}
- name: {{ $envVarName | quote }}
  value: {{ tpl $envVarValue $ | quote }}
{{- else if typeIs "map[string]interface {}" $envVarValue }}
- name: {{ $envVarName | quote }}
{{- tpl ( toYaml $envVarValue ) $ | nindent 2 }}
{{- end -}}
{{- end -}}
{{- end -}}
