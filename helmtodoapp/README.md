## File Structure of Helm Package 

root@DESKTOP-1NTM4L3:/home/stole/myapp/helmtodoapp# tree .
.
├── Chart.yaml
├── README.md
├── charts
├── templates
│   ├── pod.yml
│   └── service.yml
├── todoapp-0.1.0.tgz
└── values.yaml


## Step 1: Prerequisites

-Kubernetes cluster or MiniKube

-Ensure that you have Helm installed on your machine. If not, you can download and install it from the Helm website: https://helm.sh/docs/intro/install/

## Step 2: Package the Helm Chart
Navigate to your chart directory and package it using the helm package command:

helm package .

This command will create a .tgz file containing your Helm chart

## Step 3: Install the helm Chart 

Install the Helm chart using the following command:

helm install <release_name> ./<chart_directory>  #in mycase used the todoapp-v1 for repository name 

or 

helm install <release_name> ./<file.tgz> # it's doing the same thing as the command above using only for better file  organisation 

## Step4: Verify Installation:
After installation, users can verify that the resources have been deployed correctly:

kubectl get pods,svc,deploy -n <namespace> 

Replace <namespace> with the namespace where your application was deployed. If not specified, it will use the default namespace.

#Accessing the Application:

If you are using Kubernetes cluster and you are on one of the nodes you can access the app with localhost:30001/todoitems 
and if it's with minikube please find the clusterip by executing command 

kubectl get nodes -o wide

stole@DESKTOP-1NTM4L3:~/myapp$ kubectl get nodes -o wide

NAME       STATUS   ROLES           AGE     VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION                       CONTAINER-RUNTIME

minikube   Ready    control-plane   2d21h   v1.27.4   192.168.49.2   <none>        Ubuntu 22.04.2 LTS   5.15.146.1-microsoft-standard-WSL2   docker://24.0.4

stole@DESKTOP-1NTM4L3:~/myapp$ curl 192.168.49.2:30001/todoitems
[]

Because of the memory database the resquest output is with no data. Curl put command

 curl -X POST -H "Content-Type: application/json" -d '{"name":"Dog","description":"dog is walking"}' http://192.168.49.2:30001/todoitems

#Output 

root@DESKTOP-1NTM4L3:/home/stole/myapp# curl 192.168.49.2:30001/todoitems
 [{"id":1,"name":"Dog","isComplete":false}]

## Optional steps:

Updating the Chart (Optional):

Use helm list command to find your helm release

then 

helm upgrade <release_name> ./<chart_directory> #to upgrade the helmchart within kubernetes cluster 

and alo you can uninstall Helm chart

Uninstalling the Chart:

If users want to remove the deployed resources, they can uninstall the Helm release:

helm uninstall <release_name> #Destroy the resources by uninstalling the helm chart

