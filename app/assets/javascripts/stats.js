$(document).on('turbolinks:load', function() {

   var playerArray = [];
   var isBatter;

  $('#bat_pitch_true').on('click', function(){
    resetSearchForm();
    getSearchIndex(true);
  });
  $('#bat_pitch_false').on('click', function(){
    resetSearchForm(); //reset form controls to defaults
    getSearchIndex(false); //ajax function to reload index page

  });

  $('#stats').on('click', '.compare-cb', function(event) {
    // Your normal onclick code
    // $(".compare-cb").on('change', function(){
      if (this.checked == true) {
        if (playerArray.includes(this.value)){
          //don't need to add it again
        }
        else {
          playerArray.push(this.value);
          // add player to list of people selected to compare
          // Add ajax call to get back list of player names as json to populate list???
          var row = $(this).closest("tr");
          // var clone = row.clone();
          // console.log(clone);
          // $('#compare-results-table').append(clone);

          var firstName = row.find(".first-name");
          var lastName = row.find(".last-name");
          var name = firstName.text() + " " + lastName.text();
          $("#compare-list ul").append('<li id="'+this.value+'">'+ name +'</li>');
        }
      } else {
        var index = playerArray.indexOf(this.value);
        if (index > -1) {
          playerArray.splice(index, 1);
          document.getElementById(this.value).remove();
          // $("li:contains('"+this.value+"')").remove();
        }
      } // end if/else
      // alert(playerArray);

  }); //end compare-cb.on change function

  $('#compare-submit').on('click', function(){

    $('#compare-list ul').empty();

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
    success: function(data, textStatus, jqXHR)
      {
        // $('#hr_total').html(data.runs);
        // alert(data.hr +" " + data.rbi);

        playerArray = [];
        $('#compare-list ul').empty();
      },
    error: function (jqXHR, textStatus, errorThrown)
      {

      }
    });
  });


  $(".tablesorter").tablesorter({
   	 widgets: ['zebra'],
   	 sortList: [[1,0]],
     sortRestart : true,
     sortInitialOrder: 'desc',
   });
});

function resetSearchForm() {
  playerArray = [];
  $(".compare-cb").prop('checked', false);
  $("#avail_players").val("true");

};

function getSearchIndex(isBatter) {
  $.ajax({
  type: 'GET',
  url: "index",
  data: {
   bat_pitch: isBatter
  },
   });
};

function buildTable(){
  $('#compare-results').append(
  "<h1 id='compare-table-header'>Players</h1>"+
  "<table id='compare-results-table' class='tablesorter tablesorter-blue'>"+
  "<thead><tr>"+
  "<th>ESPN Rank</th>"+
  "<th>CBS Rank</th>"+
  "<th>First</th>"+
  "<th>Last</th>"+
  "<th>Age</th>"+
  "<th>Pos</th>"+
  "<th>Team</th>"+
  "<th>Runs</th>"+
  "<th>Home Runs</th>"+
  "<th>RBIs</th>"+
  "<th>SB</th>"+
  "<th>BA</th>"+
  "<th>Compare</th>"+
  "<th>Edit</th></tr></thead>"+
  "<tbody></tbody>"+
  "</table>");
};


//  $('#compare-list ul').empty(); remove all items from list

 function render_partial() {
  	$.ajax({
			type: 'GET',
			url : "partial",
			 });
	};
