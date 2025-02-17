---
title: Inky Frame
subtitle: Colour e-paper weather display
date: 2025-02-14
published: true
toc: false
---

Pimoroni in the UK sell a cute [5.7" e-paper photo frame][inkyframe-pimoroni], with an integrated Raspberry Pi Pico W.
They're pretty pricey, but colour e-paper is very cool.
I've had it for a while, and had grand visions of building a customisable YAML driven home assistant front-end for it, to display stats about the house, weather, inside and outside temperatures, and other nerdery.
Like all the best laid plans though, it never really got anywhere.
Time and other priorities meant it was left languishing in a drawer and I never got the project past a barely functional prototype.

Well last weekend, while procrastinating building a [greenhouse base](/blog/allotment/spring-25/) (it was raining...), I remembered it and thought I could do something more simple.
The Met Office publish a few APIs, one of which provides images for map overlays.

I hacked together a couple of scripts, one which runs locally on my network pulls a day's worth of imagery from the Met Office API and processes it to be easy to display on the inky frame.
Those images are then hosted on the same pi's web server.


```python
#!/usr/bin/env python3
import json
import re
import datetime
import urllib.request

API_URL = "https://data.hub.api.metoffice.gov.uk/map-images/1.0.0"
MET_OFFICE_API_KEY = """YOUR KEY HERE"""
ORDER_NAME = "YOUR ORDER NUMBER HERE"
FILENAME_BASE = ""

# Get a list of files in the job, filter out dupes.
req = urllib.request.Request(API_URL + "/orders/" + ORDER_NAME + "/latest")
req.add_header("apikey", MET_OFFICE_API_KEY)
req.add_header("Accept", "application/json")
resp = urllib.request.urlopen(req).read()
data = json.loads(resp.decode("utf-8"))

files = []
for file in data["orderDetails"]["files"]:
    fileId = file["fileId"]
    if "_+00" not in fileId and "ts" in fileId:
        timestamp = datetime.datetime.strptime(file["runDateTime"], "%Y-%m-%dT%H:%M:%S%z")
        timestep = int(re.findall(r"ts\d\d?", fileId)[0][2:])
        series = re.split(r"_", fileId)[0]
        timestamp = timestamp + datetime.timedelta(hours=timestep)
        files.append({'fileId' : fileId, 'timestamp': timestamp, 'series': series})


# Download each file from the list of files.
for file in files:
    req = urllib.request.Request(API_URL + "/orders/" + ORDER_NAME + "/latest/" + file['fileId'] + "/data")
    req.add_header("apikey", MET_OFFICE_API_KEY)
    req.add_header("Accept", "image/png")
    resp = urllib.request.urlopen(req).read()
    filename = FILENAME_BASE + "{}-{}.png".format(file['series'], file['timestamp'].strftime("%Y-%m-%d-%H"))
    with open(filename, 'wb') as f:
        f.write(resp)
        print(filename)
```

This produces a bunch of PNG files with names like `temperature-2025-02-14-10.png` (the temperature forecast for Valentine's Day 2025 at 10:00).
The Micro Python libraries available for the inky frame only support JPEG compression, so I have written a bash script which calls imagemagick to convert all the output PNGs into JPEGs.
The PNGs returned by the Met Office do not include a map background layer (despite what their sample data shows...) so I composite in a background image for the British Isles.
I experimented with using imagemagick's dithering, but the automatic dithering done by the JPEG library on the Inky Frame produced (to me) a more pleasing result.
This script also copies the files to the web server's hosted directory.

```bash
#!/bin/bash

cd /home/simon/weather

# Delete old files
rm -f temperature-*.png
rm -f mean-*.png
rm -f total-*.png

for f in `python3 /home/simon/weather/metoffice.py`; do
    #convert -composite -compose Multiply british-isles.png $f -dither Riemersma -remap palate.bmp -crop 600x448+200+352 ${f%.*}.jpeg;
    convert -composite -compose Multiply british-isles.png $f -crop 600x448+200+352 ${f%.*}.jpeg;
    #echo $f
done

rm -f /var/www/html/weather/*.jpeg
cp *.jpeg /var/www/html/weather/
```

Then, on the Inky Frame itself I hacked together some Micro Python to download the correct file based on the setting of the RTC, and update the display accordingly.

```python
# to follow
```

## Battery, sleep, and Thonny

I had surprising friction trying to take my `main.py` from something that worked under Thonny.
The update of the screen appears to be asynchronous, but that seems to mean that calling deep sleep allows the Pi Pico to sleep before the screen has updated causing meaning it never draws the JPEG to the display.


[inkyframe-pimoroni]: https://shop.pimoroni.com/products/inky-frame-5-7?variant=40048398958675
