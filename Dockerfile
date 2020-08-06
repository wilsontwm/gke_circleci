# Start from base image
FROM golang:alpine as builder

# Set the current working directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy source from current directory to working directory
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -o main .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

# Set the current working directory inside the container
WORKDIR /root

# Copy the binary executable over
COPY --from=builder /app/main .
COPY --from=builder /app/.env .

# Expose necessary port
EXPOSE 8080

# Run the created binary executable 
CMD ["./main"]