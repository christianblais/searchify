(function( $ ) {
    $.fn.searchify = function() {
        return this.each(function() {
            $(this).autocomplete({
              source: $(this).data("search-url"),
              select: function (event, ui) {
                  if (select_url = $(this).data("select-url"))
                      window.location.href = select_url.replace(/\(id\)/, ui.item.id);
                  else
                      $(this).prev().val(ui.item.id);
              }
            });
        });
    };
})( jQuery );