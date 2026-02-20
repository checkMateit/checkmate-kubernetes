#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${1:-.env.dev.secrets}"
NAMESPACES=(community user store study gateway eureka)

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Missing ${ENV_FILE}. Copy .env.dev.secrets.example and fill real values."
  exit 1
fi

set -a
source "${ENV_FILE}"
set +a

for ns in "${NAMESPACES[@]}"; do
  kubectl -n "${ns}" create secret generic app-secrets \
    --from-literal=DB_URL="${DB_URL}" \
    --from-literal=DB_USERNAME="${DB_USERNAME}" \
    --from-literal=DB_PASSWORD="${DB_PASSWORD}" \
    --from-literal=DB_NAME="${DB_NAME}" \
    --from-literal=SPRING_DATASOURCE_URL="${DB_URL}" \
    --from-literal=SPRING_DATASOURCE_USERNAME="${DB_USERNAME}" \
    --from-literal=SPRING_DATASOURCE_PASSWORD="${DB_PASSWORD}" \
    --from-literal=REDIS_HOST="${REDIS_HOST}" \
    --from-literal=REDIS_PORT="${REDIS_PORT}" \
    --from-literal=SPRING_REDIS_HOST="${REDIS_HOST}" \
    --from-literal=SPRING_REDIS_PORT="${REDIS_PORT}" \
    --from-literal=JWT_SECRET="${JWT_SECRET}" \
    --from-literal=JWT_ACCESS_EXPIRATION="${JWT_ACCESS_EXPIRATION}" \
    --from-literal=JWT_REFRESH_EXPIRATION="${JWT_REFRESH_EXPIRATION}" \
    --from-literal=GOOGLE_CLIENT_ID="${GOOGLE_CLIENT_ID}" \
    --from-literal=GOOGLE_CLIENT_SECRET="${GOOGLE_CLIENT_SECRET}" \
    --from-literal=GITHUB_CLIENT_ID="${GITHUB_CLIENT_ID}" \
    --from-literal=GITHUB_CLIENT_SECRET="${GITHUB_CLIENT_SECRET}" \
    --dry-run=client -o yaml | kubectl apply -f -
done

echo "Applied app-secrets to: ${NAMESPACES[*]}"
