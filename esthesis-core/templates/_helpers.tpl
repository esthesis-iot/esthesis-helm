{{/* Default probes configuration */}}
{{- define "pod.probes" }}
livenessProbe:
  httpGet:
    path: /q/health/live
    port: 8080
  failureThreshold: 1
  periodSeconds: 15
startupProbe:
  httpGet:
    path: /q/health/started
    port: 8080
  initialDelaySeconds: 10
  failureThreshold: 30
  periodSeconds: 10
{{- end }}

{{/* API Service template */}}
{{- define "service.api.template" }}
apiVersion: v1
kind: Service
metadata:
  name: {{ .serviceName }}-service
spec:
  selector:
    app: {{ .serviceName }}
  ports:
    - port: 8080
{{- end }}

{{/* API APISIX route template */}}
{{- define "route.api.template" }}
apiVersion: apisix.apache.org/v2
kind: ApisixRoute
metadata:
  name: {{ .servicePath }}-routes
spec:
  http:
    - name: {{ .servicePath }}-route
      match:
        paths:
          - /api/{{ .servicePath }}
          - /api/{{ .servicePath }}/*
      {{ if .devMode }}
      upstreams:
        - name: {{ .serviceName}}-upstream
      {{ else }}
      backends:
        - serviceName: {{ .serviceName }}
          servicePort: 8080
      {{ end }}
      plugins:
        - name: proxy-rewrite
          enable: true
          config:
            regex_uri:
              - "/api/{{ .servicePath }}/(.*)"
              - "/api/$1"
        {{ if .serviceOidc }}
        - name: openid-connect
          enable: true
          config:
            client_id: "esthesis"
            client_secret: ""
            discovery: {{ .Values.oidcDiscoveryUrlCluster | quote}}
            scope: "openid profile"
            use_jwks: true
            bearer_only: true
            realm: "esthesis"
            redirect_uri: "/api/{{ .servicePath }}/callback"
            set_access_token_header: false
            set_id_token_header: false
            set_userinfo_header:  false
        {{ end }}
{{- end }}

{{/* API Deployment template */}}
{{- define "deployment.api.template" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .podName }}-deployment
spec:
  selector:
    matchLabels:
      app: {{ .podName }}
  replicas: 1
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: {{ .podName }}
    spec:
      {{- if .serviceAccount }}
      serviceAccountName: {{ .serviceAccount }}
      {{- end }}
      containers:
        - name: {{ .podName }}
          {{- if .registry }}
          image: {{ .registry }}/esthesisiot/{{ .podName }}: 3.0.1
          {{- else }}
          image: esthesisiot/{{ .podName }}: 3.0.1
          {{- end }}
          imagePullPolicy: Always
          resources:
            requests:
              cpu: "0.1"
              memory: "128M"
            limits:
              cpu: {{ .podMaxCpu | quote }}
              memory: {{ .podMaxMemory | quote }}
          ports:
            - containerPort: 8080
          {{- if .podProbes }}
          livenessProbe:
            httpGet:
              path: /q/health/live
              port: 8080
            failureThreshold: 1
            periodSeconds: 15
          startupProbe:
            httpGet:
              path: /q/health/started
              port: 8080
            initialDelaySeconds: 10
            failureThreshold: 30
            periodSeconds: 10
          {{- end }}
          env:
            - name: "TZ"
              value: {{ .timezone | quote}}
            {{- if .extraEnvVars }}
            {{- range $k, $v := .extraEnvVars }}
            - name: {{ $k }}
              value: {{ $v }}
            {{- end }}
            {{- end }}
            {{- if .podMongoDb }}
            - name: QUARKUS_MONGODB_CONNECTION_STRING
              value: {{ .Values.mongoDbUrlCluster }}
            - name: QUARKUS_MONGODB_DATABASE
              value: {{ .Values.mongoDbDatabase }}
            - name: QUARKUS_MONGODB_CREDENTIALS_USERNAME
              value: {{ .Values.mongoDbUsername }}
            - name: QUARKUS_MONGODB_CREDENTIALS_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: esthesis-core-secret
                  key: mongoDbPassword
            {{- end }}
            {{- if .podOidcClient }}
            - name: QUARKUS_OIDC_CLIENT_AUTH_SERVER_URL
              value: {{ .Values.oidcAuthorityUrlCluster | quote}}
            - name: QUARKUS_OIDC_CLIENT_GRANT_OPTION_PASSWORD_USERNAME
              value: {{ .Values.esthesisSystemUsername | quote }}
            - name: QUARKUS_OIDC_CLIENT_GRANT_OPTION_PASSWORD_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: esthesis-core-secret
                  key: esthesisSystemPassword
            {{- end }}
            {{- if .podJwtVerifier }}
            - name: MP_JWT_VERIFY_PUBLICKEY_LOCATION
              value: {{ .Values.oidcJwtVerifyLocationCluster | quote}}
            {{- end }}
            {{- if .podKafka }}
            - name: KAFKA_BOOTSTRAP_SERVERS
              value: {{ .Values.kafkaBootstrapServers | quote }}
            {{- end }}
            {{- if .podRedis }}
            - name: QUARKUS_REDIS_HOSTS
              value: {{ .Values.redisHosts | quote}}
            {{- end }}
            {{- if .podCamunda }}
            - name: QUARKUS_ZEEBE_CLIENT_BROKER_GATEWAY_ADDRESS
              value: {{ .Values.camundaGatewayUrlCluster | quote}}
            {{- end }}
            {{- if .podLogging }}
            - name: QUARKUS_REST_CLIENT_LOGGING
              value: "request-response"
            - name: QUARKUS_REST_CLIENT_BODY_LIMIT
              value: "32768"
            - name: QUARKUS_LOG_MIN_LEVEL
              value: "TRACE"
            - name: QUARKUS_LOG_LEVEL
              value: {{ .Values.quarkus.log.level | quote}}
            - name: QUARKUS_LOG_CATEGORY_ESTHESIS
              value: {{ .Values.quarkus.log.category.esthesis.level | quote}}
            - name: QUARKUS_LOG_CATEGORY_ORG_JBOSS_RESTEASY_REACTIVE
              value: {{ .Values.quarkus.log.category.esthesis.level | quote}}
            - name: QUARKUS_LOG_CATEGORY_IO_QUARKUS_MONGODB_PANACHE_COMMON_RUNTIME
              value: {{ .Values.quarkus.log.category.esthesis.level | quote}}
            - name: QUARKUS_LOG_CATEGORY_ORG_MONGODB
              value: {{ .Values.quarkus.log.category.esthesis.level | quote}}
            - name: QUARKUS_LOG_CATEGORY_IO_QUARKUS_OIDC_TOKEN_PROPAGATION_REACTIVE
              value: {{ .Values.quarkus.log.category.esthesis.level | quote}}
            {{- end }}
{{- end }}

{{/* APISIX Upstream definition for development */}}
{{- define "upstream.dev.template" }}
apiVersion: apisix.apache.org/v2
kind: ApisixUpstream
metadata:
  name: {{ .serviceName }}-upstream
spec:
  externalNodes:
    - type: Domain
      name: {{ .devHost }}
      port: {{ .servicePort }}
{{- end}}
