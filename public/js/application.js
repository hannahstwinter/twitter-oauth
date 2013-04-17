$(document).ready(function(){

  $("form.create-tweet").on("submit", function(event){
    event.preventDefault();

    var form = $(this);

    var request = $.ajax({
      type: form.method,
      url: form.action,
      data: form.serialize()
    });

    request.done(function(response){
      $(".spinner").toggle();
      $(".add_tweet").append("<p>" + response + "</p>")
    });

  });
  
})
