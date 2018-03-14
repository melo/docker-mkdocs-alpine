FROM alpine

RUN apk add --no-cache python py2-pip py2-yaml \
                       curl git

## Install the mkdocs system                       
RUN pip install mkdocs

## Define our Entrypoint script
COPY cmds.pl /cmds
RUN chmod 555 /cmds
ENTRYPOINT ["/cmds"]

## The default command for the entrypoint script, show the help message
CMD ["help"]