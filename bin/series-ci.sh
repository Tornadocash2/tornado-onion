#!/bin/sh -l
# this sends metrics to the build service 

echo "Entrypoint $1"
time=$(date '+%F %T.%3N')
echo "::set-output name=time::$time"

curl \
  --header "Authorization: Token 11fe37c3-1609-48ed-bf98-8caa0408e6bb" \
  --header "Content-Type: application/json" \
  --data "{
    \"values\":[
      {
        \"line\":\"a\",
        \"value\":\"1 %\"
      },
      {
        \"line\":\"b\",
        \"value\":\"2 %\"
      },
      {
        \"line\":\"c\",
        \"value\":\"3 %\"
      }
    ],
    \"sha\":\"$(git rev-parse HEAD)\"
  }" \
  https://seriesci.com/api/sambacha/tornado-onion/:series/many
