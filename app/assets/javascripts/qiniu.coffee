$(document).on 'ready page:load', ->
  if $('#image-upload').length
    domain = $('.image-upload-input').data('qiniu_domain')

    Qiniu.uploader({
      runtimes: 'html5,flash,html4',
      browse_button: 'image-upload',
      uptoken_url: '/qiniu/uptoken',
      max_file_size: '20mb',
      domain: domain,
      chunk_size: '4mb',
      auto_start: true,
      init: {
        FilesAdded: (up, files) ->
          plupload.each files, (file) ->
        BeforeUpload: (up, file) ->
          $('#image-upload i').text(' 0%')
        UploadProgress: (up, file) ->
          $('#image-upload i').text(' ' + file.percent + '%')
        FileUploaded: (up, file, info) ->
          reply_textarea = $('#image-upload').parents('form').find('textarea')
          new_value = reply_textarea.val() + '![](' + domain + JSON.parse(info).key + '?imageView/2/w/619' + ')' + '\n'
          reply_textarea.val(new_value).focus().trigger('autosize.resize')
        Error: (up, err, errTip) ->
          console.log(err)
        UploadComplete: ->
          $('#image-upload i').text('')
        Key: (up, file) ->
          return md5(Date.now())
      }
  })