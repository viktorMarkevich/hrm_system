$(document).ready ->
  $('#sticker_title').charCount
    field_obj: '.sticker_title'
    allowed: 20
    warning: 20
    counterText: 'Осталось символов: '
  $('#sticker_description').charCount counterText: 'Осталось символов: '
  return