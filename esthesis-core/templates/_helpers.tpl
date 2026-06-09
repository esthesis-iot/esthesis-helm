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
      {{- if .serviceAccountName }}
      serviceAccountName: {{ .serviceAccountName }}
      {{- end }}
      {{- if .imagePullSecret }}
      imagePullSecrets:
        - name: {{ .imagePullSecret }}
      {{- end }}
      containers:
        - name: {{ .podName }}
          {{- if .registry }}
          image: "{{ .registry }}/{{ .podName }}:{{ .Chart.Version }}"
          {{- else }}
          image: "esthesisiot/{{ .podName }}:{{ .Chart.Version }}"
          {{- end }}
          imagePullPolicy: Always
          resources:
            requests:
              cpu: {{ default "0.1" .podReqCpu | quote }}
              memory: {{ default "128M" .podReqMemory | quote }}
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
            failureThreshold: 2
            periodSeconds: 30
          startupProbe:
            httpGet:
              path: /q/health/started
              port: 8080
            initialDelaySeconds: 45
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
              value: {{ .Values.oidcClientAuthServerUrl | quote}}
            - name: QUARKUS_OIDC_CLIENT_GRANT_OPTIONS_PASSWORD_USERNAME
              value: {{ .Values.oidcClientGrantOptionsPasswordUsername | quote }}
            - name: QUARKUS_OIDC_CLIENT_GRANT_OPTIONS_PASSWORD_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: esthesis-core-secret
                  key: oidcClientGrantOptionsPasswordPassword
            - name: QUARKUS_OIDC_CLIENT_CLIENT_ID
              value: {{ .Values.oidcClientId | quote}}
            - name: QUARKUS_OIDC_CLIENT_GRANT_TYPE
              value: "password"
            - name: QUARKUS_OIDC_CLIENT_TLS_VERIFICATION
              value: {{ .Values.oidcTlsVerification | quote}}
            {{- end }}
            {{- if .podOidc }}
            - name: QUARKUS_OIDC_AUTH_SERVER_URL
              value: {{ .Values.oidcAuthServerUrl | quote}}
            - name: QUARKUS_OIDC_TLS_VERIFICATION
              value: {{ .Values.oidcTlsVerification | quote}}
            {{- end }}
            {{- if .podKafka }}
            - name: KAFKA_BOOTSTRAP_SERVERS
              value: {{ .Values.kafkaBootstrapServers | quote }}
            - name: KAFKA_SECURITY_PROTOCOL
              value: SASL_PLAINTEXT
            - name: KAFKA_SASL_MECHANISM
              value: SCRAM-SHA-512
            - name: KAFKA_SASL_JAAS_CONFIG
              value: org.apache.kafka.common.security.scram.ScramLoginModule required username={{ .Values.esthesisSystemUsername }} password={{ .Values.esthesisSystemPassword }};
            {{- end }}
            {{- if .podRedis }}
            - name: QUARKUS_REDIS_HOSTS
              value: {{ .Values.redisHosts | quote}}
            - name: QUARKUS_REDIS_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: esthesis-core-secret
                  key: esthesisSystemPassword
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
            {{- if .podChatbot }}
            - name: QUARKUS_LANGCHAIN4J_CHAT_MODEL_PROVIDER
              value: {{ .Values.chatbot.chatModel.provider | quote }}
            - name: QUARKUS_LANGCHAIN4J_EMBEDDING_MODEL_PROVIDER
              value: {{ .Values.chatbot.embeddingModel.provider | quote }}
            - name: QUARKUS_LANGCHAIN4J_EASY_RAG_PATH
              value: {{ .Values.chatbot.easyRag.path | quote }}
            - name: QUARKUS_LANGCHAIN4J_EASY_RAG_PATH_TYPE
              value: {{ .Values.chatbot.easyRag.pathType | quote }}

              {{- if eq .Values.chatbot.chatModel.provider "openai" }}
            - name: QUARKUS_LANGCHAIN4J_OPENAI_API_KEY
              value: {{ .Values.chatbot.openai.apiKey | quote }}
            - name: QUARKUS_LANGCHAIN4J_OPENAI_CHAT_MODEL_MODEL_NAME
              value: {{ .Values.chatbot.openai.chatModel.modelName | quote }}
            - name: QUARKUS_LANGCHAIN4J_OPENAI_CHAT_MODEL_TEMPERATURE
              value: "{{ .Values.chatbot.openai.chatModel.temperature }}"
              {{- end }}

              {{- if eq .Values.chatbot.chatModel.provider "ollama" }}
            - name: QUARKUS_LANGCHAIN4J_OLLAMA_BASE_URL
              value: {{ .Values.chatbot.ollama.baseUrl | quote }}
            - name: QUARKUS_LANGCHAIN4J_OLLAMA_CHAT_MODEL_MODEL_ID
              value: {{ .Values.chatbot.ollama.chatModel.modelId | quote }}
            - name: QUARKUS_LANGCHAIN4J_OLLAMA_CHAT_MODEL_TEMPERATURE
              value: "{{ .Values.chatbot.ollama.chatModel.temperature }}"
            - name: QUARKUS_LANGCHAIN4J_OLLAMA_EMBEDDING_MODEL_MODEL_ID
              value: {{ .Values.chatbot.ollama.embeddingModel.modelId | quote }}
            - name: QUARKUS_LANGCHAIN4J_OLLAMA_EMBEDDING_MODEL_TEMPERATURE
              value: "{{ .Values.chatbot.ollama.embeddingModel.temperature }}"
              {{- end }}
            {{- end }}
{{- end }}


{{- define "chatbotImage" -}}
{{- with .Values.chatbot.chatModel }}
{{- printf "esthesis-core-srv-chatbot-%s" .provider -}}
{{- end -}}
{{- end -}}
