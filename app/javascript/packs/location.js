var qi = qi || {};

$(function () {
  const start = $("#start");
  const stop = $("#stop");

  const getRandomNumber = function (min, ref) {
    return Math.random() * ref + min;
  }

  let wakeLock = null;

  const wakeF = async () => {
    if ('wakeLock' in navigator) {
      console.log("waked")
    } else {
      return
    }

    try {
      wakeLock = await navigator.wakeLock.request('screen');
      console.log('Wake Lock is active!');
    } catch (err) {
      // The Wake Lock request has failed - usually system related, such as battery.
      console.log(`${err.name}, ${err.message}`);
    }
  }

  if ($('#map').length > 0) {
    qi.map = qi.location.showMap();
    wakeF();
    const tripName = localStorage.getItem("trip");

    if (tripName) {
      $("#start").trigger('click');
      alert("trip is continuing");
    }

  } else if ($('.puris').length > 0) {
    wakeF();
    const options = {
      enableHighAccuracy: true,
      timeout: 10000,
      maximumAge: 0
    };

    navigator.geolocation.watchPosition(
      data => {
        // call an API to save in DB
        // qi.location.saveLocation(data);
        let distance = qi.location.calcCrow(22.6085692,88.4382332, data.coords.latitude, data.coords.longitude);
        distance = 80;
        console.log(distance);

        $('.alert-danger').each(function(index) {
          //console.log( index + ": " + $( this ).data('distance') );
          if($( this ).data('distance') < distance) {
            $(this).removeClass('alert-danger').addClass('alert-success');
          }
        });

        $('.alert-danger').each(function(index) {
          if(index === 0) {
            $(this).removeClass('alert-danger').addClass('alert-warning');
          }
        });
      },
      error => console.log(error),
      options
    );
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
  saveLocation: (data) => {
    let url = '/api/v1/locations'
    let lat = data.coords.latitude;
    let lng = data.coords.longitude;

    if (lat == localStorage.getItem("lat") || lng == localStorage.getItem("lng")) {
      console.log("same location from last")
      //return;
    }

    const tripName = localStorage.getItem("trip");

    $.post(url, { lat: lat, lng: lng, trip_name: tripName }, (data) => {
      console.log("created location with ", data)
      qi.location.addDotLayer([lng, lat], 'green');
      //qi.location.resetStore();
      localStorage.setItem("lat", lat);
      localStorage.setItem("lng", lng);
    })
  },
  resetStore: () => {
    localStorage.removeItem("lat");
    localStorage.removeItem("lng");
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
    var i = 0;

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
      center: ol.proj.fromLonLat([88.4387022, 22.6092715]),
      zoom: 16
    });

    var layers = qi.location.prepareVector();

    this.map = new ol.Map({
      target: 'map',
      layers: layers,
      view: view
    });

    qi.location.drawLineTrackFromLocations();
  },
  addDotLayer: function (loc, color) {
    // sample loc
    // loc = [88.3874, 22.6157];

    var circleStyle = [
      new ol.style.Style({
        image: new ol.style.Circle({
          fill: new ol.style.Fill({ color: color }),
          width: 4,
          radius: 4,
        }),
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
  addDotWithText: function (loc, color, text, width, radius, textC) {
    // sample loc
    // loc = [88.3874, 22.6157];

    var circleStyle = [
      new ol.style.Style({
        image: new ol.style.Circle({
          fill: new ol.style.Fill({ color: color }),
          width: width,
          radius: radius,
        }),
        text: new ol.style.Text({
          font: '11px roboto,sans-serif',
          text: text,
          fill: new ol.style.Fill({
            color: textC
          }),
          scale: 2,
          textAlign: 'center',
          textBaseline: 'center',
          
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
  drawLineTrackFromLocations: function () {
    const locations = qi.location.getLocations();
    var i = 0;
    const length = locations.length;

    for (i = 0; i < length - 1; i++) {
      var x = [locations[i].lng, locations[i].lat];
      var y = [locations[i + 1].lng, locations[i + 1].lat];

      qi.location.drawLineTrack(x, y);

      if(i%30==0) {
        qi.location.addDotWithText([locations[i].lng, locations[i].lat], 'blue', locations[i].createdAt, 8, 8, 'black')
      }
      
    }

    qi.location.addDotWithText([locations[0].lng, locations[0].lat], 'black', 's', 8, 8, 'white');
    qi.location.addDotWithText([locations[length - 1].lng, locations[length - 1].lat], 'black', 'e', 8, 8, 'white');
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
          color: '#0080ff',
          width: 5
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
  },
  calcCrow: function(lat1, lon1, lat2, lon2) {
    var R = 6371; // km
    var dLat = qi.location.toRad(lat2-lat1);
    var dLon = qi.location.toRad(lon2-lon1);
    var lat1 = qi.location.toRad(lat1);
    var lat2 = qi.location.toRad(lat2);

    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
    var d = R * c;
    return d;
  },
  toRad: function(Value) {
    return Value * Math.PI / 180;
  }
}

$(document).on("click", "#start", () => {
  const options = {
    enableHighAccuracy: true,
    timeout: 10000,
    maximumAge: 0
  }

  if (localStorage.getItem("trip")) {
    alert("One trip is ongoing...");
  } else {
    localStorage.setItem("trip", "trip_" + Date.now())
  }

  navigator.geolocation.watchPosition(
    data => {
      // call an API to save in DB
      qi.location.saveLocation(data);
    },
    error => console.log(error),
    options
  );
})

$(document).on("click", "#stop", () => {
  localStorage.removeItem("trip")
  qi.location.resetStore();
  window.location.href = "/locations"
})

$(document).on("change", ".trip-dropdown", (el) => {
  if ($(el.target).val()) {
    let url = "/locations?trip_name=" + $(el.target).val();
    console.log($(el.target).val())
    window.location.href = url;
  } else {
    window.location.href = "/locations";
  }

})