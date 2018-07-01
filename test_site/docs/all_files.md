# All of our files #

.select
.order_by path
.where is_document()
.tmpl_item <<TMPL
* [{{ path }}]({{ url }}): {{ attr.title }}
TMPL
