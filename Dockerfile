FROM gramineproject/gramine:v1.5

# Install required packages
RUN apt-get update && apt-get install -y \
    make \
    curl \
    gcc \
    g++ \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install pnpm
RUN npm install -g pnpm

ENV SGX=1

# Generate SGX key
RUN gramine-sgx-gen-private-key

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
RUN SGX=1 make

ENTRYPOINT []
CMD [ "gramine-sgx-sigstruct-view", "nodejs.sig" ]