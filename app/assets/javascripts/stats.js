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
        playerArray.push(this.value);
      } else {
        var index = playerArray.indexOf(this.value);
        if (index > -1) {
          playerArray.splice(index, 1);
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
     });
  });


});

 function render_partial() {
  	$.ajax({
			type: 'GET',
			url : "partial",
			 });
	};
