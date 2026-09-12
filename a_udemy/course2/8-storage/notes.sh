# Docker File system
/var/lib/docker contains aufs, containers, image, volumes directories
docker volume create data_volume
docker run -v data_volume:/var/lib/mysql mysql
docker run -v data_volume2:/var/lib/mysql mysql
docker run --moount type=bind, source=data/mysql, target=/var/lib/mysql mysql
docker run -it --name mysql --mount src=ebs-vol,target=/var/lib/mysql mysql  # uses the AWS EBS driver to save container data to cloud

# Kubernetes volumes
# need to attach volumes to pods for data processed by pod to be preserved when pod is destroyed
# persistent volumes: cluster-wide storage. access modes are ReadOnlyMany, ReadWriteOnce, ReadWriteMany