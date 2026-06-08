.PHONY: install check-data init build step-install step-setup up status clean uninstall

# Main installation pipeline
install: check-data clean init build step-install step-setup up status

check-data:
	@if [ -d "./golem-data" ]; then \
		printf "\n=======================================================\n"; \
		printf " [WARNING] EXISTING DATA DETECTED!\n"; \
		printf " Running 'make install' will DELETE your current node\n"; \
		printf " identity, wallet configurations, and cache.\n"; \
		printf "=======================================================\n"; \
		printf "Are you sure you want to proceed and wipe everything? [y/N]: "; \
		read ans; \
		if [ "$$ans" != "y" ] && [ "$$ans" != "Y" ]; then \
			printf "\n=> Installation aborted by user. Your data is safe.\n\n"; \
			exit 1; \
		fi; \
	fi

init:
	@echo "=> Creating local volume directories..."
	@mkdir -p ./golem-data/local

build:
	@echo "=> Building the base Ubuntu image..."
	docker compose build

step-install:
	@echo "\n======================================================="
	@echo " STEP 1: GOLEM INSTALLATION"
	@echo " Running the official Golem installer."
	@echo " Please read and accept the Terms of Service."
	@echo " WHEN FINISHED, TYPE 'exit' TO CONTINUE."
	@echo "=======================================================\n"
	docker compose run -it --rm golem-provider bash -c "curl -sSf https://join.golem.network/as-provider | bash - ; echo -e '\n[!] Installation finished. Type exit to continue.'; exec bash"

step-setup:
	@echo "\n======================================================="
	@echo " STEP 2: NODE AND WALLET CONFIGURATION"
	@echo " Opening the interactive configuration prompt."
	@echo " Please type 'allow' for stats, enter your node name,"
	@echo " and provide your ERC-20 wallet address."
	@echo " WHEN FINISHED, TYPE 'exit' TO START THE NODE."
	@echo "=======================================================\n"
	docker compose run -it --rm golem-provider bash -c "golemsp setup ; echo -e '\n[!] Setup finished. Type exit to start the provider.'; exec bash"

up:
	@echo "\n=> Starting the Golem node in background..."
	docker compose up -d

status:
	@echo "\n=> Waiting for the node to connect to the P2P network and publish offers..."
	@bash -c ' \
		while true; do \
			out=$$(docker exec golem_provider_node golemsp status 2>&1); \
			if echo "$$out" | grep -q "is running" && ! echo "$$out" | grep -q "not functioning"; then \
				echo -e "\n\n[✓] Node successfully published!\n"; \
				docker exec -it golem_provider_node golemsp status; \
				break; \
			fi; \
			printf "."; \
			sleep 2; \
		done \
	'

clean:
	@echo "=> Cleaning up previous environment and local data..."
	docker compose down 2>/dev/null || true
	docker rm -f golem_provider_node 2>/dev/null || true
	sudo rm -rf ./golem-data

uninstall:
	@printf "\n=======================================================\n"
	@printf " [WARNING] COMPLETE UNINSTALLATION INITIALIZED\n"
	@printf " This will stop and remove the container, delete the\n"
	@printf " built Docker images, and wipe all node data/keys.\n"
	@printf "=======================================================\n"
	@printf "Are you sure you want to completely uninstall? [y/N]: "; \
	read ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		echo "=> Stopping containers and removing images..."; \
		docker compose down --rmi all -v 2>/dev/null || true; \
		echo "=> Deleting local node data and cache..."; \
		sudo rm -rf ./golem-data; \
		echo "\n[✓] Uninstallation complete.\n"; \
	else \
		echo "\n=> Uninstallation aborted.\n"; \
	fi
