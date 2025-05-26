#!/bin/bash

# Variáveis
RESOURCE_GROUP="rg-docker"
LOCATION="eastus2"
VM_NAME="vm-docker"
IMAGE="dockerinc1694120899427:devbox_azuremachine:devboxlicensefpromo:4.38.0"
# Comando para procurar a imagem no Marketplace
# az vm image list --all -p docker -o table
#
SIZE="Standard_D2s_v3"
ADMIN_USERNAME="admin_fiap"
ADMIN_PASSWORD="admin_fiap@123"
DISK_SKU="StandardSSD_LRS"
PORT=3389
SHUTDOWN_TIME="0230" ## Deve ser o UTC (Brasil está a -3 horas) / Ese exeplo desliga a VM às 23:30h horário de Brasília

# Criar grupo de recursos
echo "Criando grupo de recursos: $RESOURCE_GROUP..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Aceitar os Termos legais da Imagem
echo "Aceitando os Termos Legais da Imagem..."
az vm image terms accept --urn dockerinc1694120899427:devbox_azuremachine:devboxlicensefpromo:4.38.0

# Criar a VM
echo "Criando a máquina virtual: $VM_NAME..."
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image $IMAGE \
  --size $SIZE \
  --authentication-type password \
  --admin-username $ADMIN_USERNAME \
  --admin-password $ADMIN_PASSWORD \
  --storage-sku $DISK_SKU \
  --public-ip-sku Basic

# Abrir a porta RDP
echo "Abrindo porta $PORT para RDP..."
az vm open-port --port $PORT --resource-group $RESOURCE_GROUP --name $VM_NAME

# Ativar desligamento automático
echo "Configurando desligamento automático às $SHUTDOWN_TIME (UTC)..."
az vm auto-shutdown \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --time $SHUTDOWN_TIME

echo "✅   Provisionamento completo!"
