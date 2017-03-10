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

  player_id = $(this).attr("data-ownerid");
  owner_id = $('#player_owner_id').val();

  // update various html fields based on new number of player notes
  numNote = $('.duplicatable_nested_form').length;


  // $.ajax({
  //       url: 'notes',
  //       type: 'POST',
  //       data: {"note":
  //         {player_id: player_id, owner_id: owner_id} },
  //       dataType: 'json',
  //       success: function(data, textStatus, jqXHR)
  //     {
            // need to set value for newly created note's hidden field
  //         noteId = data.id

            // newNote = newNestedForm(numNote, noteId);
            //
            // if (numNote == 0) {
            //   $('.notes-container').append(newNote);
            // }
            // else {
            //   lastNestedForm = $('.duplicatable_nested_form').last();
            //   $( newNote ).insertAfter( lastNestedForm );
            // }

  //     },
  //     error: function (jqXHR, textStatus, errorThrown)
  //     {
  //
  //     }
  //     });

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
function newNestedForm(numNote, noteId){
  newNote = '<input class="form-control duplicatable_nested_form"' +
  ' type="text" value="" name="player[notes_attributes]['+ numNote +'][note]" id="player_notes_attributes_'+numNote+'_note">' +
  '<input type="hidden" value="'+noteId+'" name="player[notes_attributes]['+numNote+'][id]" id="player_notes_attributes_'+numNote+'_id">'

  return newNote;
};


});
