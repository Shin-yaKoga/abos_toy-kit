# Periodic Sleeper

## sleep_client_app
Sample application as sleeper app's client. 
This application runs in a container too, and share container image with the sleeper application.

## sleeper
The utility application running inside a container for making ABOS sleep. 
This application uses the atmark-power-utils service of ABOS via container engine's OCI hook.  

The client of this sleeper app can make request to sleep ABOS and waits the resume. 
The communication between the two container application is achieved via named pipe which will be created by the client app. 
On this sample code, the sleeper app must be started before the client app starting for satsifying the communication sequence. 
So the sleeper app container be made start when the container of client app (which is the primary application) be creating.