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

echo "📂 Unzipping project..."
unzip -q mautic.zip
mv "$REPO_NAME-$BRANCH"/* .
rm -rf "$REPO_NAME-$BRANCH" mautic.zip

echo "✅ All files downloaded and ready."

# Ensure .env exists
if [ ! -f .env ]; then
  echo "⚠️  .env file not found. Creating a default one..."
  cat > .env <<EOF
MYSQL_ROOT_PASSWORD=supersecret
MYSQL_DATABASE=mautic
MYSQL_USER=mautic_user
MYSQL_PASSWORD=mauticpass

MAUTIC_DOMAIN=mautic.yourdomain.com
EMAIL=admin@yourdomain.com
EOF
fi

# Ensure .mautic_env exists
if [ ! -f .mautic_env ]; then
  echo "⚠️  .mautic_env file not found. Creating a default one..."
  cat > .mautic_env <<EOF
MAUTIC_DB_HOST=db
MAUTIC_DB_NAME=mautic
MAUTIC_DB_USER=mautic_user
MAUTIC_DB_PASSWORD=mauticpass
MAUTIC_RUN_CRON_JOBS=true
EOF
fi

echo "📝 Opening .env for review..."
sleep 1
nano .env

echo "📝 Opening .mautic_env for review..."
sleep 1
nano .mautic_env

echo "🚀 Launching Mautic stack..."
docker compose --env-file .env up -d --build

echo "✅ Done! Visit your Mautic site to complete setup:"
echo "   👉 https://$(grep MAUTIC_DOMAIN .env | cut -d '=' -f2)"
