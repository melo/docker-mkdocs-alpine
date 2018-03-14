FROM alpine

RUN apk add --no-cache python py2-pip py2-yaml \
                       curl git

## Install the mkdocs system                       
RUN pip install mkdocs

## Define our Entrypoint script
COPY entrypoint.pl /usr/sbin/entrypoiny.pl
RUN chmod 555 /usr/sbin/entrypoiny.pl
ENTRYPOINT ["/usr/sbin/entrypoiny.pl"]

## The default command for the entrypoint script, show the help message
CMD ["help"]