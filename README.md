# ABOS ToyKit

## Utility scripts
### app_start
#### Usage: app_start.sh <app_name> [<app_archive>]
You can construct containers with common container image and an each application code that is deploying as tgz archive with this script.
The application code is extracting from the archive into container's /var/app/ directory when before the container starting i.e. prestart phase 
of that container.  
So if you specify that app as the execution command of the container with 
<a href="https://manual.atmark-techno.com/armadillo-iot-a6e/armadillo-iotg-a6e_product_manual_ja-3.3.0/ch06.html#sct.container-auto-launch">
the container's startup settings file</a> 
the container executes the application. In other words you can separate application code from container image.

### app_extractor
#### Usage: app_extractor.sh <app_name> <app_archive> [<dest_dir>]
***NOTE: This script is not intended to using alone.***  
This script is intended to using with the start up configuration file of containers.
You can extract the content of an archive into a specified directory inside a container with this script.
See also the hello_app described at "Sample codes" section.

## Sample codes
### make_app_archive
A script that make an acrhive of application code.
* The archive file name that created by this script is app.tar.gz.
* The target directory which specified as the argument of this script must contain app_file_list file.

In app_file_list you must write names or relative pathes of file which you'd like to put into the archive in one line.  
***NOTE: Files which you'd like to put into the archive shuould be placed under the target directory.***

### hello_app
"Hello World" container application. The content of hello_app/ directory are following:
* app_file_list  
  The app archive content file for make_app_archive. In this sample, contains 'hello.sh' only. 
* hello.sh  
  The application code.
* hello_app.conf  
  The startup settings file of ABOS for this application.
#### How to launch app
1. make app archive with make_app_archive  
   `make_app_archive hello_app`
2. place the app archive at /var/app/ of ABOS.  
   `mv app.tar.gz /var/app/`
3. place hello_app.conf at /etc/atmark/containers/ of ABOS.  
   `cp hello_app/hello_app.conf /etc/atmark/containers/`
4. create and start the container with the podman_start command of ABOS.  
   `podman_start hello_app`

## Use Cases
### Make the container for ABOS intermittent operation
#### precondition
  - `/etc/atmark/power-utils.conf` has set up for the intermittent operation.
See <a href="https://manual.atmark-techno.com/armadillo-iot-a9e/armadillo-iotg-a9e_product_manual_ja/ch06.html#sec.use_power_utils">the manual page</a>.
  - app archive has placed at /var/app
  - The container's startup settings file has placed at /etc/atmark/containers/
  - The application code that contained in the app archive is implemented as do following:  
    1. Does something.
    2. After a while, does self exit for triggering ABOS entering sleep.
  - The startup settings file contains following line:  
    `add_hook --stage poststop "pwu_notify" container_stop`
#### post-condition  
  - ABOS is in the sleep state.
  - When the wake up cause is occurred then ABOS resumes (i.e. leave the sleep state).
#### basic flow  
  1. `podman_start` creates a container from the container image and starts it
  2. Just before the container starts, the application code is deploying into that container 
by the prestart hook
  3. The container is starting and the application code starts running
  4. The application code does something
  5. After a while, the application code exits
  6. By the poststop hook, ABOS enters to sleep state

