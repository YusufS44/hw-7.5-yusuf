Week 10 Q&A
DNS and SSL/TLS
Question 1: Explain what the traceroute and dig commands do. Compare and contrast.

traceroute and dig are both tools used to troubleshoot internet connection problems, but they check different things.

traceroute shows the path your internet traffic takes from your computer to a website or server. Think of it like tracking a package as it moves through different stops before reaching its destination.

For example, if you try to reach google.com, traceroute shows each router your request passes through along the way. This helps you see where the connection slows down or fails.

dig is different. It checks DNS information. DNS is like the internet’s phone book. It translates a website name, like example.com, into an IP address, like 192.0.2.1.

So, in simple terms:

traceroute answers:
“What path does my traffic take to reach the website?”

dig answers:
“What IP address does this website name point to?”

They can be used together. First, you can use dig to find the IP address of a website. Then, you can use traceroute to see the path your computer takes to reach that IP address.

Question 2: What are the 3 or 4 most common DNS records and what are their use cases?

DNS records are instructions that tell the internet how to handle a domain name.

The most common DNS records are:

A Record

An A record points a domain name to an IPv4 address.

Example:
example.com points to 192.0.2.1

Use case:
You use an A record when you want your website domain to connect to the server hosting your website.

AAAA Record

An AAAA record points a domain name to an IPv6 address.

IPv6 is a newer type of internet address.

Use case:
You use an AAAA record when your website or server supports IPv6.

CNAME Record

A CNAME record is an alias. It points one domain name to another domain name.

Example:
www.example.com points to example.com

Use case:
You use a CNAME when you want different names to lead to the same website.

MX Record

An MX record tells the internet which mail server handles email for a domain.

Use case:
You use an MX record so email sent to your domain knows where to go.

Example:
If someone emails you@example.com, the MX record helps route that email to the correct mail server.

Question 3: Give an overview of the steps in a TLS handshake.

A TLS handshake is the process that happens when your browser and a website create a secure connection.

This is what allows a website to use https:// instead of just http://.

Here is the simple version:

Step 1: The browser says hello

Your browser connects to the website and says:

“I want to create a secure connection. Here are the security options I support.”

Step 2: The server says hello back

The website’s server responds and says:

“Okay, we will use this security method.”

The server also sends its SSL/TLS certificate.

Step 3: The browser checks the certificate

Your browser checks the certificate to make sure the website is real and trusted.

It checks things like:

Was this certificate issued by a trusted certificate authority?
Does the certificate match the website domain?
Is the certificate still valid?
Step 4: They create a shared secret key

The browser and server securely create a shared session key.

This key is used to encrypt the data sent between them.

Step 5: Secure communication begins

Once the key is created, the browser and server use it to send encrypted data.

That means outsiders cannot easily read the information being sent.

Question 4: How does an SSL/TLS cert know what domain it belongs to?

An SSL/TLS certificate includes the domain name inside the certificate.

For example, a certificate might say it is valid for:

example.com

or

www.example.com

Modern certificates usually store this information in a field called Subject Alternative Names, often shortened to SAN.

When you visit a website, your browser checks the domain in the address bar against the domain names listed in the certificate.

If they match, the browser trusts the connection.

If they do not match, the browser may show a security warning.

Simple version:

The certificate says:

“I belong to this domain.”

The browser checks:

“Does this certificate match the website I am visiting?”

Question 5: What is a certificate authority?

A certificate authority, or CA, is a trusted organization that issues SSL/TLS certificates.

Think of a certificate authority like the DMV issuing a driver’s license.

The DMV verifies who you are before giving you a license.

A certificate authority verifies that a website or organization owns a domain before giving it a certificate.

Browsers trust certain certificate authorities. If a website has a certificate from a trusted CA, the browser is more likely to trust the website.

Examples of certificate authorities include:

DigiCert
Sectigo
GlobalSign
Let’s Encrypt

Let’s Encrypt is popular because it gives free SSL/TLS certificates.

There is also a hierarchy:

A root certificate authority is at the top. It is highly trusted and protected.

An intermediate certificate authority does most of the everyday work of issuing certificates.

This setup helps protect the system. If an intermediate CA has a problem, the root CA can remain safe.

Question 6: How do application load balancers in GCP offload or decrypt SSL? What part of the load balancer does this?

In Google Cloud Platform, an Application Load Balancer can handle SSL/TLS encryption for your application.

This is called SSL termination or SSL offloading.

It means the load balancer handles the secure HTTPS connection from the user.

The user connects securely to the load balancer.

Then the load balancer sends the request to your backend servers.

The important parts are:

Forwarding Rule

The forwarding rule listens for traffic.

For HTTPS, it usually listens on port 443.

Port 443 is the standard port for secure web traffic.

Target HTTPS Proxy

The Target HTTPS Proxy is the part that uses the SSL/TLS certificate.

It helps complete the secure handshake with the user’s browser.

Google Front End

For global external Application Load Balancers, Google Front End, or GFE, helps handle the secure connection close to the user.

After the traffic is decrypted, the load balancer can send it to the backend using either:

HTTP, which is not encrypted
HTTPS, which is encrypted again

Simple version:

The load balancer receives the secure HTTPS traffic, decrypts it, and then passes the request to the backend.

Question 7: Are there use cases to have in-flight encryption from the backend service to the backend itself?

Yes.

Sometimes you want traffic to stay encrypted even after it passes through the load balancer.

This means the connection from the load balancer to the backend server is also encrypted.

This is useful when security requirements are higher.

Examples include:

Healthcare systems
Financial systems
Government systems
Multi-tenant systems
Zero trust environments

In simple setups, the load balancer may decrypt HTTPS traffic and then send it to the backend using HTTP.

That is easier to manage.

But in more secure setups, the load balancer decrypts the traffic and then re-encrypts it before sending it to the backend.

This gives stronger protection.

Simple version:

HTTP to the backend is easier.

HTTPS to the backend is more secure.

Question 8: Can multiple domains end up pointing to the same load balancer?

Yes.

Multiple domains can point to the same load balancer.

Think of a load balancer like the front desk of a large office building.

Many companies may share the same building address, but the front desk knows where each visitor should go.

For example, these domains could all point to the same load balancer:

example.com
store.example.com
training.example.com
anothercompany.com

When a request comes in, the load balancer checks the Host header.

The Host header tells the load balancer which domain the user was trying to reach.

Then the load balancer sends the request to the correct backend service.

Simple version:

One load balancer can serve many websites.

Question 9: In the context of Cloud DNS, what are zones?

In Cloud DNS, a zone is a container that holds DNS records for a domain.

Think of a DNS zone like a folder for one website domain.

For example, if you own:

example.com

You can create a DNS zone for that domain.

Inside that zone, you store records like:

A records
AAAA records
CNAME records
MX records
TXT records

These records tell the internet how to handle traffic for that domain.

Simple version:

A DNS zone is where you manage all the DNS settings for a domain.

It is the official place where DNS answers for that domain are stored.