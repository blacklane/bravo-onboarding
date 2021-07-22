apiData = document.getElementById("weather_data").innerText;
weather_json = JSON.parse(apiData);

const current_city = document.getElementById("my_weather");
const current_temperature = document.getElementById("current_temp")
const feels_like = document.getElementById("feels_like")
const temp_high = document.getElementById("temp_high")
const temp_low = document.getElementById("temp_low")


const displaySearchData = (data) => {
    // console.log(data)
    current_city.innerText = `Weather in ${data.city}`
    current_temperature.innerText = `Current temperature: ${data.temperature}`
    feels_like.innerText = `Feels like: ${data.feels_like}`
    temp_high.innerText = `Today's high: ${data.max_temp}`
    temp_low.innerText = ` Today's low: ${data.min_temp}`
};

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

displaySearchData(weather_json);

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