function showMark()
{

    var sel = document.getElementById("idstation");

    var index= sel.selectedIndex;

    var vsel = sel[index].text;




    if ( vsel == "Hyytiala" )
    {

        var mapProp = {
    center: new google.maps.LatLng(61.5000, 24.1800),
    zoom:3,
    mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("googleMap"),mapProp);

        marker.setMap(null);

marker=new google.maps.Marker({position: mapProp.center});

marker.setMap(map);



}

if ( vsel == "Melpitz" )
{



var mapProp = {
    center: new google.maps.LatLng(51.32, 12.56),
    zoom:3,
    mapTypeId: google.maps.MapTypeId.ROADMAP
};
map = new google.maps.Map(document.getElementById("googleMap"),mapProp);

marker.setMap(null);

marker=new google.maps.Marker({position: mapProp.center});

marker.setMap(map);




}

if ( vsel == "Aspvreten" )
{


var myCenter=new google.maps.LatLng(51.5072,0.1275);
var mapProp = {
    center: new google.maps.LatLng(58.80578,17.38837),
    zoom:3,
    mapTypeId: google.maps.MapTypeId.ROADMAP
};
map = new google.maps.Map(document.getElementById("googleMap"),mapProp);

marker.setMap(null);

marker=new google.maps.Marker({position: mapProp.center});

marker.setMap(map);

}



if ( vsel == "Zeppelin" )
{


var mapProp = {
    center: new google.maps.LatLng(78.90669,11.88934),
    zoom:3,
    mapTypeId: google.maps.MapTypeId.ROADMAP
};
map = new google.maps.Map(document.getElementById("googleMap"),mapProp);

marker.setMap(null);

marker=new google.maps.Marker({position: mapProp.center});

marker.setMap(map);



}


if ( vsel == "Pallas" )
{


var mapProp = {  
    center: new google.maps.LatLng(67.58,24.06),
    zoom:3,
    mapTypeId: google.maps.MapTypeId.ROADMAP
};
map = new google.maps.Map(document.getElementById("googleMap"),mapProp);

marker.setMap(null);

marker=new google.maps.Marker({position: mapProp.center});

marker.setMap(map);



}




}
