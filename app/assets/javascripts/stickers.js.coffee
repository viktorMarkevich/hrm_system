$(document).ready ->

  $('#sticker_performer_id').change ->
    url = '/stickers/new'
    if $('#sticker_performer_id').val() == ''
      $('.btn-default')[0].value = if window.location.pathname == url then 'Создать' else 'Обновить'
    else
      $('.btn-default')[0].value = if window.location.pathname == url then 'Назначить' else 'Обновить и назначить'

  $('#sticker_description').charCount counterText: 'Осталось символов: '
  return