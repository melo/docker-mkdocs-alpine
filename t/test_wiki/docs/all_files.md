# All of our files #

.select
.target file
.order_by path
.only_documents
.tmpl_item <<TMPL
* [{{ path }}]({{ url }}): {{ attr.title }}
TMPL
