#!/bin/bash
# Dotfiles Auto-Sync Script
# Prometheus v5.1 Configuration

DOTFILES_DIR="$HOME/dotfiles"
LOG_FILE="$HOME/.dotfiles-sync.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cd "$DOTFILES_DIR" || exit 1

# Check if there are any changes
if git diff --quiet && git diff --cached --quiet; then
    # Check for untracked files
    UNTRACKED=$(git ls-files --others --exclude-standard)
    if [ -z "$UNTRACKED" ]; then
        log "📋 No changes to sync"
        exit 0
    fi
fi

log "🔄 Syncing dotfiles..."

# Pull latest changes first (with rebase to avoid merge commits)
log "⬇️  Pulling latest changes..."
git pull --rebase origin main 2>&1 | tee -a "$LOG_FILE" || {
    log "⚠️  Pull failed, attempting to continue..."
}

# Add all changes
git add -A

# Get a meaningful commit message
CHANGES=$(git diff --cached --name-only | head -5 | tr '\n' ', ' | sed 's/,$//')
if [ -z "$CHANGES" ]; then
    log "📋 No staged changes"
    exit 0
fi

COMMIT_MSG="sync: $(date '+%Y-%m-%d %H:%M') - $CHANGES"

# Commit
log "📝 Committing: $COMMIT_MSG"
git commit -m "$COMMIT_MSG" 2>&1 | tee -a "$LOG_FILE"

# Push
log "⬆️  Pushing to origin..."
git push origin main 2>&1 | tee -a "$LOG_FILE" && {
    log "✅ Sync complete!"
} || {
    log "❌ Push failed. Will retry next cycle."
    exit 1
}

