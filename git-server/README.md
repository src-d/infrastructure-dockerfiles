# Example

```
docker run -d --name git-server \
-v /Users/rporres/Work/git/src-d:/Users/rporres/Work/git/src-d \
--env REPOSITORIES_DIR=/Users/rporres/Work/git/src-d \
srcd/git-server:v0.0.1
```
