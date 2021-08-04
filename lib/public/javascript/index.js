apiData = document.getElementById("weather_data").innerText;

//temperature card div
const current_city = document.getElementById("my_weather");
const current_temperature = document.getElementById("current_temp");
const feels_like = document.getElementById("feels_like");
const temp_high = document.getElementById("temp_high");
const temp_low = document.getElementById("temp_low");
const description = document.getElementById("weather_description");
const weather_icon = document.getElementById("weather_icon");

//error message
const error_message = document.getElementById("error_message");

//form
const city_form = document.getElementById("city_form");
const city = document.getElementById("city");

mapboxgl.accessToken = config.MAPBOX;
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

const moveMap = (lat, lng) => {
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
    current_city.innerText = data.city;
    current_temperature.innerText = data.temperature;
    feels_like.innerText = data.feels_like;
    temp_high.innerText = data.max_temp;
    temp_low.innerText = data.min_temp;
    description.innerText = data.description;
    weather_icon.src = "http://openweathermap.org/img/wn/" + data.icon + "@2x.png"
}


fetchWeather = (lat, lng) => {
    fetch('/coordinates', {
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
            moveMap(data.lat, data.lng);
        })
        .catch((error) => {
            error_message.style.visibility = "visible";
            error_message.insertAdjacentText("afterbegin", city);
    });
}

function submitWeatherForm(e) {
    e.preventDefault();
    fetchWeatherCity(city.value);
    city.value = ""
    error_message.style.visibility = "hidden"
}

city_form.addEventListener('click', submitWeatherForm);
// Execute a function when the user releases a key on the keyboard
window.addEventListener("keyup", function(event) {
    // Number 13 is the "Enter" key on the keyboard
    if (event.code === 'Enter') {
        // Cancel the default action, if needed
        event.preventDefault();
        // Trigger the button element with a click
        city_form.click(submitWeatherForm);
    }
});

if (apiData === "") {
    navigator.geolocation.getCurrentPosition((data) => {
        fetchWeather(data.coords.latitude, data.coords.longitude);
        moveMap(data.coords.latitude, data.coords.longitude);
    });
}

map.on('dragend', onDragEnd);

function onDragEnd() {
    center = map.getCenter();
    marker.setLngLat(center);
    var lngLat = marker.getLngLat();
    fetchWeather(lngLat.lat, lngLat.lng);
}
