# msales/helm-reposerver - git2helmrepo microservice

## Description

This image downloads git repository and publishes it as a helm repo.

## Usage

Defaults:

```
HELM_LISTEN=${HELM_LISTEN:-"0.0.0.0:8879"}
HELM_REPO=${HELM_REPO:-"https://github.com/helm/charts.git"}
HELM_REPO_SUBPATH=${HELM_REPO_SUBPATH:-"/stable"}
HELM_URL=${HELM_URL:-"http://localhost:8879/"} << set it correctly since this domain will appear in helm repo metadata
```

Exposing msales private repos for local usage:

```
docker run --rm -p 8879:8879 -e HELM_REPO='https://__your_github_token__@github.com/msales/helm-charts.git' -e HELM_REPO_SUBPATH='/test' --name helm-reposerver msales/helm-reposerver:latest
```

Now you can add repo to helm and use it (starting msales-mysql as example):

```
helm repo add test http://127.0.0.1:8879/
helm repo update
helm install test/msales-mysql --name test --namespace test --set mysqlAllowEmptyPassword=true
kubectl -n test get pods
helm list
helm delete test
```

Enjoy !
