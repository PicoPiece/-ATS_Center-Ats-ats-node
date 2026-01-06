# Push Image and Make Public for CI/CD

## Quick Steps

### 1. Login to GHCR

```bash
docker login ghcr.io
# Username: picopiece (your GitHub username)
# Password: <your-github-token-with-write:packages-scope>
```

### 2. Push Image

```bash
cd ats-ats-node/docker/ats-node-test
docker push ghcr.io/picopiece/ats-node-test:latest
```

### 3. Make Image Public (Required for CI without auth)

**Option A: Using GitHub CLI**
```bash
gh api user/packages/container/ats-node-test -X PATCH -f visibility=public
```

**Option B: Using GitHub Web UI**
1. Go to: https://github.com/PicoPiece?tab=packages
2. Find `ats-node-test` package
3. Click on it → Package settings
4. Scroll to "Danger Zone" → Change visibility → Public

### 4. Verify

```bash
# Should work without authentication
docker pull ghcr.io/picopiece/ats-node-test:latest
```

## Why Make Public?

- **CI/CD pipelines** (Jenkins agents) can pull without authentication
- **Simpler setup** - no need to configure Docker credentials on every agent
- **Faster builds** - no auth overhead

## Security Note

This image contains test execution tools, not sensitive data. Making it public is safe for CI/CD use.

