(function( $ ) {
    $.fn.searchify = function() {
        return this.each(function() {
            $(this).autocomplete({
                source: $(this).data("search-url"),
                select: function (event, ui) {
                    if (select_url = $(this).data("select-url")) {
                        for (element in ui.item)
                            select_url = select_url.replace('\(' + element + '\)', ui.item[element]);

                        window.location.href = select_url;
                    } else {
                        $(this).prev().val(ui.item.id);
                    }
                }
            });
        });
    };
})( jQuery );
