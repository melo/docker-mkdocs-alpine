FROM alpine

RUN apk add --no-cache               \
      curl wget make git             \
      python py2-pip                 \
      perl perl-path-tiny perl-yaml-libyaml perl-getopt-long

## Add cpanminus and install perl deps
RUN curl -L https://cpanmin.us | perl - App::cpanminus \
 && cpanm -q -n Pod::Markdown                          \
 && rm -rf "$HOME/.cpanm"

## Install the mkdocs system
RUN pip install mkdocs                                                            \
    mkdocs-alabaster mkdocs-bootstrap mkdocs-cinder mkdocs-material mkdocs-nature \
    mkdocs-safe-text-plugin

## Copy our scripts and make sure they are executable
COPY mkdocs-* /usr/bin/
COPY cmds.pl /cmds
RUN chmod 555 /cmds /usr/bin/mkdocs-*

## Define our Entrypoint script
ENTRYPOINT ["/cmds"]

## The default command for the entrypoint script, show the help message
CMD ["help"]
