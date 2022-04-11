{{- define "backbase-app.init-container.check-curl" -}}
- name: {{ .serviceName }}-curl-check
  image: byrnedo/alpine-curl
  command:
    - sh
    - -c
    - until curl --connect-timeout 5 {{ .protocol }}://{{ .host }}{{ if .port }}:{{ .port }}{{ end }}{{ .path | default "/" }}; do echo "Waiting for the {{ .host }}..."; sleep 5; done
{{- end -}}

{{- define "backbase-app.init-container.check-netcat" -}}
- name: {{ .serviceName }}-netcat-check
  image: busybox
  command:
    - sh
    - -c
    - until nc -w 5 {{ .host }} {{ .port }}; do echo "Waiting for the {{ .host }}..."; sleep 5; done
{{- end -}}

{{- define "backbase-app.init-container.check-nslookup" -}}
- name: {{ .serviceName }}-nslookup-check
  image: busybox
  command:
    - sh
    - -c
    - until nslookup {{ .host }}; do echo "Waiting for the {{ .host }}..."; sleep 5; done
{{- end -}}

{{- define "backbase-app.init-containers" -}}
{{- $registrySettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.registry) (mergeOverwrite (dict) .Values.registry) -}}
{{- $_ := set $registrySettings "serviceName" "registry" -}}
{{- $activemqSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.activemq) (mergeOverwrite (dict) .Values.activemq) -}}
{{- $_ := set $activemqSettings "serviceName" "activemq" -}}
{{- $databaseSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.database) (mergeOverwrite (dict) .Values.database) -}}
{{- $_ := set $databaseSettings "serviceName" "database" -}}
{{- if or .Values.global.initContainers .Values.initContainers $registrySettings.checkEnabled $activemqSettings.checkEnabled $databaseSettings.checkEnabled -}}
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
{{- end -}}
{{- end -}}
