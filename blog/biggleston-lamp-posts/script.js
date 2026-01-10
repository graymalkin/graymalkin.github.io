var map = L.map('map').setView([51.278938, 1.080006], 14);
L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);

function condition_code_to_color(code) {
    switch (code) {
        case 1:
            return 'green';
        case 2:
        case 3:
        case 4:
        case 5:
            return 'rgba(196, 141, 0, 1)';
        case 6:
        case 7:
            return 'red';
        default:
            return 'magenta';
    }
}

function condition_code_to_string(code) {
    switch (code) {
        case 0: return 'Not surveyed.'
        case 1: return 'Good condition';
        case 2: return 'Poor: needs repaint';
        case 3: return 'Poor: needs access hatch repair';
        case 4: return 'Poor: needs repaint and hatch repair';
        case 5: return 'Poor: other reason'
        case 6: return 'Removed (stump)';
        case 7: return 'Removed (completely missing)'
        default: return 'Unknown condition';
    }
}

async function populate() {
    const requestURL = "/blog/biggleston-lamp-posts/data.json";
    const request = new Request(requestURL);

    const response = await fetch(request);
    const data = await response.json();
    var notTracked = 0;
    var goodCondition = 0;
    var poorCondition = 0;
    var razed = 0;
    for(i = 0; i < data.length; i++) {
        // console.log("Data: " + data[i]);
        var condition_code = data[i]["condition_code"];
        switch (condition_code) {
            case 1:
                goodCondition++;
                break;
            case 2:
            case 3:
                poorCondition++;
                break;
            case 4:
            case 5:
            case 6:
                razed++;
                break;
        }

        var c = L.circle([data[i]["lat"], data[i]["lon"]], {
            color: condition_code_to_color(condition_code),
            fillColor: condition_code_to_color(condition_code),
            fillOpacity: 0.5,
            radius: 5
        });
        var popupString = "";
        var image_url = data[i]["image_url"];
        if (image_url != null) {
            popupString += `<a href="${image_url}"><img src="${image_url}" alt="Image" class="mapPopupImg"/></a> <br/>`
        }
        popupString += `Condition: <i>${condition_code_to_string(data[i]["condition_code"])}</i><br/>`;
        popupString += `Date checked: <i>${data[i]["date_checked"]}</i><br />`;
        popupString += `Council tracked: <i>${data[i]["council_tracked"]}`;
        if (!data[i]["council_tracked"]) notTracked++;

        c.bindPopup(popupString);
        c.addTo(map);
    }

    var total = goodCondition + poorCondition + razed;
    document.getElementById("dataLen").innerHTML = `${data.length}`;
    document.getElementById("numLampPosts").innerHTML = `${total}`;
    document.getElementById("numGood").innerHTML = `${goodCondition} (${(goodCondition/total * 100).toFixed(0)}%)`;
    document.getElementById("numPoor").innerHTML = `${poorCondition} (${(poorCondition/total * 100).toFixed(0)}%)`;
    document.getElementById("numRazed").innerHTML = `${razed} (${(razed/total * 100).toFixed(0)}%)`;
    document.getElementById("notTracked").innerHTML = `${notTracked}`;
}

populate();