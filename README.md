# Mkdocs.org Image #

Allows us to use the mkdocs command on our projects to generate documentation.

We usually do this with a multi-stage build, like this:

```
FROM melopt/mkdocs-alpine AS builder

COPY <your source files> /docs/

RUN /usr/bin/generate_mkdocs_site


FROM melopt/nginx-alt

COPY --from=builder /build /usr/share/nginx/docs/
```

The final image will be a nginx-powered static site.

