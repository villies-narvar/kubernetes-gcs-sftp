# GCS SFTP Server
SFTP Server designed to store data in Google Cloud Storage (GCS) Buckets

This is based upon [atmoz/sftp](https://github.com/atmoz/sftp) project.

# Dockerfile
We need to setup an image (based on atomz/sftp) so that we can mount to Google Cloud Storage. That means just installing [gcsfuse](https://github.com/GoogleCloudPlatform/gcsfuse/tree/master/docs).

Find and build your own image using the `Dockerfile` provided.


# Mounting Buckets
We use gcsfuse `--uid`, `--gid`, and `--only-dir` arguments to mount each SFTP users home directory to a single bucket. Inside the bucket, we create a directory for each user manually. (Not sure if using `--only-dir` will work unless the directory already exists)

Sample Bucket Directory Structure:
```
bucket-name
  - /user1
  - /user2
```

The mounting is done in `etc/sftp.d/gcs-mounts.sh`. When deploying to Kubernetes, this script gets executed as a `postStart` command.

## Access Control for GCS Bucket
We just need to ensure your GKE cluster is created with the OAuth scope https://www.googleapis.com/auth/devstorage.read_write, and everything else will be handled automatically. Alternatively, we can mount a file in Service Account JSON key.

# Setup Instructions
## Dependencies
For deployment, you will need to have terraform, kubectl, the gcloud SDK and helm.

## Configuration
You can configure SFTP user accounts by adjusting what's in `etc/sftp/users.conf` and `etc/sftp.d/gcs-mounts.sh`.

When adding a new user, add a new line into `etc/sftp/users.conf`:
```
<username>:<encrypted_password>:e:<uid>:<gid>:<comma_separated_directory_names>
```
Where `uid` is a number (e.g. 1003) and `gid` is a number (e.g. 1002).
And then add a new line for each directory into `etc/sftp.d/gcs-mounts.sh` to mount them to a GCS bucket:
```
runuser -l <username> -c 'gcsfuse -o nonempty --only-dir <username> <inbound_gcs_bucket> /home/<username>/inbound'
runuser -l <username> -c 'gcsfuse -o nonempty --only-dir <username> <outbound_gcs_bucket> /home/<username>/outbound'
```

## Deployment
To deploy to GKE follow these steps:

### 1. Use terraform to create the GKE cluster and GCS buckets:
```
cd terraform-gcp && terraform apply
```

### 2. Use gcloud to get GKE cluster credentials:
```
gcloud beta container clusters get-credentials villies-test-sftp --region us-west1 --project narvar-qa-202121
```

### 3. Use kubectl to create tiller service account:
```
kubectl apply -f helm/tiller_rbac.yaml
```

### 4. Install helm to the GKE cluster:
```
helm init --service-account tiller
```

### 5. Setup Secrets and Config Mappings
You'll need to adjust files in `etc` so that it reflects the SFTP users you're planning to use.

Then, you can run these commands to put these files on the cluster as secrets:
```
kubectl create secret generic users --from-file=users.conf=./etc/sftp/users.conf
kubectl create secret generic ssh-host-keys --from-file=sftp_ssh_host_keys.tgz=/path/to/sftp_ssh_host_keys.tgz
kubectl create configmap gcs-mounts --from-file=gcs-mounts.sh=./etc/sftp.d/gcs-mounts.sh
```
* **users** - Code for maintaining users credentials for SFTP access
* **ssh-host-keys** - Tar archive containing the SSH host keys for the SFTP service
* **gcs-mounts** - Code for mounting GCS buckets

### 6. Deploy the SFTP service to Kubernetes:
```
helm install helm/sftp
```
