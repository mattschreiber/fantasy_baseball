$(document).on('turbolinks:load', function() {
  $("#myTable").tablesorter({
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