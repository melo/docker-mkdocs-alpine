FROM alpine

RUN apk add --no-cache               \
      curl git                       \
      python py2-pip                 \
      perl perl-path-tiny perl-yaml-tiny perl-getopt-long

## Install the mkdocs system
RUN pip install mkdocs                                                            \
    mkdocs-alabaster mkdocs-bootstrap mkdocs-cinder mkdocs-material mkdocs-nature \
    mkdocs-safe-text-plugin

## Copy our scripts and make sure they are executable
COPY mkdocs-sql /usr/bin/
COPY cmds.pl /cmds
RUN chmod 555 /cmds /usr/bin/mkdocs-sql

## Define our Entrypoint script
ENTRYPOINT ["/cmds"]

## The default command for the entrypoint script, show the help message
CMD ["help"]
