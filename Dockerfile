FROM alpine

RUN apk add --no-cache               \
      curl wget make git             \
      python py2-pip                 \
      nodejs yarn                    \
      perl perl-path-tiny perl-yaml-libyaml perl-getopt-long

## Add the MermaidJS utility
RUN yarn add mermaid

## Add cpanminus and install perl deps
RUN curl -L https://cpanmin.us | perl - App::cpanminus \
 && cpanm -q -n Pod::Markdown                          \
 && rm -rf "$HOME/.cpanm"

## Install the mkdocs system
RUN pip install mkdocs pygments                                                   \
    mkdocs-alabaster mkdocs-bootstrap mkdocs-cinder mkdocs-material mkdocs-nature \
    mkdocs-rtd-dropdown                                                           \
    mkdocs-safe-text-plugin                                                       \
 && rm -rf "$HOME/.cache"

## Copy our scripts and make sure they are executable
COPY cmds/ /usr/local/bin/
COPY cmds/cmds.pl /cmds
RUN chmod 555 /cmds /usr/local/bin/*

## Define our Entrypoint script
ENTRYPOINT ["/cmds"]

## The default command for the entrypoint script, show the help message
CMD ["help"]
