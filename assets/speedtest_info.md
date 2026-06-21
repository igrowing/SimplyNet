# Speed Test

SimplyNet measures your internet connection by transferring data to and from a test server and timing it. Three numbers are reported:

- **Download** — how fast data reaches your device, in Mbps. Higher is better.
- **Upload** — how fast your device sends data out, in Mbps. Higher is better.
- **Ping** — the round-trip delay to the server, in milliseconds. Lower is
  better.

## Choosing a provider

The dropdown under the **Start Test** button selects which test backend is
used.

## Speed test service comparison

| Feature | Cloudflare (Default) | Ookla |
|---|---|---|
| Measurement Goal | Real-world web browsing speed | Absolute theoretical line capacity |
| Privacy Status | 100% Anonymous. Zero tracking | Collects IP, location, and device data |
| Technical Method | Single-stream progressive download | Multi-stream network saturation | 
| Ideal For | Gauging daily internet performance | Verifying ISP advertised speeds |

### Via Cloudflare (default)

Uses Cloudflare's public `speed.cloudflare.com` endpoints. No account or extra consent is required, and no personal identifiers are shared beyond the normal information any website request carries (such as your IP address, which is needed to deliver the response).

This is the recommended option for most users.

### Via Ookla

Uses Ookla's global speedtest.net server network — the same infrastructure behind the well-known Speedtest service. Ookla servers are operated by third parties around the world, so a test connects to whichever server is nearest and reachable.

Because this involves third-party servers, choosing Ookla asks for your consent the first time. **Ookla collects and shares your IP address, device identifiers, and location data.** Your choice is remembered so you are not asked again; you can switch back to Cloudflare at any time.

When Ookla is active the **Start Test** button turns amber as a reminder that a third-party backend is in use. Cloudflare restores the blue button.

## Tips for accurate results

- Test over Wi-Fi or mobile data depending on what you want to measure.
- Close other apps that may be using the network.
- Run the test a few times — results vary with network conditions and server load.
- Very high-speed links may be limited by the device or the test method rather than your actual connection.

## Privacy

Results are stored only on your device under **Previous Measurements**. You can clear them at any time from the history section. SimplyNet does not upload your results anywhere.
