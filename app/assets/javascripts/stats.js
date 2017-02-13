$(document).on('turbolinks:load', function() {
  $("#myTable").tablesorter({
   	 widgets: ['zebra'],
   	 sortList: [[7,1]] 
   });

  var pitch = document.getElementById('bat_pitch_false');
  // var btn_c = document.getElementsByName('pos')
  pitch.onclick = function() {
      $("#pos_c").hide();
      $('label[for="pos_c"]').hide();
      $("#pos_1b").hide();
      $('label[for="pos_one"]').hide();
      $("#pos_2b").hide();
      $('label[for="pos_2b"]').hide();
      $("#pos_2b").hide();
      $('label[for="pos_2b"]').hide();
      $("#pos_3b").hide();
      $('label[for="pos_3b"]').hide();
      $("#pos_ss").hide();
      $('label[for="pos_ss"]').hide();
      $("#pos_of").hide();
      $('label[for="pos_of"]').hide();
      $("#pos_sp").show();
      $('label[for="pos_p"]').show();
      $("#pos_rp").show();
      $('label[for="pos_rp"]').show();
  };

  var bat = document.getElementById('bat_pitch_true');
  // var btn_c = document.getElementsByName('pos')
  bat.onclick = function() {
  		$("#pos_c").show();
      $('label[for="pos_c"]').show();
      $("#pos_1b").show();
      $('label[for="pos_one"]').show();
      $("#pos_2b").show();
      $('label[for="pos_2b"]').show();
      $("#pos_2b").show();
      $('label[for="pos_2b"]').show();
      $("#pos_3b").show();
      $('label[for="pos_3b"]').show();
      $("#pos_ss").show();
      $('label[for="pos_ss"]').show();
      $("#pos_of").show();
      $('label[for="pos_of"]').show();
      $("#pos_sp").hide();
      $('label[for="pos_p"]').hide();
      $("#pos_rp").hide();
      $('label[for="pos_rp"]').hide();
  };
});