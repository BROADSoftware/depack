# Argo workflow + events

### Pro
- workflow Web UI
- Large set of events sources
- Workflow seems powerfull (To dig more into)

### Con:
- Complexity
- Lot of moving part (eventsource/eventbuss/sensor)
- eventsource / sensor coupling by parameters structure. 
- Resiliency: Events are lost during eventsource downtime.
- By default, eventbus got temp storage.
- Yet another events storage (NATS).
- The event source manifest has some base64 encoded. This complexifies maintenance
- Crds definition are lax

# Launch for testing

```
helm upgrade -i -n gha1 --values ./values.kspray1.local.yaml minio2kafka .
```
