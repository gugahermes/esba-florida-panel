#!/bin/bash
# Script para publicar el panel ESBA Florida (Cloudflare Pages)
# Ejecutar desde Terminal: bash push_to_github.sh

REPO_DIR="/Users/gugahermes/Documents/Claude/Projects/ESBA Florida (1)"
GITHUB_USER="gugahermes"
REPO_NAME="esba-florida-panel"

cd "$REPO_DIR"

echo "📁 Directorio: $REPO_DIR"
echo "🔗 Repo: https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""

# Inicializar git si no existe
if [ ! -d ".git" ]; then
  echo "⚙️  Inicializando git..."
  git init
  git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
else
  echo "✓ Git ya inicializado"
  # Asegurar que el remote apunte al repo correcto
  git remote set-url origin "https://github.com/$GITHUB_USER/$REPO_NAME.git" 2>/dev/null || \
  git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
fi

# Configurar usuario si no está configurado
git config user.name "gugahermes" 2>/dev/null
git config user.email "agente.ia@esbaflorida.edu.ar" 2>/dev/null

# Agregar y commitear
echo "📦 Preparando commit..."
git add panel_esba_florida_2025.html
git commit -m "Panel ESBA Florida 2026 - $(date '+%d/%m/%Y %H:%M')" 2>/dev/null || \
git commit --allow-empty -m "Update panel - $(date '+%d/%m/%Y %H:%M')"

# Push al branch main
echo "🚀 Subiendo a GitHub..."
git push origin main

echo ""
echo "✅ Listo. El panel estará disponible en:"
echo "   https://esba-florida-panel.pages.dev/ (Cloudflare Pages, redeploy automático)"
echo ""
echo "El archivo _redirects hace que la raíz '/' sirva panel_esba_florida_2025.html"
echo "directamente — no hace falta (ni hay que volver a crear) un index.html duplicado."
