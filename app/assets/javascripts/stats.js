$(document).on('turbolinks:load', function() {
  $(".tablesorter").tablesorter({
   	 widgets: ['zebra'],
   	 sortList: [[1,0]],
     sortRestart : true,
     sortInitialOrder: 'desc',
   });

   var playerArray = [];


  $('#search-submit').on('click', function(){
    playerArray = [];
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
      alert(playerArray);
  }); //end compare-cb.on change function




});

 function render_partial() {
  	$.ajax({
			type: 'GET',
			url : "partial",
			 });
	};
