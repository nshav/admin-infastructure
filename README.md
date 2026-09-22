# infrastructure

Terraform that provisions the rate-limiter platform onto a GKE cluster. It
installs the shared cluster services and the control plane; the data-plane
agents themselves are deployed by Argo CD from the `agent-deployments` repo, not
from here.

## Target

- Cluster: `nsha-cluster` (`us-central1`, project `poc-cloud-nodes`), read via a
  `google_container_cluster` data source.
- The Kubernetes / Helm / kubectl providers authenticate to that cluster with
  the caller's GCP access token, so the identity running Terraform needs both
  GCP access **and** RBAC in the cluster.

## Modules

| Module | What it installs |
|--------|------------------|
| `cert-manager`   | cert-manager (TLS via Let's Encrypt). |
| `kong`           | Kong ingress controller. |
| `admin-panel`    | Common namespace + shared resources for the panel. |
| `admin-panel/backend`  | The control-plane API (`admin-backend`) + its config/secrets. |
| `admin-panel/frontend` | The React SPA (`admin-frontend`). |
| `argo`           | Argo CD (Helm) + the `agents` ApplicationSet that deploys agents. |

## State

Remote state in GCS: bucket `support-tfstates`, prefix `infra` (see the
`backend "gcs"` block in `provider.tf`). Any local `terraform.tfstate` files are
stale leftovers and are git-ignored.

## Usage (local)

Authenticate to GCP first (`gcloud auth application-default login`, with access
to the cluster and the state bucket), then:

```bash
terraform init
terraform plan
terraform apply
```

## CI/CD

`.github/workflows/terraform.yml` runs on every PR and push to `main`:

- **Pull request** → `fmt -check` → `init` → `validate` → `plan` (no apply).
- **Push to `main`** (including a merged PR) → the same, then `apply -auto-approve`.

Runs are serialized with a `concurrency` group so two applies can't race on the
state.

### Required secret

`GOOGLE_CREDENTIALS` — a service-account JSON key, set as a repository
**secret**. The google provider and the GCS backend read it directly. The
service account needs:

- `roles/storage.objectAdmin` on the `support-tfstates` bucket (read/write state);
- access to `nsha-cluster` and RBAC to manage resources in it
  (`roles/container.admin` covers both `clusters.get` and in-cluster admin).

Keep `TF_VERSION` in the workflow `>=` the Terraform version that last wrote the
state, or `init` will refuse to read it.

## Secrets

Credential manifests are **not** committed. `*_creds.yaml` is git-ignored
(e.g. the GitHub token secret for the backend is applied to the cluster by hand,
not through Terraform state).
