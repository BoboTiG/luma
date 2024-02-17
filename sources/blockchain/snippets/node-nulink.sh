#!/bin/bash

GETH_VERSION='1.13.11-8f7eb9cc'
GETH_FOLDER="geth-linux-amd64-${GETH_VERSION}"

wget "https://gethstore.blob.core.windows.net/builds/${GETH_FOLDER}.tar.gz" \
    && tar -xzf "${GETH_FOLDER}.tar.gz" \
    && cd "${GETH_FOLDER}" \
    && echo 'OK'

./geth account new --keystore ./keystore \
    && echo 'OK'

scp keystore/UTC--* nulink:/root \
    && echo 'OK'

apt update \
    && apt full-upgrade -y \
    && apt autoremove -y \
    && reboot

apt install -y ufw \
    && ufw limit ssh \
    && ufw allow 9151/tcp \
    && ufw enable \
    && echo 'OK'

curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update \
    && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && echo 'OK'

mkdir nulink \
    && mv UTC--* nulink/ \
    && chmod -R 777 nulink \
    && echo 'OK'

docker pull nulink/nulink:latest \
    && echo 'OK'

echo "export NULINK_KEYSTORE_PASSWORD='TON_MOT_DE_PASSE_POUR_NULINK'" >> ~/.profile
echo "export NULINK_OPERATOR_ETH_PASSWORD='LE_MOT_DE_PASSE_DU_COMPTE_WORKER'" >> ~/.profile

echo "${NULINK_KEYSTORE_PASSWORD}" \
    && echo "${NULINK_OPERATOR_ETH_PASSWORD}" \
    && echo 'OK'

docker run -it --rm \
    -p 9151:9151 \
    -v /root/nulink:/code \
    -v /root/nulink:/home/circleci/.local/share/nulink \
    -e NULINK_KEYSTORE_PASSWORD \
    nulink/nulink nulink ursula init \
    --signer keystore:///code/FICHIER_CLEF_PRIVEE \
    --eth-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
    --network horus \
    --payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
    --payment-network bsc_testnet \
    --operator-address ADRESSE_WORKER \
    --max-gas-price 10000000000 \
    && echo 'OK'

scp nulink:'/root/nulink/keystore/*' . \
    && echo 'OK'

docker run --restart on-failure -d \
    --name ursula \
    -p 9151:9151 \
    -v /root/nulink:/code \
    -v /root/nulink:/home/circleci/.local/share/nulink \
    -e NULINK_KEYSTORE_PASSWORD \
    -e NULINK_OPERATOR_ETH_PASSWORD \
    nulink/nulink nulink ursula run --no-block-until-ready \
    && echo 'OK'

docker stop ursula \
    && docker rm ursula \
    && docker pull nulink/nulink:latest \
    && echo 'OK'

cat << EOF >> ~/.ssh/config
Host nulink
    User root
    HostName ADRESSE_IP
    Port 22
EOF

docker logs -f ursula
