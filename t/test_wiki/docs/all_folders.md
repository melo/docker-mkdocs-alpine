# All of our folders #

.select
.order_by path
.where is_folder()
.tmpl_item <<TMPL
* [{{ attr.name }}]({{ url || ''}})
TMPL
