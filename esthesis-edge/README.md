# esthesis-edge

![Version: 1.0.0-SNAPSHOT](https://img.shields.io/badge/Version-1.0.0--SNAPSHOT-informational?style=flat-square) ![AppVersion: 1.0.0-SNAPSHOT](https://img.shields.io/badge/AppVersion-1.0.0--SNAPSHOT-informational?style=flat-square)

**Homepage:** <https://esthes.is>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| European Dynamics SA | <esthesis@eurodyn.com> | <https://www.eurodyn.com> |

## Source Code

* <https://github.com/esthesis-iot>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | influxdb | 5.6.1 |
| oci://registry-1.docker.io/bitnamicharts | mariadb | 11.4.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| esthesis.edge.adminSecret | string | `"ca820829-328f-41e0-9207-ef42372f94c3"` | The secret used to access the admin API of esthesis EDGE. |
| esthesis.edge.core.keyAlgorithm | string | `"RSA"` | The algorithm used to generate keys for devices in esthesis CORE. |
| esthesis.edge.core.push.enabled | bool | `false` | Whether data is pushed to esthesis CORE. |
| esthesis.edge.core.push.topicPing | string | `"esthesis/ping"` | The topic used to send ping data to esthesis CORE. |
| esthesis.edge.core.push.topicTelemetry | string | `"esthesis/telemetry"` | The topic used to send telemetry data to esthesis CORE. |
| esthesis.edge.core.push.url | string | `"ssl://mosquitto.esthesis:8883"` | The URL of the esthesis CORE MQTT broker. |
| esthesis.edge.core.registration.enabled | bool | `false` | Whether device registration in esthesis CORE takes place when a new device is registered in esthesis EDGE. |
| esthesis.edge.core.registration.secret | string | `"esthesis-edge"` | The secret used to access the registration API of esthesis CORE. |
| esthesis.edge.core.registration.tags | list | `["edge"]` | The tags added to an esthesis EDGE devices registered in esthesis CORE. |
| esthesis.edge.ingress.certManagerClusterIssuer | string | `"letsencrypt-staging"` | The name of the cluster issuer used by cert-manager for the ingress resource. |
| esthesis.edge.ingress.certManagerIssuer | string | `nil` | The name of the issuer used by cert-manager for the ingress resource. |
| esthesis.edge.ingress.className | string | `nil` | The class name of the ingress controller. |
| esthesis.edge.ingress.enabled | bool | `true` | Whether an ingress resource is created for esthesis EDGE. |
| esthesis.edge.ingress.hostname | string | `"edge.k8s.home.nassosmichas.com"` | The hostname of the ingress resource. |
| esthesis.edge.local.enabled | bool | `true` | Whether the local InfluxDB database is updated with data fetched. |
| esthesis.edge.local.influxDb.bucket | string | `"esthesis-edge"` | The bucket used to store data in the local InfluxDB database. |
| esthesis.edge.local.influxDb.org | string | `"esthesis"` | The organisation used to store data in the local InfluxDB database. |
| esthesis.edge.local.influxDb.token | string | `"fVfC4PNVzPnO_qsYY4X3lsvYmqIZNFHE3kE6fI8hpZqR"` | The token used to access the local InfluxDB database. |
| esthesis.edge.local.influxDb.url | string | `"http://influxdb:8088"` | The URL of the local InfluxDB database. |
| esthesis.edge.modules.enedis.clientId | string | `"myclientid"` | The client ID used to access the Enedis API. |
| esthesis.edge.modules.enedis.clientSecret | string | `"myclientsecret"` | The client secret used to access the Enedis API. |
| esthesis.edge.modules.enedis.cron | string | `"0 0 6 * * ?"` | The cron expression used to schedule how often data is fetched from Enedis. |
| esthesis.edge.modules.enedis.enabled | bool | `false` | Whether the Enedis module is enabled. |
| esthesis.edge.modules.enedis.fetchTypes.dc.category | string | `"energy"` | The category name used to store Data Consumption data (used both in local InfluxDB database and in eLP). |
| esthesis.edge.modules.enedis.fetchTypes.dc.enabled | bool | `true` | Whether  Data Consumption data is fetched from Enedis. |
| esthesis.edge.modules.enedis.fetchTypes.dc.errorsThreshold | int | `3` | The number of errors after which the fetching of Data Consumption data is stopped. |
| esthesis.edge.modules.enedis.fetchTypes.dc.measurement | string | `"dc"` | The measurement name used to store Data Consumption data (used both in local InfluxDB database and in eLP). |
| esthesis.edge.modules.enedis.fetchTypes.dcmp.category | string | `"energy"` | The category name used to store Data Consumption Max Power data (used both in local InfluxDB database and in eLP). |
| esthesis.edge.modules.enedis.fetchTypes.dcmp.enabled | bool | `true` | Whether Data Consumption Max Power data is fetched from Enedis. |
| esthesis.edge.modules.enedis.fetchTypes.dcmp.errorsThreshold | int | `3` | The number of errors after which the fetching of Data Consumption Max Power data is stopped. |
| esthesis.edge.modules.enedis.fetchTypes.dcmp.measurement | string | `"dcmp"` | The measurement name used to store Data Consumption Max Power data (used both in local InfluxDB database and in eLP). |
| esthesis.edge.modules.enedis.fetchTypes.dp.category | string | `"energy"` | The category name used to store Data Production data (used both in local InfluxDB database and in eLP). |
| esthesis.edge.modules.enedis.fetchTypes.dp.enabled | bool | `true` | Whether Data Production data is fetched from Enedis. |
| esthesis.edge.modules.enedis.fetchTypes.dp.errorsThreshold | int | `3` | The number of errors after which the fetching of Data Production data is stopped. |
| esthesis.edge.modules.enedis.fetchTypes.dp.measurement | string | `"dp"` | The measurement name used to store Data Production data (used both in local InfluxDB database and in eLP). |
| esthesis.edge.modules.enedis.maxDevices | int | `1000` | The maximum number of devices that can be registered by the Enedis module. |
| esthesis.edge.modules.enedis.pastDaysInit | int | `7` | The number of days in the past for which data is fetched from Enedis when a new device is registered. |
| esthesis.edge.modules.enedis.selfRegistration.duration | string | `"P1Y"` | The duration for which the Enedis data access token is requested for (see Enedis API for details). |
| esthesis.edge.modules.enedis.selfRegistration.enabled | bool | `true` | Whether the self-registration page and functionality is enabled for the Enedis module. |
| esthesis.edge.modules.enedis.selfRegistration.page.error.message | string | `"An error occurred while connecting your account. Please try again later."` | The message of the error message displayed after an unsuccessful self-registration. |
| esthesis.edge.modules.enedis.selfRegistration.page.error.title | string | `"Error connecting account"` | The title of the error message displayed after an unsuccessful self-registration. |
| esthesis.edge.modules.enedis.selfRegistration.page.logo1Alt | string | `nil` | The alt text of the first logo being displayed on the self-registration page, if the welcome URL is empty. |
| esthesis.edge.modules.enedis.selfRegistration.page.logo1Url | string | `"https://getlogovector.com/wp-content/uploads/2019/08/enedis-logo-vector.png"` | The URL of the first logo being displayed on the self-registration page, if the welcome URL is empty. |
| esthesis.edge.modules.enedis.selfRegistration.page.logo2Alt | string | `nil` | The alt text of the second logo being displayed on the self-registration page, if the welcome URL is empty. |
| esthesis.edge.modules.enedis.selfRegistration.page.logo2Url | string | `nil` | The URL of the second logo being displayed on the self-registration page, if the welcome URL is empty. |
| esthesis.edge.modules.enedis.selfRegistration.page.registration.message | string | `"You will be redirected to Enedis, where you have to authenticate with your Enedis account, and authorise this application to retrieve your electricity consumption data. The authorisation will be valid for 1 year. Your data will be used by us to provide you with insights and recommendations on how to save energy."` | The message displayed on the self-registration page, if the welcome URL is empty. |
| esthesis.edge.modules.enedis.selfRegistration.page.registration.title | string | `"Connect your Enedis account"` | The title of the self-registration page, if the welcome URL is empty. |
| esthesis.edge.modules.enedis.selfRegistration.page.success.message | string | `"Your account was successfully connected, you may now close this window."` | The message of the success message displayed after a successful self-registration. |
| esthesis.edge.modules.enedis.selfRegistration.page.success.title | string | `"Account connected"` | The title of the success message displayed after a successful self-registration. |
| esthesis.edge.modules.enedis.selfRegistration.redirectUrl | string | `"http://localhost:8080"` | The URL to which Enedis is redirecting the user after accepting access to their data. |
| esthesis.edge.modules.enedis.selfRegistration.stateChecking | bool | `false` | Whether self-registration redirect from Enedis requires a valid state. |
| esthesis.edge.modules.enedis.selfRegistration.welcomeUrl | string | `nil` | The URL of the self-registration welcome page. If left empty, a default page is provided by the Enedis module. |
| esthesis.edge.purgeCron | string | `"0 0 0 * * ?"` | The cron expression used to schedule how often data is purged. |
| esthesis.edge.purgeQueuedMinutes | int | `10080` | The number of minutes after which data is purged from the queue, irrespective of its status. |
| esthesis.edge.purgeSuccessfulMinutes | int | `60` | The number of minutes after which data successfully stored in local database or esthesis CORE is purged from the queue. |
| esthesis.edge.service.port | int | `80` | The port of the service to be created for esthesis EDGE. |
| esthesis.edge.service.type | string | `"ClusterIP"` | The type of the service to be created for esthesis EDGE. |
| esthesis.edge.syncCron | string | `"0 0 * * * ?"` | The cron expression used to schedule how often new data is fetched. |
| global.esthesisRegistry | string | `nil` | A custom registry to fetch container images from, in the form of "registry/project", e.g. "192.168.50.211:5000/esthesis" |
| global.imagePullSecrets | string | `nil` | The secret used to pull images from the container registry. |
| global.storageClass | string | `nil` | The storage class used by the persistent volume claims. |
| global.timezone | string | `"Europe/Athens"` | The timezone used by the application. |
| influxdb.auth.admin.password | string | `"esthesis-system"` | The password of the InfluxDB admin user. |
| influxdb.auth.admin.token | string | `"fVfC4PNVzPnO_qsYY4X3lsvYmqIZNFHE3kE6fI8hpZqR"` | The token that will be created for InfluxDB. |
| influxdb.auth.admin.username | string | `"esthesis-system"` | The username of the InfluxDB admin user. |
| influxdb.auth.createUserToken | bool | `true` | Whether a user token will be created during deployment. |
| influxdb.auth.user.bucket | string | `"esthesisedge"` | The bucket name of esthesis EDGE in InfluxDB. |
| influxdb.auth.user.org | string | `"esthesis"` | The organisation name of the esthesis EDGE user for InfluxDB. |
| influxdb.auth.user.password | string | `"esthesis-admin"` | The password of the esthesis EDGE user for InfluxDB. |
| influxdb.auth.user.username | string | `"esthesis-admin"` | The username of the esthesis EDGE user for InfluxDB. |
| influxdb.enabled | bool | `true` | Whether InfluxDB will be installed. |
| influxdb.persistence.size | string | `"32Gi"` | The size of the persistent volume claim for InfluxDB. |
| mariadb.auth.database | string | `"esthesis-edge"` | The name of the database that will be created for esthesis EDGE. |
| mariadb.auth.password | string | `"esthesis-system"` | The password of the database user that will be created for esthesis EDGE. |
| mariadb.auth.rootPassword | string | `"esthesis-system"` | The password for the root MariaDB user. |
| mariadb.auth.username | string | `"esthesis-system"` | The username of the database user that will be created for esthesis EDGE. |
| mariadb.enabled | bool | `true` | Whether MariaDB will be installed. |
| quarkus.datasource.jdbc.url | string | `"jdbc:mariadb://edge-mariadb:3306/esthesis-edge"` | The JDBC URL of MariaDB used by esthesis EDGE. |
| quarkus.datasource.password | string | `"esthesis-system"` | The password of MariaDB used by esthesis EDGE. |
| quarkus.datasource.username | string | `"esthesis-system"` | The username of MariaDB used by esthesis EDGE. |
| quarkus.restClient.enedisClient | object | `{"url":"https://ext.prod-sandbox.api.enedis.fr"}` | The URL of the Enedis API. |
| quarkus.restClient.esthesisAgentServiceClient | object | `{"url":"http://esthesis-agent-service:8080"}` | The URL of the esthesis Agent Service. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
