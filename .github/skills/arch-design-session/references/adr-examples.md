# ADR Examples

Two concrete ADR examples to use as models.

---

## Example 1: Choosing an event streaming platform

```markdown
# ADR-0012: Use Kafka (MSK) for cross-service event streaming

**Date**: 2024-11-15
**Status**: Accepted
**Deciders**: Ihor (Staff Eng), Platform Team Lead, SRE Lead

## Context

We are decomposing the order processing monolith into discrete services (order, inventory, fulfillment).
Services need to communicate state changes without tight coupling. We evaluated three options:
synchronous gRPC fan-out, SQS/SNS, and Kafka via Amazon MSK.

Key constraints:
- Event ordering required within a partition (order state machine must be sequential per order_id)
- Multiple independent consumers per event type (audit log, fulfillment, analytics)
- Peak throughput: 5k events/sec, p99 latency tolerance: 500ms for consumer processing
- Team has existing Go Kafka client experience (confluent-kafka-go)

## Decision

Use Amazon MSK (Kafka 3.x) for all cross-service event streaming.

## Options Considered

| Option | Rejected because |
|---|---|
| gRPC fan-out from publisher | Tight coupling; publisher must know all consumers; fan-out failures block publisher |
| AWS SNS + SQS | No ordering guarantees across messages; fan-out to SQS queues adds operational overhead per consumer |

## Consequences

**Positive**:
- Decoupled producers/consumers; new consumers added without touching publisher
- Ordering per partition key (order_id) natively
- Replay capability for bootstrapping new consumers
- Team familiarity reduces ramp-up

**Negative / risks**:
- MSK cluster is a new operational dependency; SRE needs runbook and alerting
- Consumer lag monitoring required (CloudWatch + custom metric)
- Schema evolution discipline needed (use Avro or Protobuf + schema registry, or agree on additive-only JSON)

**Mitigations**:
- Adopt MSK Serverless initially to reduce ops burden; migrate to provisioned when traffic pattern is known
- Add consumer lag alert: alert if lag > 10k messages for > 5min
- Use Protobuf for all event schemas; enforce backwards compatibility in CI

**Review date**: 2025-05-15 (after 6 months in production)
```

---

## Example 2: Database choice for a new service

```markdown
# ADR-0019: Use PostgreSQL (RDS) as primary datastore for the Notification Service

**Date**: 2025-01-08
**Status**: Accepted
**Deciders**: Ihor (Staff Eng), Data Platform Team

## Context

The notification service needs a datastore for: notification templates, per-user preferences,
send history (90-day retention), and idempotency keys (24h TTL).

Volume estimates:
- 2M users, avg 3 preference rows each → ~6M rows
- 500k notification events/day → ~45M history rows/year (pruned at 90 days → ~40M steady state)
- Idempotency keys: ~500k active at any time, TTL 24h

Access patterns:
- Point lookups by user_id (preferences) — high frequency, low latency required (<10ms)
- Insert + single-row read by idempotency_key — very high frequency
- Append-only history writes — high frequency, reads are rare (support queries)
- Template reads — low frequency, cacheable

## Decision

Use Amazon RDS PostgreSQL 16 (Multi-AZ) as the primary datastore.
Add a Redis layer (ElastiCache) for preference and idempotency caching.

## Options Considered

| Option | Rejected because |
|---|---|
| DynamoDB | Query flexibility needed for support tooling; team lacks DynamoDB expertise; secondary indexes add cost complexity |
| CockroachDB / distributed SQL | Operational overhead not justified at current scale; adds new vendor dependency |
| Separate DB per access pattern | Premature; adds complexity before scale demands it |

## Consequences

**Positive**:
- Team has deep PostgreSQL expertise (Go + pgx driver in use across 6 services)
- Multi-AZ covers HA requirement (RTO ~60s, RPO ~0 with synchronous standby)
- Flexible queries for support/ops tooling without extra infra
- Partitioning by created_at on history table handles 90-day retention pruning efficiently

**Negative / risks**:
- Connection pooling needed at scale (add PgBouncer sidecar or RDS Proxy before 500 concurrent connections)
- History table will grow to ~40M rows; partition pruning strategy needed before launch

**Mitigations**:
- Implement pg_partman for monthly range partitioning on history table from day one
- Add PgBouncer in transaction mode as sidecar; revisit RDS Proxy if connection overhead increases
- Cache preferences in Redis (TTL 5min); cache idempotency keys in Redis (TTL 24h + DB fallback)
- Set CloudWatch alarm: storage > 70%, connections > 80% of max_connections

**Review date**: 2025-07-08
```

---

## ADR Anti-patterns to Avoid

| Anti-pattern | Problem | Fix |
|---|---|---|
| "We chose X because it's the best" | No reasoning, not revisitable | State *why it beats alternatives* for *your context* |
| "We will use X" (future tense) | ADR documents decisions already made, not plans | Write as "We use / We have decided" |
| No options considered section | Looks like only one option was ever thought of | Always list ≥2 alternatives even if quickly dismissed |
| No consequences section | Team doesn't know what they signed up for | Always list both positives and negatives |
| No review date | Decision fossilizes forever | Every ADR gets a review date |
| Vague consequences ("may cause issues") | Unactionable | Be specific: "will require X if Y happens" |
