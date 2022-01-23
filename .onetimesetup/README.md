# Steps to set up initial Infrastructure

These are the steps to set up your infrastructure for all apps.

## Pre-req

1. You as an admin must have valid permissions on gcp.
2. Have helm installed on your local.
3. Have gcloud cli installed on local.

## Summary of steps

1. Set up a k8s cluster on GCP via terraform
2. Set up nginx ingress on this k8s cluster (which will create an lb)
3. Set up argocd on this k8s cluster
4. Set up external secrets on this k8s cluster
5. Set up KMS keyring on GCP platform

## Summary of steps for individual projects

1. Set up circleci with an ssh key generated on github.
2. Add your argo yaml to .onetimesetup/apps to create an argocd project

- Everytime a new app is created, ensure it is created. We can automated this too by using argocd to monitor the folder.

## Main steps

### 1. Set up a k8s cluster on GCP via terraform

- Run terraform apply on .onetimesetup/.infrastructure folder [About 5 minutes]
- Ensure you have your credentials set via export GOOGLE_APPLICATION_CREDENTIALS=PATH
  - Create a service account on gcp, download it and set the PATH to the location of these credentials^
  - Change ur k8s context to ur new cluster `gcloud container clusters get-credentials sathish-cluster --zone us-central1-a --project rsathishx87`

### 2. Set up nginx ingress on this k8s cluster (which will create an lb) [About 1 minute]

- https://cloud.google.com/community/tutorials/nginx-ingress-gke
- Steps
  - helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  - helm install nginx-ingress ingress-nginx/ingress-nginx

### 3. Set up argocd on this k8s cluster

- kubectl create namespace argocd
- kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
- kubectl apply -n argocd -f argo_ingress.yaml # Remember to set your ip address accordingly.
  - echo $(kubectl get service nginx-ingress-ingress-nginx-controller -ojson | jq -r '.status.loadBalancer.ingress[].ip')
- If you want to see UI, Login password is @ `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`
  - Username is 'admin'
- Add your github key to argocd manually!!! Very important!

### 4. Set up external secrets on this k8s cluster

- Create service account
  - gcloud iam service-accounts create external-secrets --project rsathishx87
  - gcloud projects add-iam-policy-binding rsathishx87 --member "serviceAccount:external-secrets@rsathishx87.iam.gserviceaccount.com" --role "roles/secretmanager.secretAccessor" --project rsathishx87
  - Go to external_secrets folder and do the following
    - gcloud iam service-accounts keys create key.json --iam-account=external-secrets@rsathishx87.iam.gserviceaccount.com --project rsathishx87
    - kubectl create secret generic gcp-creds --from-file=gcp-creds.json=key.json
    - helm install extsecrets external-secrets/kubernetes-external-secrets -f values.yaml

### 5. Set up KMS keyring on GCP platform (This is for storing encrypted-passwords in git)

- terraform gcp_kms.tf (Should be already done in step 1)

## Individual Apps Steps

1. Put their argocd template at apps folder .onetimesetup/apps

- Run k apply -f <app>.yaml [Recommended to run only after .infrastructure is ran, due to secrets etc.]

2. Do a helm create on new repos for a pre-done template.
