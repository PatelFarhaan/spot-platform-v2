.PHONY: install_packages
install_packages:
	docker-compose -f docker-compose.yml up --build --remove-orphans --detach
	docker-compose exec -T pb-app-test /bin/sh -c "pytest --color=yes"