# Hello girls

here we go again...

.def stuff important
.end

List all files that are not on the same folder as we are...

.select
.order_by path
.where type = 'file' and parent !== page.parent
