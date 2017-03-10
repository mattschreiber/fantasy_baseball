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

$("#add-note-btn").on('click', function(e) {
  e.preventDefault();

  // ajax post method to create new note with data{player_id and owner_id}

  alert($('.duplicatable_nested_form').length);

  newNestedForm = '<input class="form-control duplicatable_nested_form"' +
  ' type="text" value="" name="player[notes_attributes][2][note]" id="player_notes_attributes_2_note">' +
  '<input type="hidden" value="5" name="player[notes_attributes][2][id]" id="player_notes_attributes_2_id">'



  //


  // nestedForm = $('.duplicatable_nested_form').last().clone();
  lastNestedForm = $('.duplicatable_nested_form').last();
  // newNestedForm  = $(nestedForm).clone();
  $( newNestedForm ).insertAfter( lastNestedForm );
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
