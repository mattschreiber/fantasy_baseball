$(document).on('turbolinks:load', function() {
$(".starter").bind('change', function(){
    $.ajax({
      url: '/players/'+this.value+'/set_starter',
      type: 'POST',
      data: {"starter": this.checked}
    });

});
});