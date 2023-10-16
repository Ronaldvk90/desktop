install:
	@echo "Installing the Desktop"
	docker compose up -d
install-debug:
	@echo "Debug installer"
	docker compose up
clean:
	@echo "removing the Desktop"
	docker compose down

clean-all:
	@echo -e Removing "\033[0;31m!!! AND CLEANING !!!\033[0m" all files
	docker compose down
	docker volume rm desktop_home
	docker image rm desktop:latest
