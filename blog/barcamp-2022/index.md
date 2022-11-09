---
title: A Maker's Guide to EBikes
subtitle: My talk at BarCamp Canterbury
date: 2022-11-02
published: false
bibliography: barcamp-2022/bib.bib
---

This year's BarCamp Canterbury was held at the MakerSpace in the new Engineering building at Canterbury Christ Church university.
I gave a short talk on building eBikes, the slides are available [here](./slides.pdf) (53M PDF).

# Manifesto: Bikes as a hacking platform

# Technical Aspects of EBikes
To make this a somewhat useful (I hope) resource, I will enumerate some of the things I've learned about EBikes, and how to build them.

## EBikes and the law
Most importantly, we want to build bikes which fit within the UK law.
I am not a laywer.

The UK law is largely derrived from european law, which is useful as European ebikes are largely legal in the UK.
They are technically defined as "Electrically Assisted Pedal Cycles" (EAPCs).
Specifically the laws are derived from British Standard and European Norm BS EN 15194:2017 [@BSEN15194:2017].
EBikes you find in high-street bike shops should all conform to that standard, and the testing methodology specified -- but there's some interesting questions to be raised motor specifications in particular, but more on that in a second.

Mainly, the concern for legality in the UK is how power can be applied by the rider and the maximum power available.
The exact details are available on the GOV.UK website[^1], but I'll outline them here:

> What counts as an EAPC
> An EAPC must have pedals that can be used to propel it.
> 
> It must show either:
> 
>   - the power output
>   - the manufacturer of the motor
> 
> It must also show either:
> 
>   - the battery’s voltage
>   - the maximum speed of the bike
>   
> Its electric motor:
> 
>   - must have a maximum power output of 250 watts
>   - should not be able to propel the bike when it’s travelling more than 15.5mph
> 
> An EAPC can have more than 2 wheels (for example, a tricycle).

These rules to me don't make a great deal of sense.
The maximum power output of a motor is a slightly odd thing, most motors have a very wide power envelope, and performance will depend on airflow, voltage and current.
Many 250W labelled motors will work fine at 500W, if cooled adequately.
Many EBike 1000W hub-motors will run at 2.5kW with minor cooling modification[^2].
Similarly, having a 1000W motor run at 250W by a brushless motor controller is totally practical, so building a bike which can work on-road legally and off-road with higher power leads a bike builder to need to label their motor as, say, 1000W even if it's not operated at that wattage.

They don't make sense for other reasons too: a generic motor manufacturer name, and the voltage of the battery have almost no baring on describing the performance of an EBike.
A 72v system connected to a 9Continent motor does not tell you a whether the motor is conformant, what wattage the bike is designed for, whether it is speed limitted etc.

[^1]: Electric Bike Rules on [GOV.UK](https://www.gov.uk/electric-bike-rules)
[^2]: Discussion on understanding EBike motor power and how to measure it on the [Grin technologies website](https://ebikes.ca/learn/power-ratings.html)


## Types of EBike Drive


### Brushless vs Brushed

### Hub vs Bottom Bracket


## Understanding Batteries
### Lead acid vs Lithium

### Technical specifications of batteries
**S and P rating.**
Batteries are specified by the number and configuration of the cells.

The S rating is the number of cells arranged in series, this defines pack voltage.

The P rating is the nbumber of strings of cells arranged in parallel, this defines the pack's capacity and the maximum current draw.

**C rating.**
The C rating is a multiplier of the battery (or cell's) Ah rating to give you a charge/discharge current in A.
It's a bit of an odd number, but it can help with napkin maths about how quickly a cycle on a battery will take.

Let's take a 10Ah battery to start with.

 - If I do a 1C discharge, it will have a current draw of 10A, and discharge in 1 hour.
 - If I do a 0.2C discharge, I will draw 2A, and it will discharge in 5 hours.
 - If I do a 2C discharge, I will draw 20A, and it will discharge in half an hour.

C ratings are given for charge and discharge. A typical 18650 battery will be good for about 1C continuous discharge, and 0.2C charge.
Lower C numbers will result in better long-term energy storage with your battery pack.

Each charge/discharge cycle mechanically alters the structure of the inside of your cells, and the more aggressive the charge/discharge the more the internal structure changes.
These changes mean the battery stores less energy -- so using lower C ratings will mean your battery lasts longer.

### Designing a battery pack
You will need to know your system voltage, the type of cell you will use, and motor wattage.
These specifications will essentially define a minimum pack size to safely (electrically) operate your bike.

Say, you are going to use Samsung 29E cells, to operate a 250W EBike with a 24v system voltage. How do you pick the pack size?

Well, first off is the voltage. You'd like the _nominal_ voltage of the pack to be 24v. The nominal voltage of a single Lithium Ion cell is 3.7v. We shall first calculate the S rating.

$$
\begin{align}
    S &= \left\lceil \frac{V_{system}}{V_{cell}} \right\rceil \\
    S &= \left\lceil \frac{24v}{3.7v} \right\rceil = \lceil 6.48 \rceil = 7
\end{align}
$$

So, we must build a 7S pack. Okay. 
Now how many strings of cells do we need in parallel?
We need to do some unit conversion for this.
Let's take our 250W motor, running on a 24v pack -- what current does it draw?
Well, $\frac{250W}{24v} = 10.41A$.
We should add a bit of headroom here, let's build a battery pack which can comfortably accomodate a 15A current draw.
Okay, how many cells in parallel do we need?
Consulting the datasheet for the Samsung 29E cells we're using, we can see that they have a continuous discharge rating of 2.75A (1C discharge), but that can hurt the cycle life of the battery, i.e. how quickly the energy storage will deteriorate with charge/discharge cycles.
Let's take that as a maximum though, and find out what P rating we'd need.

$$
\begin{align}
    P &= \left\lceil \frac{I_{max}}{I_{cell}} \right\rceil\\
    P &= \left\lceil \frac{15A}{2.75A}\right\rceil = \lceil 5.45\rceil = 6
\end{align}
$$

So we should build at a minimum a 7S6P pack, which will contain 42 cells.
We can also now pick a charger: a CC/CV charger which is less than the 0.2C charge rate of the battery will suffice.
Our total Ah capacity of the battery is $P * I_{cell} = 6 * 2.9 = 17.4Ah$, so a 0.2C charge rate would mean the maximum charger size we should use is about 3.5A.

With our S and P rating we can also calculate the pack energy capacity in Wh:

$$
\begin{align}
    E &= S * P * V_{cell} * Ah_{cell} \\
    E &= 7 * 6 * 3.7v * 2.9 Ah = 450 Wh
\end{align}
$$

This is a fairly large battery, for context my commute of about 6.5 miles uses about 80 to 100Wh of energy.
A 450Wh pack would last me several days of commuting.
If you plan on using the bike for serious distances, then you can consider adding extra strings in parallel -- this won't change the voltage, only increase the maximum continuous current you can draw, and increase the battery pack's overall energy storage.

## Building your own custom lithium pack

Okay, so you know what size and configuration battery to build now, how do you actually build it?

# References
