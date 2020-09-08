DOCKERPORT=8080
HOSTPORT=8080
VERSION=1.0
CONTAINER=jannetta/autoprognosis
NAME=autoprognosis
DOCKERFILE=Dockerfile


echo:
	echo $(DOCKERFILE)
build:
	zip -r autoprognosis.zip autoprognosis util init
	docker build --force-rm -f $(DOCKERFILE) -t $(CONTAINER):$(VERSION) .

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
