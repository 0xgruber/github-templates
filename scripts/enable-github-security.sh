#!/bin/bash

#############################################################################
# Enable GitHub Native Security Features
# 
# Enables Dependabot and other GitHub security features on all repositories
#############################################################################

set -euo pipefail

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

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║     Enable GitHub Security Features on All Repositories           ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

SUCCESS_COUNT=0
TOTAL_REPOS=${#REPOS[@]}

for repo in "${REPOS[@]}"; do
  echo "=== $repo ==="
  
  # Enable Dependabot alerts
  if gh api -X PUT "repos/${GITHUB_USER}/${repo}/vulnerability-alerts" &>/dev/null; then
    echo "  ✓ Dependabot alerts enabled"
    ((SUCCESS_COUNT++)) || true
  else
    echo "  ✗ Dependabot alerts: Failed or already enabled"
  fi
  
  # Enable Dependabot security updates
  if gh api -X PUT "repos/${GITHUB_USER}/${repo}/automated-security-fixes" &>/dev/null; then
    echo "  ✓ Dependabot security updates enabled"
  else
    echo "  ✗ Dependabot security updates: Failed or already enabled"
  fi
  
  # Check if repo is public
  VISIBILITY=$(gh repo view "${GITHUB_USER}/${repo}" --json visibility -q .visibility)
  if [[ "$VISIBILITY" == "public" ]]; then
    echo "  ✓ Secret scanning: Auto-enabled (public repo)"
    echo "  ✓ Dependency review: Auto-enabled (public repo)"
  else
    echo "  ℹ Secret scanning: Requires GitHub Advanced Security (private repo)"
    echo "  ℹ Dependency review: Limited for private repos"
  fi
  
  echo ""
done

echo "════════════════════════════════════════════════════════════════════"
echo ""
echo "✓ Security features enabled on $SUCCESS_COUNT/$TOTAL_REPOS repos!"
echo ""
echo "Next steps:"
echo "  1. Visit https://github.com/$GITHUB_USER/<repo>/security to verify"
echo "  2. Review any initial security alerts"
echo "  3. Configure notification preferences"
echo "  4. Consider enabling CodeQL code scanning"
echo ""
echo "Documentation:"
echo "  - github-templates/docs/ENABLE-GITHUB-SECURITY.md"
echo ""
