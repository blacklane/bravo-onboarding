const current_city = document.getElementById("my_weather");
const current_temperature = document.getElementById("current_temp")
const feels_like = document.getElementById("feels_like")
const temp_high = document.getElementById("temp_high")
const temp_low = document.getElementById("temp_low")

const displayData = (data) => {
    console.log(data)
    current_city.innerText = `Weather in ${data.name}`
    current_temperature.innerText = `Current temperature: ${data.main.temp}`
    feels_like.innerText = `Feels like: ${data.main.feels_like}`
    temp_high.innerText = `Today's high: ${data.main.temp_max}`
    temp_low.innerText = ` Tpday's low: ${data.main.temp_min}`
};

const currentWeather = (lat, lon) => {
    fetch(`http://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&units=metric&appid=a64896bb4676c4331e621f1940dc623d`)
        .then(response => response.json())
        .then(displayData);
};

const searchWeather = (query) => {
    fetch(`http://api.openweathermap.org/data/2.5/weather?q=${query}&appid=a64896bb4676c4331e621f1940dc623d`)
        .then(response => response.json())
        .then(displayData);
};

navigator.geolocation.getCurrentPosition((data) => {
    currentWeather(data.coords.latitude, data.coords.longitude);
});

// export { currentWeather, searchWeather, displayData }
marker.on('dragend', onDragEnd);

function onDragEnd() {
    var lngLat = marker.getLngLat();
    console.log('Longitude: ' + lngLat.lng + ' Latitude: ' + lngLat.lat);

    // move map to where the marker is dragged
    map.flyTo({
        center: [
            lngLat.lng,
            lngLat.lat
        ],
        essential: false // this animation is considered essential with respect to prefers-reduced-motion
    });
    fetch(`http://api.openweathermap.org/data/2.5/weather?lat=${lngLat.lat}&lon=${lngLat.lng}&units=metric&appid=a64896bb4676c4331e621f1940dc623d`)
        .then(response => response.json())
        .then(displayData);
}