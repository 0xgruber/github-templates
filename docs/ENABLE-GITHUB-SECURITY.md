# Enabling GitHub Native Security Features

This guide shows how to enable GitHub's built-in security features on all repositories. These features are **FREE for public repositories** and complement our custom security workflows.

## GitHub's Native Security Features

### 1. Dependabot (Automatic Dependency Updates)

**What it does:**
- Scans dependencies for known vulnerabilities
- Creates PRs to update vulnerable packages
- Keeps dependencies up-to-date automatically

**How to enable via GitHub CLI:**

```bash
# Enable Dependabot alerts
gh api -X PUT repos/{owner}/{repo}/vulnerability-alerts

# Enable Dependabot security updates (requires alerts enabled first)
gh api -X PUT repos/{owner}/{repo}/automated-security-fixes
```

**How to enable via Web UI:**
1. Go to repository Settings
2. Navigate to Security & analysis
3. Enable "Dependabot alerts"
4. Enable "Dependabot security updates"

### 2. Secret Scanning

**What it does:**
- Scans commits for known secret patterns
- Partners notify about leaked tokens
- Prevents accidental credential leaks

**Availability:**
- ✅ **FREE** for public repositories (auto-enabled)
- 💰 **Paid** for private repos (requires GitHub Advanced Security)

**How to enable (public repos):**
- Automatically enabled, no action needed
- Verify: Settings → Security & analysis → Secret scanning

**How to enable (private repos with GH Advanced Security):**
```bash
gh api -X PUT repos/{owner}/{repo}/security-and-analysis/secret_scanning
```

### 3. Code Scanning (CodeQL)

**What it does:**
- Advanced semantic code analysis
- Finds security vulnerabilities in source code
- Detects: SQL injection, XSS, command injection, etc.

**Availability:**
- ✅ **FREE** for public repositories
- 💰 **Paid** for private repos (requires GitHub Advanced Security)

**How to enable:**

**Option A - Via GitHub CLI:**
```bash
# This creates a CodeQL workflow file
gh workflow create

# Or manually add CodeQL workflow
cat > .github/workflows/codeql.yml << 'EOF'
name: "CodeQL"
on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  schedule:
    - cron: '0 0 * * 1'

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write
    strategy:
      matrix:
        language: [ 'python', 'javascript' ]  # Adjust per repo
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v2
        with:
          languages: ${{ matrix.language }}
      - uses: github/codeql-action/autobuild@v2
      - uses: github/codeql-action/analyze@v2
EOF
```

**Option B - Via Web UI:**
1. Go to Settings → Security & analysis
2. Click "Set up" under Code scanning
3. Choose "CodeQL Analysis"
4. Select languages
5. Commit the workflow

### 4. Dependency Review

**What it does:**
- Shows vulnerable dependencies in pull requests
- Blocks merges with critical vulnerabilities
- No setup required

**How to enable:**
- Automatically enabled for public repos
- No action needed

**Optional: Enforce with GitHub Actions:**
```yaml
name: Dependency Review
on: [pull_request]
jobs:
  dependency-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/dependency-review-action@v4
```

## Bulk Enable Script

Enable all features on all public repos at once:

```bash
#!/bin/bash
# enable-github-security.sh

REPOS=(
  "password-store"
  "threat-intelligence-mailbox"
  "winget-frontend"
  "python-scripts"
  "fedora-optimization"
  "nixos-config"
  "linux-scripts"
  "wallpapers"
  "linux-health-checks"
  "repo-migration-scripts"
  "github-templates"
)

GITHUB_USER="0xgruber"

for repo in "${REPOS[@]}"; do
  echo "=== Enabling security features for $repo ==="
  
  # Enable Dependabot alerts
  gh api -X PUT "repos/${GITHUB_USER}/${repo}/vulnerability-alerts" 2>/dev/null && \
    echo "✓ Dependabot alerts enabled" || echo "✗ Failed or already enabled"
  
  # Enable Dependabot security updates
  gh api -X PUT "repos/${GITHUB_USER}/${repo}/automated-security-fixes" 2>/dev/null && \
    echo "✓ Dependabot security updates enabled" || echo "✗ Failed or already enabled"
  
  # Secret scanning (auto-enabled for public repos)
  echo "✓ Secret scanning auto-enabled (public repo)"
  
  echo ""
done

echo "✓ Security features enabled on all repos!"
echo ""
echo "Next steps:"
echo "1. Go to each repo's Security tab to verify"
echo "2. Review any initial alerts"
echo "3. Consider enabling CodeQL for code scanning"
```

## Verify Everything is Enabled

Check a repository's security status:

```bash
gh api repos/{owner}/{repo} | jq '{
  name: .name,
  visibility: .visibility,
  dependabot_alerts: .has_vulnerability_alerts_enabled,
  secret_scanning: (if .visibility == "public" then "auto-enabled" else "check manually" end)
}'
```

Or visit each repo's Security tab:
```
https://github.com/{owner}/{repo}/security
```

## Security Feature Comparison

| Feature | GitHub Native | Our Custom Workflow |
|---------|---------------|---------------------|
| **Secret Scanning** | ✅ Public repos (free)<br>💰 Private repos (paid) | ✅ All repos (Gitleaks) |
| **Dependency Scanning** | ✅ All repos (Dependabot) | ✅ All repos (Dependency Review action) |
| **Code Scanning** | ✅ Public repos (CodeQL)<br>💰 Private repos (paid) | ❌ Not included |
| **Shell Script Linting** | ❌ Not included | ✅ All repos (ShellCheck) |
| **Weekly Scheduled Scans** | ✅ Can configure | ✅ Included (Mondays) |

## Recommendation

**For Public Repos:** Use BOTH
- Enable GitHub native features (free and powerful)
- Keep custom workflow for ShellCheck and extra coverage

**For Private Repos:**
- Use custom workflows (free)
- Consider GitHub Advanced Security if budget allows

## Next Steps

1. Run the bulk enable script above
2. Review initial security alerts
3. Set up notification preferences (Settings → Notifications → Security alerts)
4. Configure Dependabot for auto-merge of non-breaking updates
