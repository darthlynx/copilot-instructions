# Troubleshooting

Suggested order:
1. `kubectl get <xr-kind> -n <ns>`
2. `kubectl describe <xr-kind> <name> -n <ns>`
3. inspect composed resources
4. inspect events in the namespace
5. inspect provider config references
6. inspect function pipeline configuration
7. verify the provider supports the resource and scope you expect

Common fault domains:
- XRD schema mismatch
- patch/transform mistakes
- missing or wrong `providerConfigRef`
- readiness assumptions between composed resources
- namespace/scope mismatches
- provider reconciliation or permissions issues
