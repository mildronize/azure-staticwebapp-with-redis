# -----------------------------
# ตัวแปรหลัก (ปรับตามต้องการ)
# -----------------------------
RG=rg
LOC=southeastasia
VNET=aca-vnet
SUBNET=workload
ENV=redis-env
APP=redis

# 1) VNet + Subnet (/23 ตามข้อกำหนด Consumption)
az network vnet create -g $RG -n $VNET \
  --address-prefix 10.10.0.0/16 \
  --subnet-name $SUBNET --subnet-prefix 10.10.0.0/23

# 2) สร้าง Environment แบบ VNet‑injected
SUBNET_ID=$(az network vnet subnet show -g $RG -n $SUBNET \
             --vnet-name $VNET --query id -o tsv)

az containerapp env create -g $RG -n $ENV -l $LOC \
  --infrastructure-subnet-resource-id $SUBNET_ID

# 3) Deploy Redis ‑‑ 0.5 vCPU + 0.5 GiB (≈ 512 MiB)
az containerapp create -g $RG -n $APP --environment $ENV \
  --image redis:7 \
  --ingress external --transport tcp --target-port 6379 \
  --cpu 0.5 --memory 0.5Gi \
  --scale-rule-name tcp --scale-rule-type tcp \
  --scale-rule-concurrent-connections 50 \
  --min-replicas 0 --max-replicas 3
