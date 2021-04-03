.PHONY: init plan apply destroy check
ps:
	docker-compose ps
attach app:
	docker-compose exec app bash
attach db:
	docker-compose exec mysql bash
up:
	docker-compose up
up-d:
	docker-compose up -d
restart:
	docker-compose restart
stop:
	docker-compose stop
migrate:
	docker-compose run app rails db:migrate
seed:
	docker-compose run app rails db:seed
