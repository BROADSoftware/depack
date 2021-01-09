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


- Pb on minio-eventsource on start. Seems if minio is not ready when starting, system is unable to fall back in his feet (May be we should fix this by exiting of the function on minio error, to reset minio subsystem.)

