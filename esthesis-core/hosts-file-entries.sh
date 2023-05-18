echo $(kubectl get service mongodb -o=jsonpath='{.status.loadBalancer.ingress[].ip}') mongodb.esthesis.localdev
