### Проброс порта minikube, kubernetes
```yaml
### Манифест для пода ###
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
    - name: nginx
      image: nginx
      ports:
        - containerPort: 80
```
```yaml
### Использование Cluster IP Service + kubectl port-forward ###
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```
```bash
kubectl port-forward pod/nginx-pod 8080:80
```