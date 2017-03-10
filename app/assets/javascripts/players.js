$(document).on('turbolinks:load', function() {
$(".starter").on('change', function(){
    $.ajax({
      url: '/players/'+this.value+'/set_starter',
      type: 'POST',
      data: {"player":
      	{starter: this.checked} },
      // dataType: 'json',
      success: function(data, textStatus, jqXHR)
    {
        // $('#hr_total').html(data.runs);
        // alert(data.hr +" " + data.rbi);
    },
    error: function (jqXHR, textStatus, errorThrown)
    {

    }
    });

});
$("#player_owner_id").on('change', function() {
	if ($("#player_owner_id").val()) {
		$("#player_avail").prop('checked', false);
	}
	else {
		$("#player_avail").prop('checked', true);
	}
});

// $("#update-submit").on('click', function(){
// //
//     var note = $("textarea").val();
//     var id = $("#player_id").text();
// //
// //     // $.ajax({
// //     //   url: '/players/'+this.value,
// //     //   type: 'POST',
// //     //   data: {"player":
// //     //     {starter: this.checked} },
// //     //   // dataType: 'json',
// //     //   success: function(data, textStatus, jqXHR)
// //     // {
// //     //     // $('#hr_total').html(data.runs);
// //     //     // alert(data.hr +" " + data.rbi);
// //     // },
// //     // error: function (jqXHR, textStatus, errorThrown)
// //     // {
// //     //
// //     // }
// //     // });
// //
// });


});
