# RIAC-snapCloud

RIAC-snapCloud Docker image is a self-contained package that includes all the components for running snapCloud within a Docker container. This allows for easy deployment and consistent operation across different environments. Pull the image from the Docker registry and run it to get started with snap Cloud.

=======
#RAIC-snapCloud v0.0.1 Arm version

RIAC-snapCloud is a Docker image that contains everything you need to run snapCloud within a Docker container. This makes it easy to deploy snapCloud in a variety of environments, as you can simply pull the image from the Docker registry and run it to get started.

Using this Docker image has several benefits:

-   Consistency: The image contains all of the necessary components and dependencies, so you can be sure that snapCloud will run the same way on any machine that has Docker installed.
-   Portability: You can easily move snapCloud to different environments or machines by simply moving the Docker image.
-   Isolation: The Docker container provides a level of isolation, which can be useful if you need to run multiple applications on the same machine.

To get started with RIAC-snapCloud, you'll need to have Docker installed on your machine. Once you have Docker set up, you can pull and run the image from the Docker registry using the following command:

Copy code

`docker run -it openco/riac-snapcloud`

Note if you are on an ARM system (Apple m1, Rasbery Pi)  be sure to pull the ARM version.

Copy code

`docker run -it openco/riac-snapcloud:arm`



This will start a new Docker container with snapCloud running inside it. You can then access snapCloud using the instructions provided in the documentation.

Overall, RIAC-snapCloud makes it easy to deploy and run snapCloud in a consistent and portable manner, using the power of Docker.

    docker run -it -p 8080:8080 openco/riac-snapcloud-master

### Static pages:

```
    /about /bjc /coach /contact  /credits  /DMCA /extensions
    /materials /mirrors /offline /partners  /privacy /requirements
    /research /snapinator /snappy /source /tos
```

### Simple pages:

```
    /blog /change_email /change_password /delete_user /forgot_password
    /forgot_username /sign_up /login
```
