# claude-skills

My personal collection of Claude Code skills. Install any skill into a project with a single command.

## Install a skill

From inside any project directory:

```bash
~/build/claude-skills/install.sh grill-me
```

This creates `.claude/skills/grill-me/` in the current directory.

### One-liner (no clone required)

```bash
curl -fsSL https://raw.githubusercontent.com/lukewoodstech/claude-skills/main/install.sh | bash -s -- grill-me
```

## List available skills

```bash
~/build/claude-skills/install.sh --list
```

## Convenience alias

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
alias skill="~/build/claude-skills/install.sh"
```

Then use it from any project:

```bash
skill grill-me
skill --list
```

## Adding a new skill

1. Create a directory under `skills/`:
   ```
   skills/my-skill/
   └── SKILL.md
   ```

2. `SKILL.md` requires a frontmatter block at the top:
   ```markdown
   ---
   name: my-skill
   description: One-line description of when Claude should use this skill.
   ---

   Your skill instructions here...
   ```

3. Commit and push — it's immediately available to install.

## Skills

| Skill | Description |
|-------|-------------|
| [grill-me](skills/grill-me/SKILL.md) | Interview the user relentlessly about a plan or design until reaching shared understanding |
