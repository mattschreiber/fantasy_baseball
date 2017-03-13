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



$("#myModal").on('click', '#add-note-btn', function(e) {
  e.preventDefault();

  var numNote = $('.duplicatable_nested_form').length; // how many notes are displayed

  // make sure the modal for entering the note is displayed. This check accounts for when a user hits the enter key
  if (($("#myModal").data('bs.modal') || {}).isShown) {

    // console.log(e);
    // ajax post method to create new note with data{player_id and owner_id}

    var player_id = $(this).attr("data-ownerid");
    var owner_id = $('#player_owner_id').val();
    var noteModal = $('#modal-note-textarea').val();

    // for now only allow one note so check to make sure none exist
    if (numNote < 1) {
      $.ajax({
            url: '/notes',
            type: 'POST',
            data: {"note":
              {player_id: player_id, owner_id: owner_id, note: noteModal} },
            dataType: 'json',
            success: function(data, textStatus, jqXHR)
          {
            // need to set value for newly created note's hidden field
            var noteId = data.id;
            var note = data.note;
            //call newNestedForm function which retuns html for new note to be appended to page
            newNote = newNestedForm(numNote, noteId, note);

                if (numNote == 0) {
                  $('.notes-container').append(newNote);
                  $("#create-note").hide();
                }
                else {
                  lastNestedForm = $('.duplicatable_nested_form').last();
                  $( newNote ).insertAfter( lastNestedForm );
                }
          },
          error: function (jqXHR, textStatus, errorThrown)
          {

          }
          });
    } //end if numNote < 1
    else {
      //do nothing, we only allow one note
    }
  }
  else { // if user presses enter
    if (numNote < 1){
        $("#myModal").modal();
      }

  } // end if/else to check if modal is shown

  $('#myModal').on('hidden.bs.modal', function (e) {
    $('#modal-note-textarea').val("");
  });

});


function newNestedForm(numNote, noteId, note){
  newNote = '<br><textarea class="form-control duplicatable_nested_form"' +
  'name="player[notes_attributes]['+ numNote +'][note]" id="player_notes_attributes_'+numNote+'_note">'+note+'</textarea>' +
  '<input type="hidden" value="'+noteId+'" name="player[notes_attributes]['+numNote+'][id]" id="player_notes_attributes_'+numNote+'_id">'

  return newNote;
};

(function(){
  // a player can have multiple notes, but for now limiting to only one
  if ($('.duplicatable_nested_form').length > 0) {
      $("#create-note").hide();
  }

})();

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
