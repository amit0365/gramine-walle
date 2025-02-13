FROM gramineproject/gramine:stable-noble

# Install required packages
RUN apt-get update && apt-get install -y \
    make \
    curl \
    g++ \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_23.x | bash - \
    && apt-get install -y nodejs=23.3.0-1nodesource1

# Install pnpm
RUN npm install -g pnpm

ENV SGX=1

# Generate SGX key
# Generate SGX key and verify
RUN gramine-sgx-gen-private-key && \
    ls -l /root/.config/gramine/enclave-key.pem || echo "Key generation failed"

WORKDIR /root/

# Add your application files
ADD walle/ ./walle/
ADD nodejs.manifest.template ./
ADD Makefile ./

# Create directory for untrusted host files if needed
RUN mkdir -p untrustedhost

# Install dependencies and build TypeScript
RUN cd walle && pnpm install && pnpm build

# Build SGX application
RUN SGX=1 DEBUG=1 make && \
    test -f nodejs.manifest.sgx || (echo "SGX manifest not generated" && exit 1)

ENTRYPOINT []
CMD ["gramine-sgx-sigstruct-view", "nodejs.sig"]