FROM alpine

RUN apk add --no-cache python py2-pip py2-yaml \
                       curl git

## Install the mkdocs system                       
RUN pip install mkdocs
