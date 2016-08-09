#!/usr/bin/env bash

set -e

ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}

git config user.name "${GIT_NAME}"
git config user.email "${GIT_EMAIL}"
git remote add deploy "${GIT_URL}"
git checkout --orphan gh-pages
git rm --cached -r .
git add -f *.pdf
git commit -m "Automatic build by Travis CI: ${TRAVIS_COMMIT}"

openssl aes-256-cbc -K ${ENCRYPTED_KEY} -iv ${ENCRYPTED_IV} -in ${KEY_LOCATION}.enc -out ${KEY_LOCATION} -d
chmod 600 ${KEY_LOCATION}
eval $(ssh-agent)
ssh-add ${KEY_LOCATION}

git push --force deploy gh-pages