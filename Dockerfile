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

# Run the Go build command to compile the application
RUN  CGO_ENABLED=0 go build  --trimpath -o /parcel

# Stage 2: Create a minimal final image
# Use the official Alpine Linux image as the base image for the final application
FROM alpine:latest

# Set the working directory inside the final image
WORKDIR /app

# Copy the built Go application from the builder stage to the final image
COPY --from=builder /parcel .

# Ensure the application binary has the correct permissions
RUN chmod 754 ./parcel

# Set the command to run the Go application when the container starts
CMD ["./parcel"]

#command to build the Docker image
# docker build -t <your_docker_id>/parcel:v1 .
# command to run the Docker container
# docker run -v ./tracker.db:/app/tracker.db <your_docker_id>/parcel:v1
