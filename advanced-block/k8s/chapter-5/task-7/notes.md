### ConfigMaps and Secrets from file
kubectl create configmap cm1 --from-file=file.txt 
kubectl create secret secret1 --from-file=secret-file.txt 