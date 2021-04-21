# "Global" makefile

STACK       = concourse
DCL         = $(STACK).yml

# $HELP$
# help             Print this message
# build            Build all components in this Makefile
# deploy           Deploy stack
# undeploy         Undeploy stack
# status           Check status of stack
# all              Build componts and Deploy
# stop             Alias of undeploy
# start            Alias of deploy
# logs             Containers log
# is_swarm_active
# swarm_on

.PHONY: help
help:
	@awk -f scripts/help.awk Makefile

is_swarm_active:
	@docker info | awk '/Swarm:/ { print $$2 } '

swarm_on:
	@docker swarm init --advertise-addr 127.0.0.1:2377

.PHONY:
deploy: 
	@docker stack ps -q $(STACK) > /dev/null 2>&1 && { echo "Make sure you 'undeploy' first"; } || { docker stack deploy $(STACK) -c $(DCL); }


.PHONY: undeploy
undeploy:
	@docker stack rm $(STACK) 2>&1

.PHONY: status
status:
	@docker stack ps $(STACK) --no-trunc

.PHONY: all
all: build deploy

stop: undeploy

sleep:
	@sleep 10

.PHONY: redeploy
redeploy: build undeploy sleep deploy

restart: redeploy

all: undeploy

start: deploy

.PHONY: logs
logs:
	@for service in $(COMPONENTS); do docker service logs  $(STACK)_default; done

# EOF #
