FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

WORKDIR /app 
#
# copy csproj and restore as distinct layers
COPY *.sln .
COPY TodoApi/*.csproj ./TodoApi/

RUN dotnet restore

# copy everything else and build app
COPY TodoApi/ ./TodoApi/

#
WORKDIR /app/TodoApi
RUN dotnet publish -c Release -o out 
#
FROM mcr.microsoft.com/dotnet/aspnet:5.0.0
WORKDIR /app 
#
COPY --from=build /app/TodoApi/out ./
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["dotnet", "TodoApi.dll"]