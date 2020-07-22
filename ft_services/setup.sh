minikube delete

minikube config unset vm-driver
minikube start --driver=virtualbox
eval $(minikube docker-env)

#metallb + configmap
Kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
kubectl create -f srcs/configmap.yml


#builds
docker build -t mysql_alpine srcs/mysql
kubectl apply -f srcs/k8s/mysql.yaml
docker build -t nginx_alpine srcs/nginx
docker build -t mysql_alpine srcs/mysql
docker build -t phpmyadmin_alpine srcs/phpmyadmin
docker build -t wordpress_alpine srcs/wordpress

#deploys
kubectl apply -f srcs/k8s/nginx.yaml

sleep 20s
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql -u root -e 'CREATE DATABASE wordpress;' > /dev/null
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/mysql/srcs/wordpress.sql


kubectl apply -f srcs/k8s/wordpress.yaml
kubectl apply -f srcs/k8s/phpmyadmin.yaml

