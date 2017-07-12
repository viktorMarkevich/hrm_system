$(document).ready(function() {
    $('#sticker_description').charCount({
        counterText: 'Осталось символов: '
    });
});

$(function() {

    var body = $('body');

    $.rails.allowAction = function(link) {
        if (!link.attr('data-confirm')) {
            return true;
        }
        $.rails.showConfirmDialog(link);
        return false;
    };
    $.rails.confirmed = function(link) {
        link.removeAttr('data-confirm');
        return link.trigger('click.rails');
    };
    return $.rails.showConfirmDialog = function(link) {
        var html, message;
        message = link.attr('data-confirm');
        html = "<div class=\"modal fade\" id=\"confirmationDialog\" data-keyboard=\"true\" tabindex=\"-1\" >\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        <a class=\"close\" data-dismiss=\"modal\">×</a>\n        <h4><i class=\"glyphicon glyphicon-trash\"></i>  " + message + "</h4>\n      </div>\n      <div class=\"modal-footer\">\n        <a data-dismiss=\"modal\" class=\"btn\">Cancel</a>\n        <a data-dismiss=\"modal\" class=\"btn btn-danger confirm\">Ok</a>\n      </div>\n    </div>\n  </div>\n</div>";
        $(html).modal('show');
        body.off('click.confirm', '#confirmationDialog .confirm');
        return body.on('click.confirm', '#confirmationDialog .confirm', function() {
            return $.rails.confirmed(link);
        });
    };
});