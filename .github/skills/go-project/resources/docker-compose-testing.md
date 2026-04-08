# Docker Compose Testing Notes

Use this guidance when the repository relies on Docker Compose for integration testing.

## Checks
- Inspect `docker-compose.yml`, `docker-compose.yaml`, or `compose.yml`.
- Confirm which services are required for the task.
- Avoid starting the full stack when only one dependency is needed.
- Check ports, healthchecks, volumes, and environment variables.

## Good practices
- Prefer repository-provided Make targets or scripts when available.
- Use `docker compose up -d <service>` for the smallest necessary dependency set.
- Use `docker compose ps` and `docker compose logs --tail=100 <service>` when diagnosing failures.
- Tear down services when they are no longer needed if the workflow expects a clean environment.

## Common issues
- container is running but not healthy
- port already in use
- stale volume data causes test failures
- startup race between the app and its dependencies
- local credentials or env vars not loaded into the container
