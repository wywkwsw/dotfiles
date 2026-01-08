#!/bin/bash
# Dotfiles Installation Script
# Prometheus v5.1 Configuration

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
CODEX_DIR="$HOME/.codex"
CLAUDE_DIR="$HOME/.claude"

echo "🚀 Prometheus Dotfiles Installer"
echo "================================="

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Extra backups (non-symlink files)
backup_if_present() {
    local target="$1"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "📦 Backing up: $target"
        cp -p "$target" "$BACKUP_DIR/"
    fi
}

backup_if_present "$HOME/.config/opencode/opencode.jsonc"
backup_if_present "$HOME/.config/opencode/oh-my-opencode.jsonc"

# Function to backup and link
backup_and_link() {
    local source="$1"
    local target="$2"
    
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "📦 Backing up: $target"
        cp -r "$target" "$BACKUP_DIR/"
    fi
    
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        rm -rf "$target"
    fi
    
    # Ensure parent directory exists
    mkdir -p "$(dirname "$target")"
    
    ln -s "$source" "$target"
    echo "🔗 Linked: $source -> $target"
}

# ===== Codex Configuration =====
echo ""
echo "📁 Setting up Codex configuration..."

mkdir -p "$CODEX_DIR"

backup_and_link "$DOTFILES_DIR/codex/AGENTS.md" "$CODEX_DIR/AGENTS.md"
backup_and_link "$DOTFILES_DIR/codex/CLAUDE.md" "$CODEX_DIR/CLAUDE.md"
backup_and_link "$DOTFILES_DIR/codex/prompts" "$CODEX_DIR/prompts"
backup_and_link "$DOTFILES_DIR/codex/skills" "$CODEX_DIR/skills"
backup_and_link "$DOTFILES_DIR/codex/rules" "$CODEX_DIR/rules"

# ===== Claude Configuration =====
echo ""
echo "📁 Setting up Claude configuration..."

mkdir -p "$CLAUDE_DIR"

backup_and_link "$DOTFILES_DIR/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
backup_and_link "$DOTFILES_DIR/claude/commands" "$CLAUDE_DIR/commands"
backup_and_link "$DOTFILES_DIR/claude/skills" "$CLAUDE_DIR/skills"

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
echo "📝 Next steps:"
echo "   1. Copy config template: cp $DOTFILES_DIR/config/codex-config.toml.template ~/.codex/config.toml"
echo "   2. Edit and add your API keys: vim ~/.codex/config.toml"
echo "   3. Restart Codex/Claude Code to load new configuration"
echo ""
echo "📦 Backup saved to: $BACKUP_DIR"
