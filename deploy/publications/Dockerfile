# Publications as a kube: build the Astro app, serve the static output
# with nginx. The dynamic parts (editor, studio, API) bind to SurrealDB
# as a sibling kube (the backend contract). Drop this at the repo root.
FROM node:22-alpine AS build
WORKDIR /src
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build           # Astro: outputs ./dist (set output:'static' for the face)

FROM nginx:1.27
COPY --from=build /src/dist /usr/share/nginx/html
