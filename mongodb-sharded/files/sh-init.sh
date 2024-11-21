#!/bin/bash

MONGO_REPLSET=${MONGO_REPLSET:-shard}

MONGO_1="{{ v "mongo1-url" }}"
MONGO_2="{{ v "mongo2-url" }}"
MONGO_3="{{ v "mongo3-url" }}"
ADMIN_USER="{{ v "mongo-init-username" }}"
ADMIN_PASS="{{ v "mongo-init-password" }}"

mongosh <<EOF
var config = {
    "_id": "${MONGO_REPLSET}",
    "members": [
        { "_id": 1, "host": "${MONGO_1}", "priority": 1 },
        { "_id": 2, "host": "${MONGO_2}", "priority": 0 },
        { "_id": 3, "host": "${MONGO_3}", "priority": 0 }
    ]
};

rs.initiate(config, { force: true });
rs.status();
EOF
