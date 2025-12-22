#!/bin/bash
# Dotfiles Installation Script (Copy Mode)
# Prometheus v5.1 Configuration

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
CODEX_DIR="$HOME/.codex"
CLAUDE_DIR="$HOME/.claude"

echo "🚀 Prometheus Dotfiles Installer (Copy Mode)"
echo "============================================="

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to backup and copy
backup_and_copy() {
    local source="$1"
    local target="$2"
    
    if [ -e "$target" ]; then
        echo "📦 Backing up: $target"
        cp -r "$target" "$BACKUP_DIR/" 2>/dev/null || true
    fi
    
    # Ensure parent directory exists
    mkdir -p "$(dirname "$target")"
    
    if [ -d "$source" ]; then
        rm -rf "$target"
        cp -r "$source" "$target"
    else
        cp "$source" "$target"
    fi
    echo "📋 Copied: $source -> $target"
}

# ===== Codex Configuration =====
echo ""
echo "📁 Setting up Codex configuration..."

mkdir -p "$CODEX_DIR"
mkdir -p "$CODEX_DIR/prompts"
mkdir -p "$CODEX_DIR/skills"
mkdir -p "$CODEX_DIR/rules"

backup_and_copy "$DOTFILES_DIR/codex/AGENTS.md" "$CODEX_DIR/AGENTS.md"
backup_and_copy "$DOTFILES_DIR/codex/CLAUDE.md" "$CODEX_DIR/CLAUDE.md"

# Copy prompts
for file in "$DOTFILES_DIR/codex/prompts/"*; do
    [ -e "$file" ] && cp "$file" "$CODEX_DIR/prompts/"
done

# Copy skills
for skill_dir in "$DOTFILES_DIR/codex/skills/prometheus-"*; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        backup_and_copy "$skill_dir" "$CODEX_DIR/skills/$skill_name"
    fi
done
[ -f "$DOTFILES_DIR/codex/skills/README.md" ] && cp "$DOTFILES_DIR/codex/skills/README.md" "$CODEX_DIR/skills/"

# Copy rules
for file in "$DOTFILES_DIR/codex/rules/"*; do
    [ -e "$file" ] && cp "$file" "$CODEX_DIR/rules/"
done

# ===== Claude Configuration =====
echo ""
echo "📁 Setting up Claude configuration..."

mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/skills"

backup_and_copy "$DOTFILES_DIR/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

# Copy commands
for file in "$DOTFILES_DIR/claude/commands/"*; do
    [ -e "$file" ] && cp "$file" "$CLAUDE_DIR/commands/"
done

# Copy skills
for skill_dir in "$DOTFILES_DIR/claude/skills/prometheus-"*; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        backup_and_copy "$skill_dir" "$CLAUDE_DIR/skills/$skill_name"
    fi
done
[ -f "$DOTFILES_DIR/claude/skills/README.md" ] && cp "$DOTFILES_DIR/claude/skills/README.md" "$CLAUDE_DIR/skills/"

# ===== Setup Auto-Sync (macOS) =====
echo ""
echo "⏰ Setting up auto-sync..."

LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_FILE="$LAUNCH_AGENTS_DIR/com.dotfiles.sync.plist"

if [ "$(uname)" == "Darwin" ]; then
    mkdir -p "$LAUNCH_AGENTS_DIR"
    
    cat > "$PLIST_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.dotfiles.sync</string>
    <key>ProgramArguments</key>
    <array>
        <string>$DOTFILES_DIR/scripts/sync.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>3600</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/.dotfiles-sync.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.dotfiles-sync.log</string>
</dict>
</plist>
EOF

    launchctl unload "$PLIST_FILE" 2>/dev/null || true
    launchctl load "$PLIST_FILE"
    echo "✅ Auto-sync enabled (every hour)"
else
    echo "⚠️  Auto-sync only supported on macOS. For Linux, add to crontab:"
    echo "    0 * * * * $DOTFILES_DIR/scripts/sync.sh"
fi

# ===== Done =====
echo ""
echo "✅ Installation complete!"
echo ""
echo "📝 Sync workflow:"
echo "   1. Edit files in ~/.codex/ or ~/.claude/"
echo "   2. Run: ~/dotfiles/scripts/sync.sh (or wait for auto-sync)"
echo "   3. Changes will be copied to dotfiles and pushed to GitHub"
echo ""
echo "📦 Backup saved to: $BACKUP_DIR"
