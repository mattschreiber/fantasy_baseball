$(".starter").bind('change', function(){
  if (this.checked){
    $.ajax({
      url: '/players/'+this.value+'/set_starter',
      type: 'POST',
      data: {"starter": this.checked}
    });
  }
  else {
     alert("no");
  }
});




