$(document).on('turbolinks:load', function(){
  $('body').on('click', '.js__share_note', null, function(){
    $('.sharing_msg').text('');
    user_email = $('#sharing_email').val();
    $.ajax({
      url: window.location.href + '/share_note',
      data: { user_email: user_email },
      type: "POST",
      dataType: "json",
      success: function(data){
        $('.sharing_msg').text(data.msg);
      },
      error: function(data){
        msg = data.responseJSON;
      $('.sharing_msg').text(msg.msg);
      }
    });
  });
});
