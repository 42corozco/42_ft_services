# start minikube + addons + change docker enviroment to miniukbe docker

#minikube start

#printf '\e[1;34m%-6s\e[m' "\ninstalling metallb... \n\n"

#printf "installing metallb... \n\n"

#kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
#kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml

printf "\n building images... \n\n"

eval $(minikube docker-env)

IP=$(minikube ip)
#IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)

docker build -t nginx srcs/nginx
docker build -t ftps --build-arg IP=${IP} srcs/ftps
docker build -t influxdb srcs/influxdb
docker build -t grafana srcs/grafana

printf "\n running kubernetes cluster... \n\n"

#kubectl apply -f srcs/nginx.yaml

kubectl delete -f srcs/nginx/nginx.yaml
kubectl create -f srcs/nginx/nginx.yaml
kubectl delete -f srcs/ftps/ftps.yaml
kubectl create -f srcs/ftps/ftps.yaml
kubectl delete -f srcs/influxdb/influxdb.yaml
kubectl create -f srcs/influxdb/influxdb.yaml
kubectl delete -f srcs/grafana/grafana.yaml
kubectl create -f srcs/grafana/grafana.yaml

printf "\nopening dashboard... \n\n"

minikube dashboard &
