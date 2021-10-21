$ ->
  $('a').click ->
    $.ajax(
      async: false,
      type: 'POST',
      url: '/link_clicks', 
      data: {
        url: $(this).attr('href'),
        link_css_id: $(this).attr('id'),
        link_name: $(this).data('link-name')
      }
    )
