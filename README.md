# Mkdocs.org Image #

Allows us to use the mkdocs command on our projects to generate documentation.

## Quick Start

From the command line, you can obtain an explanation on how to use with:

    docker run -i --rm melopt/mkdocs

This will guide you on how to use this image effectively during your documentation writing process.


# Whats Included?

The image includes the following themes and plugins:

* Themes:
  * the two standard themes, `mkdocs` and `readthedocs`;
  * [`alabaster`](https://github.com/iamale/mkdocs-alabaster#alabaster-for-mkdocs);
  * [`bootstrap`](https://mkdocs.github.io/mkdocs-bootstrap/);
  * [`cinder`](https://sourcefoundry.org/cinder/);
  * [`material`](https://squidfunk.github.io/mkdocs-material/);
  * [`nature`](http://waylan.limberg.name/mkdocs-nature/).
* Plugins:
  * [MkDocs Merge](https://github.com/ovasquez/mkdocs-merge#mkdocs-merge).

Please note that none of the plugins are active by default, you need to activate them on your `mkdocs.yml` file.


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
