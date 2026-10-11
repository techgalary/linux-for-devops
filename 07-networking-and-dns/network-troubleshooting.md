# Linux Networking and DNS Troubleshooting

DevOps engineers frequently investigate problems such as a service being unreachable, a hostname failing to resolve, a port not accepting connections, or a request timing out. This lesson introduces common Linux networking tools and a structured troubleshooting workflow.

> **Goal:** Inspect network interfaces, IP addresses, routes, DNS resolution, connectivity, and listening ports using safe diagnostic commands.

## 1. Inspect network interfaces and IP addresses

Show network interfaces and their addresses:

```bash
ip addr
```

Show only addresses:

```bash
ip -brief address
```

The output may include:
- A loopback interface such as `lo`.
- An Ethernet or virtual interface.
- A wireless interface on laptops.
- Container or VPN interfaces.

Interface names vary by system. An interface can exist without having a working connection.

## 2. Inspect routes

Show the routing table:

```bash
ip route
```

The default route is often used to reach destinations that do not match a more specific route. A route alone does not prove that the destination is reachable; firewall rules, gateways, DNS, and remote services may still be issues.

To see the route the kernel would choose for a destination:

```bash
ip route get 1.1.1.1
```

This asks the local routing table how it would route traffic to that IP address. It does not send a connectivity test packet.

## 3. Test basic connectivity with `ping`

Try:

```bash
ping -c 4 1.1.1.1
```

`-c 4` asks `ping` to send four packets and then stop. Some networks block or deprioritise ICMP, so no response does not automatically mean the destination or application is down.

Compare with a hostname:

```bash
ping -c 4 example.com
```

If the IP-address test works but the hostname test fails, DNS is one possible cause. It is not the only possible cause; compare the error messages and inspect DNS configuration.

Use connectivity tests only against systems you are permitted to test.

## 4. Understand DNS resolution

DNS translates hostnames such as `example.com` into IP addresses and other records.

Query a hostname:

```bash
getent hosts example.com
```

If installed, `dig` can provide more detail:

```bash
dig example.com
dig A example.com
dig AAAA example.com
```

- `A` records map a hostname to IPv4 addresses.
- `AAAA` records map a hostname to IPv6 addresses.

You can also try:

```bash
nslookup example.com
```

`dig` and `nslookup` may not be installed by default. `getent` uses the system's configured name-service resolution path, which can involve DNS and other sources such as `/etc/hosts`.

Inspect resolver configuration:

```bash
cat /etc/resolv.conf
```

On some systems this file is managed automatically or points to a local resolver. Do not edit it as a troubleshooting shortcut without understanding how networking is managed on that machine.

## 5. Check hostname resolution through `/etc/hosts`

The `/etc/hosts` file can contain local hostname-to-address mappings:

```bash
cat /etc/hosts
```

Test the system's configured name resolution:

```bash
getent hosts localhost
```

If a hostname resolves to an unexpected address, inspect the relevant name-service configuration and any local overrides. Do not add or change entries on shared or production machines without authorisation.

## 6. Check listening ports and sockets

Show listening TCP and UDP sockets:

```bash
ss -lntup
```

Common options:
- `-l` — listening sockets.
- `-n` — numeric addresses and ports.
- `-t` — TCP sockets.
- `-u` — UDP sockets.
- `-p` — process information when available and permitted.

For listening TCP sockets only:

```bash
ss -lnt
```

A service listening on `127.0.0.1` may accept connections only from the local machine, while a service bound to `0.0.0.0` generally listens on all IPv4 interfaces. IPv6 binding behaviour depends on the system configuration.

Do not assume that an open listening port is reachable from another machine. Firewalls, routing, cloud security rules, and service binding can affect reachability.

## 7. Test an application endpoint with `curl`

If `curl` is installed, request a public test endpoint:

```bash
curl -I https://example.com
```

`-I` requests response headers. Some servers handle `HEAD` requests differently from normal `GET` requests, so a failure here does not always mean a regular browser request would fail.

For more connection detail:

```bash
curl -v --max-time 10 https://example.com/
```

The verbose output may include hostnames, addresses, headers, and other details. Avoid sharing output that contains cookies, authentication headers, tokens, or private information.

Use `--max-time` to limit how long the command waits for the operation. A timeout helps keep tests bounded but does not identify the root cause by itself.

## 8. Inspect a network path with `traceroute` or `tracepath`

If available:

```bash
tracepath example.com
```

or:

```bash
traceroute example.com
```

These tools attempt to show network hops between your machine and a destination. Some routers do not respond to the probes, so missing hops do not necessarily indicate a broken path. The tools may not be installed by default, and networks may restrict their traffic.

## 9. Understand common networking errors

- **Name or service not known / could not resolve host:** Check the hostname spelling and DNS resolution.
- **Connection refused:** The destination was reachable enough to reject the connection, but no service may be listening on that address and port, or a device actively rejected it.
- **Connection timed out:** Traffic or responses may be blocked, routed incorrectly, or delayed; the remote service may also be unavailable.
- **No route to host / network unreachable:** Inspect local addresses, routes, gateways, and relevant network policies.
- **Works locally but not remotely:** Check the address the service binds to, host firewall, cloud firewall/security rules, routing, and port exposure.

Error messages vary by application and operating system. Treat them as clues, not definitive diagnoses.

## 10. A practical troubleshooting sequence

When an application cannot be reached, work from the local system toward the destination:

1. **Confirm the exact symptom:** Record hostname, port, protocol, source, and time of failure.
2. **Check local interfaces:** Run `ip -brief address`.
3. **Check routes:** Run `ip route` and, when useful, `ip route get DESTINATION_IP`.
4. **Check name resolution:** Use `getent hosts HOSTNAME` or `dig HOSTNAME`.
5. **Check local service state:** If you administer the destination, inspect service status and listening sockets with `ss`.
6. **Test the endpoint:** Use an approved `curl` or other protocol-specific test.
7. **Compare perspectives:** A test from the server itself may succeed while a test from another host fails.
8. **Review policy and logs:** Check host firewalls, cloud security rules, proxies, and application logs according to your environment's runbook.

Replace placeholder values such as `HOSTNAME` and `DESTINATION_IP` with the real values. Do not paste placeholder strings directly into commands that require actual addresses.

## 11. Hands-on exercises

Use your own machine or an authorised lab.

1. Run `ip -brief address` and identify the loopback interface.
2. Run `ip route` and identify the default route if present.
3. Query `localhost` with `getent hosts localhost`.
4. If DNS tools are available, query `example.com` with `dig` or `nslookup`.
5. Run `ping -c 4 1.1.1.1` if network policy permits it.
6. Use `ss -lnt` to inspect listening TCP ports.
7. Use `curl -I https://example.com` if permitted.
8. Explain why a successful `ping` does not prove that a web application is healthy.
9. Explain why a service listening only on loopback may not be reachable from another machine.

## 12. Knowledge check

1. Which command displays local IP addresses?
2. What does the default route do?
3. What is the difference between DNS resolution and an application connection?
4. Why can `ping` fail even when a web service works?
5. What does `ss -lnt` display?
6. Name three possible causes of a connection timeout.
7. Why should verbose network output be reviewed before sharing it?

**Suggested answers**

1. `ip addr` or `ip -brief address`.
2. It provides a route for destinations that do not match a more specific route.
3. DNS maps names to records/addresses; an application connection then attempts to communicate with a service.
4. ICMP may be blocked or deprioritised even when TCP/HTTPS traffic is allowed.
5. Listening TCP sockets, using numeric addresses and ports.
6. Firewall rules, routing issues, an unavailable destination, packet loss, or delayed responses.
7. It may contain sensitive host details, headers, cookies, or tokens.

## What comes next?

Continue to `08-logs-and-troubleshooting/log-analysis.md` to practise using logs and evidence to investigate failures.

---

**Safety note:** Run network tests only against destinations you are authorised to test. Do not change firewall rules, routes, DNS settings, or exposed ports on production systems without approval and a tested plan.
