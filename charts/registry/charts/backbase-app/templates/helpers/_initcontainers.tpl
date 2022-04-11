{{- define "backbase-app.init-container.check-curl" -}}
- name: {{ .serviceName }}-curl-check
  image: {{ .checkInitContainerImage }}
  imagePullPolicy: IfNotPresent
  command:
    - sh
    - -c
    - until curl --connect-timeout 5 {{ .protocol }}://{{ .host }}{{ if .port }}:{{ .port }}{{ end }}{{ .path | default "/" }}; do echo "Waiting for the {{ .host }}..."; sleep 5; done
{{- end -}}

{{- define "backbase-app.init-container.check-netcat" -}}
- name: {{ .serviceName }}-netcat-check
  image: {{ .checkInitContainerImage }}
  imagePullPolicy: IfNotPresent
  command:
    - sh
    - -c
    - until nc -w 5 {{ .host }} {{ .port }}; do echo "Waiting for the {{ .host }}..."; sleep 5; done
{{- end -}}

{{- define "backbase-app.init-container.check-nslookup" -}}
- name: {{ .serviceName }}-nslookup-check
  image: {{ .checkInitContainerImage }}
  imagePullPolicy: IfNotPresent
  command:
    - sh
    - -c
    - until nslookup {{ .host }}; do echo "Waiting for the {{ .host }}..."; sleep 5; done
{{- end -}}

{{- define "backbase-app.init-container.liquibase" -}}
- name: {{ .liquibaseSettings.serviceName }}
  image: {{ include "backbase-app.image-ref" . }}
  imagePullPolicy: {{ include "backbase-app.image-pullpolicy" . }}
  command: ['java']
  args: ['-cp', '/app/extras/*:/app/WEB-INF/classes:/app/WEB-INF/lib/*', {{ .liquibaseSettings.initMainClass }}]
  env:
    - name: SPRING_LIQUIBASE_ENABLED
      value: "true"
{{- $liquibaseCreds := coalesce .Values.liquibase.username .Values.global.liquibase.username false -}}
{{- if $liquibaseCreds -}}
    {{- include "backbase-app.init-liquibase.env-vars" . | nindent 4 }}
{{- else }}
    {{- include "backbase-app.database.env-vars" . | nindent 4 }}
{{- end -}}
{{- end -}}

{{- define "backbase-app.init-containers" -}}
{{- $fakeRootContext := $ -}}
{{- $registrySettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.registry) (mergeOverwrite (dict) .Values.registry) -}}
{{- $_ := set $registrySettings "serviceName" "registry" -}}
{{- $activemqSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.activemq) (mergeOverwrite (dict) .Values.activemq) -}}
{{- $_ := set $activemqSettings "serviceName" "activemq" -}}
{{- $databaseSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.database) (mergeOverwrite (dict) .Values.database) -}}
{{- $_ := set $databaseSettings "serviceName" "database" -}}
{{- $liquibaseSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.liquibase) (mergeOverwrite (dict) .Values.liquibase) (mergeOverwrite (dict) .Values.global.app.image) (mergeOverwrite (dict) .Values.app.image) -}}
{{- $_ := set $liquibaseSettings "serviceName" "init-liquibase" -}}
{{- $_ := set $fakeRootContext  "liquibaseSettings" $liquibaseSettings -}}
{{- if or .Values.global.initContainers .Values.initContainers $registrySettings.checkEnabled $activemqSettings.checkEnabled $databaseSettings.checkEnabled $liquibaseSettings.enabled -}}
initContainers:
{{- if .Values.global.initContainers -}}
{{ tpl (toYaml .Values.global.initContainers) . | nindent 2 }}
{{- end -}}
{{- if .Values.initContainers -}}
{{ tpl (toYaml .Values.initContainers) . | nindent 2 }}
{{- end -}}
{{- if and $registrySettings.enabled $registrySettings.checkEnabled -}}
{{- $checkTemplateName := printf "%s-%s" "backbase-app.init-container.check" $registrySettings.checkType -}}
{{ include $checkTemplateName $registrySettings | nindent 2 }}
{{- end -}}
{{- if and $activemqSettings.enabled $activemqSettings.checkEnabled -}}
{{- $checkTemplateName := printf "%s-%s" "backbase-app.init-container.check" $activemqSettings.checkType -}}
{{ include $checkTemplateName $activemqSettings | nindent 2 }}
{{- end -}}
{{- if and $databaseSettings.enabled $databaseSettings.checkEnabled -}}
{{- $checkTemplateName := printf "%s-%s" "backbase-app.init-container.check" $databaseSettings.checkType -}}
{{ include $checkTemplateName $databaseSettings | nindent 2}}
{{- end -}}
{{- if and $databaseSettings.enabled $fakeRootContext.liquibaseSettings.enabled -}}
{{- $checkTemplateName := printf "%s" "backbase-app.init-container.liquibase" -}}
{{ include $checkTemplateName $fakeRootContext | nindent 2}}
{{- end -}}
{{- end -}}
{{- end -}}
