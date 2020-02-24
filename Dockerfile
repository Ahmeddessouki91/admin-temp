FROM node:12.14.0 AS build-env
LABEL multi.maintainer="deso" multi.desc="this stage for setup node" 
WORKDIR /app
# Copy everything else and build
COPY . ./
LABEL multi.maintainer="deso" multi.desc="this stage for build app" 
WORKDIR /app
ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN npm install -g @angular/cli && npm install && npm run build

# Build runtime image
FROM node:12.14.0
LABEL multi.maintainer="deso" multi.desc="this stage for run app" 
WORKDIR /app
ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN npm i angular-http-server -g
COPY --from=build-env /app/out .
ENTRYPOINT ["angular-http-server"]
