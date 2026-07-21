# What is a Port Scan?

How hackers or security experts find vulnerability points on a device?

They do this using a tool called a Port Scan.

## 1. The Analogy: A Secured Building with 65,536 Doors

Imagine a massive, secure office building or apartment complex.

* The Host (the IP address or domain) is the street address of the building. It gets you to the front gate.
* Once inside, the building has exactly 65,536 numbered doors (called Ports).
* Behind each door is a specific business or service. For example, behind Door 80 is a website manager, and behind Door 554 is a security camera stream.

  💡 A Port Scan is like a security guard walking down the hallways, knocking on the doors, and checking which ones are open, locked, or completely abandoned.

If a door is Open, it means a service is actively running behind it and listening for connections. If it is Closed, the door is locked and nobody is inside.

## 2. Choosing Your Target: Well-Known vs. Custom Range

You can choose which "doors" you want to check:

### A. Well-Known Ports (Checking the Main Lobby)

Out of the 65,536 possible doors, the vast majority are empty. By default, the internet reserves the first 1,024 doors for standard, official services.

* Door 80: Standard Websites (HTTP)
* Door 443: Secure Websites (HTTPS)
* Door 21: File Sharing (FTP)
* Door 22: Secure Remote Controls (SSH)
* How it helps you: Scanning Well-Known Ports is like checking only the main lobbies and loading docks of the building. It is incredibly fast (takes just a couple of seconds) and covers 99% of the things a normal user is looking for.

### B. User-Defined Range (Searching Every Room)

Sometimes, custom apps, smart-home devices, or cameras hide behind unusual door numbers (like Door 8080 or Door 32400) to keep out of sight.

* How it helps you: You can tell the app to scan a custom range—for example, from Door 1 to Door 2048. The app will diligently knock on every single one of those doors, one after the other, to find hidden services.

## 3. The Protocols: TCP vs. UDP

The "doors" of a computer speak two different languages. Depending on your settings, the app will knock using different styles:

### 1. TCP (The Polite Handshake)

TCP (Transmission Control Protocol) is the most common protocol on the internet. It is designed for 100% accuracy.

* The Knock Style: The app knocks on the door, waits for someone to open it, shakes their hand, says "Hello!", and then politely leaves.
* Analogy: Like sending a registered letter. It is extremely reliable for confirming if someone is home, but the "handshake" takes a fraction of a second to complete.

### 2. UDP (The Postcard Throw-and-Go)

UDP (User Datagram Protocol) is designed for raw speed, often used for live video streams or online gaming.

* The Knock Style: The app throws a postcard through the mail slot and listens for a split second to see if anyone inside yells back. It does not wait to shake hands.
* Analogy: Like throwing a paper airplane over a fence. It is incredibly fast, but if nobody yells back, it is harder to be 100% sure if the room is empty or if they just ignored your paper airplane.

## 4. Why Does a Large Scan Take So Much Time?

*"Why is my scan taking so long?"* The answer is simple math!

* If you scan Well-Known Ports using TCP only, the app checks about 60 doors. It finishes in a flash.
* If you expand the range from 1 to 10,000 and select Both TCP and UDP, the app physically has to perform **20,000** individual knocks (**10,000** for TCP, and **10,000** for UDP).

Because the app has to wait a tiny fraction of a second at each door to see if a device replies (to avoid missing a slow-responding camera or router), checking tens of thousands of doors requires patience.

To save time, always start with a "Well-Known" scan first! Only run custom, wide-range scans if you are hunting for a highly specific, hidden device on your network.
