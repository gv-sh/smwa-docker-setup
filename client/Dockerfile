FROM node:14

WORKDIR /app

COPY package*.json ./

RUN npm install

# Install all necessary Mantine dependencies
RUN npm install @mantine/core @mantine/hooks @mantine/form @mantine/notifications @mantine/modals

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]