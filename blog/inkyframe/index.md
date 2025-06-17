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

Well last weekend, while procrastinating building a [greenhouse base](/blog/allotment/winter-24/#february) (it was raining...), I remembered it and thought I could do something more simple.
The Met Office publishes a few APIs, one of which provides images for map overlays.

I hacked together a couple of scripts, one which runs locally on my network pulls a day's worth of imagery from the Met Office API and processes it to be easy to display on the Inky Frame.
Those images are then hosted on the same pi's web server, where the Raspberry Pi Pico W can grab them conveniently over Wi-Fi.
It's probably not so hard to do this all in-device on the Pico W itself, but I wanted to experiment with different dithering, resizing, and cropping -- all of which are much faster to do on a computer than a Pico.
![Completed project](/blog/inkyframe/images/eink-weather.jpg)

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
The Micro Python libraries available for the Inky Frame only support JPEG compression, so I have written a bash script which calls imagemagick to convert all the output PNGs into JPEGs.
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
rm -f *.jpeg

for f in `python3 /home/simon/weather/metoffice.py`; do
    convert -composite -compose Multiply british-isles.png $f -crop 600x448+200+352 ${f%.*}.jpeg;
done

rm -f /var/www/html/weather/*.jpeg
cp *.jpeg /var/www/html/weather/
```

Then, on the Inky Frame itself I hacked together some Micro Python to download the correct file based on the setting of the RTC, and update the display accordingly.

```python
import machine
import gc
import time
import asyncio
import ntptime
import jpegdec
import json
import sdcard
import uos

from urllib import urequest
from picographics import PicoGraphics, DISPLAY_INKY_FRAME as DISPLAY
import inky_helper as ih

IF_MISO = 16
IF_CLK = 18
IF_MOSI = 19
IF_SD_CS = 22

BASE_URL = "http://raspberrypi/weather/"
FILENAME = "/sd/current-weather.jpeg"
UPDATE_INTERVAL=60
time_string = ""

MODES = [ {"url": "temperature", 'string': "Temperature" }, {"url": "mean", 'string': "Pressure" }, {"url": "total", 'string': "Precipitation" } ]
MONTH = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "November", "December"]

state = { "url" : None }

gc.collect()

ih.led_warn.on()
sd = None
while True:
    try:
        sd_spi = machine.SPI(0, sck=machine.Pin(18, machine.Pin.OUT), mosi=machine.Pin(19, machine.Pin.OUT), miso=machine.Pin(16, machine.Pin.OUT))
        sd = sdcard.SDCard(sd_spi, machine.Pin(22))
        break
    except OSError:
        sd = None
        gc.collect()
        ih.inky_frame.button_e.led_on()
        time.sleep(1)
        ih.inky_frame.button_e.led_off()
        print("failed to connect to SD card, retrying")
        
ih.led_warn.off()
uos.mount(sd, "/sd")

gc.collect()

try:
    from secrets import WIFI_SSID, WIFI_PASSWORD
    ih.network_connect(WIFI_SSID, WIFI_PASSWORD)
except ImportError:
    print("Create secrets.py with your Wi-Fi credentials")
    reset()

# Get some memory back, we really need it!
gc.collect()
print("Wi-Fi Connected")

graphics = PicoGraphics(DISPLAY)
WIDTH, HEIGHT = graphics.get_bounds()
graphics.set_font("bitmap8")

# Turn any LEDs off that may still be on from last run.
ih.clear_button_leds()
ih.led_warn.off()

def time_to_url(current_t, mode):
    global time_string
    url = BASE_URL + "{}-{:02d}-{:02d}-{:02d}-{:02d}.jpeg".format(MODES[mode]["url"], current_t[0], current_t[1], current_t[2], current_t[3])
    time_string = "{} {} {} {} {:02d}:00".format(MODES[mode]["string"], current_t[2], MONTH[current_t[1]], current_t[0], current_t[3])
    return url

def set_time():
    # Correct the time while we're at it
    try:
        ih.inky_frame.set_time()
        print(time.localtime())
    except e:
        print(e)
        show_error("Unable to set time: {}".format(e))
        ih.led_warn.on()
        return

def update(url):
    print("Update")
    # Grab the image
    try:
        ih.pulse_network_led()
        socket = urequest.urlopen(url)
        gc.collect()
        data = bytearray(1024)
        with open(FILENAME, "wb") as f:
            while True:
                if socket.readinto(data) == 0:
                    break
                f.write(data)
        socket.close()
        del data
        gc.collect()
    except OSError as e:
        print(e)
        show_error("Unable to download image")
        ih.led_warn.on()
    finally:
        ih.stop_network_led()


def show_error(text):
    graphics.set_pen(4)
    graphics.rectangle(0, 10, WIDTH, 70)
    graphics.set_pen(1)
    graphics.text(text, 5, 16, 635, 2)


def draw():
    global state
    try:
        jpeg = jpegdec.JPEG(graphics)
        graphics.set_pen(1)
        graphics.clear()

        gc.collect()
        jpeg.open_file(FILENAME)
        jpeg.decode()
        graphics.set_pen(0)
        graphics.rectangle(0, 0, WIDTH, 25)
        graphics.set_pen(1)
        graphics.text(time_string, 5, 5, WIDTH, 2)
    except OSError as e:
        show_error("Unable to display image! OSError: {}".format(e))
        ih.inky_frame.button_b.led_on()
    except Exception as e:
        show_error("Unable to display image! Error: {}".format(e))
        ih.inky_frame.button_c.led_on()
    finally:
        graphics.update()

def save_state(data):
    with open("/state.json", "w") as f:
        f.write(json.dumps(data))
        f.flush()

def load_state():
    global state
    data = json.loads(open("/state.json", "r").read())
    if type(data) is dict:
        state = data
    else:
        state = { "url" : None }


set_time()

while True:
    # Disable deep sleep while we check for an update
    ih.inky_frame.vsys.init(machine.Pin.OUT)
    ih.inky_frame.vsys.on()
    
    old_url = state['url']
    url = time_to_url(time.localtime(), 0)
    if old_url != url:
        print("New URL: {}".format(url))
        update(url)
        draw()
        state['url'] = url
        save_state(state)
        time.sleep(30)
    
    # Sleep for one minute
    ih.inky_frame.sleep_for(1)
```

## Battery, sleep, and Thonny

I had surprising friction trying to take my `main.py` from something that worked under Thonny.
The update of the screen appears to be asynchronous, but that seems to mean that calling deep sleep allows the Pi Pico to sleep before the screen has updated causing meaning it never draws the JPEG to the display.
Thus far, still not working -- I am probably doing something bone-headed, but I can't see what.
For now, it works when connected to USB (external power disables the sleep function) so it can sit on my desk powered by my monitor.

[inkyframe-pimoroni]: https://shop.pimoroni.com/products/inky-frame-5-7?variant=40048398958675
