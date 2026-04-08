# Expected Commands

For a typical Go repo, common commands are:

- detect repository:
  - `bash scripts/detect.sh`

- format:
  - `bash scripts/fmt.sh`

- build:
  - `go build ./...`

- run all unit tests:
  - `bash scripts/test.sh`

- run one test:
  - `go test ./path/to/pkg -run TestName`

- benchmark:
  - `go test ./path/to/pkg -bench=. -benchmem`

- lint:
  - `bash scripts/lint.sh`

- integration tests:
  - `bash scripts/integration-test.sh`

- full validation:
  - `bash scripts/ci-check.sh`
