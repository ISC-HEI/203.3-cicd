# =========================
# Build stage
# =========================
FROM gcc:13 AS builder

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Copy only what is needed for the build
COPY include ./include
COPY src ./src
COPY test ./test
COPY Makefile .

# Build and test
RUN make clean && make && make test

# =========================
# Runtime stage
# =========================
FROM ubuntu:24.04

# Create a non-root user
RUN useradd -m appuser

WORKDIR /app

# Copy the binary only
COPY --from=builder /app/build/main /app/main

RUN chmod +x /app/main && chown appuser:appuser /app/main

USER appuser

# Default command
ENTRYPOINT ["/app/main"]
