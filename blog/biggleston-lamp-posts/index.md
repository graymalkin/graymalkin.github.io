---
title: Biggleston lamp posts
subtitle: Documenting the condition of Canterbury's historic lamposts
date: 2026
published: true
toc: false
---

![Biggleston Lamp Post in good condition](/blog/biggleston-lamp-posts/images/15-york-road.jpeg)

There is [a campaign](https://www.canterbury-archaeology.org.uk/biggleston-lamp-posts) to save some of Canterbury's historic lamp posts.
Dating back to the 19th century, the lamp posts were made locally by the Biggleston Foundry, which used to operate from Canterbury.
Over the last 10-15 years or so they have been poorly maintained, and weathering paint has allowed them to rust.
Many have been removed, and of those many have been removed quite poorly: the top has been chopped off, and a new modern lamp post has been installed directly next to the stump.

There's lots of other ironwork around the city from the Biggleston company, bollards, railings, other types of light fixture, metal covers for fire hydrants.
Not all of it appears well documented, and some of this history is lost to time.

Sadly a lot of iron work is left in a condition which will accelerate its deterioration.
The railings along Wincheap high street under the railway bridge are another example.
It is understandable that councils with ever tightening budgets allow maintenance of these things to dwindle, but there's a risk of poor maintenance saving money now and costing far more in the future.
In the meantime we're left with a deteriorating local environment and a hodge-podge mix of partially replaced street furniture.

&nbsp;
![Badly removed lamp post on Castle Street](/blog/biggleston-lamp-posts/images/24-york-road-base.jpeg)

To contribute some effort to the campaign to try and stop the continued deterioration and removal of Canterbury's interesting lamp posts, I am documenting the condition and location of those that remain.
One of my local councillors has been helpful in providing a spreadsheet with the locations of all the lamp posts that Kent County Council know about.
Starting in Wincheap, I have cross-referenced their list with the lamp posts I've found and plotted their locations and condition on the map below.
Magenta dots are lamp posts in the Council data set that I have not visited to survey yet.
Red dots are lamp posts that have been partially or completely removed.
Orange dots are lamp posts in poor condition.
Green dots are lamp posts in good condition.

<div id="map"></div>

Full data is available in JSON format [here](/blog/biggleston-lamp-posts/data.json).

In total I have surveyed <span id="numLampPosts">x</span> of <span id="dataLen">a</span> lamp posts.
Of those, <span id="numGood">y (yy%)</span> are in good condition, <span id="numPoor">z (zz%)</span> are in poor condition, and <span id="numRazed">j (jj%)</span> have been razed.
<span id="notTracked">b</span> were not in the council data set.


<style>#map { height: 400px; }
.mapPopupImg { max-height: 250px; max-height: 250px; }
</style>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
    integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
    crossorigin=""/>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
    integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
    crossorigin=""></script>
<script src="/blog/biggleston-lamp-posts/script.js"></script>
