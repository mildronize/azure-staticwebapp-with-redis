# -----------------------------
# ตัวแปรหลัก (ปรับตามต้องการ)
# -----------------------------
RG=demo-redis-serverless
LOC=southeastasia
VNET=aca-vnet
SUBNET=demo-workload
ENV=redis-env
APP=redis

REDIS_USER=myuser
REDIS_PASS=s3cr3tP@ss

# 1) VNet + Subnet (/23 ตามข้อกำหนด Consumption)
echo "create network $VNET and subnet $SUBNET in resource group $RG"
az network vnet create -g $RG -n $VNET \
  --address-prefix 10.10.0.0/16 \
  --subnet-name $SUBNET --subnet-prefix 10.10.0.0/23

echo "Created VNet $VNET and Subnet $SUBNET in resource group $RG"

echo "Getting Virtual Network $VNET in resource group $RG"
# 2) สร้าง Environment แบบ VNet‑injected
SUBNET_ID=$(az network vnet subnet show -g $RG -n $SUBNET \
             --vnet-name $VNET --query id -o tsv)

echo "Delegating subnet $SUBNET to Microsoft.App/environments"
az network vnet subnet update \
  -g $RG --vnet-name $VNET --name $SUBNET \
  --delegations Microsoft.App/environments

echo "Creating Container Apps Environment $ENV in resource group $RG"
az containerapp env create -g $RG -n $ENV -l $LOC \
  --infrastructure-subnet-resource-id $SUBNET_ID

echo "Container Apps Environment mode";
az containerapp env show -g $RG -n $ENV \
  --query "{name:name, type:properties.environmentType, profiles:properties.workloadProfiles[].name}"


# No Log Analytics workspace provided.
# Generating a Log Analytics workspace with name "workspace-demoredisserverless3QK2"

echo "Created Container Apps Environment $ENV in resource group $RG"
# 3) Deploy Redis ‑‑ 0.5 vCPU + 0.5 GiB (≈ 512 MiB)
az containerapp create -g $RG -n $APP --environment $ENV \
  --image redis:7 \
  --ingress external --transport tcp --target-port 6379 \
  --cpu 0.25 --memory 0.5Gi \
  --scale-rule-name tcp --scale-rule-type tcp \
  --scale-rule-tcp-concurrency 50 \
  --min-replicas 0 --max-replicas 1


echo "Setting up secrets for Redis serverless app"
az containerapp secret set -g $RG -n $APP \
  --secrets redis-user=$ACA_REDIS_USER redis-pass='$ACA_REDIS_PASS'

echo "Setting up user/pass for Redis serverless app"
az containerapp update -g $RG -n $APP \
  --image redis:7 \
  --set-env-vars REDIS_USER=secretref:redis-user REDIS_PASS=secretref:redis-pass \
  --command /bin/sh \
  --args "-c" "printf 'user \$REDIS_USER on >\$REDIS_PASS ~* +@all\nuser default off' >/tmp/users.acl && \
                redis-server --aclfile /tmp/users.acl --port 6379 --save \"\" --appendonly no"


# 2. รอให้ revision deploy เสร็จ (อาจต้อง sleep 30-90s)
echo "Waiting for container app to restart..."
sleep 40

# 3. Get FQDN ของ Container App
ACA_FQDN=$(az containerapp show -g $RG -n $APP --query properties.configuration.ingress.fqdn -o tsv)
echo "FQDN: $ACA_FQDN"

# 4. ลอง ping ด้วย redis-cli (บนเครื่อง dev ต้องเปิดพอร์ต/allow ก่อน)
echo "Check redis ping"
redis-cli -h $ACA_FQDN -p 6379 --user $REDIS_USER --pass $REDIS_PASS PING

