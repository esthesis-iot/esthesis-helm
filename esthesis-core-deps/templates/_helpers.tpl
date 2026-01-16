{{/* Return the base pg name (fullnameOverride or Release.Name) */}}
{{- define "pg.name" -}}
{{- $pg := (get .Values "pg_db") | default dict -}}
{{- $name := ($pg.fullnameOverride | default .Release.Name) | default "" -}}
{{- $name -}}
{{- end -}}

{{/* Return the pg superuser secret name */}}
{{- define "pg.superuserSecretName" -}}
{{- $base := include "pg.name" . -}}
{{- if $base -}}
{{- printf "%s-superuser" $base -}}
{{- else -}}
{{- "" -}}
{{- end -}}
{{- end -}}

{{/* Return the pg hostname with -pooler-rw suffix */}}
{{- define "pg.hostname" -}}
{{- $base := include "pg.name" . -}}
{{- if $base -}}
{{- printf "%s-pooler-rw" $base -}}
{{- else -}}
{{- "" -}}
{{- end -}}
{{- end -}}

