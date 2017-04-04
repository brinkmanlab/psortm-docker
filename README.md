# psortm-docker
Docker build environment for PSORTm

##Quick Start
```bash
    $ git clone https://github.com/lairdm/psortm-docker.git && cd psortm-docker
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

The Docker image exposes port 80, if this doesn't work for you, rather than "make run" you can manually start up the image using a different port.

```bash
    $ docker run -d -p 8000:80 --restart=always --name psortm brinkmanlab/psortm:1.0.0
```
