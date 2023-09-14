I've been following [this guide](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity?cloudshell=true#gcloud_3) to set up a Kubernetes Cluster on GCP with Workload Identity, and I'm completely stuck with service account permissions.

```
gcloud container clusters create test-cluster \
    --region=europe-west1 \
    --workload-pool=my-project.svc.id.goog

gcloud container clusters get-credentials test-cluster \
    --region=europe-west1

kubectl create namespace test-kns

kubectl create serviceaccount test-ksa \
    --namespace test-kns

gcloud iam service-accounts create test-gsa \
    --project=my-project

gcloud projects add-iam-policy-binding my-project \
    --member "serviceAccount:test-gsa@my-project.iam.gserviceaccount.com" \
    --role "roles/composer.worker"

gcloud iam service-accounts add-iam-policy-binding test-gsa@my-project.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:my-project.svc.id.goog[test-kns/test-ksa]"

kubectl annotate serviceaccount test-ksa \
    --namespace test-kns \
    iam.gke.io/gcp-service-account=test-gsa@my-project.iam.gserviceaccount.com

kubectl auth can-i list pods --all-namespaces --as "system:serviceaccount:test-kns:test-ksa"
[no]

gcloud config set auth/impersonate_service_account test-gsa@my-project.iam.gserviceaccount.com

gcloud container clusters get-credentials test-cluster --location europe-west1

kubectl auth can-i list pods --all-namespaces
[yes]
```

I think I've got all the steps in (a few are optional when Autopilot is enabled, which it is), but when I come to test the permissions with `kubectl`, I'm always told `no`. Impersonating the Google Service Account directly results in a `yes`.

Testing the email annotation in a pod as per the documentation is also fine:
```
root@workload-identity-test:/# curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/email
test-gsa@my-project.iam.gserviceaccount.com
```

Does anybody know what's missing between my GSA and KSA?