RANDOMNR=$[ $RANDOM % 70 + 10 ]

mkdir src/
touch src/index.ts

yarn add -D typescript rimraf ts-node @types/node
npx npm-add-script \
  -k "inspect" \
  -v "node --inspect=92$RANDOMNR --nolazy -r ts-node/register/transpile-only src/index.ts" \
  --force

npx npm-add-script \
  -k "start" \
  -v "ts-node src/index.ts" \
  --force
