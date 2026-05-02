#!/bin/bash
# Auto-push hacking path site to GitHub every Sunday at 8:30 PM
# Triggered by launchd — runs silently in background

REPO_DIR="$HOME/Documents/CloudeCowork/Hacking"
LOG_FILE="$REPO_DIR/autopush.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

cd "$REPO_DIR" || { echo "[$TIMESTAMP] ERROR: Could not cd to $REPO_DIR" >> "$LOG_FILE"; exit 1; }

# Configure git identity
git config user.email "antonioreyesnava@gmail.com"
git config user.name "TonoRey"

# Set remote with token (in case it needs refreshing)
git remote set-url origin https://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@github.com/TonoRey/hacking-path.git 2>/dev/null

# Check if there are changes to push
if git diff --quiet HEAD -- index.html 2>/dev/null && git diff --cached --quiet -- index.html 2>/dev/null; then
  echo "[$TIMESTAMP] No changes to push." >> "$LOG_FILE"
  exit 0
fi

# Stage, commit, pull rebase, push
git add index.html
git commit -m "Weekly auto-update - $(date '+%Y-%m-%d')"
git pull --rebase origin main >> "$LOG_FILE" 2>&1
git push origin main >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
  echo "[$TIMESTAMP] SUCCESS: Pushed to GitHub. Site live at https://protuberito.netlify.app" >> "$LOG_FILE"
else
  echo "[$TIMESTAMP] ERROR: Push failed. Check log above." >> "$LOG_FILE"
fi
