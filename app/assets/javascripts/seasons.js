$(document).on('turbolinks:load', function() {
  $(".projected_standings").tablesorter({
   	 widgets: ['zebra'],
   	 sortList: [[12,1]],
     sortRestart : true,
     sortInitialOrder: 'desc',
   });
});
