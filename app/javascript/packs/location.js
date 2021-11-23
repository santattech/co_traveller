var qi = qi || {};

$(function () {
  const start = $("#start");
  const stop = $("#stop");

  const getRandomNumber = function (min, ref) {
    return Math.random() * ref + min;
  }

  if ($('#map').length > 0) {
    qi.map = qi.location.showMap();
  }
});

qi.location = {
  map: {},
  getLocations: function () {
    var locationData = document.querySelector('#map').dataset.locations;

    if (locationData) {
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
  getPoint: function (x) {
    return new ol.geom.Point(ol.proj.fromLonLat(x));
  },
  prepareVector: function () {
    var features = [];
    var layers = [
      new ol.layer.Tile({
        source: new ol.source.OSM()
      })
    ];
    var locations = qi.location.getLocations();

    for (i = 0; i < locations.length; i++) {
      var x = [locations[i].lng, locations[i].lat];

      features.push(new ol.Feature({
        geometry: qi.location.getPoint(x)
      }));
    }

    // create the source and layer for random features
    const vectorSource = new ol.source.Vector({
      features
    });

    this.features = features;

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

    this.map = new ol.Map({
      target: 'map',
      layers: layers,
      view: view
    });

    qi.location.drawLineTrackFromLocations();
  },
  addDotLayer: function (loc) {
    // sample loc
    // loc = [88.3874, 22.6157];

    var circleStyle = [
      new ol.style.Style({
        image: new ol.style.Circle({
          fill: new ol.style.Fill({ color: 'green' }),
          width: 6,
          radius: 6
        })
      })
    ];

    var circleDot = new ol.layer.Vector({
      source: new ol.source.Vector({
        features: [
          new ol.Feature({
            geometry: qi.location.getPoint(loc)
          })
        ]
      })
    })

    circleDot.setStyle(circleStyle);
    qi.location.map.addLayer(circleDot);
  },
  drawLineTrackFromLocations: function() {
    var locations = qi.location.getLocations();

    for (i = 0; i < locations.length - 1; i++) {
      var x = [locations[i].lng, locations[i].lat];
      var y = [locations[i+1].lng, locations[i+1].lat];

      qi.location.drawLineTrack(x, y);
    }

  },
  drawLineTrack: function (location1, location2) {
    //var lonlat = ol.proj.fromLonLat([33.8, 8.4]);
    //var location2 = ol.proj.fromLonLat([37.5, 8.0]);
    var lonlat = ol.proj.fromLonLat(location1);
    var location2 = ol.proj.fromLonLat(location2);
    
    var linie2style = [
      // linestring
      new ol.style.Style({
        stroke: new ol.style.Stroke({
          color: '#d12710',
          width: 2
        })
      })
    ];

    var linie2 = new ol.layer.Vector({
      source: new ol.source.Vector({
        features: [new ol.Feature({
          geometry: new ol.geom.LineString([lonlat, location2]),
          name: 'Line',
        })]
      })
    });

    linie2.setStyle(linie2style);
    qi.location.map.addLayer(linie2);
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
      let lat = data.coords.latitude;
      let lng = data.coords.longitude;

      $.post(url, { lat: lat, lng: lng }, (data) => {
        console.log("created location with ", data)
        var loc = [lng, lat];
        qi.location.addDotLayer(loc)
      })
    },
    error => console.log(error),
    options
  );

  qi.location.drawLineTrack();
})

$(document).on("click", "#stop", () => {
  window.location.href = "/locations"
})