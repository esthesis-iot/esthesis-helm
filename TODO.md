Modify the entry on row 2 in `esthesis-core/templates/srv-public-access/deployment.yaml`

```yaml
{{ $redirectUrl := print "http://" .Values.esthesisHostname "/callback" }}
```
to

```yaml
{{ $redirectUrl := print "https://" .Values.esthesisHostname "/callback" }}
```