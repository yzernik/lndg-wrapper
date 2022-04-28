#!/bin/bash
set -e
_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$backend_process" 2>/dev/null
}

TOR_ADDRESS=$(yq e '.tor-address' /root/start9/config.yaml)
LAN_ADDRESS=$(yq e '.lan-address' /root/start9/config.yaml)
LND_ADDRESS='lnd.embassy'
LNDG_ADDRESS='lndg.embassy'
LNDG_PASS=$(yq e '.password' /root/start9/config.yaml)
HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')


export SQUEAKNODE_BITCOIN_RPC_HOST="TODO"
export SQUEAKNODE_BITCOIN_RPC_PORT=8332
export SQUEAKNODE_BITCOIN_RPC_USER=
export SQUEAKNODE_BITCOIN_RPC_PASS=
export SQUEAKNODE_LND_HOST=$LND_ADDRESS
export SQUEAKNODE_LND_RPC_PORT=10009
export SQUEAKNODE_LND_TLS_CERT_PATH="/mnt/lnd/tls.cert"
export SQUEAKNODE_LND_MACAROON_PATH="/mnt/lnd/data/chain/bitcoin/mainnet/admin.macaroon"
export SQUEAKNODE_TOR_PROXY_IP=
export SQUEAKNODE_TOR_PROXY_PORT=
export SQUEAKNODE_WEBADMIN_ENABLED="true"
export SQUEAKNODE_WEBADMIN_USERNAME='lndg-admin'
export SQUEAKNODE_WEBADMIN_PASSWORD=$LNDG_PASS
export SQUEAKNODE_NODE_NETWORK='mainnet'
export SQUEAKNODE_NODE_SQK_DIR_PATH=
export SQUEAKNODE_NODE_MAX_SQUEAKS=10000
export SQUEAKNODE_SERVER_EXTERNAL_ADDRESS="TODO"


# Creating duplicate directory for the lnd macaroon files 
mkdir -p /mnt/lnd/data/chain/bitcoin/mainnet
cp /mnt/lnd/*.macaroon /mnt/lnd/data/chain/bitcoin/mainnet

# #Starting Squeaknode
# echo
# echo "  Starting Squeaknode... "
# echo
# .venv/bin/python initialize.py -net 'mainnet' -server $LND_ADDRESS':10009' -d -dx -dir /mnt/lnd -ip $LAN_ADDRESS -p $LNDG_PASS
# echo "modifying settings.py..."
# echo "CORS_ALLOW_CREDENTIALS = True
# CORS_ORIGIN_ALLOW_ALL = True
# CORS_ALLOW_CREDENTIALS = True
# GRPC_DNS_RESOLVER='native'
# CSRF_TRUSTED_ORIGINS = ['https://"$LAN_ADDRESS"']
# " >> lndg/settings.py
# sed -i "s/ALLOWED_HOSTS = \[/&'"$TOR_ADDRESS"','"$LNDG_ADDRESS"',/" lndg/settings.py
# sed -i "s/+ '\/data\/chain\/bitcoin\/' + LND_NETWORK +/ + /" /src/lndg/gui/lnd_deps/lnd_connect.py

# Properties Page showing password to be used for login
  echo 'version: 2' >> /root/start9/stats.yaml
  echo 'data:' >> /root/start9/stats.yaml
  echo '  Username: ' >> /root/start9/stats.yaml
        echo '    type: string' >> /root/start9/stats.yaml
        echo '    value: lndg-admin' >> /root/start9/stats.yaml
        echo '    description: This is your admin username for LNDg' >> /root/start9/stats.yaml
        echo '    copyable: true' >> /root/start9/stats.yaml
        echo '    masked: false' >> /root/start9/stats.yaml
        echo '    qr: false' >> /root/start9/stats.yaml
  echo '  Password: ' >> /root/start9/stats.yaml
        echo '    type: string' >> /root/start9/stats.yaml
        echo "    value: \"$LNDG_PASS\"" >> /root/start9/stats.yaml
        echo '    description: This is your admin password for LNDg. Please use caution when sharing this password, you could lose your funds!' >> /root/start9/stats.yaml
        echo '    copyable: true' >> /root/start9/stats.yaml
        echo '    masked: true' >> /root/start9/stats.yaml
        echo '    qr: false' >> /root/start9/stats.yaml

# Starting all processes
echo "starting squeaknode..."
# .venv/bin/python jobs.py
# echo "modifying systemd.sh..."
# chmod a+x systemd.sh
# sed -i 's/${SUDO_USER:-${USER}}/"'root'"/g' systemd.sh
# sed -i "s/HOME_DIR='\/root'/HOME_DIR='\/src'/g" systemd.sh
# echo "running .venv/bin/python manage.py runserver 0.0.0.0:8889 "
# .venv/bin/python manage.py runserver 0.0.0.0:8889 & 
# backend_process=$!
# echo "PID: $backend_process"
# echo "starting systemd..."
# sleep 15 && ./systemd.sh 

# # ERROR HANDLING
# trap _term SIGTERM
# wait $backend_process
# echo "Exit status $?"

exec squeaknode --log-level INFO
