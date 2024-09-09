FROM node:14

WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Install all necessary Mantine dependencies
RUN npm install @mantine/core @mantine/hooks @mantine/form @mantine/notifications @mantine/modals

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

EXPOSE 3000

# Use a lightweight Node.js image to serve the built application
FROM node:14-alpine

WORKDIR /app

# Copy the built application from the previous stage
COPY --from=0 /app/build ./build

# Install serve to run the application
RUN npm install -g serve

EXPOSE 3000

# Serve the static files
CMD ["serve", "-s", "build", "-l", "3000"]