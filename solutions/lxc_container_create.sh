API_TOKEN=$(cat .env | grep API_TOKEN | cut -d '=' -f2)
API_SECRET=$(cat .env | grep API_SECRET | cut -d '=' -f2)
API_NODE=$(cat .env | grep API_NODE | cut -d '=' -f2)
NODE=$(cat .env | grep TARGET_NODE | cut -d '=' -f2)

echo "Verifying if VMID 127 is already used"

response=$(curl \
  --request GET \
  --silent \
  --header "Authorization: PVEAPIToken=$API_TOKEN=$API_SECRET" \
  --url https://$API_NODE:8006/api2/json/nodes/$NODE/lxc/127)

echo "Response: $response"

if [ "$response" != "{\"data\":null}" ]; then
  echo "VMID $VMID is already used"
  exit 1
fi

echo "Creating container"

response=$(curl \
  --request POST \
  --silent \
  --url https://$API_NODE:8006/api2/json/nodes/$NODE/lxc \
  --header "Authorization: PVEAPIToken=$API_TOKEN=$API_SECRET" \
  --data vmid=127 \
  --data-urlencode ostemplate=local-hdd-templates:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst \
  --data-urlencode pool=ASD-202410 \
  --data-urlencode net0="name=eth0,bridge=vmbr2,firewall=1" \
  --data cores=1 \
  --data start=1 \
  --data-urlencode rootfs=local-nvme-datas:8)

echo "Response: $response"

echo "Container created"
