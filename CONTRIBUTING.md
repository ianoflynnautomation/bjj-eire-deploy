# Contributing

- Use feature branches and open PRs to `main`.
- Follow conventional commits for titles (feat:, fix:, chore:, docs:).
- Keep secrets out of code and values.yaml. Use Kubernetes Secrets or Key Vault.
- For Helm changes, validate with:
```
helm lint ./bjj-eire-api/artifact
helm template bjj-api ./bjj-eire-api/artifact
```
- Update documentation in `README.md` when behavior changes.
