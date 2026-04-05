gcloud iam service-accounts add-iam-policy-binding pern-ecommerce-backend-gsa@sapient-depot-482908-d3.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:sapient-depot-482908-d3.svc.id.goog[default/backend-ksa]"