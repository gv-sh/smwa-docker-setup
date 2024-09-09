FROM node:14

WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

EXPOSE 3000

# Use serve to run the application
RUN npm install -g serve

# Serve the static files
CMD ["serve", "-s", "build", "-l", "3000"]