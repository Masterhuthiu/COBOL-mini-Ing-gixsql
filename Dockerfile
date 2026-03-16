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

# Stage 1: build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# copy csproj và restore
COPY src/MiniIngenium/*.csproj ./MiniIngenium/
RUN dotnet restore ./MiniIngenium/MiniIngenium.csproj

# copy toàn bộ source
COPY src/MiniIngenium ./MiniIngenium

# publish
RUN dotnet publish ./MiniIngenium/MiniIngenium.csproj -c Release -o /app/publish

# Stage 2: runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
COPY cobol/ ./cobol/
COPY db/ ./db/

ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 5000

# Init schema rồi start app
CMD sh -c "until pg_isready -h $PGHOST -U $PGUSER 2>/dev/null; do sleep 1; done && \
   PGPASSWORD=$PGPASSWORD psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f /app/db/schema.sql && \
   dotnet MiniIngenium.dll"
