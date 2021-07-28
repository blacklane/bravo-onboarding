apiData = document.getElementById("weather_data").innerText;

//temperature card div
const current_city = document.getElementById("my_weather");
const current_temperature = document.getElementById("current_temp");
const feels_like = document.getElementById("feels_like");
const temp_high = document.getElementById("temp_high");
const temp_low = document.getElementById("temp_low");

//form
const city_form = document.getElementById("city_form");
const city = document.getElementById("city");

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

const geoLocateMap = (lat, lng) => {
    map.jumpTo({
        center: [
            lng,
            lat
        ]
    })
    center = map.getCenter();
    marker.setLngLat(center);
}

const displayWeather = (data) => {
    current_city.innerText = `Weather in ${data.city}`
    current_temperature.innerText = "Current Temperature: " + data.temperature;
    feels_like.innerText = "Feels like: " + data.feels_like;
    temp_high.innerText = "Today's high: " + data.max_temp;
    temp_low.innerText = "Today's low: " + data.min_temp;
}

fetchWeather = (lat, lng) => {
    fetch('/weather', {
        method: 'POST',
        mode: 'cors',
        headers: {
            'Content-Type': 'application/json' },
        body: JSON.stringify({lat: lat, lng: lng})
    })
        .then(response => response.json())
        .then(data => displayWeather(data))
}

fetchWeatherCity = (city) => {
    fetch('/weather', {
        method: 'POST',
        mode: 'cors',
        headers: {
            'Content-Type': 'application/json' },
        body: JSON.stringify({city: city})
    })
        .then(response => response.json())
        .then(data => {
            displayWeather(data);
            geoLocateMap(data.lat, data.lng);
        });
}

function submitWeatherForm(e) {
    e.preventDefault();
    fetchWeatherCity(city.value);
}

city_form.addEventListener('submit', submitWeatherForm);

if (apiData === "") {
    navigator.geolocation.getCurrentPosition((data) => {
        fetchWeather(data.coords.latitude, data.coords.longitude);
        geoLocateMap(data.coords.latitude, data.coords.longitude);
    });
}

const moveMap  = (data) => {
    map.jumpTo({
        center: [
            data.lng,
            data.lat
        ]
    })
    center = map.getCenter();
    marker.setLngLat(center);
}


if (apiData != "") {
    weather_json = JSON.parse(apiData);
    moveMap(weather_json);
}

map.on('dragend', onDragEnd);

function onDragEnd() {
    center = map.getCenter();
    marker.setLngLat(center);
    var lngLat = marker.getLngLat();
    fetchWeather(lngLat.lat, lngLat.lat);
}
