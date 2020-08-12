minikube delete
minikube config unset vm-driver

# Detect the platform (similar to $OSTYPE)
OS="`uname`"

case $OS in
	"Linux")
		minikube start
		sed -i "s/xxxx-xxxx/172.17.0.10-172.17.0.19/g" srcs/configmap.yml
		sed -i "s/zzzz-zzzz/172.17.0.20-172.17.0.20/g" srcs/configmap.yml
		sed -i "s/192.168.99.111:5050/172.17.0.20:5050/g" srcs/mysql/srcs/wordpress.sql
		sed -i "s/yyyy-yyyy/172.17.0.21-172.17.0.21/g" srcs/configmap.yml
		FTPSIP=172.17.0.21
	;;
	"Darwin")
		minikube start --driver=virtualbox
		sed -i '' "s/xxxx-xxxx/192.168.99.110-192.168.99.119/g" srcs/configmap.yml
		sed -i '' "s/zzzz-zzzz/192.168.99.120-192.168.99.120/g" srcs/configmap.yml
		sed -i '' "s/192.168.99.111:5050/192.168.99.120:5050/g" srcs/mysql/srcs/wordpress.sql
		sed -i '' "s/yyyy-yyyy/192.168.99.121-192.168.99.121/g" srcs/configmap.yml
		FTPSIP=192.168.99.121
	;;
	*) ;;
esac

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
docker build -t ftps --build-arg IP=${FTPSIP} srcs/ftps
docker build -t influxdb srcs/influxdb
docker build -t grafana srcs/grafana

kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/mysql/srcs/wordpress.sql

#deploys
kubectl apply -f srcs/k8s/nginx.yaml
kubectl apply -f srcs/k8s/wordpress.yaml
kubectl apply -f srcs/k8s/ftps.yaml
kubectl apply -f srcs/k8s/influxdb.yaml
kubectl apply -f srcs/k8s/grafana.yaml
kubectl apply -f srcs/k8s/phpmyadmin.yaml

echo "---------------------------------------------------"
echo "|            |     User       |      Password     |"
echo "|grafana     |admin           |admin1234          |"
echo "|phpmyadmin  |root            |root               |"
echo "|wordpress   |admin           |admin              |"
echo "|   ->       |   user1        |user1              |"
echo "|   ->       |   user2        |user2              |"
echo "|   ->       |   user3        |user3              |"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "|ssh nginx   |ssh -p 2222 admin@ url | pass: admin|"
echo "|ftps        |ftp url             21 |            |"
echo "|   ->       |   User:               | user       |"
echo "|   ->       |   Password:           | password   |"
echo "---------------------------------------------------"

#minikube dashboard &


