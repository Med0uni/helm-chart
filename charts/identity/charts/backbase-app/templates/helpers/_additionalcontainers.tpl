{{/*
Custom environment variables for additional containers
*/}}
{{- define "backbase-app.env-vars-additional-containers" -}}
{{- range $envVarName, $envVarValue := . }}
{{- if typeIs "string" $envVarValue }}
- name: {{ $envVarName | quote }}
  value: {{ $envVarValue | quote }}
{{- else if typeIs "map[string]interface {}" $envVarValue }}
- name: {{ $envVarName | quote }}
{{- toYaml $envVarValue | nindent 2 }}
{{- end -}}
{{- end -}}
{{- end -}}