# Notes

- Writing application code is *not necessarily required*, something like [podinfo](https://github.com/stefanprodan/podinfo) can be used.
  - There is already [a Helm chart](https://github.com/stefanprodan/podinfo#helm) and [kustomize](https://github.com/stefanprodan/podinfo#kustomize) available, and there are many different versions of the service and manifests available.
  - Any other container (like simple `busybox` image or similar) can be used.
- Pipelines don't require building or testing any application or producing artifacts.
  - One can just simulate a promotion with version inputs (e.g., start the pipeline with app version `1.2.3` as if this version was just created). <br>
  *See the example pipeline in this repository for reference.*
- The provided (if any) Kubernetes environment is not required, and any setup (e.g., using kind) can be used.
- *No changes to this repository are required.*
  - One can use their own private repositories.
  - Repos to work on (e.g., app/manifests/config) *can be provided if needed*.
- different stages can be just defined as namespaces
- the mentioned "microservice setup" can be considered to be just multiple "apps" like an `ordering`, `payment`, `profile` services *(no real functionality is required, nginx images or similar can be used here)*
- it's recommended to just create an ArgoCD App from a helm chart using the UI and play with it, like change some parameters (updating the image version, like switching to a new release)