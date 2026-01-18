# Redis Overview

Redis is an in-memory key–value data store with built-in data structures (string, hash, list, set, sorted set, stream).
It is commonly used for caching, sessions, counters, queues, leaderboards, and real-time messaging (Pub/Sub).

Key ideas:
- Very low latency (memory-first)
- Atomic operations per command
- Optional persistence (RDB snapshots / AOF append-only log)
- Scaling via replication + Redis Cluster (sharding)

In this project, Redis is demonstrated as a NoSQL key–value database with practical demos for common use cases.
