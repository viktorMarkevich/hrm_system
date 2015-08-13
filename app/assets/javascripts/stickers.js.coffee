$(document).ready ->

  $('#sticker_performer_id').change ->
    url = '/stickers/new'
    if $('#sticker_performer_id').val() == ''
      $('.btn-default')[0].value = if window.location.pathname == url then 'Создать' else 'Обновить'
    else
      $('.btn-default')[0].value = if window.location.pathname == url then 'Назначить' else 'Обновить и назначить'

  $('#sticker_description').charCount counterText: 'Осталось символов: '
  return

$ ->
  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link)
    false

  $.rails.confirmed = (link) ->
    link.removeAttr('data-confirm')
    link.trigger('click.rails')

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    html = """
           <div class="modal fade" id="confirmationDialog" data-keyboard="true" tabindex="-1" >
             <div class="modal-dialog">
               <div class="modal-content">
                 <div class="modal-header">
                   <a class="close" data-dismiss="modal">×</a>
                   <h4><i class="glyphicon glyphicon-trash"></i>  #{message}</h4>
                 </div>
                 <div class="modal-footer">
                   <a data-dismiss="modal" class="btn">Cancel</a>
                   <a data-dismiss="modal" class="btn btn-danger confirm">Ok</a>
                 </div>
               </div>
             </div>
           </div>
           """
    $(html).modal('show')
    $('body').off 'click.confirm', '#confirmationDialog .confirm'
    $('body').on 'click.confirm', '#confirmationDialog .confirm', -> $.rails.confirmed(link)