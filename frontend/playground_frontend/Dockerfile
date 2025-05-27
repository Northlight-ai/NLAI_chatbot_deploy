FROM node:20

WORKDIR /app

COPY package*.json ./
COPY .npmrc .npmrc

RUN npm install

COPY . .

# Build the frontend
RUN npm run build

# Install lightweight static server
RUN npm install -g serve

EXPOSE 8080

# Serve the dist folder
CMD ["serve", "-s", "dist", "-l", "8080"]
