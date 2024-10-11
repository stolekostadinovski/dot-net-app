FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY src/TodoApi.csproj ./
RUN dotnet restore

# Copy the remaining source code
COPY src/ ./

# Build the application
RUN dotnet publish -c Release -o out

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Set the working directory in the container
WORKDIR /app

# Copy the built app from the build environment
COPY --from=build-env /app/out .

# Expose the port that the application listens on
EXPOSE 80

# Command to run the application
ENTRYPOINT ["dotnet", "TodoApi.dll"]
