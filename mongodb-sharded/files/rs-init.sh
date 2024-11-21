#!/bin/bash

DELAY=${DELAY:-25}
MONGO_REPLSET=${MONGO_REPLSET:-config}

MONGO_1="{{ v "mongo1-url" }}"
MONGO_2="{{ v "mongo2-url" }}"
MONGO_3="{{ v "mongo3-url" }}"
ADMIN_USER="{{ v "mongo-init-username" }}"
ADMIN_PASS="{{ v "mongo-init-password" }}"

mongosh <<EOF
var config = {
    "_id": "${MONGO_REPLSET}",
    "configsvr": true,
    "members": [
        { "_id": 1, "host": "${MONGO_1}", "priority": 3 },
        { "_id": 2, "host": "${MONGO_2}", "priority": 2 },
        { "_id": 3, "host": "${MONGO_3}", "priority": 1 }
    ]
};

rs.initiate(config, { force: true });
rs.status();
EOF

echo "****** Waiting for ${DELAY} seconds for replicaset configuration to be applied ******"
sleep $DELAY

mongosh <<EOF
db.createUser({user: "${ADMIN_USER}", pwd: "${ADMIN_PASS}", roles:[{role: "userAdminAnyDatabase" , db:"admin"}]})
EOF
