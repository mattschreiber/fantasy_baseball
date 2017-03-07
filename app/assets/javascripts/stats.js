$(document).on('turbolinks:load', function() {
  $(".tablesorter").tablesorter({
   	 widgets: ['zebra'],
   	 sortList: [[1,0]],
     sortRestart : true,
     sortInitialOrder: 'desc',
   });

   var playerArray = [];
   var isBatter;

  $('#bat_pitch_true').on('click', function(){
    playerArray = [];
    $(".compare-cb").prop('checked', false);

    $.ajax({
    type: 'GET',
    url: "index",
     });
  });
  $('#bat_pitch_false').on('click', function(){
    playerArray = [];
    $(".compare-cb").prop('checked', false);

    $.ajax({
    type: 'GET',
    url: "index",
    data: {
     bat_pitch: false
    },
     });

  });

  $('#stats').on('click', '.compare-cb', function(event) {

    // Your normal onclick code
    // $(".compare-cb").on('change', function(){
      if (this.checked == true) {
        if (playerArray.includes(this.value)){
          //don't need to add it again
        }
        else {
          playerArray.push(this.value);
          $("#compare-list ul").append('<li>'+this.value+'</li>');
        }
      } else {
        var index = playerArray.indexOf(this.value);
        if (index > -1) {
          playerArray.splice(index, 1);
          $("li:contains('"+this.value+"')").remove();
        }
      } // end if/else
      // alert(playerArray);

  }); //end compare-cb.on change function

  $('#compare-submit').on('click', function(){

    if ($('#bat_pitch_true').is(':checked')){
      isBatter = true;
    }
    else {
      isBatter = false;
    } //end bat_pitch_true if/else

    $.ajax({
    type: 'GET',
    url: "/stats/compare.js",
    data: {
     players: playerArray,
     batter: isBatter
    },
    success: function(data, textStatus, jqXHR)
      {
        // $('#hr_total').html(data.runs);
        // alert(data.hr +" " + data.rbi);

        playerArray = [];
        $('#compare-list ul').empty();
      },
    error: function (jqXHR, textStatus, errorThrown)
      {

      }
    });
  });


});

//  $('#compare-list ul').empty(); remove all items from list

 function render_partial() {
  	$.ajax({
			type: 'GET',
			url : "partial",
			 });
	};
