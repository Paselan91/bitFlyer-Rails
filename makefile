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
create:
	docker-compose run app rails db:create
migrate:
	docker-compose run app rails db:migrate
seed:
	docker-compose run app rails db:seed
bundle install:
	docker-compose run app bundle install
attach for pry:
	docker attach bitflyer_rails
	# binding.pry　
	# docker attachから抜けるには、　ctl + p -> ctl + q　
