---
name: arch-design-session
description: >
  Facilitates staff-level architecture design sessions: framing problems, eliciting requirements,
  generating design options with trade-off analysis, producing Architecture Decision Records (ADRs),
  and creating structured design docs suitable for staff/principal engineer review. Trigger this skill
  whenever the user mentions "architecture session", "design session", "system design", "design doc",
  "ADR", "architecture review", "tech design", "design trade-offs", "scalability design",
  "service design", or any request to think through the architecture of a new system, feature,
  or migration. Also trigger when the user asks to evaluate or critique an existing architecture,
  compare architectural patterns (microservices vs monolith, event-driven vs request-response, etc.),
  or prepare for a technical design review. Always use this skill rather than freeform discussion
  when the conversation is clearly about architectural decision-making at a staff or principal level.
---

# Staff-Level Architecture Design Session Skill

This skill structures architecture design sessions the way strong staff/principal engineers run them:
rigorous problem framing, explicit trade-off reasoning, clear decision criteria, and documentation
artifacts that survive the meeting.

---

## When Not To Use This Skill

- Use language- or infra-specific skills for implementation-level questions (for example, use the `go-project` skill for Go implementation details or `crossplane-v2` for Crossplane platform design).
- Do not trigger this skill for small tactical tasks such as unit-test help, linting, local debugging, or single-file refactors.


## Phase 0 — Orient Before You Design

Before any whiteboarding, establish:

1. **Trigger type** — Which mode fits?
   - `greenfield` → new system or service from scratch
   - `migration` → moving from X to Y (e.g., monolith → services, DB swap)
   - `scaling` → existing system hitting limits
   - `incident-driven` → design in response to a failure or outage
   - `review` → critique or approve someone else's proposal

2. **Session goal** — one sentence. "By the end of this session we should be able to…"
   - Bad: "discuss the architecture"
   - Good: "decide whether to adopt event-driven fanout or polling for the notification service, and document the decision"

3. **Stakeholders** — who must sign off? Engineering lead, SRE, Security, Product? Know this upfront to avoid re-opening decisions later.

---

## Phase 1 — Requirements Elicitation

Run through all four categories. Capture as a table (see `references/requirements-template.md`).

### Functional Requirements
- What does the system **do**? (user-facing behaviors, APIs, data flows)
- What are the **boundaries**? (explicitly out of scope)
- Key **data entities** and relationships

### Non-Functional Requirements (NFRs) — the real staff-level differentiator
Quantify each or say "unknown / TBD" — never leave it vague:

| Attribute | Target | Measurement method |
|---|---|---|
| Latency (p99) | e.g., <200ms | APM trace, SLO dashboard |
| Throughput | e.g., 10k RPS peak | load test |
| Availability | e.g., 99.9% (43min/month) | uptime SLO |
| Durability | e.g., 0 data loss on crash | WAL / replication factor |
| Consistency | strong / eventual / causal | by operation type |
| Data volume | e.g., 500GB/year growth | capacity model |
| Regulatory / compliance | GDPR, SOC2, HIPAA | per data classification |

### Constraints
- **Tech stack** constraints (language, cloud, existing infra — e.g., Go, Kubernetes/Helm, Terraform)
- **Team** constraints (size, expertise, on-call burden)
- **Time** constraints (MVP date, migration window)
- **Cost** constraints (budget ceiling, cost per unit target)

### Assumptions
Explicitly list. Every assumption is a future risk. Tag each: `[safe to assume]` or `[must validate]`.

---

## Phase 2 — Threat Model & Failure Mode Inventory

Do this before designing. It prevents the classic mistake of designing for the happy path.

**For each major component ask:**
- What happens if it's **slow**? (latency cascade)
- What happens if it's **down**? (failover, degraded mode)
- What happens if it **corrupts data**? (detection, recovery)
- What happens under **10x load**? (saturation behavior)

**Security surface:**
- Auth/Authz model (who calls what, with what identity)
- Trust boundaries (what crosses a network boundary?)
- Sensitive data classification and encryption at rest/transit

Output: a short risk table. See `references/risk-table-template.md`.

---

## Phase 3 — Design Option Generation

Generate **at least 2, ideally 3** distinct options. Options must be meaningfully different —
not just "same thing with different names."

For each option, capture:

```
### Option N: <Name>

**Summary**: One-sentence description.

**How it works**: Narrative + diagram pointer (see Phase 4 for diagrams).

**Pros**:
- ...

**Cons / risks**:
- ...

**Estimated complexity**: Low / Medium / High
**Estimated operational burden**: Low / Medium / High
**Fits constraints**: Yes / Partial / No — explain if partial or no
```

### Common Option Archetypes to Consider
- **Synchronous vs. async** (request-response vs. queue/event)
- **Monolith vs. decomposed** (single deployable vs. separate services)
- **Stateful vs. stateless** (who owns state, where)
- **Push vs. pull** (producer-driven vs. consumer-driven)
- **Managed service vs. self-hosted** (ops burden vs. control)
- **Strong consistency vs. eventual** (correctness vs. availability/performance)

---

## Phase 4 — Trade-off Matrix

Build a decision matrix with criteria weighted by the team:

| Criterion | Weight | Option A | Option B | Option C |
|---|---|---|---|---|
| Operational simplicity | 30% | 8 | 5 | 7 |
| Meets latency NFR | 25% | 9 | 7 | 6 |
| Migration risk | 20% | 3 | 8 | 6 |
| Cost | 15% | 9 | 6 | 7 |
| Team familiarity | 10% | 7 | 9 | 5 |
| **Weighted total** | | **7.35** | **6.75** | **6.5** |

**Important**: The matrix informs — it doesn't decide. If the "winning" option feels wrong, the weights
are wrong. Revisit criteria.

---

## Phase 5 — Diagrams (C4 Model, Mermaid)

All diagrams follow the **C4 model**. Always produce L1 and L2; add L3/Dynamic/Deployment when the
complexity warrants it. Mermaid is the default format — renders in GitHub, GitLab, Notion, and most wikis.

| Level | C4 Mermaid keyword | Produce when |
|---|---|---|
| L1 System Context | `C4Context` | Always — anchors scope for all stakeholders |
| L2 Container | `C4Container` | Always — shows deployable units and protocols |
| L3 Component | `C4Component` | When a container has significant internal structure |
| Dynamic (flow) | `C4Dynamic` | For critical or tricky request flows (replaces sequence diagrams) |
| Deployment | `C4Deployment` | When infra topology drives reliability/cost decisions |
| State machine | `stateDiagram-v2` | When a domain entity has a non-trivial lifecycle (supplements C4) |

**L1 — System Context**: external actors (Person, System_Ext, SystemQueue_Ext) + your system boundary.
No internal detail.

**L2 — Container**: deployable units inside your boundary (Container, ContainerDb, ContainerQueue) +
protocols on every Rel arrow (gRPC/mTLS, SQL/TLS, RESP3, Kafka/9092).

**L3 — Component**: internal structure of one container — handlers, domain services, repos, clients.
Only draw when L2 leaves meaningful ambiguity.

**Dynamic**: anchor participants to C4 containers already defined; number steps; show the main error
branch inline.

See `references/diagram-templates.md` for complete ready-to-edit templates and a C4 Mermaid shape
cheat sheet.

---

## Phase 6 — Architecture Decision Record (ADR)

Every session should produce at least one ADR. ADRs are the primary artifact that survives the meeting.

```markdown
# ADR-NNNN: <Short Title>

**Date**: YYYY-MM-DD
**Status**: Proposed | Accepted | Deprecated | Superseded by ADR-XXXX
**Deciders**: [names / roles]
**Context**:
<What is the situation? What forces are at play? Include relevant NFRs and constraints.>

**Decision**:
<What is the change we're making? State clearly what we decided, not what we're doing.>

**Options considered**:
| Option | Rejected because |
|---|---|
| Option A | ... |
| Option B | ... |

**Consequences**:
**Positive**: ...
**Negative / risks**: ...
**Mitigations**: ...

**Review date**: <when should we revisit this? — 6mo, 1yr, after X milestone>
```

Store ADRs in `docs/architecture/decisions/` in the repo. File as `NNNN-short-title.md`.

---

## Phase 7 — Implementation Roadmap Sketch

A design session isn't done until there's a path to build it. Produce a rough sequencing:

```
Phase 1 (MVP / de-risk):   <what you build first, what it validates>
Phase 2 (Scale / harden):  <what you add after proven>
Phase 3 (Full vision):     <where it goes long-term>
```

For each phase:
- **Key milestones** (not tasks — outcomes)
- **Biggest unknowns / spikes needed** before committing
- **Rollback / escape hatch** if Phase 1 fails

---

## Phase 8 — Review Checklist

Run before closing the session. Every item gets ✅ or 🚧 (needs follow-up):

**Correctness**
- [ ] All NFRs addressed or explicitly deferred with owner
- [ ] Data model covers all functional requirements
- [ ] Failure modes inventoried; degraded mode defined

**Reliability**
- [ ] Single points of failure identified and mitigated or accepted
- [ ] SLO / error budget defined
- [ ] Runbook / on-call implications documented

**Security**
- [ ] Auth/authz model complete
- [ ] PII / sensitive data classified; encryption defined
- [ ] Threat model reviewed with Security team if applicable

**Operability**
- [ ] Deployment strategy defined (blue/green, canary, feature flag)
- [ ] Observability: metrics, logs, traces — instrumentation plan
- [ ] Rollback procedure exists

**Cost**
- [ ] Cost model sketched (infra, data egress, licensing)
- [ ] Cost at 10x load estimated

**Team**
- [ ] Required skills available or have hiring/training plan
- [ ] On-call rotation impact assessed

---

## Implementation details

For language- and infrastructure-specific implementation patterns and checklists, see the corresponding skills (for example, the `go-project` skill for Go services and the `crossplane-v2` skill for Crossplane platform guidance).
---

## Reference Files

Load these when needed — don't load all upfront:

| File | Load when |
|---|---|
| `references/requirements-template.md` | Starting Phase 1 |
| `references/risk-table-template.md` | Starting Phase 2 |
| `references/diagram-templates.md` | Generating diagrams in Phase 5 |
| `references/adr-examples.md` | Writing the first ADR in Phase 6 |

---

## Facilitation Tips for the Session Runner

- **Timebox each phase**: context (10min), requirements (20min), options (30min), decision (15min), ADR (15min)
- **Name the parking lot early**: write "Parking Lot" on the board; defer rabbit holes, don't lose them
- **Call out undecidable questions**: "We can't answer this in the room — assign an owner and date"
- **Repeat the decision back verbally** before writing the ADR — prevents "that's not what I meant"
- **Don't leave without owners**: every open item needs a name and a date, or it doesn't exist
