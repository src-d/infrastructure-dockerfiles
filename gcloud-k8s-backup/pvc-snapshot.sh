#!/bin/bash

set -xe

[[ $# -eq 2 ]] || { echo "Usage: $0 pvc-name environment"; exit 1; }
PVC=$1
ENVIRONMENT=$2

count=0
for var in K8S_CLIENT_CERTIFICATE \
           K8S_CLIENT_KEY \
           K8S_CERTIFICATE_AUTHORITY \
           K8S_SERVER \
           GCE_ZONE \
           GOOGLE_APPLICATION_CREDENTIALS
do
    if [[ ! "${!var}" ]]; then
        echo "$var not defined"
        count=$((count +1))
    fi
done

[[ $count -gt 0 ]] && exit 1

volume=$(kubectl --client-certificate="${K8S_CLIENT_CERTIFICATE}" \
                 --client-key="${K8S_CLIENT_KEY}" \
                 --certificate-authority="${K8S_CERTIFICATE_AUTHORITY}" \
                 --server="${K8S_SERVER}" get pvc |
         grep "${PVC}" |
         awk '{print $3}')

[[ -z "${volume}" ]] && { echo "Cannot find any matching ${PVC}"; exit 1; }

disk=$(gcloud compute disks list | grep "${volume}" | awk '{print $1}')

gcloud compute disks snapshot "${disk}" --snapshot-names ${PVC}-${ENVIRONMENT}-"$(date '+%Y%m%d%H%M%S')" --zone "${GCE_ZONE}"
