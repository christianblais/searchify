$ ->
  $(".searchify").each (i, object) ->
    self = $(object)

    self.autocomplete({
      source: $(this).data("search-url"),
      select: (event, ui) ->
        if select_url = $(this).data("select-url")
          window.location.href = $(this).data("select-url").replace(/\(id\)/, ui.item.id)
        else
          self.prev().val(ui.item.id)
    });
