# Satisfactory dedicated server kubernetes deployment


## deployment

  1. Clone this project down and CD into that directory
  3. Make any necessary changes (examples: change configmap(Other server settings), pv and pvcs..etc)
  4. Deploy the server resources(This assumes you have `envsubst` installed):
      - Run `./deploy.sh` within the Satisfactory directory within this project.
  5. Verify pod starts:
    - `k get pod -n satisfactory`

Note: To patch server just restart the pod.

## Troubleshooting
  - Verify the pod:
    - `k get pod -n satisfactory`
    - `k describe pod -n satisfactory`
      - review the events on the pod

  - Review pods app logs
    - Review init container logs: `k logs -n satisfactory pods/satisfactory-66574f9b8c-tfj25 init-steamcmd --follow`
      - is it having issues downloading the game files?
    - Review main container logs: `k logs -n satisfactory pods/satisfactory-66574f9b8c-tfj25 satisfactory-server --follow`
      - Is it having issues starting the server?

  - Verify storage is bound:
    - `k get pv -n satisfactory`
    - `k get pvc -n satisfactory`

  - Verify storage permissions:
    - If pod wont start or you are getting `permission denied` errors and you are using nfs as your persistent storage.
      - validate 1026:100 has 755 permissions to your nfs mounts. You may have to exec into the pod or set it from the storage side.

  - Verify the service has an endpoint
    - `k describe svc -n satisfactory satisfactory-svc`

## TODO
  1. Setup network policies to further lock down who can connect to this server(already doing this via my firewall).
  2. Setup [vertical pod autoscaling](https://kubernetes.io/docs/concepts/workloads/autoscaling/vertical-pod-autoscale/) since this is a very single core/ram heavy single pod type of deployment. I haven't had any performance issues with this server yet due to the resource limits/requests, but this gives me an excuse to setup metrics server and better monitoring of my other pods.
  3. Convert all this to a helm chart for an even easier deployment.
