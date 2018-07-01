# All Object in database

.select
.tmpl_head <<TMPL
What follows is a list of all objects on our database...
TMPL
.tmpl_item <<TMPL
* [id `{{ id }}` of type `{{ type }}`]({{ url }}): {{attr.descr || ''}};
TMPL
