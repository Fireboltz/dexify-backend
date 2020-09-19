#Stage 1
FROM node:alpine as builder

WORKDIR /usr/src/app
COPY package*.json ./

RUN npm install

COPY src ./
COPY tsconfig.json ./
RUN npm run build


#Stage 2
FROM node:alpine

WORKDIR /usr/src/app
COPY package*.json ./

RUN npm install --production

COPY --from=builder /usr/src/app/build ./
COPY src/schema/typeDefs.graphql ./schema/typeDefs.graphql
COPY src/config/hackmit-chat-firebase-adminsdk-gry8e-252d84a3d7.json ./config/
COPY .env ./

EXPOSE 3350

CMD node index.js