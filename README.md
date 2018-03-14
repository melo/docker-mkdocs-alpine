# Mkdocs.org Image #

Allows us to use the mkdocs command on our projects to generate documentation.

## Quick Start

From the command line, you can obtain an explanation on how to use with:

    docker run -i --rm melopt/mkdocs

This will guide you on how to use this image effectively during your documentation writing process.

# Creating a Static Site

At the end of this proces you'll have a very tiny nginx-based image that will launch a HTTP site
with your documentation.

We use a multi-stage build for this. Use the following `Dockerfile` as starting point:

```
FROM melopt/mkdocs AS builder

COPY <your source files> /docs/

RUN /usr/bin/generate_mkdocs_site


FROM melopt/nginx-alt

COPY --from=builder /build /usr/share/nginx/docs/
```

The final image will be a nginx-powered static site.
