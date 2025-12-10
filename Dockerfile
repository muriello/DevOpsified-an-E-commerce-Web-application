# Stage 1: Build the Go binary
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copy Go module files first
COPY go.mod .
RUN go mod download

# Copy the source code
COPY . .

# Build the Go app for Linux (important!)
RUN GOOS=linux GOARCH=amd64 go build -o main .

# Stage 2: Use distroless base image
FROM gcr.io/distroless/base

WORKDIR /app

# Copy the Go binary from the builder stage
COPY --from=builder /app/main .

# Copy static folder only if it exists
COPY --from=builder /app/static ./static

EXPOSE 8080

# Run the Linux binary
CMD ["/app/main"]
