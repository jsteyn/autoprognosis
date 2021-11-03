DOCKERPORT=8080
HOSTPORT=8088
VERSION=2.0
CONTAINER=jannetta/autoprognosis
NAME=autoprognosis
VOLUME=mlflow
HOSTMOUNTPOINT=/home/jannetta/DOCKERVOLUMES/MLFlow/autoprognosis/
DOCKERMOUNTPOINT=/autoprognosis
DOCKERFILE=Dockerfile


echo:
	echo $(DOCKERFILE)
build:
	zip -r autoprognosis.zip autoprognosis util init
	docker build --force-rm -f $(DOCKERFILE) -t $(CONTAINER):$(VERSION) .

run_mount:
	docker run -d --rm --name $(NAME) -p $(HOSTPORT):$(DOCKERPORT) -v $(HOSTMOUNTPOINT):$(DOCKERMOUNTPOINT) $(CONTAINER):$(VERSION)

run:
	docker run -d --rm --name $(NAME) -p $(HOSTPORT):$(DOCKERPORT) $(CONTAINER):$(VERSION)

stop:
	docker stop $(NAME)

start:
	docker start $(NAME)

exec:
	docker exec -ti $(NAME) bash

tar:
	docker save -o $(NAME)$(VERSION).tar $(CONTAINER):$(VERSION)

install:
	docker load -i $(NAME)$(VERSION).tar

push:
	git push --atomic origin master $(VERSION)

network:
	docker network create --gateway 172.16.1.1 --subnet 172.16.1.0/24 mvc_network

remove:
	docker image rm $(CONTAINER):$(VERSION)
