minikube delete
minikube config unset vm-driver

# Detect the platform (similar to $OSTYPE)
OS="`uname`"

case $OS in
	"Linux")
		minikube start
		sed -i -e "s/xxxx-xxxx/172.17.0.10-172.17.0.15/g" srcs/configmap.yml
	;;
	"Darwin")
		minikube start --driver=virtualbox
		sed -i -e "s/xxxx-xxxx/192.168.99.110-192.168.99.115/g" srcs/configmap.yml
	;;
	*) ;;
esac

#minikube start --driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000

#IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)

#IP=$(minikube ip)
#IP=192.168.99.110

eval $(minikube docker-env)

#metallb + configmap
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
kubectl create -f srcs/configmap.yml

#builds
docker build -t mysql_alpine srcs/mysql
kubectl apply -f srcs/k8s/mysql.yaml
docker build -t nginx_alpine srcs/nginx
docker build -t phpmyadmin_alpine srcs/phpmyadmin
docker build -t wordpress_alpine srcs/wordpress

#docker build -t nginx srcs/my_nginx
#docker build -t ftps --build-arg IP=${IP} srcs/ftps
docker build -t influxdb srcs/influxdb
docker build -t grafana srcs/grafana

#minikube dashboard &

sleep 12s
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/mysql/srcs/wordpress.sql

#deploys
kubectl apply -f srcs/k8s/nginx.yaml
kubectl apply -f srcs/k8s/wordpress.yaml
kubectl apply -f srcs/k8s/phpmyadmin.yaml
kubectl apply -f srcs/k8s/influxdb.yaml
kubectl apply -f srcs/k8s/grafana.yaml


#kubectl apply -f srcs/k8s/my_nginx.yaml
#kubectl apply -f srcs/k8s/ftps.yaml

