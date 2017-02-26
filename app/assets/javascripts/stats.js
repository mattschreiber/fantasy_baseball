$(document).on('turbolinks:load', function() {
  $(".tablesorter").tablesorter({
   	 widgets: ['zebra'],
   	 sortList: [[1,0]],
     sortRestart : true,
     sortInitialOrder: 'desc',
   });  
});

 function render_partial() {
  	$.ajax({
			type: 'GET',
			url : "partial",
			 });
	};