$(document).on('turbolinks:load', function() {

var active = document.getElementById('active');

  if ( $( "#active" ).length ) {

    active.onchange = function() {

      var val = $("#active").val();

      $.ajax({
      type: 'GET',
      url: "owners.js",
      data: {
       active: val
      },
       });

  };

}

});
