# GitHub Repository Templates

Reusable templates and workflows for all repositories.

## Quick Start

### For New Repositories

**Option 1 - Use GitHub's "Use this template" button** (if enabled)

**Option 2 - Manual Copy:**
```bash
# Copy security workflow
cp github-templates/workflows/security.yml <your-repo>/.github/workflows/

# Copy other templates as needed
```

### For Existing Repositories

Use the provided scripts to deploy to all existing repos.

## Available Templates

### 🔒 Security Workflow

**Location:** `workflows/security.yml`

**Features:**
- **Gitleaks**: Secret scanning (full git history)
- **ShellCheck**: Shell script linting
- **Dependency Review**: CVE scanning in PRs
- **Weekly Scans**: Scheduled Monday 00:00 UTC

**When to use:**
- All repositories (public and private)
- Especially important for repos with scripts or sensitive data
- Supplements GitHub's native security features

**Enable it:**
```bash
mkdir -p .github/workflows
cp workflows/security.yml .github/workflows/
git add .github/workflows/security.yml
git commit -m "Add security workflow"
git push
```

### 📋 .gitignore Templates

**Location:** `gitignore/`

Pre-configured .gitignore files for common project types:
- `python.gitignore` - Python projects
- `node.gitignore` - Node.js projects
- `rust.gitignore` - Rust projects
- `generic.gitignore` - General purpose

## GitHub Native Security (Enable These Too!)

Our custom workflows complement GitHub's built-in features. **Enable these in each repo:**

### For Public Repositories (FREE)

1. **Dependabot** - Automatic dependency updates
   - Go to: Settings → Security → Dependabot
   - Enable: Dependabot alerts, Dependabot security updates

2. **Secret Scanning** - GitHub's native secret detection
   - Go to: Settings → Security → Secret scanning
   - Enable: Secret scanning (auto-enabled for public repos)

3. **Code Scanning (CodeQL)** - Advanced code analysis
   - Go to: Settings → Security → Code scanning
   - Click "Set up" → Use GitHub Actions workflow

### For Private Repositories

- Requires GitHub Advanced Security (paid)
- OR use our custom workflows (free)

## Deployment Scripts

Use the migration scripts to deploy to all repos:

```bash
# From repo-migration-scripts directory
./07-deploy-security-workflow.sh
```

## Template Structure

```
github-templates/
├── workflows/              # GitHub Actions workflows
│   └── security.yml       # Security scanning workflow
├── gitignore/             # Language-specific .gitignore
│   ├── python.gitignore
│   ├── node.gitignore
│   └── generic.gitignore
├── docs/                  # Documentation templates
│   ├── README-template.md
│   └── CONTRIBUTING.md
└── README.md              # This file
```

## Best Practices

### Security Workflow

✅ **Do:**
- Enable on all repositories
- Review and fix issues promptly
- Check weekly scan results
- Combine with GitHub's native features

❌ **Don't:**
- Disable without good reason
- Ignore workflow failures
- Use `.gitleaksignore` to hide real secrets
- Skip ShellCheck warnings in production scripts

### GitHub Native Features

✅ **Do:**
- Enable Dependabot on all repos
- Auto-merge non-breaking dependency updates
- Enable secret scanning for all repos
- Use CodeQL for critical applications

❌ **Don't:**
- Disable Dependabot alerts
- Ignore security advisories
- Commit secrets (rotate if leaked)

## Updating Templates

When templates are updated in this repo:

1. Pull latest changes
2. Copy updated files to your repos
3. Or re-run deployment script

## Contributing

To add new templates:

1. Create the template file
2. Add documentation to this README
3. Add to deployment scripts if applicable
4. Commit and push

## Support

For issues or questions:
- Check workflow logs: `https://github.com/<user>/<repo>/actions`
- Review documentation in this repo
- Open an issue in this repository

## License

MIT - Use these templates however you like!
