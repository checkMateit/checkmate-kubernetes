# Monitoring Secrets

Do not commit real webhook URLs to Git.

Create or update the Discord webhook secret manually:

```bash
kubectl -n monitoring create secret generic discord-webhook \
  --from-literal=url='https://discord.com/api/webhooks/REPLACE/REPLACE' \
  --dry-run=client -o yaml | kubectl apply -f -
```
