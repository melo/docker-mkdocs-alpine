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
  * [`rtd-dropdown`](https://github.com/cjsheets/mkdocs-rtd-dropdown#readthedocs-dropdown-for-mkdocs): a
    ReadTheDocs clone but with collapsible navigation - must have for big sites;
  * [`bootstrap`](https://mkdocs.github.io/mkdocs-bootstrap/);
  * [`cinder`](https://sourcefoundry.org/cinder/);
  * [`material`](https://squidfunk.github.io/mkdocs-material/);
  * [`nature`](http://waylan.limberg.name/mkdocs-nature/).
* Plugins:
  * [MkDocs Merge](https://github.com/ovasquez/mkdocs-merge#mkdocs-merge).

Please note that none of the plugins are active by default, you need to activate them on your `mkdocs.yml` file.

## Markdown extensions

MkDocs uses the [Python Markdown package](https://python-markdown.github.io). This package includes
a lot of [useful default extensions](https://python-markdown.github.io/extensions/) that you can
use on your wiki.

To use an extension, edit your `mkdocs.yml` file and add a `markdown_extensions` section with the list of extensions you want to add. For example:

```yml
markdown_extensions:
  - abbr
  - attr_list
  - def_list
  - footnotes
  - codehilite
```


## Pygments

The Pygments package is installed to provide code hi-lighting to your fenced code blocks, but this requires a bit of work on your part.

You'll need to:

* place a Pygments styles CSS on your site;
* load it on your pages using the `extra_css` configuration on your `mkdocs.yml` file.

#### Pygments styles CSS generation

To generate the CSS file, on your Dockerfile for your site, add the following line:

```dockerfile
RUN mkdir /docs/docs/css && pygmentize -S default -f html -a .codehilite > /docs/docs/css/pygments.css
```

Tweak the locations of the destination file (make sure the destination folder exists), and adjust
the style and class names in the `pygmentize` execution. See the
[codehilite Markdown plugin](https://python-markdown.github.io/extensions/code_hilite/) for more
information on the options you have.

### Load the Pygments CSS file

On your `mkdocs.yml` file, add a section:

```yaml
extra_css:
  - css/pygment-styles.css
```

Make sure the path matches the file you generated on the previous section.


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
