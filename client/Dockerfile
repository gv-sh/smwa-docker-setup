FROM node:14

WORKDIR /app

COPY package*.json ./

RUN npm install

# Install the missing @mantine/core dependency
RUN npm install @mantine/core

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]