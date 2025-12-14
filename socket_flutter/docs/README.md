# InvenTalk Policies

This directory contains the public policy documents for InvenTalk, published via GitHub Pages.

## Available Policies

- [Child Sexual Abuse and Exploitation (CSAE) Policy (English)](./csae-policy.html)
- [児童の性的虐待および搾取（CSAE）に関するポリシー（日本語）](./csae-policy-ja.html)

## GitHub Pages Setup (Automated with GitHub Actions)

This repository uses GitHub Actions to automatically deploy the `docs` folder to GitHub Pages.

### Initial Setup (One-time)

1. Go to your repository settings on GitHub
2. Navigate to **Settings** → **Pages** in the left sidebar
3. Under **Source**, select **"GitHub Actions"**
4. Click **Save**

### Automatic Deployment

Once configured, the pages will be automatically deployed when:
- You push changes to the `docs/` folder to the `main` or `master` branch
- You manually trigger the workflow from the Actions tab

The workflow file is located at: `.github/workflows/deploy-pages.yml`

### Access Your Pages

After the first deployment, your policies will be available at:
- `https://[your-username].github.io/[repository-name]/`
- `https://[your-username].github.io/[repository-name]/csae-policy.html`
- `https://[your-username].github.io/[repository-name]/csae-policy-ja.html`

### Manual Deployment

You can also manually trigger the deployment:
1. Go to the **Actions** tab in your repository
2. Select **"Deploy to GitHub Pages"** workflow
3. Click **"Run workflow"** button

## Local Preview

To preview the pages locally, you can use a simple HTTP server:

```bash
cd docs
python3 -m http.server 8000
```

Then open `http://localhost:8000` in your browser.
