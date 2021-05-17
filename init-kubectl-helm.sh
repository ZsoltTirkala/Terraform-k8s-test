#Deploying the application
aws eks --region eu-west-2 update-kubeconfig --name terraform-eks-test
kubectl apply -f deployment/test-application.yaml

#Deploying prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install helm-prometheus prometheus-community/prometheus --values deployment/prometheus-values.yaml

#Deploying grafana
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install helm-grafana grafana/grafana --set adminUser=admin,adminPassword=admin --values deployment/grafana-values.yaml