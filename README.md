# capyexports-node-base

Node.js 22 Alpine base Docker image for capyexports projects. Built and published to Aliyun ACR (Shanghai) via GitHub Actions.

## Standard Reference

- **Base image name:** `capyexports-node-base`
- **Base environment:** Node.js 22 (Alpine)
- **Target registry:** Aliyun ACR Shanghai (`registry.cn-shanghai.aliyuncs.com`)
- **Deploy node:** Volcano Engine Ubuntu instance (4C4G / 40GB disk)

## Version

**Current version:** 1.0.0

| Version | Base Image   | Notes                    |
|---------|--------------|--------------------------|
| 1.0.0   | node:22-alpine | Node 22, tz Asia/Shanghai, npmmirror, USER node |

## Usage

### Pull from Aliyun ACR (Shanghai)

```bash
# Login to ACR (use ACR_USERNAME / ACR_PASSWORD, never hardcode)
docker login registry.cn-shanghai.aliyuncs.com -u YOUR_ACR_USERNAME -p YOUR_ACR_PASSWORD

# Pull latest
docker pull registry.cn-shanghai.aliyuncs.com/YOUR_NAMESPACE/capyexports-node-base:latest

# Pull by date tag (YYYYMMDD)
docker pull registry.cn-shanghai.aliyuncs.com/YOUR_NAMESPACE/capyexports-node-base:20250201
```

### Use in child projects (layer reuse)

**Always use `FROM` with this base image to reuse layers; do not pull the official Node image again.**

```dockerfile
# In capyexports or other sub-projects: multi-stage build
FROM registry.cn-shanghai.aliyuncs.com/YOUR_NAMESPACE/capyexports-node-base:latest
WORKDIR /app
COPY --chown=node:node . .
RUN npm ci --omit=dev
USER node
CMD ["node", "index.js"]
```

### Build locally

```bash
docker build -t capyexports-node-base:local .
```

### Run

```bash
docker run -it capyexports-node-base:local
```

## CI/CD

- **Workflow:** `.github/workflows/build-base.yml`
- **Trigger:** Only when `Dockerfile` or `.github/workflows/**` changes (path filter).
- **Tags:** Pushed as `:latest` and `:${{ date }}` (YYYYMMDD).
- **Secrets:** Use `ACR_USERNAME`, `ACR_PASSWORD`, and `ACR_NAMESPACE` in repo secrets (no hardcoded credentials).
- **Cache:** GitHub Actions cache for faster rebuilds.

## 40GB disk constraint (deploy node)

- **Log limit:** In `docker-compose.yml` or `daemon.json`, set log driver with `max-size: 20m` for all containers.
- **Layer reuse:** In all sub-projects (e.g. capyexports), use `FROM [ACR_BASE_IMAGE_URL]` so layers are reused and the official Node image is not pulled again.
- **Cleanup:** At the end of deploy scripts, run `docker image prune -f` to free disk space.

## File layout

```
.
├── .github/workflows/build-base.yml   # GitHub Actions workflow
├── Dockerfile                         # Base image definition (Node 22 Alpine)
├── .dockerignore                      # Build context exclusions
└── README.md                          # This file
```

## Troubleshooting

- **Build failure:** Check ACR login (`ACR_USERNAME` / `ACR_PASSWORD`) and network access to `registry.cn-shanghai.aliyuncs.com`.
- **Adding a new project:** Use a multi-stage build and `FROM` this base image as above.

## License

See repository license.
