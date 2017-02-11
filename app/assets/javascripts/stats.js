$(document).on('turbolinks:load', function() {
  $("#myTable").tablesorter({
   	 widgets: ['zebra'],
   	 sortList: [[7,1]] 
   });
});