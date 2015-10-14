# static-http-preview-server-using-docker

This is a simple HTTP static preview server that can be used to showcase web dev work with ease. It is a Docker
container with SSHD and a password protected Nodejs server.

## Usage

### Setting up

The following steps are needed to fire up the preview server:

* Add your SSH public key to _authorized_keys_
* In _config.json_, set a suitable cookieSecret and add your users using the template provided

### Deploying

Build with Docker and run at an available server. Don't forget to expose ports 22 and 8080.

For example, using 8001 and 8002 for SSHD and the preview server, respectively:
```
docker run -p 8001:22 -p 8002:8080 -d <imageId>
```

Using different port pairs for each preview server, you can easily run several simultaneously on a single machine,
and the users who can access and update are individually configurable.

### Updating the preview code

Everything you put under _/preview_ will be available through the root path on the Nodejs server after authentication.

An example, using rsync and ssh port 8001:

```
rsync -azP --delete -e 'ssh -p 8001' . root@<ip>:/preview
```

Then navigating to _http://\<ip\>:8002_ and logging in, you'll have access to the code you uploaded.
