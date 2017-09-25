#!/bin/sh

echo "*****hello openstack tacker alarm*****"

#tacker vnf-create --vnfd-name VNFD_alarm --vim-name VIM0 TEST0

ALARM_ID=$(aodh alarm list | awk '/-vdu_hcpu_usage_respawning-/ {print $2}')
ACTION_ID="$(aodh alarm show $ALARM_ID | awk '/ alarm_actions  / {print $4}')"
VM_ID=$(openstack server list | awk ' / threshold / {print $2}')
#pattern1='[u'
#pattern2=']'
#pattern3=
#ACTION_ID_NEW=${ACTION_ID#$pattern1}
#ACTION_ID_FI=${ACTION_ID_NEW%$pattern2}
#ACTION_ID_VER2=$(ACTION_ID&&0001111111111111111111111111111100

echo "....complete variables..."
echo "===1. alarm id ==="
echo "$ALARM_ID"
echo "===2. action id ==="
echo "$ACTION_ID"
echo "===3. vm id ==="
echo "$VM_ID"


aodh alarm create \
--name threshold-test \
--type gnocchi_resources_threshold \
--description 'instance running hot' \
--metric cpu_util \
--threshold 40.0 \
--comparison-operator gt \
--severity low \
--aggregation-method mean \
--granularity 300 \
--evaluation-periods 2 \
--repeat-actions True \
--alarm-action ${ACTION_ID} \
--resource-id $VM_ID \
--resource-type instance

echo "....created alarm....."


aodh alarm delete $ALARM_ID
echo "....complete delete resapwning alarm..."

echo "====aodh alarm list===="
aodh alarm list
echo "====openstack server list===="
openstack server list
