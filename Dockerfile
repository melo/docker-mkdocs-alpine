FROM alpine

RUN apk add --no-cache python py2-pip py2-yaml \
                       curl git

RUN pip install mkdocs
