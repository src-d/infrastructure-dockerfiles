FROM alpine:3.7
RUN apk --no-cache add git-daemon
ENV REPOSITORIES_DIR /var/lib/git/repositories
ENV GIT_PORT 9418
EXPOSE $GIT_PORT
CMD ["sh", "-c", "git daemon --reuseaddr --base-path=${REPOSITORIES_DIR} --port=${GIT_PORT} --verbose --export-all ${REPOSITORIES_DIR}" ]
