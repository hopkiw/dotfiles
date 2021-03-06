alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ipython="python -c 'from IPython import embed; embed()'"
alias kindlog='KUBECONFIG="$HOME/.kube/kind-config-mkpod" kubectl logs -c test'
alias gcin='gcloud compute instances'
alias instances='gcloud compute instances list'
alias gcim='gcloud compute images'
alias images='gcloud compute images list'
alias gssh='gcloud compute ssh'
alias list="gcloud compute instances list --format=\"table(name,metadata.items.extract(\"enable-oslogin\").flatten():label=OSLOGIN,machineType.basename())\" --filter=\"name !~ ^gke\""
alias kairflow='kubectl exec -n $AIRFLOW_NS $AIRFLOW_POD -c airflow-scheduler -- airflow'
