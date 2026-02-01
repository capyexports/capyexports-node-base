# capyexports-node-base

Node.js 22 Alpine base Docker image for capyexports projects. Built and published to Aliyun ACR (Beijing Personal) as **base-node** via GitHub Actions.

## Standard Reference

- **ACR repo name:** `base-node` (namespace: `capyexports`)
- **Base environment:** Node.js 22 (Alpine)
- **Target registry:** Aliyun ACR Beijing Personal (`crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com`)
- **Deploy node:** Volcano Engine Ubuntu instance (4C4G / 40GB disk)

## Version

**Current version:** 1.0.0

| Version | Base Image   | Notes                    |
|---------|--------------|--------------------------|
| 1.0.0   | node:22-alpine | Node 22, tz Asia/Shanghai, npmmirror, USER node |

## Usage

### ACR 操作指南（与控制台一致）

**1. 登录阿里云 Container Registry**

```bash
docker login --username=gxt4221 crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com
```

用户名：阿里云账号全名；密码：访问凭证页面设置的密码。可在 [访问凭证](https://cr.console.aliyun.com) 修改。

**2. 从 Registry 拉取镜像**

```bash
docker pull crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com/capyexports/base-node:[镜像版本号]
```

**3. 推送到 Registry（CI 已自动推送，本地需先登录）**

```bash
docker login --username=gxt4221 crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com
docker tag [ImageId] crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com/capyexports/base-node:[镜像版本号]
docker push crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com/capyexports/base-node:[镜像版本号]
```

**4. 专有网络（VPC）**  
从 ECS 推送时可用内网地址加速、不耗公网流量：  
`crpi-5nqoro6hoopis4cp-vpc.cn-beijing.personal.cr.aliyuncs.com/capyexports/base-node:[镜像版本号]`

---

### Pull from Aliyun ACR (Beijing Personal)

```bash
# Login (use ACR_USERNAME / ACR_PASSWORD in GitHub Secrets; locally use your username)
docker login crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com -u YOUR_ACR_USERNAME -p YOUR_ACR_PASSWORD

# Pull latest
docker pull crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com/capyexports/base-node:latest

# Pull by date tag (YYYYMMDD)
docker pull crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com/capyexports/base-node:20250201
```

### Use in child projects (layer reuse)

**Always use `FROM` with this base image to reuse layers; do not pull the official Node image again.**

```dockerfile
# In capyexports or other sub-projects: multi-stage build
FROM crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com/capyexports/base-node:latest
WORKDIR /app
COPY --chown=node:node . .
RUN npm ci --omit=dev
USER node
CMD ["node", "index.js"]
```

### Build locally

```bash
docker build -t base-node:local .
```

### Run

```bash
docker run -it base-node:local
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

- **Build failure:** Check ACR login (`ACR_USERNAME` / `ACR_PASSWORD`) and network access to `crpi-5nqoro6hoopis4cp.cn-beijing.personal.cr.aliyuncs.com`.
- **Adding a new project:** Use a multi-stage build and `FROM` this base image as above.

## License

See repository license.
