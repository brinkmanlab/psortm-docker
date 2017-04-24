# psortm-docker
Docker build environment for PSORTm

##Quick Start
```bash
    $ git clone https://github.com/brinkmanlab/psortm-docker.git && cd psortm-docker
    $ make build
    $ make run
```

Then point your browser at http://localhost/ to start PSORTing (or whatever host your Docker runs on).

## More words

The full list of available commands:

```
     make build        - Build image lairdm/psortb
     make push         - Push brinkmanlab/psortb to public docker repo
     make run          - Run psortm container
     make start        - Start the EXISTING psortm container
     make stop         - Stop psortm container
     make restart      - Stop and start psortm container
     make remove       - Stop and remove psortm container
     make state        - View state psortm container
     make logs         - View logs in real time
```

The Docker image exposes port 80, if this doesn't work for you, rather than "make run" you can manually start up the image using a different port. Hint: you may need to use sudo privileges to install the docker instance.

```bash
    $ docker run -d -p 8888:80 --restart=always --name psortm brinkmanlab/psortm:1.0.0
```
By default, psortm-docker will ask you to download your results as a zip file on completion of each run. If you prefer to manage the results in a way that allows better accessibility, you can mount a local directory inside the Docker instance. To do this, add the -v option to the docker run command to specify a local directory first (which must be a directory in your environment with write access), followed by /tmp (/tmp exists inside the docker instance so you need to use this exact directory name). Specify it like this:

```bash
    $ docker run -d -p 8888:80 --restart=always -v /data/psortm_results:/tmp --name psortm brinkmanlab/psortm:1.0.0
```
