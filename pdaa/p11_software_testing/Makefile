run:
	go run main.go

test:
	go test -v ./...

coverage:
	mkdir -p coverage
	go test -coverprofile=coverage/coverage.out ./...
	go tool cover -html=coverage/coverage.out -o coverage/coverage.html

.PHONY: run test coverage
