#!/bin/bash
set -e

REPO_USER="diligentmoves"
REPO_NAME="mautic-docker-deploy"
BRANCH="main"
TARGET_DIR="mautic-docker-deploy"

echo "🧹 Cleaning up old containers and folders..."
docker rm -f mautic-web mautic-db mautic-cron mautic-worker traefik 2>/dev/null || true
rm -rf ~/$TARGET_DIR
mkdir -p ~/$TARGET_DIR
cd ~/$TARGET_DIR

echo "📦 Downloading project from GitHub..."
wget -q https://github.com/$REPO_USER/$REPO_NAME/archive/refs/heads/$BRANCH.zip -O mautic.zip
unzip -q mautic.zip
mv "$REPO_NAME-$BRANCH"/* .
rm -rf "$REPO_NAME-$BRANCH" mautic.zip

echo "📝 Please review and update your .env file..."
sleep 1
nano .env

echo "🚀 Launching Mautic stack..."
docker compose --env-file .env up -d --build

echo "✅ Done! Visit your Mautic site to complete setup:"
echo "   👉 https://$(grep MAUTIC_DOMAIN .env | cut -d '=' -f2)"
