# Multi-stage build for Go application

# Build stage
FROM golang:1.23.3-alpine AS builder
WORKDIR /app

# Copy go mod files
COPY go.mod ./

# Copy source code
COPY main.go ./

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o testpod .

# Runtime stage
FROM scratch AS runtime

# Copy the binary from builder
COPY --from=builder /app/testpod /testpod

# Run the application
CMD ["/testpod"]