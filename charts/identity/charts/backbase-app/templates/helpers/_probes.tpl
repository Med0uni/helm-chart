{{/*
Liveness probe main container
*/}}
{{- define "backbase-app.liveness-probe" -}}
{{- $livenessProbe := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.livenessProbe) (mergeOverwrite (dict) .Values.livenessProbe) -}}
{{- include "backbase-app.liveness-probe-generic" $livenessProbe -}}
{{- end -}}

{{/*
Readiness probe main container
*/}}
{{- define "backbase-app.readiness-probe" -}}
{{- $readinessProbe := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.readinessProbe) (mergeOverwrite (dict) .Values.readinessProbe) -}}
{{- include "backbase-app.readiness-probe-generic" $readinessProbe -}}
{{- end -}}

{{/*
Liveness probe generic
*/}}
{{- define "backbase-app.liveness-probe-generic" -}}
{{- if .enabled }}
livenessProbe:
  httpGet:
    path: {{ .path }}
    port: {{ .port }}
    scheme: {{ .scheme }}
  initialDelaySeconds: {{ .initialDelaySeconds }}
  failureThreshold: {{ .failureThreshold }}
  periodSeconds: {{ .periodSeconds }}
  timeoutSeconds: {{ .timeoutSeconds }}
{{- end -}}
{{- end -}}

{{/*
Readiness probe generic
*/}}
{{- define "backbase-app.readiness-probe-generic" -}}
{{- if .enabled }}
readinessProbe:
  httpGet:
    path: {{ .path }}
    port: {{ .port }}
    scheme: {{ .scheme }}
  initialDelaySeconds: {{ .initialDelaySeconds }}
  failureThreshold: {{ .failureThreshold }}
  periodSeconds: {{ .periodSeconds }}
  timeoutSeconds: {{ .timeoutSeconds }}
{{- end -}}
{{- end -}}
