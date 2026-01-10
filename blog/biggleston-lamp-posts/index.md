---
title: Biggleston lamp posts
subtitle: Documenting the condition of Canterbury's historic lamposts
date: 2026
published: true
toc: false
---

![Biggleston Lamp Post in good condition](/blog/biggleston-lamp-posts/images/pinocchios-castle-street.jpg)

There is [a campaign](https://www.canterbury-archaeology.org.uk/biggleston-lamp-posts) to save some of Canterbury's historic lamp posts.
Dating back to the 19th century, the lamp posts were made locally by the Biggleston Foundry, which used to operate from Canterbury.
Over the last 10-15 years or so they have been poorly maintained, and weathering paint has allowed them to rust.
Many have been removed, and of those many have been removed quite poorly: the top has been chopped off, and a new modern lamp post has been installed directly next to the stump.

&nbsp;
![Badly removed lamp post on Castle Street](/blog/biggleston-lamp-posts/images/24-york-road-base.jpeg)

I have been surveying the remaining lamp posts I can find in Canterbury and have documented their locations and condition on the map below.

<div id="map"></div>

Full data is available in JSON format [here](/blog/biggleston-lamp-posts/data.json).

In total <span id="numLampPosts">x</span> lamp posts were surveyed, with <span id="numGood">y (yy%)</span> in good condition, <span id="numPoor">z (zz%)</span> in poor condition, and <span id="numRazed">j (jj%)</span> razed.


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
