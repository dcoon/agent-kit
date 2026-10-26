# Zoraxy config-file routing (verified, v3.1.7+)

Read this when declaring proxy rules as JSON files. Proxy rules can be declared as JSON in `conf/proxy/<hostname>.config`; Zoraxy loads them at startup. Core fields:

```json
{
  "ProxyType": 1,
  "RootOrMatchingDomain": "test1.localhost",
  "MatchingDomainAlias": ["test2.localhost"],
  "ActiveOrigins": [
    {
      "OriginIpOrDomain": "example.com",
      "RequireTLS": true,
      "SkipCertValidations": false,
      "SkipWebSocketOriginCheck": true,
      "Weight": 1,
      "MaxConn": 0
    }
  ],
  "InactiveOrigins": [],
  "UseStickySession": false,
  "UseActiveLoadBalance": false,
  "Disabled": false,
  "BypassGlobalTLS": false,
  "VirtualDirectories": [
    {
      "MatchingPath": "/firework/",
      "Domain": "example.com/fw/",
      "RequireTLS": true,
      "SkipCertValidations": false,
      "Disabled": false
    }
  ],
  "HeaderRewriteRules": {
    "UserDefinedHeaders": [],
    "RequestHostOverwrite": "",
    "HSTSMaxAge": 0
  }
}
```

The full schema includes per-origin load balancing and a large `PermissionPolicy` block — inspect an existing `.config` on the target install before writing new ones. Changes require a Zoraxy restart/reload to take effect.