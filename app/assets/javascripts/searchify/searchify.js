(function( $ ) {
    $.fn.searchify = function() {
        return this.each(function() {
            $(this).autocomplete({
                source: $(this).data("search-url"),
                change: function (event, ui) {
                    if ( $(this).data('value') != $(this).prev().val() ) {
                        $(this).val('');
                        $(this).prev().val('');
                    }
                },
                select: function (event, ui) {
                    if (select_url = $(this).data("select-url")) {
                        for (element in ui.item)
                            select_url = select_url.replace('\(' + element + '\)', ui.item[element]);

                        window.location.href = select_url;
                    } else {
                        $(this).prev().val(ui.item.id);
                        $(this).data('value', ui.item.id)
                    }
                }
            });
        });
    };
})( jQuery );
