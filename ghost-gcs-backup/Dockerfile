FROM node:12

COPY ./script /ghost-gcs-backup
WORKDIR /ghost-gcs-backup

RUN npm install

CMD node /ghost-gcs-backup/backup.js
