#!/bin/bash

DELAY=25

mongo1="{{ v "mongo1-url" }}"
mongo2="{{ v "mongo2-url" }}"
mongo3="{{ v "mongo3-url" }}"
admin_user="{{ v "mongo-init-username" }}"
admin_pass="{{ v "mongo-init-password" }}"

mongosh <<EOF
var config = {
    "_id": "dbrs",
    "configsvr": true,
    "members": [
        { "_id": 1, "host": "$mongo1" },
        { "_id": 2, "host": "$mongo2" },
        { "_id": 3, "host": "$mongo3" }
    ]
};

rs.initiate(config, { force: true });
rs.status();
EOF

echo "****** Waiting for ${DELAY} seconds for replicaset configuration to be applied ******"
sleep $DELAY

mongosh <<EOF
db.createUser({user: "$admin_user", pwd: "$admin_pass", roles:[{role: "userAdminAnyDatabase" , db:"admin"}]})
EOF
