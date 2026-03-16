# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /build

# Copy toàn bộ giải pháp để đảm bảo các file liên quan đều có mặt
COPY . .

# Chạy restore với cờ verbosity để xem chi tiết lỗi nếu thất bại
RUN dotnet restore src/MiniIngenium.csproj --verbosity normal

# Build và Publish
RUN dotnet publish src/MiniIngenium.csproj \
    -c Release -o /app/publish --no-restore

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
# Cài đặt postgresql-client để nạp schema
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /app/publish .
COPY db/ ./db/

ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 5000

CMD ["sh", "-c", \
  "until pg_isready -h $PGHOST -U $PGUSER 2>/dev/null; do echo 'Waiting for DB...'; sleep 1; done && \
   PGPASSWORD=$PGPASSWORD psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f /app/db/schema.sql && \
   dotnet MiniIngenium.dll"]