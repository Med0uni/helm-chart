{{/* vim: set filetype=mustache: */}}
{{/*
Docker image tag
*/}}
{{- define "backbase-app.image-tag" -}}
{{- if .Values.app.image.tagFrom }}
{{- if hasKey .Values.global .Values.app.image.tagFrom }}
{{- printf "%s" (index .Values.global .Values.app.image.tagFrom) -}}
{{- else }}
{{- fail "Specified .Values.global key name for docker image tag does not exist!" -}}
{{- end -}}
{{- else -}}
{{- $imageSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.app.image) (mergeOverwrite (dict) .Values.app.image) -}}
{{- printf "%s" (default "latest" $imageSettings.tag) -}}
{{- end -}}
{{- end -}}

{{/*
Docker image reference
*/}}
{{- define "backbase-app.image-ref" -}}
{{- $imageSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.app.image) (mergeOverwrite (dict) .Values.app.image) -}}
{{- $appImageRepository := default "backbase/application" .Values.app.image.repository -}}
{{- if $imageSettings.registry -}}
{{- printf "%s/%s:%s" $imageSettings.registry $appImageRepository ( include "backbase-app.image-tag" . ) -}}
{{- else -}}
{{- printf "%s:%s" $appImageRepository ( include "backbase-app.image-tag" . ) -}}
{{- end -}}
{{- end -}}

{{- define "backbase-app.image-pullpolicy" -}}
{{- $imageSettings := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.app.image) (mergeOverwrite (dict) .Values.app.image) -}}
{{- printf "%s" $imageSettings.pullPolicy -}}
{{- end -}}

{{/*
Kubernetes PriorityClass Name
*/}}
{{- define "backbase-app.priority-class-name" -}}
{{ printf "%s" ( .Values.priorityClassName | default .Values.global.priorityClassName ) }}
{{- end -}}

{{/*
Kubernetes ReplicaCount
*/}}
{{- define "backbase-app.replica-count" -}}
{{ printf "%d" (int ( .Values.replicaCount | default .Values.global.replicaCount )) }}
{{- end -}}

{{/*
Kubernetes Deployment Strategy
*/}}
{{- define "backbase-app.strategy" -}}
{{- $strategy := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.strategy) (mergeOverwrite (dict) .Values.strategy) -}}
{{- if $strategy -}}
{{- toYaml $strategy -}}
{{- else if eq .Values.replicaCount 1.0 -}}
type: RollingUpdate
rollingUpdate:
  maxUnavailable: 0
{{- end -}}
{{- end -}}

{{/*
Kubernetes nodeSelector
*/}}
{{- define "backbase-app.nodeselector" -}}
{{- $nodeSelector := mergeOverwrite (dict) (mergeOverwrite (dict) .Values.global.nodeSelector) (mergeOverwrite (dict) .Values.nodeSelector) -}}
{{- with $nodeSelector }}
{{- toYaml . }}
{{- end }}
{{- end -}}

{{/*
Kubernetes Storage Class
*/}}
{{- define "backbase-app.persistence.storage-class" -}}
{{ printf "%s" ( .Values.persistence.storageClass | default .Values.global.persistence.storageClass ) }}
{{- end -}}

{{/*
Kubernetes resources
*/}}
{{- define "backbase-app.kubernetes-resources" -}}
requests:
  cpu: {{ .cpu.minShares }}m
  memory: {{ .memory.ram }}Mi
limits:
  cpu: {{ .cpu.maxShares }}m
  memory: {{ add .memory.ram .memory.containerReserve }}Mi
{{- end -}}
