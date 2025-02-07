FROM gramineproject/gramine:v1.5

RUN apt-get update && apt-get install -y \
    make \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

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

# Build SGX application
RUN SGX=1 make

ENTRYPOINT []
CMD [ "gramine-sgx", "nodejs" ]
