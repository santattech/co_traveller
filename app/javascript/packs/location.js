var qi = qi || {};

$(function () {
  const start = $("#start");
  const stop = $("#stop");

  const getRandomNumber = function (min, ref) {
    return Math.random() * ref + min;
  }

  if($('#map').length > 0) {
    qi.location.showMap();
  }
  
});

qi.location = {
  getLocations: function() {
    var locationData = document.querySelector('#map').dataset.locations;

    if(locationData) {
      var locations = JSON.parse(locationData);
    }
    else {
      var locations = [
        { lng: 88.4067, lat: 22.6001 },
        { lng: 88.4306, lat: 22.6138 },
        { lng: 88.4222, lat: 22.6666 }
      ];
    }
    
    return locations;
  },
  prepareVector: function () {
    var features = [];
    var layers = [
      new ol.layer.Tile({
        source: new ol.source.OSM()
      })
    ];
    var locations = qi.location.getLocations();

    /*$.each(locations, function (index, location) {
      console.log(location.lat);
      features.push(new ol.Feature({
        geometry: new ol.geom.Point(
          ol.proj.fromLonLat(22.6001, 88.4067)
        )
      })
      )
    });*/

    for (i = 0; i < locations.length; i++) {
      features.push(new ol.Feature({
        geometry: new ol.geom.Point(ol.proj.fromLonLat([
          locations[i].lng, locations[i].lat
        ]))
      }));
    }

    // create the source and layer for random features
    const vectorSource = new ol.source.Vector({
      features
    });

    const vectorLayer = new ol.layer.Vector({
      source: vectorSource,
      style: new ol.style.Style({
        image: new ol.style.Circle({
          radius: 3,
          fill: new ol.style.Fill({ color: 'red' })
        })
      })
    });

    layers.push(vectorLayer);
    return layers;
  },
  showMap: function () {
    var view = new ol.View({
      center: ol.proj.fromLonLat([88.4306, 22.6138]),
      zoom: 12
    });

    var layers = qi.location.prepareVector();

    var map = new ol.Map({
      target: 'map',
      layers: layers,
      view: view
    });
  }
}

$(document).on("click", "#start", () => {
  const options = {
    enableHighAccuracy: true,
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

$(document).on("click", "#stop", () => {
  window.location.href = "/locations"
})