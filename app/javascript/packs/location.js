
$(function () {
  const start = $("#start");
  const stop = $("#stop");

  var map = new ol.Map({
    target: 'map',
    layers: [
      new ol.layer.Tile({
        source: new ol.source.OSM()
      })
    ],
    view: new ol.View({
      center: ol.proj.fromLonLat([88.4306, 22.6138]),
      zoom: 10
    })
  });
});

$(document).on("click", "#start", () => {
  const options = {
    enableHighAccuracy: false,
    timeout: 10000,
    maximumAge: 0
  }

  navigator.geolocation.watchPosition(
    data => {
      // call an API to save in DB
      let url = '/api/v1/locations'

      $.post(url, { lat: data.coords.latitude, lng: data.coords.longitude }, (data) => {
        console.log("created location with ", data)
      })
    },
    error => console.log(error),
    options
  );
})

