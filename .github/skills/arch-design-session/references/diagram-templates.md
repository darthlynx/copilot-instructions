# Diagram Templates — C4 Model (Mermaid)

All diagrams follow the [C4 model](https://c4model.com): Context → Container → Component → Code.
Mermaid's C4 support renders in GitHub, Notion, GitLab, and most modern wikis.

**C4 zoom levels used in sessions:**
| Level | Mermaid keyword | Audience | When to produce |
|---|---|---|---|
| L1 System Context | `C4Context` | Everyone (PMs, execs) | Always |
| L2 Container | `C4Container` | Engineers, architects | Always |
| L3 Component | `C4Component` | Engineers on that container | When a container is complex |
| Dynamic (sequence) | `C4Dynamic` | Engineers debugging flows | For critical / tricky flows |
| Deployment | `C4Deployment` | SRE, infra | When infra topology matters |

---

## L1 — System Context (`C4Context`)

Who uses the system and what external systems does it touch.

```mermaid
C4Context
  title System Context — Order Service

  Person(customer, "Customer", "Places and tracks orders via web/mobile")
  Person(operator, "Ops / Support", "Manages orders via internal dashboard")

  System(orderSvc, "Order Service", "Manages order lifecycle: creation, payment, fulfillment")

  System_Ext(authSvc, "Auth Service", "Issues and validates JWTs")
  System_Ext(paymentSvc, "Payment Gateway", "Processes charges and refunds")
  System_Ext(notifSvc, "Notification Service", "Sends email and push notifications")
  SystemQueue_Ext(eventBus, "Event Bus (Kafka)", "Cross-service event streaming")

  Rel(customer, orderSvc, "Creates/views orders", "HTTPS/REST")
  Rel(operator, orderSvc, "Manages orders", "HTTPS/REST")
  Rel(orderSvc, authSvc, "Validates token", "gRPC/mTLS")
  Rel(orderSvc, paymentSvc, "Charges / refunds", "HTTPS/REST")
  Rel(orderSvc, eventBus, "Publishes order.* events", "Kafka protocol")
  Rel(notifSvc, eventBus, "Consumes order.created", "Kafka protocol")

  UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

---

## L2 — Container Diagram (`C4Container`)

The deployable units inside the system boundary, their tech, and how they communicate.

```mermaid
C4Container
  title Container Diagram — Order Service

  Person(customer, "Customer", "Web / mobile")
  Person(operator, "Ops / Support", "Internal tooling")

  System_Ext(authSvc, "Auth Service", "JWT validation")
  System_Ext(paymentSvc, "Payment Gateway", "Charges")
  SystemQueue_Ext(kafka, "Kafka (MSK)", "Event bus")

  System_Boundary(orderBoundary, "Order Service") {
    Container(api, "API Container", "Go, net/http + gRPC", "Handles inbound REST and gRPC; validates auth; orchestrates business logic")
    Container(worker, "Event Worker", "Go", "Consumes Kafka events; processes async jobs (fulfillment, retries)")
    ContainerDb(postgres, "PostgreSQL (RDS)", "PostgreSQL 16, Multi-AZ", "Orders, line items, idempotency keys")
    ContainerDb(redis, "Redis (ElastiCache)", "Redis 7, cluster mode", "Auth cache, distributed locks, rate-limit counters")
    Container(migrator, "Schema Migrator", "Go + golang-migrate", "Runs DB migrations at deploy time; init container in Kubernetes")
  }

  Rel(customer, api, "REST calls", "HTTPS/443")
  Rel(operator, api, "REST calls", "HTTPS/443")
  Rel(api, authSvc, "Validate JWT", "gRPC/mTLS")
  Rel(api, paymentSvc, "Charge / refund", "HTTPS/REST")
  Rel(api, postgres, "Read / write orders", "SQL, TLS/5432")
  Rel(api, redis, "Cache + lock", "RESP3/6379")
  Rel(api, kafka, "Produce order.created", "Kafka/9092")
  Rel(kafka, worker, "Consume order.*", "Kafka/9092")
  Rel(worker, postgres, "Update order state", "SQL, TLS/5432")
  Rel(migrator, postgres, "Apply migrations", "SQL, TLS/5432")

  UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

---

## L3 — Component Diagram (`C4Component`)

Internal structure of one container. Use when a container has meaningful internal architecture.

```mermaid
C4Component
  title Component Diagram — API Container (Order Service)

  Container_Ext(client, "Client", "Browser / mobile / service mesh")
  Container_Ext(authSvc, "Auth Service", "JWT validation")
  ContainerDb_Ext(postgres, "PostgreSQL", "Primary datastore")
  ContainerDb_Ext(redis, "Redis", "Cache + locks")
  ContainerQueue_Ext(kafka, "Kafka", "Event bus")

  Container_Boundary(api, "API Container") {
    Component(router, "HTTP/gRPC Router", "Go, chi + grpc-go", "Routes requests; enforces TLS; injects request context")
    Component(authMW, "Auth Middleware", "Go", "Extracts and validates JWT; populates caller identity in context")
    Component(orderHandler, "Order Handler", "Go", "Validates input; calls domain service; maps to HTTP/gRPC response")
    Component(orderDomain, "Order Domain Service", "Go", "Business rules: state machine, idempotency, invariant checks")
    Component(orderRepo, "Order Repository", "Go + pgx/v5", "SQL queries; transaction management; optimistic locking")
    Component(cacheClient, "Cache Client", "Go + go-redis", "Wraps Redis: get/set/del with TTL; distributed lock via Redlock")
    Component(eventPublisher, "Event Publisher", "Go + confluent-kafka-go", "Transactional outbox pattern; publishes post-commit")
  }

  Rel(client, router, "Sends requests", "HTTPS/gRPC")
  Rel(router, authMW, "Passes request")
  Rel(authMW, authSvc, "Validates token", "gRPC/mTLS")
  Rel(authMW, orderHandler, "Forwards with identity")
  Rel(orderHandler, orderDomain, "Calls")
  Rel(orderDomain, orderRepo, "Persists state")
  Rel(orderDomain, cacheClient, "Checks / acquires lock")
  Rel(orderDomain, eventPublisher, "Enqueues event post-commit")
  Rel(orderRepo, postgres, "SQL", "TLS/5432")
  Rel(cacheClient, redis, "RESP3", "6379")
  Rel(eventPublisher, kafka, "Produce", "9092")

  UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

---

## Dynamic Diagram — Critical Flow (`C4Dynamic`)

Use for flows where ordering and branching logic matter. Preferred over generic sequence diagrams
because it anchors participants to the C4 containers already defined.

```mermaid
C4Dynamic
  title Dynamic — Create Order (happy path + idempotency)

  Person(customer, "Customer")
  Container(api, "API Container", "Go")
  ContainerDb(redis, "Redis", "Locks")
  ContainerDb(postgres, "PostgreSQL", "Orders")
  ContainerQueue(kafka, "Kafka", "Events")

  Rel(customer, api, "1. POST /orders", "HTTPS")
  Rel(api, redis, "2. SETNX lock:order:<idempotency-key> EX 30s")
  Rel(redis, api, "3a. OK (lock acquired) / 3b. FAIL (duplicate)")
  Rel(api, postgres, "4. BEGIN; INSERT order; COMMIT", "pgx/TLS")
  Rel(postgres, api, "5. order_id = 42")
  Rel(api, kafka, "6. Produce order.created {order_id=42}", "transactional outbox")
  Rel(kafka, api, "7. ack")
  Rel(api, customer, "8. 201 Created / 409 Conflict (step 3b)")

  UpdateLayoutConfig($c4ShapeInRow="4")
```

---

## Deployment Diagram (`C4Deployment`)

Maps containers onto infrastructure. Use when topology affects reliability, latency, or cost decisions.

```mermaid
C4Deployment
  title Deployment — Order Service, AWS us-east-1

  Deployment_Node(aws, "AWS us-east-1") {
    Deployment_Node(vpc, "VPC 10.0.0.0/16") {

      Deployment_Node(pubSubnets, "Public Subnets (AZ a/b/c)") {
        InfrastructureNode(alb, "ALB", "AWS ALB", "TLS termination, health checks")
      }

      Deployment_Node(privSubnets, "Private Subnets (AZ a/b/c)") {
        Deployment_Node(eks, "EKS Cluster", "Kubernetes 1.30, managed node groups") {
          Container(api, "API Container", "Go", "3 replicas min; HPA on CPU+RPS")
          Container(worker, "Event Worker", "Go", "KEDA-scaled on Kafka consumer lag")
          Container(migrator, "Schema Migrator", "Go", "Init container, runs once per deploy")
        }

        Deployment_Node(rds, "RDS PostgreSQL 16", "Multi-AZ, db.r7g.xlarge") {
          ContainerDb(pgPrimary, "Primary", "PostgreSQL", "Writes")
          ContainerDb(pgStandby, "Standby", "PostgreSQL", "Sync replica, auto-failover")
        }

        Deployment_Node(elasticache, "ElastiCache Redis 7", "Cluster mode, 3 shards x 1 replica") {
          ContainerDb(redis, "Redis Cluster", "Redis", "Cache + Redlock")
        }

        Deployment_Node(msk, "MSK Kafka", "3 brokers, RF=3, min ISR=2") {
          ContainerQueue(kafka, "Kafka", "MSK", "order.* topics")
        }
      }
    }

    Deployment_Node(global, "Global / Regional") {
      InfrastructureNode(ecr, "ECR", "Container Registry", "Image pull at deploy time")
      InfrastructureNode(s3, "S3", "Object Store", "Artifacts, backups, Terraform state")
    }
  }

  Rel(alb, api, "HTTP/8080", "internal")
  Rel(api, pgPrimary, "SQL/5432", "TLS")
  Rel(api, redis, "RESP3/6379", "TLS")
  Rel(api, kafka, "9092")
  Rel(kafka, worker, "consume 9092")
  Rel(worker, pgPrimary, "SQL/5432", "TLS")
  Rel(migrator, pgPrimary, "SQL/5432", "TLS")
```

---

## State Machine (supplement — not a C4 level)

Use alongside C4 diagrams when a domain entity has a non-trivial lifecycle.

```mermaid
stateDiagram-v2
  direction LR
  [*] --> Draft
  Draft --> Submitted : customer submits
  Submitted --> PaymentPending : worker picks up
  PaymentPending --> Confirmed : payment succeeds
  PaymentPending --> PaymentFailed : payment fails / timeout
  PaymentFailed --> Submitted : operator retries
  Confirmed --> Fulfilling : fulfillment triggered
  Fulfilling --> Shipped : shipment confirmed
  Shipped --> Delivered : delivery confirmed
  Shipped --> ReturnRequested : customer requests return
  ReturnRequested --> Returned : return processed
  PaymentFailed --> Cancelled : operator cancels
  Confirmed --> Cancelled : customer cancels (pre-fulfillment)
  Delivered --> [*]
  Returned --> [*]
  Cancelled --> [*]
```

---

## Quick Reference — C4 Mermaid Shape Cheat Sheet

| Shape macro | Renders as | Use for |
|---|---|---|
| `Person(id, name, desc)` | Person (stick figure) | Human users |
| `Person_Ext(...)` | Person, grey | External users |
| `System(id, name, desc)` | Box | Your system |
| `System_Ext(...)` | Box, grey | External systems |
| `SystemDb(...)` | Cylinder | External DB |
| `SystemQueue(...)` | Queue shape | External queue |
| `Container(id, name, tech, desc)` | Box | Deployable unit |
| `ContainerDb(...)` | Cylinder | Database container |
| `ContainerQueue(...)` | Queue shape | Message queue container |
| `Component(id, name, tech, desc)` | Box | Internal component |
| `Deployment_Node(id, name, tech)` | Dashed boundary | Infra node / environment |
| `InfrastructureNode(...)` | Hexagon | Infra element (LB, CDN) |
| `Rel(from, to, label, tech?)` | Arrow | Relationship |
| `Rel_Back(...)` | Reverse arrow | Response direction |
| `BiRel(...)` | Bidirectional | Two-way comm |
