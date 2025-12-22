#!/bin/bash
# Dotfiles Auto-Sync Script (Copy Mode)
# Prometheus v5.1 Configuration

DOTFILES_DIR="$HOME/dotfiles"
CODEX_DIR="$HOME/.codex"
CLAUDE_DIR="$HOME/.claude"
LOG_FILE="$HOME/.dotfiles-sync.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cd "$DOTFILES_DIR" || exit 1

log "🔄 Starting sync..."

# ===== Step 1: Copy from source directories =====
log "📋 Copying from .codex and .claude..."

# Codex files
cp "$CODEX_DIR/AGENTS.md" "$DOTFILES_DIR/codex/" 2>/dev/null
cp "$CODEX_DIR/CLAUDE.md" "$DOTFILES_DIR/codex/" 2>/dev/null
cp -r "$CODEX_DIR/prompts/"* "$DOTFILES_DIR/codex/prompts/" 2>/dev/null
cp -r "$CODEX_DIR/rules/"* "$DOTFILES_DIR/codex/rules/" 2>/dev/null

# Codex skills (only prometheus-* skills)
mkdir -p "$DOTFILES_DIR/codex/skills"
cp "$CODEX_DIR/skills/README.md" "$DOTFILES_DIR/codex/skills/" 2>/dev/null
for skill_dir in "$CODEX_DIR/skills/prometheus-"*; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        rm -rf "$DOTFILES_DIR/codex/skills/$skill_name"
        cp -r "$skill_dir" "$DOTFILES_DIR/codex/skills/"
    fi
done

# Claude files
cp "$CLAUDE_DIR/CLAUDE.md" "$DOTFILES_DIR/claude/" 2>/dev/null
cp -r "$CLAUDE_DIR/commands/"* "$DOTFILES_DIR/claude/commands/" 2>/dev/null

# Claude skills (only prometheus-* skills)
mkdir -p "$DOTFILES_DIR/claude/skills"
cp "$CLAUDE_DIR/skills/README.md" "$DOTFILES_DIR/claude/skills/" 2>/dev/null
for skill_dir in "$CLAUDE_DIR/skills/prometheus-"*; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        rm -rf "$DOTFILES_DIR/claude/skills/$skill_name"
        cp -r "$skill_dir" "$DOTFILES_DIR/claude/skills/"
    fi
done

log "✅ Files copied"

# ===== Step 2: Check for changes =====
if git diff --quiet && git diff --cached --quiet; then
    UNTRACKED=$(git ls-files --others --exclude-standard)
    if [ -z "$UNTRACKED" ]; then
        log "📋 No changes to sync"
        exit 0
    fi
fi

# ===== Step 3: Pull latest (avoid conflicts) =====
log "⬇️  Pulling latest..."
git pull --rebase origin main 2>&1 | tee -a "$LOG_FILE" || {
    log "⚠️  Pull failed, continuing..."
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

log "⬆️  Pushing..."
git push origin main 2>&1 | tee -a "$LOG_FILE" && {
    log "✅ Sync complete!"
} || {
    log "❌ Push failed"
    exit 1
}
