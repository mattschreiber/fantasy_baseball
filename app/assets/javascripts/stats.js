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

  $('#stats').on('change', '.change-owner', function(){

    var starter = true;
    var avail = false;
    if (this.value < 1){
      starter = false;
      avail = true;
    }
    var playerId = $(this).parent().attr('data-playerid')
    $.ajax({
      url: '/players/'+playerId,
      type: 'PUT',
      data: {"player": {
        owner_id: this.value,
        avail: avail,
        starter: starter
        }
      },
        dataType: 'json',
      success: function(data, textStatus, jqXHR)
    {
    },
    error: function (jqXHR, textStatus, errorThrown)
    {
        $( "<p>"+textStatus + " " + errorThrown + "</p>" ).insertBefore( "#compare-submit" );
    }
    });
  });

// functions for player_select view
(function(){

  var counter = 1; // use this to dynamically create select tag with unique id
  //this changes the categories to be chosen from based on if it's a batter or a hitter
  //we also remove and then re-add a div to insert additonal categories
  // finally reset the counter to 1 (which is used to give each select tag a unique name and id)
  $("#is_batter").on('change', function(){
    if (this.value == 'true') {
      $("#new-category").remove();
      $( "<div id='new-category'></div>" ).insertBefore( "#add-category" );
      addCategoryBatter(0);
      counter = 1;
    }
    else {
      $("#new-category").remove();
      $( "<div id='new-category'></div>" ).insertBefore( "#add-category" );
      addCategoryPitcher(0);
      counter = 1;
    }

  });

  $("#add-category").on('click', function() {
    if ($("#is_batter").val() == 'true'){
      addCategoryBatter(counter);
    }
    else {
      addCategoryPitcher(counter);
    }
    counter = counter + 1;
  });

  $("#remove-category").on('click', function(){
    $("#new-category").remove();
    $( "<div id='new-category'></div>" ).insertBefore( "#add-category" );
    counter = 1;
  });
  // validate weights equal 1 before submitting page
  $("#search-submit").on('click', function(){
    let iterable = document.getElementsByClassName("weight-control");
    let total = 0;
    for (let val of iterable) {
      total += parseFloat(val.value);
    }
    //apply equal weights if total equals 2
    if (total == 1 || total == 2) {
      $(".alert-danger").hide();
    }
    else {
      $(".alert-danger").show();
      return false;
    }
  });

  function addCategoryBatter(counter){
    var batterSelect = "<div class='form-spacing'>"+
    "<label for="+'category'+counter+">Select Category: </label> "+
    "<select name="+'category'+counter+" id="+'category'+counter+ " class='form-control'>" +
    "<option value='run'>RUNS</option>" +
    "<option value='hr'>HR</option>" +
    "<option value='rbi'>RBI</option>" +
    "<option value='sb'>SB</option>"+
    "<option value='average'>AVG</option>"+
    "</select> "+ appendWeightInput(counter) +
    "</div>"
    $("#new-category").append(batterSelect);
  };

  function addCategoryPitcher(counter){
    var pitcherSelect = "<div class='form-spacing'>"+
    "<label for="+'category'+counter+">Select Category: </label> "+
    "<select name="+'category'+counter+" id="+'category'+counter+ " class='form-control'>" +
    "<option value='win'>WIN</option>" +
    "<option value='so'>SO</option>" +
    "<option value='era'>ERA</option>" +
    "<option value='whip'>WHIP</option>"+
    "<option value='sv'>SV</option>"+
    "</select> "+ appendWeightInput(counter) +
    "</div>"
    $("#new-category").append(pitcherSelect);
  };

  function appendWeightInput(counter) {
    return "<input type='number' min='0' max='1' step='0.1' value='1' class='form-control weight-control' name="+'num'+counter+" data-toggle='tooltip' title='Select Weight - default 1'><strong> Weight </strong>(sum must equal 1)"
  };


  var hideAlert = $(".alert-danger").hide(); //hide the alert div on page load. Only will be displayed if there's an error on submit
  hideAlert.hide();
})(); //end player_select view iife
$(".tablesorter").tablesorter({
   widgets: ['zebra'],
   sortList: [[1,0]],
   sortRestart : true,
   sortInitialOrder: 'desc',
 });
}); // end document.ready


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
