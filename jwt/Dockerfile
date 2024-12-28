# Use a lightweight base image with bash and openssl
FROM debian:bullseye-slim

# Set working directory
WORKDIR /app

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssl \
    bash \
 && rm -rf /var/lib/apt/lists/*

# Copy the script to the container
COPY generate-jwt.sh /app/generate-jwt.sh

# Make the script executable
RUN chmod +x /app/generate-jwt.sh

# Define the JWT directory as a volume
VOLUME /app/jwttoken

# Run the script when the container starts
CMD ["/app/generate-jwt.sh"]
