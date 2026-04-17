# Risk & Failure Mode Template

Use during Phase 2 of the design session. Fill one row per major component or dependency.

---

## Failure Mode Table

| Component | Failure mode | Impact | Likelihood | Mitigation | Residual risk |
|---|---|---|---|---|---|
| PostgreSQL primary | Node crash | Write unavailable | Low | Multi-AZ failover, ~60s RTO | 60s downtime per event |
| PostgreSQL primary | Disk full | Write errors | Medium | CloudWatch alarm at 80%, autoscaling | Alert lag |
| Kafka broker | 1 broker down (of 3) | No impact (RF=3) | Medium | Replication factor 3, min ISR 2 | None |
| Kafka broker | All brokers down | Message loss / backpressure | Very low | MSK managed, cross-AZ | Full service degradation |
| Redis | Cache eviction storm | Latency spike to DB | Medium | Maxmemory-policy allkeys-lru, circuit breaker | Brief latency spike |
| Redis | Node failure | Cache miss storm | Low | ElastiCache cluster mode, auto-failover | Brief latency spike |
| Downstream service | Slow responses | Latency cascade | Medium | Timeout + circuit breaker (e.g., go-hystrix, failsafe-go) | Degraded mode |
| Downstream service | Down | Feature unavailable | Medium | Graceful degradation, stub response | Partial functionality |
| API service pod | OOMKilled | Request drop | Medium | Tune memory limits; HPA on memory | Pod restart (<5s) |
| Worker pod | Crash loop | Event processing backlog | Medium | DLQ, alerting on lag, liveness probe | Backlog buildup |

---

## Security Risk Table

| Surface | Threat | Control | Owner |
|---|---|---|---|
| Public API | Unauthenticated access | JWT validation middleware | Platform team |
| Inter-service calls | Spoofed identity | mTLS via service mesh / IRSA | Platform team |
| RDS | Credential leak | IAM auth + Secrets Manager rotation | Infra team |
| S3 bucket | Public access | Block public access policy | Infra team |
| Container images | Vulnerable base image | Trivy scan in CI, ECR scan | DevSecOps |
| Terraform state | Sensitive values in state | Never write secrets to state; use data sources | Infra team |
| Kubernetes secrets | Plain text in etcd | Envelope encryption + Sealed Secrets / ESO | Platform team |

---

## Load / Saturation Model

Quick napkin math — fill before designing for scale.

| Resource | Normal load | Peak load (estimate) | Saturation point | Action at 70% saturation |
|---|---|---|---|---|
| API pods (CPU) | | | | HPA scale-out |
| API pods (memory) | | | | Tune / add replicas |
| DB connections | | | | PgBouncer pooling |
| DB IOPS | | | | gp3 IOPS increase |
| Kafka topic lag | | | | Worker scale-out |
| Redis memory | | | | Shard / eviction policy |
| S3 request rate | | | | Prefix partitioning |
