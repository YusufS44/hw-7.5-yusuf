# Q&A

- High Availability vs. Fault Tolerance
    -    Both approaches involve avoiding system downtime. High Availability (HA) comes from the use of redundant VMs, all running the same services in the same conffiguration. Fault Tolerance (FT) means the system has zero interruptions making it both more reliable as well as more expensive and requires a resource heavy architecture because it includes duplicating the infrastructure. Honestly, HA is the better option because it is possible to reach 99.99% availability which is cheaper than FT. FT is mainly used when downtime is catastrophic. Life safety - i.e. systems that either sustain life or help save lives, financial trading, and aviation are some examples of cases where FT is the goal to strive for.
- Autoscaling vs. Elasticity
    -    Both concepts deal with adjusting capacity to demand. Elasticity is the property of being able to scale up and down to match demand, while autoscaling is the mechanism — i.e. the rules and metrics — that automates that scaling. There are two types of scaling: vertical (resizing one machine with more CPU/RAM, which hits a ceiling and usually requires a restart) and horizontal (adding or removing identical instances behind a load balancer, which is basically unbounded but requires stateless workloads). Honestly, horizontal is the better option because it scales further, isolates failures better, and fits cloud-native patterns like MIGs + load balancers. Vertical still has its place — i.e. stateful workloads like databases that don't shard easily. On-prem, you can do some of this if you have headroom or spare hardware, but true elasticity is really a cloud property because you can't rack a new server in 30 seconds.
- Managed vs. Unmanaged Instance Groups
    -    These are ways of grouping VMs together. A managed instance group (MIG) is a fleet of identical VMs built from an instance template that GCP treats as a single unit — i.e. it can autoscale, autoheal, and roll updates across them. An unmanaged instance group (UIG) is just a bag of different VMs grouped together so a load balancer can hit them as one backend — no template, no autoscaling, no autohealing. Honestly, MIGs are the better option for nearly every modern design because of the automation. UIGs are mainly for legacy or transitional cases where the VMs genuinely need to be different from each other but still share traffic.
- Application vs. Load Balancer Health Checks
    -    These health checks check whether a VM is healthy, but they drive different actions. The MIG's health check drives autohealing — i.e. if the checks fail persistently, the MIG deletes and recreates the VM. The load balancer's health check drives traffic routing — failing backends get pulled out of rotation but otherwise left alone. They can hit the same endpoint and often do, but they're distinct GCP resources and separate API calls. Honestly, the thresholds should differ — LB checks should be aggressive (pull a sick instance fast) while autohealing should be conservative (don't recreate a VM over a transient blip). Same endpoint, different sensitivities.
- Three-Tier Architecture
    -    Three-tier architecture separates an application into a presentation tier (web/UI), an application tier (business logic/API), and a data tier (database) — each scaling and securing independently. It maps cleanly onto network design — i.e. public subnet for web, private subnet for the app layer, locked-down subnet for the database, with firewall rules controlling which tier talks to which. My Terraform stack is the foundation for that pattern — the VPC, subnets, Cloud Router, Cloud NAT, and firewall rules are exactly the primitives you'd use to place each tier in its own security boundary, and the Apache VM from startup.sh is sitting in the web tier. The NAT in particular is what lets private-tier VMs reach the internet for package installs and API calls without ever being publicly addressable — which is the whole point of a tiered design.

# Runbook

The goal here is to spin up a fully configured Managed Instance Group via the GCP console — i.e. autoscaling and autohealing turned on, with instances spread across multiple zones in `us-central1`.

### Prerequisites

- GCP project with the Compute Engine API enabled
- VPC and subnet in `us-central1` (or just use the default VPC)
- Compute Admin IAM role

---

### Step 1 — Create a Health Check

The health check has to be created before the MIG — autohealing needs something to point at, and you can't bolt one on after the fact without recreating things.

**Compute Engine > Health Checks > Create**
- Name: `week8-health-check`
- Protocol: `HTTP` | Port: `80` | Path: `/`
- Check interval: `10s` | Unhealthy threshold: `3`

---

### Step 2 — Create an Instance Template

The template is what the MIG uses to stamp out identical VMs — i.e. all the VM config goes here, not on the MIG itself.

**Compute Engine > Instance Templates > Create**
- Name: `week8-template`
- Machine type: `n2-standard-2`
- Boot disk: CentOS Stream 10, `100 GB`
- Network: your VPC or default
- Network tag: `http-server`

---

### Step 3 — Create the Managed Instance Group

This is where everything comes together — i.e. the template, the health check, autoscaling, and the multi-zone setup all get tied to the MIG here.

**Compute Engine > Instance Groups > Create > New managed instance group (stateless)**
- Name: `week8-mig`
- Template: `week8-template`
- Location: **Multiple zones** | Region: `us-central1` | leave the zones as default
- Autoscaling: **On** | Signal: CPU | Target: `60%` | Min: `2` | Max: `5`
- Autohealing: pick `week8-health-check` | Initial delay: `300s`

Then hit **Create**.

---

### Step 4 — Verify Multi-Zone Distribution

**Compute Engine > Instance Groups > week8-mig > Instances tab**

Confirm the instances are spread across different zones — i.e. `us-central1-a`, `us-central1-b`, and `us-central1-c`. Multi-zone is set at creation, i.e. you can't change it after the fact.

---

### Critical Notes

- The health check has to be created before the MIG — autohealing has nothing to configure against otherwise
- Initial delay needs to be high enough to cover the startup script runtime — too low and the MIG will start killing instances that are still booting up
- Honestly, multi-zone is the easiest thing to mess up here — it's locked in at creation, so if you forget to set it you're recreating the whole MIG

# Terraform

- A VM needs the following arguments
    - Resource Google Compute Instance: name and machine type
    - boot disk: The image and size parameters
    - Network Interface: Subnetwork and subnetwork configuration

- Non-required Arguements
    - Metadata Startup Script: The commant to start the start up file as well as the name of the   start up file
    - Zone: This is where the machine is created. If I list it in the provider (authentication.tf) I don't need it in the compute.tf file.

- Explain how to output the internal and external IP addresses of the provisioned VM and how you figured this out 
    - Adding an output block to the configuration exposes information about the infrastructure on the command line, in HCP Terraform, and in other Terraform configurations.
    - In the outputs.tf file, add 2 resource blocks, one for internal IP and anotehr for the external IP. You can find these in the Terraform Developer Registry.

- VM Format 
    - Step 1: Look up the compute_instance terraform code inthe terraform registry. This just gives you the compute_instance format. You still need the format for the image. Make sure you have all of the required arguments.
    - Step 2: Run gcloud compute images list grep centos.
    - Step 3: Copy the specific image name.
    - Step 4: Paste the image name into the proper place in the image argument.
    - Stap 5: Save the compute.tf file.
    - Step 6: Run the Terraform commands in VS code, assuming the aforementioned compute.tf file is in the folder and the terminal is showing the proper folder.
    - Step 7: If there are no errors showing for your compute.tf specific to the image terraform code, then you are good.

- Explain the difference between the “name” argument and the computed “id” and “self_link” attributes
    - The name is what we call the VM.
    - The compute.id is the unique attribute assigned to the resource by the cloud provider after it is created.
    - The self_link attribute is the URI of a resource. A URI is an address that stands for Uniform Resource Identifier. It assigns the IP address to the provisioned VM.

# Annotated Resources
- 00-aunthentication.tf
    - Terraform Registry - (registry.terraform.io/providers/hashicorp/google/latest) - In the top-right corner of the screen, there is a purple button. I selected it and copied the Provider code from there and into my 00-authentication.tf file.
    - Other Resources
- 01-vpc.tf - 
    - Terraform Registry
        - google_project_service - (https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/google_project_service) -  I used this resource to enable compute.googleapis.com and container.googleapis.com. I set disable_on_desrtoy to false because I don't want to disable the Compute API when use submit the terraform destroy command in the terminal (git bash)
        - google_compute_network - (https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) - I used this for the name and teh auto_create_subnetworks. I set the auto_create_subnetworks to false so the code won't automatically create a subnet and to avoid overlapping CIDRs.
        - google_compute_subnetwork - (https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) - I used this resource to confirm the required arguments. Those arguments are name, ip_cidr_range, region, and network.
    - Other Resources - I had to use each resource listed above to double check that I only included the required arguments.
- 02-subnets.tf
    - Terraform Registry
        - google_compute_subnetwork - (https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) - I used this resource to find the private_ip_google_access code. I set it to true. Even though this is listed as optional in the registry, I had to include it for this assignment because it had to show up in the outputs when I run terraform IVPA.
    - Hashicorp Developer
        - depends_on - (https://developer.hashicorp.com/terraform/language/meta-arguments) - I used this resource to find the code that tells terraform to complete all actions on the dependency before performing actions on teh object declaring the dependency.
    - Other Resources - Experience setting up these resources has told me that I sometimes forget to make sure that the CIDRs can't overlap. I added a comment in the file as a reminder to check for this.
- 03-router.tf
    - Terraform Registry - (https://registry.terraform.io/providers/hashicorp/google/5.43.1/docs/resources/compute_router) - I used this to make sure I included the required arguments for teh router. Those arguments are name, region, and network.
    - Other Resources - None
- 04-nat.tf
    - Terraform Registry 
        - google_compute_router_nat - (https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) - I used this to find out what I need to include in this file. That includes ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RaNGES, and LIST_of_SUBNETWORKS.
        - google_compute_address - (https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) - I sued this resource to get the code to get the external IP address. The 
    - Study group discussion. This discussion helped me understand what is needed fro this file and how to format the resources as well as the file.
    - Google Cloud Documentation - (https://docs.cloud.google.com/compute/docs/ip-addresses/configure-static-external-ip-address) - I used this guide to help me write the google_compute_address resource block so that it will show/get the external IP address.
- 05-firewall.tf
    - Terraform Registry - google_compute_firewall - (https://registry.terraform.io/providers/hashicorp/google/3.41.0/docs/resources/compute_firewall) - I used this resource to make sure that the GCP firewall rules attaches to the network and not just the VM.
    - Study Group Discussion - The study group helped me understand that the firewall rules need to attach at the network level and not at the VM level.
- 06-compute.tf
    - Terraform Registry - google_compute_instance - (https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/compute_instance) - I used this resource ti firm the required arguments. THose arguments are name, boot_disk, and machine_type. I added zone out of habit. Plus, I didn't include teh zone in the 00-authentication file. This page also shows how to load a script from a disk.
    - Google Cloud Documentaiton - gcloud compute image list - (https://docs.cloud.google.com/sdk/gcloud/reference/compute/images/list) - I used this resource to get the command to list the compute images. From the list, I found the exact image identifier.
- 07-outputs.tf
    - Hashicorp Developer - Outputs Overview - (https://developer.hashicorp.com/terraform/language/values/outputs) - I used this to understand how output resources are used.
    - Hashicorp Developer - Outputs Block - (https://developer.hashicorp.com/terraform/language/block/output) - I used this resource, along with group discussion, to help me understand how to format the outputs terraform code in this file.
    - Attributes Reference (google_compute_instance) - (https://registry.terraform.io/providers/hashicorp/google/3.85.0/docs/resources/compute_instance#attributes-reference) - I used this resource to figure out the code for showing the internal and external IP, name, ID, and self_link outputs.