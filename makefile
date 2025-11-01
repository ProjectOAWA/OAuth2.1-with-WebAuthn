SERVICES := auth-server database nginx vault

.PHONY: all build dev $(SERVICES) client test install

all: build


##########
# DOCKER #
##########

# Run `make build` at the top level to build all service images
build: $(SERVICES)

# Run `make auth-server` or `make vault` from top-level directory to build specific service
$(SERVICES):
	$(MAKE) -C services/$@

dev:
	make dev -C ./services/auth-server


##########
# CLIENT #
##########

client:
	@if [ ! -d ".venv" ]; then \
		echo "Creating virtual environment..."; \
		python3 -m venv .venv; \
		echo "Installing dependencies from pyproject.toml..."; \
		make bootstrap -C ./clients/python-client; \
	else \
		make update -C ./clients/python-client; \
	fi
	. .venv/bin/activate && python3 -m oauth_client
	

#########
# CI/CD #
#########

install:
	make install -C ./services/auth-server

test:
	make test -C ./services/auth-server