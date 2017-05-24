# Build a PSORTm container
# By Matthew Laird <lairdm@sfu.ca>

NAME = psortm
IMAGE_REPO = brinkmanlab
VERSION = 1.0.0
IMAGE_NAME = $(IMAGE_REPO)/$(NAME)
DOMAIN = psort.org

all:: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "     make build        - Build image $(IMAGE_NAME)"
	@echo "     make start        - Start the EXISTING $(NAME) container"
	@echo "     make stop         - Stop $(NAME) container"
	@echo "     make restart      - Stop and start $(NAME) container"
	@echo "     make remove       - Stop and remove $(NAME) container"
	@echo "     make state        - View state $(NAME) container"
	@echo "     make logs         - View logs in real time"

build:
	docker build --rm --no-cache -t $(IMAGE_NAME):$(VERSION) .

start:
	@echo "Starting $(NAME)..."
	docker start $(NAME) > /dev/null

stop:
	@echo "Stopping $(NAME)..."
	docker stop $(NAME) > /dev/null

restart: stop start

remove: stop
	@echo "Removing $(NAME)..."
	docker rm $(NAME) > /dev/null

state:
	docker ps -a | grep $(NAME)

logs:
	@echo "Build $(NAME)..."
	docker logs -f $(NAME)
