$(document).on('turbolinks:load', function() {
  $("#myTable").tablesorter({
   	 widgets: ['zebra'],
   	 sortList: [[7,1]] 
   });
  $("#myTable1").tablesorter({
   	 widgets: ['zebra'],
   	 sortList: [[7,1]] 
   });
  
});

 function render_partial() {
  	$.ajax({
			type: 'GET',
			url : "partial",
			 });
	};