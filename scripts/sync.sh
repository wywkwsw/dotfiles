#!/bin/bash
# Dotfiles Auto-Sync Script
# Prometheus v5.1 Configuration

DOTFILES_DIR="$HOME/dotfiles"
LOG_FILE="$HOME/.dotfiles-sync.log"
GEMINI_DIR="$HOME/.gemini"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

copy_file_if_exists() {
    local src="$1"
    local dest="$2"

    if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
    fi
}

copy_tree_if_exists() {
    local src="$1"
    local dest="$2"

    if [ -d "$src" ]; then
        mkdir -p "$dest"
        cp -R "$src"/. "$dest/"
    fi
}

cd "$DOTFILES_DIR" || exit 1

# ===== Step 1: Pull latest from source directories =====
log "📥 Pulling latest configs from source..."

# Codex configs
cp "$HOME/.codex/AGENTS.md" "$DOTFILES_DIR/codex/" 2>/dev/null
cp "$HOME/.codex/CLAUDE.md" "$DOTFILES_DIR/codex/" 2>/dev/null
cp -r "$HOME/.codex/prompts/"* "$DOTFILES_DIR/codex/prompts/" 2>/dev/null
cp -r "$HOME/.codex/rules/"* "$DOTFILES_DIR/codex/rules/" 2>/dev/null
# Skills (only prometheus-* to avoid .system)
for skill in "$HOME/.codex/skills/prometheus-"*; do
    [ -d "$skill" ] && cp -r "$skill" "$DOTFILES_DIR/codex/skills/"
done
cp "$HOME/.codex/skills/README.md" "$DOTFILES_DIR/codex/skills/" 2>/dev/null

# Claude configs
cp "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/claude/" 2>/dev/null
cp -r "$HOME/.claude/commands/"* "$DOTFILES_DIR/claude/commands/" 2>/dev/null
# Skills (only prometheus-* to avoid copy folders)
for skill in "$HOME/.claude/skills/prometheus-"*; do
    [ -d "$skill" ] && cp -r "$skill" "$DOTFILES_DIR/claude/skills/"
done
cp "$HOME/.claude/skills/README.md" "$DOTFILES_DIR/claude/skills/" 2>/dev/null

# Gemini configs (explicit files/directories only)
copy_file_if_exists "$GEMINI_DIR/settings.json" "$DOTFILES_DIR/gemini/settings.json"
copy_file_if_exists "$GEMINI_DIR/GEMINI.md" "$DOTFILES_DIR/gemini/GEMINI.md"
copy_tree_if_exists "$GEMINI_DIR/skills" "$DOTFILES_DIR/gemini/skills"

# ===== Step 2: Check for changes =====
if git diff --quiet && git diff --cached --quiet; then
    UNTRACKED=$(git ls-files --others --exclude-standard)
    if [ -z "$UNTRACKED" ]; then
        log "📋 No changes to sync"
        exit 0
    fi
fi

log "🔄 Syncing dotfiles..."

# ===== Step 3: Pull latest from remote (rebase) =====
log "⬇️  Pulling latest from remote..."
git pull --rebase origin main 2>&1 | tee -a "$LOG_FILE" || {
    log "⚠️  Pull failed, attempting to continue..."
}

# ===== Step 4: Commit and push =====
git add -A

CHANGES=$(git diff --cached --name-only | head -5 | tr '\n' ', ' | sed 's/,$//')
if [ -z "$CHANGES" ]; then
    log "📋 No staged changes"
    exit 0
fi

COMMIT_MSG="sync: $(date '+%Y-%m-%d %H:%M') - $CHANGES"

log "📝 Committing: $COMMIT_MSG"
git commit -m "$COMMIT_MSG" 2>&1 | tee -a "$LOG_FILE"

log "⬆️  Pushing to origin..."
git push origin main 2>&1 | tee -a "$LOG_FILE" && {
    log "✅ Sync complete!"
} || {
    log "❌ Push failed. Will retry next cycle."
    exit 1
}
