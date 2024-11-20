# Monk & MongoDB

This repository contains Monk.io template to deploy MongoDB cluster in system either locally or on cloud of your choice (AWS, GCP, Azure, Digital Ocean).

## Start

[Set up Monk](https://docs.monk.io/docs/monk-in-10/)

Start `monkd` and login.

```bash
monk login --email=<email> --password=<password>
```

## Clone Monk MongoDB repository

In order to load templates and change configuration simply use below commands:

```bash
git clone https://github.com/monk-io/monk-mongodb

# and change directory to the monk-elk template folder
cd monk-mongodb/mongodb-replicated

```

## Configuration

You can add/remove configuration of the template.

The current variables can be found in `mongodb/variables` section

```yaml
  variables:
    mongo-image-tag: "latest"
    mongodb-init-username: "mongo"
    mongodb-init-password: "password"
    mongodb-init-database: "mongo"
```

## Template variables

| Variable                  | Description                    | Type   | Default  |
| ------------------------- | ------------------------------ | ------ | -------- |
| **mongo-image-tag**       | MongoDB image version.         | string | latest   |
| **mongodb-init-username** | MongoDB Initial root username. | string | mongo    |
| **mongodb-init-password** | MongoDB Initial root password. | string | password |
| **mongodb-init-database** | MongoDB Initial root database. | string | mongo    |

## Local Deployment

| First clone the repository simply run below command after launching `monkd`: |
| :--------------------------------------------------------------------------: |

```bash
➜  monk load MANIFEST

✨ Loaded:
 ├─🔩 Runnables:
 │  ├─🧩 mongodb-replicated/mongodb-common
 │  ├─🧩 mongodb-replicated/mongodb-1
 │  ├─🧩 mongodb-replicated/mongodb-2
 │  └─🧩 mongodb-replicated/mongodb-3
 ├─🔗 Process groups:
 │  └─🧩 mongodb-replicated/stack
 └─⚙️ Entity instances:
    └─🧩 mongodb-replicated/mongodb-common/metadata
✔ All templates loaded successfully

➜  monk list -l mongodb-replicated

✔ Got the list
Type      Template                         Repository  Version  Tags
runnable  mongodb-replicated/mongodb-1        local       -        -
runnable  mongodb-replicated/mongodb-2        local       latest   database, nosql
runnable  mongodb-replicated/mongodb-3        local       latest   database, nosql
runnable  mongodb-replicated/mongodb-common   local       latest   database, nosql
runnable  mongodb-replicated/mongodb-express  local       latest   -
group     mongodb-replicated/stack            local       -        -


➜ monk run mongodb-replicated/stack

✔ Started local/mongodb-replicated/stack

```

This will start the entire mongodb-replicated/stack.

## Cloud Deployment

To deploy the above system to your cloud provider, create a new Monk cluster and provision your instances.

```bash
➜  monk cluster new -n monkha
✔ Cluster created
Your cluster has been created successfully.

➜  monk cluster provider add -p aws -f <path/to/your-credentials-file>
✔ Provider added successfully

➜   monk cluster grow -p  aws --name monkha --tag monkha  -i t3.large --region eu-north-1 -m 3 -d 50 --disk-type SSD
✔ Start creation of new instance(s) on aws... DONE
✔ Creating node: monkha-1 DONE
✔ Creating node: monkha-2 DONE
✔ Initializing node: monkha-1 DONE
✔ Initializing node: monkha-2 DONE
✔ Creating node: monkha-3 DONE
✔ Initializing node: monkha-3 DONE
✔ Connecting: monkha-1 DONE
✔ Syncing peer: monkha-1 DONE
✔ Connecting: monkha-2 DONE
✔ Syncing peer: monkha-2 DONE
✔ Connecting: monkha-3 DONE
✔ Syncing peer: monkha-3 DONE
✔ Syncing nodes DONE
✔ Cluster grown successfully
```

Once cluster is ready execute the same command as for local and select your cluster (the option will appear automatically).

```bash
➜  monk load MANIFEST

✨ Loaded:
 ├─🔩 Runnables:
 │  ├─🧩 mongodb-replicated/mongodb-common
 │  ├─🧩 mongodb-replicated/mongodb-1
 │  ├─🧩 mongodb-replicated/mongodb-2
 │  └─🧩 mongodb-replicated/mongodb-3
 ├─🔗 Process groups:
 │  └─🧩 mongodb-replicated/stack
 └─⚙️ Entity instances:
    └─🧩 mongodb-replicated/mongodb-common/metadata
✔ All templates loaded successfully

➜  monk list -l mongodb-replicated

✔ Got the list
Type      Template                         Repository  Version  Tags
runnable  mongodb-replicated/mongodb-1        local       -        -
runnable  mongodb-replicated/mongodb-2        local       latest   database, nosql
runnable  mongodb-replicated/mongodb-3        local       latest   database, nosql
runnable  mongodb-replicated/mongodb-common   local       latest   database, nosql
runnable  mongodb-replicated/mongodb-express  local       latest   -
group     mongodb-replicated/stack            local       -        -


➜ monk run mongodb-replicated/stack

✔ Started local/mongodb-replicated/stack


```

## Logs & Shell

```bash
# show MongoDB logs
➜  monk logs -l 1000 -f  mongodb-replicated/mongodb-1

# show MongoDB logs
➜  monk logs -l 1000 -f  mongodb-replicated/mongodb-2

# show MongoDB logs
➜  monk logs -l 1000 -f  mongodb-replicated/mongodb-3

# access shell in the container running MongoDB
➜  monk shell mongodb-replicated/mongodb-1

# access shell in the container running MongoDB
➜  monk shell mongodb-replicated/mongodb-2

# access shell in the container running MongoDB
➜  monk shell mongodb-replicated/mongodb-3
```

## Stop, remove and clean up workloads and templates

```bash
➜ monk purge  --ii --rv --rs --no-confirm --rv --rs local/mongodb-replicated/stack

✔ mongodb/mongodb purged
✔ mongodb/stack purged
```
