# Fcm Mock Server (Docker)
FCM v1 Mock for testing server applications

## Running
The docker container is available under `kmakiela/fcm-mock-server`.  
It exposes port `4000` and you need to map it to the port of your choice (`-p` option).  
To run, type:
```
docker run -p 4000:4000 kmakiela/fcm-mock-server
```

## API
FCM endpoints:
* **POST** */v1/:project_id/messages:send* - Main FCM endpoint for sending notifications. Requires `authorization` header

Mock endpoints:
* **POST or PUT** */mock/error-tokens* - Sets `HTTP` *error code* and *error reason* for *device tokens*. Payload should be `JSON` list of objects with required fields: `device_token`, `status`, `reason`
* **GET** */mock/error-tokens* - Returns current error-per-token configuration
* **GET** */mock/activity* - Returns the history of calls to `FCM` API of this mock
* **POST or PUT** */mock/reset* - Resets error-per-token configuration and clears `FCM` activity history
