cd ./lib/assets/
FILE="configuration.json"

tee ${FILE} <<<"{\"firebase_key\":\"${todo_firebease_key}\"}"
