
## Authors

- Ahmed Ali


## 🚀 About Me
I'm a DevOps Engineer...

# Deploy helloworld python app on GKE cluster using /Docker/Terraform/GCR/GKE cluster


![image](https://drive.google.com/uc?export=view&id=1Jy2B409ayrUye4nMwfSULdKEqWt_QU_H)
## Demo

This Repo contains Project (application source code & terraform code & deployment files). I'm gonna explain how to dockerize the application terraform code to create Google Kuberentes Private Cluster and how to make it pull images needed from GCR and deploy our python application on Our Cluster.
## Installation

Install  infrastructure with terraform

```bash
    # terraform init
    # terraform apply
```
    
## Tools 


#### Docker :
  - Dockerize the helloworld python application 


#### Terraform :


  - Provision the infrastructure as a code.


#### Google Container Registry :



 - Is a private Docker registry running on Google Cloud Storage. It uses the same authentication, storage, and billing as google/docker-registry,


#### Kubernetes :


  - Where we will deploy helloworld app on it (GKE cluster).


## Docker
1- I will dockerize the helloworld python application and build an image for our app with the right tag for GCR. We will need redis image to for our application. I will push these images to GCR.(I will explain the permissions needed later.)
```bash
    # docker build . -t gcr.io/wired-sol-367809/helloworldapp:latest
    # docker pull redis
    # docker tag redis gcr.io/wired-sol-367809/redis:5.0.4
    # docker push gcr.io/wired-sol-367809/helloworldapp:latest
    # docker push gcr.io/wired-sol-367809/redis:5.0.4
```
![image](https://drive.google.com/uc?export=view&id=1TANdH4zu7-94rDmrHKlGzWk6DvK3cyA5)

![image](https://drive.google.com/uc?export=view&id=1x41R2q8DF3DVNVMQDDwXOx6GoKqUenTI)

![image](https://drive.google.com/uc?export=view&id=1PrjkdyV5i9-Gtlff9c-Uu8YvzI2hjoL5)


## Terraform
1- Configure the Provider (Google Cloud)

![image](https://drive.google.com/uc?export=view&id=1XMHXTDm9dXtrqyboG8VVPdzvT9iHlGMt)

2- Create VPC with name "vpc_network"


![image](https://drive.google.com/uc?export=view&id=1_7BAD552vAIvcm891aR_ZPkgZ3FUAjvh)


3- Create 2 Subnets (Management-subnet) where we will create bastion VM in it & (Restricted-subnet) will contain our private cluster

![image](https://drive.google.com/uc?export=view&id=16RCqgOb-fh4DPNc3GWG_7ZmpNk0kGUxF)


4- Create a VM act as a bastion in Management subnet to access the private cluster

![image](https://drive.google.com/uc?export=view&id=1dzgLe5FYt9WgSdFF2gtxPXKpq1kA3Rsl)


5- Create NAT Gateway to allow our bastion to access internet.

![image](https://drive.google.com/uc?export=view&id=1rzjldSQvVJZKdh6LabizbDZ65ovHODgj)


6- Create Firewall allow SSH and http 

![image](https://drive.google.com/uc?export=view&id=1aAUMzjIpzaHGlCwjzjnm-LmRmswmtn3W)

7- Create 2 Service Accounts one with role "container.admin"/"storage.admin" which we will give it to the VM to Access our GKE Cluster and push/pull images from GCR, the second one for our GKE cluster with "storage.admin" role or with (storage.bucket.* /storage.objects.*) permissions to allow GKE cluster pull images from GCR when applying deployment files

![image](https://drive.google.com/uc?export=view&id=1xl-zC6q4bOas0i9hF0UtVVDSBLjvUp7H)

![image](https://drive.google.com/uc?export=view&id=1LBoBy4Uy9EufVafj5H5JHQiuQvmUGXK0)

8- Create a Private cluster with the previous Service Account

![image](https://drive.google.com/uc?export=view&id=1cwNWriLIPMAlblvRa7G3gCuJlEMCROpQ)

![image](https://drive.google.com/uc?export=view&id=1OdhOI6bLaLkVn6kQFwlyxxeen2_bC1gI)

![image](https://drive.google.com/uc?export=view&id=1MScKM4sczlMP3mcmmRlWMkOqp1g-6zqn)

![image](https://drive.google.com/uc?export=view&id=1LwVn6n_CB4QlBUNmXLBtCt1LzFbKJORM)


## Configure bastion VM :
1- I will accessto bastion vm (install docker & kubectl & generate kubeconfig file for our cluster)
```bash
    # gcloud container clusters get-credentials private-cluster --zone us-central1-a --project wired-sol-367809
```
![image](https://drive.google.com/uc?export=view&id=1zhK55-Viax5gF6K5AqgrCuR-eNbwETYF)

2- I will create a secret with the cluster service account key and configure kubernetes to pull images from GCR instead of dockerhub

```bash
    # kubectl create secret google-registry countly-registry --docker-server=http://gcr.io --docker-username=_json_key --docker-password="$(cat sakey.json)"
```
![image](https://drive.google.com/uc?export=view&id=1w6_AfbldXPDnASUhDxtDGwLBcHZwI1Lj)

3- I will build and push helloworldapp and redis images to GCR as mentioned in docker section
![image](https://drive.google.com/uc?export=view&id=1INawRmvOwuQnfeln_Dijmh2ERSEcqWkc)

## write deployment files for helloworldapp and redis :

1- I will write (redis-conf.yaml, redisapp.yaml, helloapp.yaml) I will add imagePullSecrets section in deployment files with (google-registry)
```bash
    # kubectl apply -f redis-conf.yaml
    # kubectl apply -f redisapp.yaml
    # kubectl apply -f helloapp.yaml
```
![image](https://drive.google.com/uc?export=view&id=1hFh6_0EzVHYUJ3NjR_3b3AjB_66atr-z)

![image](https://drive.google.com/uc?export=view&id=1F_w43B7TuZSUGHWkZXHHJcbpZ0pfGuzP)

![image](https://drive.google.com/uc?export=view&id=1Btm_ewNMcXz6rR2rWfndJJm-K5tDmmUA)

![image](https://drive.google.com/uc?export=view&id=1YbU_ztdfaOOyXhmcqb9v6lxxRy9nvky-)


## Show time :

![image](https://drive.google.com/uc?export=view&id=1OtLIxzDT6CaATZqXfn942X8gFGs5fNxd)

![image](https://drive.google.com/uc?export=view&id=1p2qYx_np7dKrhUKGbvZSe--5_06hr0PO)

## What can be improved upon?

- I'm gonna improve terraform code to use module.
## Feedback

If you have any feedback, please reach out to me at ahmed.ali.elbaz.mohamed@gmail.com

