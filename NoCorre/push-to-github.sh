#!/bin/bash

# Script para inicializar e fazer push do NoCorre ao GitHub

echo "🚀 NoCorre — Iniciando push ao GitHub"
echo ""

# Configurações
REPO_URL="https://github.com/eucarolinapimenta-crypto/NoCorre"
REPO_DIR="NoCorre"

# Verificar se já existe diretório
if [ -d "$REPO_DIR" ]; then
    echo "⚠️  Diretório $REPO_DIR já existe"
    read -p "Deseja sobrescrever? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        rm -rf "$REPO_DIR"
    else
        echo "❌ Operação cancelada"
        exit 1
    fi
fi

# Criar diretório
echo "📁 Criando estrutura do projeto..."
mkdir -p "$REPO_DIR"
cd "$REPO_DIR"

# Copiar arquivos já criados (você vai fazer isso)
# Por enquanto, mostrar os arquivos que precisam ser copiados
echo ""
echo "✅ Estrutura criada em: $(pwd)"
echo ""
echo "Próximos passos:"
echo "1. Copie os arquivos de /home/claude/NoCorre-scaffold para $REPO_DIR"
echo "2. Execute:"
echo ""
echo "   cd $REPO_DIR"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial commit: NoCorre Companion App scaffold'"
echo "   git branch -M main"
echo "   git remote add origin $REPO_URL"
echo "   git push -u origin main"
echo ""
echo "Ou copie e cole este comando único:"
echo ""
echo "git init && git add . && git commit -m 'Initial commit: NoCorre Companion App scaffold' && git branch -M main && git remote add origin $REPO_URL && git push -u origin main"
echo ""
