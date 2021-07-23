apiData = document.getElementById("weather_data").innerText;

if (apiData === "") {
    navigator.geolocation.getCurrentPosition((data) => {
        console.log(data.coords.latitude, data.coords.longitude);
        document.getElementById("lat").value = data.coords.latitude;
        document.getElementById("lon").value = data.coords.longitude;
        cityForm = document.getElementById('coords_form')
        cityForm.submit();
    });
}

weather_json = JSON.parse(apiData);

const current_city = document.getElementById("my_weather");
const current_temperature = document.getElementById("current_temp")
const feels_like = document.getElementById("feels_like")
const temp_high = document.getElementById("temp_high")
const temp_low = document.getElementById("temp_low")

mapboxgl.accessToken = 'pk.eyJ1IjoianNpZW1lbnMiLCJhIjoiY2tyYzJubzl4NHZzZTJ1cWhzOXdlMG9yeiJ9.YHohGf-MCj8k_T4X40j1IQ';
var map = new mapboxgl.Map({
    container: 'map', // container ID
    style: 'mapbox://styles/mapbox/streets-v11', // style URL
    center: [0.12, 51.50], // starting position [lng, lat]
    zoom: 8 // starting zoom
});
marker = new mapboxgl.Marker({
    draggable: false
})
    .setLngLat([0.12, 51.5])
    .addTo(map);

const moveMap  = (data) => {
    map.jumpTo({
        center: [
            data.lon,
            data.lat
        ]
    })
    center = map.getCenter();
    marker.setLngLat(center);
}

// displaySearchData(weather_json);
moveMap(weather_json);

map.on('dragend', onDragEnd);

function onDragEnd() {
    center = map.getCenter();
    marker.setLngLat(center);
    var lngLat = marker.getLngLat();
    console.log('Longitude: ' + lngLat.lng + ' Latitude: ' + lngLat.lat);

    // retrieve coords
    document.getElementById("lat").value = lngLat.lat;
    document.getElementById("lon").value = lngLat.lng;
    cityForm = document.getElementById('coords_form')
    cityForm.submit();
}











