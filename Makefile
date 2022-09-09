postgres:
	docker run --name a4bankDB -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it a4bankDB createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it a4bankDB dropdb simple_bank

initdb:
	migrate create -ext sql -dir ./db/migration -seq init_schema

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose down

initsqlc:
	sqlc init

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/oddinnovate/a4bank/db/sqlc Store

.PHONY: postgres createdb dropdb initdb migrateup migratedown test server mock
