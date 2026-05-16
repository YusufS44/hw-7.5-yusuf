# Q&A 
- Load Balancers
How does load balancing contribute to Fault tolerance? What about high availability? 
  Load balancing helps with fault tolerance by automatically sending traffic away from a failed server to healthy ones, if one server crashes, users don't even notice. For high availability, it helps by making sure there's always a working server ready to respond, since the workload is spread across multiple machines instead of relying on just one.
  
Do global load balancers decrease latency for end users? Why or why not?
    Yeah, global load balancers reduce latency by routing users to the nearest or best-performing data center geographically. Instead of a user in Tokyo hitting a server in New York, they get routed to a server in Asia — cutting down the physical distance data has to travel, which directly reduces response time.
What are LB health checks for? Do we always need them? Is a LB different from a reverse proxy?
    Health checks are how the load balancer knows if a server is still alive. It pings each server regularly, and if one doesn't respond, it stops sending traffic there.
You almost always want them — without them, the load balancer might keep sending users to a crashed server.
    As for load balancer vs. reverse proxy — a reverse proxy just sits in front of your servers and forwards requests. A load balancer does that plus spreads traffic across multiple servers. In practice they overlap a lot — tools like Nginx can act as both.
What are LB routing rules and URL maps for? Give an example or two of them in use.
    Routing rules and URL maps tell the load balancer where to send different requests, instead of sending everything to the same place. Think of it like a restaurant host instead of seating everyone at the same table, they direct you based on your needs: parties of 2 go to the small tables, large groups go to the big tables, and VIPs go to the private room.
Explain what an anycast IP address is used for in the context of a global load balancer.
    An Anycast IP is one single IP address that lives on multiple servers around the world. When you send a request to it, the internet automatically routes you to the nearest one — no extra logic needed. Like a chain restaurant. Every location has the same name and menu, and when you're hungry, you just go to the nearest one — you don't need to know the address of every location, you just search "near me" and get routed there automatically. In global load balancing, Anycast is what makes sure a user in Tokyo hits an Asian server and a user in London hits a European one — all through the same single IP address.
- Cloud Armor
What does cloud armor offer?
    Cloud Armor is Google's security service that sits in front of your load balancer and protects your application from threats. It blocks DDoS attacks, filters out malicious traffic using a Web Application Firewall (WAF), and lets you set rules to allow or deny traffic based on IP addresses or regions. Think of the load balancer as the host seating guests, and Cloud Armor as the bouncer at the door deciding who even gets inside.
Why is it used in the first place?
    Without Cloud Armor, your load balancer is basically an open door — it just lets everyone in and passes them along. Cloud Armor is the security guard that checks people before they walk through that door, turning away the bad actors so only legitimate traffic gets through.
What layer in the OSI model does it operate at? Why is this important and how is this firewall different from VPC firewall rules?
    Cloud Armor operates at Layer 7, which means it can actually read and understand the content of requests — like what URL someone is hitting or what data they're sending. This is important because it lets Cloud Armor catch sneaky attacks that hide inside otherwise normal-looking traffic. VPC firewall rules on the other hand only work at the network level — they can block traffic based on IP addresses and ports, but they can't see inside the request itself. Think of VPC firewall rules as a fence around your property, and Cloud Armor as a security guard who actually checks what's in your bag before letting you in.
What are rate based rules for?
    Rate based rules let you limit how many requests a single client can make in a given time window. If someone exceeds that limit — whether it's a bot hammering your site or a DDoS attack — Cloud Armor automatically blocks them. It's basically a way of saying "you can knock on the door, but not a thousand times per second."
What is reCAPTCHA and how does it relate to this service?
    reCAPTCHA is just those little "prove you're human" challenges you see on websites. Cloud Armor can automatically serve one to anyone who looks suspicious — so instead of just blocking them, it gives real humans a chance to prove they're not a bot.
- Cloud CDN
What are POPs used for?
    Points of presence are basically Google's servers scattered around the world that act as the first stop for user traffic. Instead of a request traveling all the way to your main data center, it hits the nearest POP first — which reduces latency and lets things like Cloud Armor and load balancing kick in as close to the user as possible.
What kind of files are served with Cloud CDN?
    Cloud CDN serves static files — things that don't change between users, like images, videos, CSS, JavaScript, and HTML files. Instead of fetching them from your server every time, they get cached at a nearby POP so users get them faster.
What services can be used with cloud CDN for the source of content (the origin)? 
    Cloud CDN can pull content from a few different origins. The most common are Cloud Storage buckets for static files, Compute Engine VMs, and serverless options like Cloud Run or Cloud Functions. You can even point it at an external backend hosted outside of Google Cloud entirely, making it flexible regardless of where your content actually lives.
Does Cloud CDN help protect against any types of malicious actors or cyberattacks? Explain. 
    Cloud CDN isn't really a security tool, but it does offer some indirect protection. Because cached content is served from Google's POPs instead of your origin server, your actual backend stays hidden and absorbs far less direct traffic — making it harder for attackers to overwhelm it.Think of it like a food truck that sells pre-packaged meals. The kitchen (your origin) stays in the back and barely gets touched, because most customers are just grabbing something off the shelf. An attacker trying to flood the kitchen still has to get through the food truck first.
Should an enterprise always use cloud CDN? Why or why not?
    Not always. Cloud CDN is great if you're serving lots of static content like images or videos to users all over the world — it speeds things up significantly. But if your app serves personalized or real-time content, like a banking app, there's not much to cache so the benefit is minimal. It also costs money, so it's only worth it if the performance gains justify the expense.
What is TTL and how does it control content “freshness”? 
    Time to live is a timer that tells the CDN how long to cache a file before fetching a fresh copy from the origin. For example, a 24 hour TTL on an image means the CDN serves that same cached version to everyone for 24 hours before checking for updates. It's a tradeoff — longer TTL means faster delivery but potentially stale content, shorter TTL means fresher content but more load on your origin.