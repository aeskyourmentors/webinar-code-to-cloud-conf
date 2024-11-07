
# Argo CD Installation and Configuration Guide

This guide provides a step-by-step process for installing and configuring Argo CD on your Kubernetes cluster.

## Steps

### Step 1: Create a Namespace for Argo CD
Create a dedicated namespace called `argocd` to organize and manage Argo CD resources within your Kubernetes cluster.

`kubectl create namespace argocd`

## Step 2: Install Argo CD
Apply the official Argo CD manifest file to install Argo CD components in the argocd namespace.\
`kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`

## Step 3: Expose the Argo CD Server with a LoadBalancer
Update the argocd-server service to use the LoadBalancer type, allowing external access to the Argo CD server. This is useful when running on a cloud provider that supports load balancers, as it will provision a public IP address for accessing the Argo CD web UI.\
`kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'`

## Step 4: Verify Argo CD Services
Check the status of all services across namespaces, including the argocd namespace, to verify that the argocd-server service is correctly exposed with an external IP if using LoadBalancer.\
`kubectl get svc -A`

## Step 5: Retrieve the Initial Admin Password for Argo CD
Fetch the initial admin password for the Argo CD web UI. The password is stored in a Kubernetes secret named argocd-initial-admin-secret. The command retrieves this password in base64-encoded format and decodes it for easy reading.\
`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

## Step 6: Check the Status of Kubernetes Pods, Nodes and other object
Display the list and status of all pod, svc, nodes in your Kubernetes cluster. This ensures that your cluster is healthy and ready to run Argo CD.

`kubectl get pod -A`

`kubectl get pod -n argocd`

`kubectl get nodes`