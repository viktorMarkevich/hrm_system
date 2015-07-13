$(document).ready ->

  $('#sticker_performer_id').change ->
    url = 'http://localhost:3000/stickers/new'
    if $('#sticker_performer_id').val() == ''
      $('.btn-default')[0].value = if document.URL == url then 'Создать' else 'Обновить'
    else
      $('.btn-default')[0].value = if document.URL == url then 'Назначить' else 'Обновить и назначить'

  $('#sticker_description').charCount counterText: 'Осталось символов: '
  return