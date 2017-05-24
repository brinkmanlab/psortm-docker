# psortm-docker
Docker build environment for PSORTm

## Introduction
PSORTm is a program for the prediction of the subcellular localization of metagenomics sequences. It is a modification of the popular protein subcellular localization tool PSORTb. Like PSORTb, PSORTm focuses on making correct predictions at the expense of making fewer predictions (i.e. prioritizes precision over recall).

## Pre-Built Docker Image
Please note there is a ready-made PSORTm docker image at https://hub.docker.com/r/brinkmanlab/psortm/.
Installation instructions for this image can be found at the same location.

## Quick Start
```bash
    $ git clone https://github.com/brinkmanlab/psortm-docker.git && cd psortm-docker
    $ make build
    $ make run
```

In order to access your PSORTm results, you need to mount a local directory to save the results in. To do this, we use the -v option of the docker run command to specify a local directory first (which must be a directory in your environment with write access), followed by /tmp/psortm (/tmp/psortm exists inside the docker instance so you need to use this exact directory name). Specify the docker run command like this:

```bash
    $ docker run -d -p 80:80 --restart=always -v </path/to/local/psortm_results_dir>:/tmp/psortm --name psortm -e NODE_ENVIRONMENT="production" -e MOUNT_DIRECTORY="</path/to/local/psortm_results_dir>" brinkmanlab/psortm:1.0.0
```

Then point your browser at http://localhost/ to start PSORTm-ing.

## More Makefile Commands
The full list of available commands:

```
     make build        - Build image brinkmanlab/psortm
     make start        - Start the EXISTING psortm container
     make stop         - Stop psortm container
     make restart      - Stop and start psortm container
     make remove       - Stop and remove psortm container
     make state        - View state psortm container
     make logs         - View logs in real time
```
