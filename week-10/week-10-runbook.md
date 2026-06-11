# How to Troubleshoot a GCP VPC / GCE VM Connectivity Issue
## Prerequisite tools: Git Bash (Run as Admin) and GCP Console
## Steps
- Step 1: In gitbash, use the following command to export your project ID, VM name, and zone as shell variables.
````bash
    export PROJECT_ID="your-project-id"; export VM_NAME="your-vm-name"; export ZONE="your-zone". Then set the active project: gcloud config set project $PROJECT_ID
*NOTE: Every command after this step references these variables. SEtting them now avoids typos and makes sure all commands target the correct resource.*
*IMPORTANT: To check that everything is right, run this command. It confirms all 3 values are printed correctly.
````bash
    echo $PROJECT_ID $VM_NAME $ZONE 

- Step 2: To verify the VM is running, run this command:
````bash
    gcloud compute instances describe $VM_NAME --zone=$ZONE --format="value(status)"

- Step 3: Confirm the VM has an external IP by running this command:
````bash
    gcloud compute instances describe $VM_NAME --zone=$ZONE --format="value(networkInterfaces[0].accessConfigs[0].natIP)"
*NOTE: Public web access and SSH from your laptop are impossible without this external IP. 

- Step 4: Lots of VM connectivity issues are caused by mistakes in the setting up of firewall rules. Run this command to check if this is an issue with your VM:
````bash
    gcloud compute firewall-rules list
*IMPORTANT: Make sure you confirm there is an enabled rule allowing tcp:22 from 0.0.0.0/0 or at minimum 35.235.240.0/20 (for IAP), and rules allowing tcp:80 and tcp:443 from 0.0.0.0/0. Check that no DENY rule with priority lower than 1000 overrides these allows, and that no needed rule has disabled: True. 

*EXTRA IMPORTANT: If any of the above don’t pass check, address the issue(s) and then restart the VM. Then, use the following steps to verify that the VM is working.

- Step 5: AFter you fix the firewall issue, verify that the external IP can be accessed publicly by running this command:
````bash
    gcloud compute ssh $VM_NAME --zone=$ZONE  
*IMPORTANT: IAP tunneling works even when tcp:22 is closed from the public internet, as long as the IAP firewall rule for 35.235.240.0/20 exists. It is the preferred fallback when direct SSH fails. You will know that you did this right when you receive a shell prompt on the VM. If you get permission errors, grant yourself roles/iap.tunnelResourceAccessor and verify the IAP firewall rule exists.

- Step 6: VErify the external IP by running this command:
````bash
    gcloud compute instances describe $VM_NAME --zone=$ZONE --format="value(networkInterfaces[0].accessConfigs[0].natIP)"
*NOTE: If the VM is still not working after that, escalate the issue with a well constructed ticket. Here is an example.

# Example Ticket
Subject: VM TRoubleshooting
Date: 8.25.2026
Content: Not able to SSH into VM, No External IP, Deny All Firewall Rule configured highest priority
Reprioritized deny all firewall rule to allow http. SSH available in console, but times out during connection. External IP available and displayed but can’t access web server. 
