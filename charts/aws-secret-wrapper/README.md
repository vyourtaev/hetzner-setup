### Deployment aws-secret-wrapper

After all CRDs deployed it's a time to deploy all secrets and first 
we have to deploy ClusterSecretStore. 

#### Cluster Secret Store.
It required to finish set up External Secret Operator and get access 
to AWS Secret Manager (Parameter Store) and get aws keys / aws secret keys
for other services accounts like (cert-manager and external-dns)

