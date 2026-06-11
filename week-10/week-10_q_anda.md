## DNS and SSL/TLS

## Question 1: Explain what the traceroute and dig commands do. Compare and contrast.
Traceroute and dig are both tools used to troubleshoot internet connection problems, but they check different things. Traceroute shows the path your internet traffic takes from your computer to a website or server. Think of it like tracking a package as it moves through different stops before reaching its destination.

Example: If you try to reach `google.com`, `traceroute` shows each router your request passes through along the way. This helps you see where the connection slows down or fails. Dig checks DNS information. DNS is like the internet’s phone book. It translates a website name, like `example.com`, into an IP address, like `192.0.2.1`.

### Simple Comparison
* Traceroute answers: “What path does my traffic take to reach the website?”
* Dig answers: “What IP address does this website name point to?”

### How They Work Together
You can use both commands together:
1. Use dig to find the IP address of a website.
2. Use traceroute to see the path your computer takes to reach that IP address.

## Question 2: What are the 3 or 4 most common DNS records and what are their use cases?
    The four most common DNS records are:
    •	Address Record – Use this record to point your domain to the web server hosting your website. It handles IPv4 addresses.
    •	AAAA Record – Use this record to handle IPv6 addresses which are required by the modern internet infrastructure.
    •	Canonical Name (CNAME) Record  - Acts as an alias, pointing one domain name to another domain name instead of an IP address (e.g., pointing www.yourwebsite.com to yourwebsite.com).
    •	Mail Exchange (MX) Record – Use this push email to the correct mail servers for a domain.

## Question 3: Give an overview of the steps in a TLS handshake.
    Step 1: The client’s browser connects to the server, says hi, and lists the TLS versions and cryptographic algorithms it supports.
    Step 2: The server says hi back. In other words, the server replies with its chosen cipher suite and sends over its SSL/TLS certificate.
    Step 3: The client’s browser checks the server’s certificate against its built-in list of trusted certificate authorities to make sure the server is real.
    Step 4: The client and server securely exchange cryptographic data to generate an identical, private session key. This is done using asymmetric encryption.
    Step 5: Both sides send a "finished" message encrypted with that new session key. From this point on, all traffic is symmetrically encrypted and fully confidential.

## Question 4: How does an SSL/TLS cert know what domain it belongs to?
An SSL/TLS certificate includes the domain name inside the certificate. For example, a certificate might say it is valid for:
* example.com
* www.example.com

Modern certificates usually store this information in a field called Subject Alternative Names, often shortened to SAN. When you visit a website, your browser checks the domain in the address bar against the domain names listed in the certificate.
* If they match, the browser trusts the connection.
* If they do not match, the browser may show a security warning.

The certificate says, “I belong to this domain.” The browser checks: “Does this certificate match the website I am visiting?”

## Question 5: What is a certificate authority?
A certificate authority, or CA, is a trusted organization that issues SSL/TLS certificates. Think of a certificate authority like the DMV issuing a driver’s license. The DMV verifies who you are before giving you a license. A certificate authority verifies that a website or organization owns a domain before giving it a certificate.

### Why Certificate Authorities Matter

Browsers trust certain certificate authorities. If a website has a certificate from a trusted CA, the browser is more likely to trust the website.

### Examples of Certificate Authorities

* DigiCert
* Sectigo
* GlobalSign
* Let’s Encrypt

Let’s Encrypt is popular because it gives free SSL/TLS certificates.

### Certificate Authority Hierarchy

There is also a hierarchy.

#### Root Certificate Authority

A root certificate authority is at the top.

It is highly trusted and protected.

#### Intermediate Certificate Authority

An intermediate certificate authority does most of the everyday work of issuing certificates. This setup helps protect the system. If an intermediate CA has a problem, the root CA can remain safe.

## Question 6: How do application load balancers in GCP offload or decrypt SSL? What part of the load balancer does this?
In Google Cloud Platform, an Application Load Balancer can handle SSL/TLS encryption for your application.

This is called:
* SSL termination
* SSL offloading

It means the load balancer handles the secure HTTPS connection from the user.

### Basic Flow
1. The user connects securely to the load balancer.
2. The load balancer decrypts the HTTPS traffic.
3. The load balancer sends the request to your backend servers.

### Forwarding Rule
The forwarding rule listens for traffic.For HTTPS, it usually listens on port 443. Port 443 is the standard port for secure web traffic.

### Target HTTPS Proxy
The Target HTTPS Proxy is the part that uses the SSL/TLS certificate. It helps complete the secure handshake with the user’s browser.

### Google Front End
For global external Application Load Balancers, Google Front End, or GFE, helps handle the secure connection close to the user. After the traffic is decrypted, the load balancer can send it to the backend using either:
* HTTP, which is not encrypted
* HTTPS, which is encrypted again

### Simple Version
The load balancer receives secure HTTPS traffic, decrypts it, and then passes the request to the backend.

## Question 7: Are there use cases to have in-flight encryption from the backend service to the backend itself?
Yes. Sometimes you want traffic to stay encrypted even after it passes through the load balancer. This means the connection from the load balancer to the backend server is also encrypted.

### When This Is Useful
This is useful when security requirements are higher.

Examples include:
* Healthcare systems
* Financial systems
* Government systems
* Multi-tenant systems
* Zero trust environments

### Simple Setup
In simple setups, the load balancer may decrypt HTTPS traffic and then send it to the backend using HTTP. This is easier to manage.

### More Secure Setup
In more secure setups, the load balancer decrypts the traffic and then re-encrypts it before sending it to the backend. This gives stronger protection.


## Question 8: Can multiple domains end up pointing to the same load balancer?
Yes. Multiple domains can point to the same load balancer. Root domains like facebook.com has other domains like settings.facebook.com. Think of a load balancer like the front desk of a large office building. Many companies may share the same building address, but the front desk knows where each visitor should go.

### Example Domains
These domains could all point to the same load balancer:
* example.com
* store.example.com
* training.example.com
* anothercompany.com

### How the Load Balancer Knows Where to Send Traffic
When a request comes in, the load balancer checks the Host header. The Host header tells the load balancer which domain the user was trying to reach. Then the load balancer sends the request to the correct backend service.

## Question 9: In the context of Cloud DNS, what are zones?
In Cloud DNS, a zone is a container that holds DNS records for a domain. Think of a DNS zone like a folder for one website domain. If you own: example.com you can create a DNS zone for that domain. Inside that zone, you store records like:
* A records
* AAAA records
* CNAME records
* MX records
* TXT records

A DNS zone is where you manage all the DNS settings for a domain. It is the official place where DNS answers for that domain are stored.
