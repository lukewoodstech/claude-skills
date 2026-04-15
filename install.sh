#!/usr/bin/env bash
set -euo pipefail

REPO="lukewoodstech/claude-skills"
BRANCH="main"
TARBALL_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"

usage() {
  echo "Usage:"
  echo "  ./install.sh <skill-name>   Install a skill into .claude/skills/ in the current directory"
  echo "  ./install.sh --list         List all available skills"
  echo ""
  echo "Examples:"
  echo "  ./install.sh grill-me"
  echo "  ./install.sh --list"
}

fetch_tarball() {
  local tmpdir
  tmpdir=$(mktemp -d)
  curl -fsSL "$TARBALL_URL" | tar -xz -C "$tmpdir" --strip-components=1 2>/dev/null
  echo "$tmpdir"
}

list_skills() {
  echo "Fetching available skills from ${REPO}..."
  local tmpdir
  tmpdir=$(fetch_tarball)

  local skills=()
  for dir in "$tmpdir/skills"/*/; do
    [ -d "$dir" ] && skills+=("$(basename "$dir")")
  done

  if [ ${#skills[@]} -eq 0 ]; then
    echo "No skills found."
  else
    echo ""
    echo "Available skills:"
    for skill in "${skills[@]}"; do
      local skill_file="$tmpdir/skills/$skill/SKILL.md"
      if [ -f "$skill_file" ]; then
        local desc
        desc=$(grep -m1 '^description:' "$skill_file" | sed 's/^description: *//' | tr -d '"' | cut -c1-80)
        printf "  %-20s %s\n" "$skill" "$desc"
      else
        printf "  %s\n" "$skill"
      fi
    done
  fi

  rm -rf "$tmpdir"
}

install_skill() {
  local skill_name="$1"
  local dest=".claude/skills/${skill_name}"

  if [ -d "$dest" ]; then
    echo "Skill '${skill_name}' is already installed at ${dest}"
    echo "Remove it first to reinstall: rm -rf ${dest}"
    exit 1
  fi

  echo "Downloading skill '${skill_name}' from ${REPO}..."
  local tmpdir
  tmpdir=$(fetch_tarball)

  local skill_src="$tmpdir/skills/${skill_name}"
  if [ ! -d "$skill_src" ]; then
    rm -rf "$tmpdir"
    echo "Error: skill '${skill_name}' not found in ${REPO}"
    echo "Run './install.sh --list' to see available skills."
    exit 1
  fi

  mkdir -p ".claude/skills"
  cp -r "$skill_src" "$dest"
  rm -rf "$tmpdir"
  echo "Installed '${skill_name}' to ${dest}"
}

# --- Main ---

if [ $# -eq 0 ]; then
  usage
  exit 1
fi

case "$1" in
  --list|-l)
    list_skills
    ;;
  --help|-h)
    usage
    ;;
  -*)
    echo "Unknown flag: $1"
    usage
    exit 1
    ;;
  *)
    install_skill "$1"
    ;;
esac
