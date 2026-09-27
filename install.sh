#!/usr/bin/env bash
# install.sh — Install skills into Claude Code and/or Codex (Grok reads ~/.claude/skills too)
# Usage: ./install.sh [skill-name]   # install one skill
#        ./install.sh                # install all skills

set -euo pipefail

SKILLS_SRC="$(cd "$(dirname "$0")/skills" && pwd)"
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
CODEX_SKILLS_DIR="$HOME/.codex/skills"
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}!${NC} $*"; }
err()  { echo -e "${RED}✗${NC} $*"; }

# link <src> <target> <label> — create or repoint a symlink; never replaces a real file
link() {
  local src="$1" target="$2" label="$3"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
    ok "$label (already linked)"
  elif [ -e "$target" ] && [ ! -L "$target" ]; then
    warn "$label: $target exists and is not a symlink, skipping"
  else
    ln -sfn "$src" "$target"
    ok "$label → $target"
  fi
}

has_claude() { [ -d "$CLAUDE_SKILLS_DIR" ]; }
has_codex()  { [ -d "$CODEX_SKILLS_DIR" ]; }

install_skill() {
  local skill_name="$1"
  local skill_src="$SKILLS_SRC/$skill_name"

  if [ ! -d "$skill_src" ]; then
    err "Skill not found: $skill_name (looked in $skill_src)"
    return 1
  fi

  local installed=0

  if has_claude; then
    link "$skill_src" "$CLAUDE_SKILLS_DIR/$skill_name" "Claude Code: $skill_name"
    # Subagent definitions shipped with a skill (skills/<name>/agents/*.md)
    for agent in "$skill_src"/agents/*.md; do
      [ -f "$agent" ] || continue
      mkdir -p "$CLAUDE_AGENTS_DIR"
      link "$agent" "$CLAUDE_AGENTS_DIR/$(basename "$agent")" "Claude Code agent: $(basename "$agent" .md)"
    done
    installed=$((installed + 1))
  else
    warn "Claude Code skills dir not found ($CLAUDE_SKILLS_DIR), skipping"
  fi

  if has_codex; then
    link "$skill_src" "$CODEX_SKILLS_DIR/$skill_name" "Codex: $skill_name"
    installed=$((installed + 1))
  else
    warn "Codex skills dir not found ($CODEX_SKILLS_DIR), skipping"
  fi

  if [ "$installed" -eq 0 ]; then
    err "Neither Claude Code nor Codex skills dir found — nothing installed"
    return 1
  fi
}

main() {
  if [ $# -eq 1 ]; then
    install_skill "$1"
  else
    # Install all skills
    local count=0
    for skill_dir in "$SKILLS_SRC"/*/; do
      [ -d "$skill_dir" ] || continue
      skill_name="$(basename "$skill_dir")"
      install_skill "$skill_name"
      count=$((count + 1))
    done
    echo ""
    echo "Installed $count skill(s)."
  fi
}

main "$@"
