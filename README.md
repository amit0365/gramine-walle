# gramine-walle

## Build and Run

# Build the Docker image
docker build -t gramine .

# View SGX measurements
docker run --rm gramine

# Run the application in SGX
docker compose run --rm gramine bash -c "cd walle && pnpm build && gramine-sgx nodejs dist/index.js"