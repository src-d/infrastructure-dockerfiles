VLAN ?= 2018
NAME ?= ipxe-$(VLAN).lkrn

build:
	docker build --build-arg VLAN=$(VLAN) -t ipxe-build .
	docker run -d --rm --name ipxe-build ipxe-build
	docker cp ipxe-build:/opt/ipxe/ipxe.lkrn $(NAME)
	docker kill ipxe-build
	docker rmi ipxe-build

