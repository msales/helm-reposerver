#!/bin/sh
#set -eu

HELM_LISTEN=${HELM_LISTEN:-"0.0.0.0:8879"}
HELM_REPO=${HELM_REPO:-"https://github.com/helm/charts.git"}
HELM_REPO_SUBPATH=${HELM_REPO_SUBPATH:-"/stable"}
HELM_URL=${HELM_URL:-"http://localhost:8879/"}

if [ -d /repo/.git ];then
  echo "== Pulling current branch ..."
  cd /repo && git pull
else
  echo "== Clonning ..."
  rm -rf /usr/share/nginx/html/*
  git clone --single-branch -- ${HELM_REPO} /repo
fi

echo "== repo preparation"
helm dependency update
helm init --client-only
find /repo/${HELM_REPO_SUBPATH} -type d -maxdepth 1 -exec helm package --destination /repo/${HELM_REPO_SUBPATH} '{}' ';'
helm repo index /repo/${HELM_REPO_SUBPATH}

echo "== Server startup ..."
helm serve --address ${HELM_LISTEN} --repo-path /repo/${HELM_REPO_SUBPATH} --url ${HELM_URL} & pid="$!"
trap "kill -TERM $pid" INT TERM
while kill -0 $pid > /dev/null 2>&1; do
  wait $pid
  ec="$?"
done;


exit $ec;
