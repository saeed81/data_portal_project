// JScript source code




function ajaxPost() {

// Post data from the web page to the cgi-bin program using Ajax,
// and write the results to the named <div> on the same page.
//
// The first argument of Ajax.Updater is the name of the container
// (a <div>) where the output obtained from the url (the second
// argument) will go. In the {} are a series of options:
//
// method: 'post', ..send information to the url using Post
// parameters: {..}, ..the posted data
// onCreate: a function() {..}, not used
// onError: a function() {..}, writes a simple message
// onComplete: a function() {..}, not used
//
new Ajax.Updater("results_div", "/cgi-bin/data_base_project.exe",
{method: 'post',

parameters: {makes: $F('stat'), models: $F('inst'), sdate: $F('dt1'), edate: $F('dt2'), resolution: $F('reso')},

onCreate: function() {
 


},
onError: function() {
// show an error message
var errMessage = 'An error occurred before ' +
'the Fortran program was called. Please try again.';
$('results_div').innerHTML = errMessage;
},
onComplete: function() {
var variable = document.getElementById('results_div').innerHTML;
var res_sel=document.getElementById('reso').innerHTML;
var split_res=variable.split(":")
var le=split_res[1].length

//alert(variable)
//alert(split_res[1].substring(0, 3));



if (split_res[1].substring(0, 3)=='OK!')
{
plot_fig()
}


// else...do nothing...just wait....and die....
}
} //end Ajax.Updater options
); //end Ajax.Updater function
} //end ajaxPost function


function plot_fig(){
Pause();

}


function Pause() {
timer = setTimeout("endpause()",1000); // 3 secs
return false;
}

function endpause() {



window.open ('ITM_results.html');


return false;
}
 
 


 
 