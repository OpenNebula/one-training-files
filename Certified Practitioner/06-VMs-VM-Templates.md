# Suppliment for Module 6 Labs

## Lab 1

### alpine-application VM Template

#### User inputs

Name: DB_HOST

Type: Text

Default value: 127.0.0.1

---

Name: APP_DATABASE

Type: Text

Default value: app

---

Name: DB_USER

Type: Text

Default value: appuser

---

Name: DB_USER_PASSWORD

Type: Password

---

Name: TIMEZONE

Type: Text

Default value: UTC

#### Custom Context Variables

Name: SET_HOSTNAME

Value: $NAME

#### Start script

```
rc-service mariadb start
source /root/bin/activate
cd /root/app/old
python3 -u app.py &
```

### ubuntu-cloudflared VM Template

#### Start script

```
cloudflared tunnel --url http://$APP_IP:5000 > /var/log/cfd.log 2>&1 &
sleep 60
export CFD=$(grep -o -e 'https.*trycloudflare.com' /var/log/cfd.log)
onegate vm update $VMID --data CFD_URL=$CFD
```

#### Custom Context Variables

Name: SET_HOSTNAME
Value: $NAME

#### User inputs

Name: APP_IP
Type: Text

## Lab 2

### OpenNebula CLI

`onevm list`

`onevm ssh <VM ID>`

### alpine-application

#### Clone the repository

```
apk add git
export REPO='https://github.com/OpenNebula/one-training-files.git'
rm -rf ~/Files
git clone --no-checkout $REPO ~/Files
cd ~/Files
git sparse-checkout init --cone
git sparse-checkout set VMs
git checkout
cd VMs
ls -lah
```

#### Install

`chmod +x prep_all.sh`

`./prep_all.sh`

### ubuntu-cloudflared

#### Clone the repository

```
export REPO='https://github.com/OpenNebula/one-training-files.git'
rm -rf ~/Files
git clone --no-checkout $REPO ~/Files
cd ~/Files
git sparse-checkout init --cone
git sparse-checkout set VMs
git checkout
cd VMs
ls -lah
```

#### Install & Verify

`chmod +x prep_all.sh`

`./prep_clfd.sh`

`cloudflared --help`

## Lab 3

### alpine-application

Password: appPassword