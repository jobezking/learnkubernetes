# Docker File system
/var/lib/docker contains aufs, containers, image, volumes directories
docker volume create data_volume
docker run -v data_volume:/var/lib/mysql mysql
docker run -v data_volume2:/var/lib/mysql mysql
docker run --moount type=bind, source=data/mysql, target=/var/lib/mysql mysql