# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# WORKDIR /build
# COPY src/MiniIngenium.csproj ./src/
# RUN dotnet restore src/MiniIngenium.csproj
# COPY src/ ./src/
# RUN dotnet publish src/MiniIngenium.csproj \
#     -c Release -o /app/publish --no-restore

# FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
# WORKDIR /app
# COPY --from=build /app/publish .
# COPY cobol/ ./cobol/
# COPY db/ ./db/
# ENV ASPNETCORE_URLS=http://+:5000
# ENV ASPNETCORE_ENVIRONMENT=Production
# EXPOSE 5000

# # Init schema rồi start app
# CMD ["sh", "-c", \
#   "until pg_isready -h $PGHOST -U $PGUSER 2>/dev/null; do sleep 1; done && \
#    PGPASSWORD=$PGPASSWORD psql -h $PGHOST -U $PGUSER -d $PGDATABASE \
#      -f /app/db/schema.sql && \
#    dotnet MiniIngenium.dll"]



# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /build

# 1. Copy file project để restore trước (tối ưu cache)
COPY src/MiniIngenium.csproj ./src/
RUN dotnet restore src/MiniIngenium.csproj

# 2. QUAN TRỌNG: Phải copy TOÀN BỘ thư mục (bao gồm folder cobol/ và src/)
# Vì file .csproj cần nhìn thấy các file .cob/.cbl để Otterkit biên dịch thành DLL
COPY . .

# 3. Build và Publish
# Không dùng --no-restore ở đây nếu bạn muốn đảm bảo Otterkit được kích hoạt đầy đủ
RUN dotnet publish src/MiniIngenium.csproj \
    -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
# Cài đặt postgresql-client để dùng được lệnh psql trong CMD
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy kết quả build từ stage trước
COPY --from=build /app/publish .
# Copy lại các folder database nếu cần cho việc init schema
COPY db/ ./db/

ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 5000

# Chờ DB sẵn sàng, nạp schema và chạy app
CMD ["sh", "-c", \
  "until pg_isready -h $PGHOST -U $PGUSER 2>/dev/null; do echo 'Waiting for DB...'; sleep 1; done && \
   PGPASSWORD=$PGPASSWORD psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f /app/db/schema.sql && \
   dotnet MiniIngenium.dll"]