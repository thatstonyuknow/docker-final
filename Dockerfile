# Dockerfile for building and running a Go application
# Use a multi-stage build to create a minimal final image
# Use the official Golang image as the base image for building the application
# Stage 1: Build the Go application

FROM golang:1.22 AS builder

# Set the working directory inside the container
WORKDIR /app    

# Copy the Go module files to the working directory
COPY go.mod go.sum ./

# Download the Go module dependencies
RUN go mod download

# Copy the Go source files to the working directory
COPY *.go ./

# Set environment variables for building the Go application
RUN go build  --trimpath -o /parcel

# Stage 2: Create a minimal final image
# Use a minimal base image for the final application
# Use the official Alpine Linux image as the base image for the final application
FROM alpine:latest

# Set the working directory inside the final image
WORKDIR /app

# Copy the built Go application from the builder stage to the final image
COPY --from=builder /parcel .

# Install necessary dependencies for the Go application
# Install ca-certificates and libc6-compat for compatibility
RUN apk add --no-cache ca-certificates libc6-compat

# Ensure the application binary has the correct permissions
RUN chmod 754 ./parcel

# Expose the port on which the Go application will run
EXPOSE 8080

# Set the command to run the Go application when the container starts
CMD ["./parcel"]

#command to build the Docker image
# docker build -t <your_docker_id>/parcel:v1 .
# command to run the Docker container
# docker run -p 8080:8080 -v ./tracker.db:/app/tracker.db <your_docker_id>/parcel:v1
