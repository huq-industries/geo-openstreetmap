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
gcloud config set auth/impersonate_service_account test-gsa@huq-jimbo.iam.gserviceaccount.com

gcloud container clusters get-credentials test-cluster --location europe-west1

kubectl auth can-i list pods --all-namespaces
[yes]