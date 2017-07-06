# coding 'utf-8'
#=require jquery_ujs
#=require jquery.ui.datepicker
#=require jquery.ui.datepicker-ru
#=require candidates/datepicker
#=require form-validator/jquery.form-validator
#=require jquery.ui.autocomplete
#=require candidates/autocomplete
#=require candidates/candidates_geo_names.js
#=require selectize

$(document).ready ->

  $.validate (
    form: '.candidate-form'
    lang: 'ru'
  )

#selectize for choose company and modal for add new in candidate form

  selectizeCallback = null

  $('.company-modal').on 'hide.bs.modal', (e) ->
    if selectizeCallback != null
      selectizeCallback()
      selectizeCallback = null
    $('#new_company').trigger 'reset'
    $.rails.enableFormElements $('#new_company')
    return

  $('#new_company').on 'submit', (e) ->
    e.preventDefault()
    $.ajax
      method: 'POST'
      url: $(this).attr('action')
      data: $(this).serialize()
      success: (response) ->
        selectizeCallback
          value: response.id
          text: response.name
        selectizeCallback = null
        $('.company-modal').modal 'toggle'
        return
    return

  $('.selectize').selectize create: (input, callback) ->
    selectizeCallback = callback
    $('.company-modal').modal()
    $('#company_name').val input
    return
  return