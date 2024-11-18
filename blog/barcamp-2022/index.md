---
title: A Maker's Guide to EBikes
subtitle: How to build an EBike, and what you might want to know.
date: 2022-11-02
published: false
bibliography: bib.bib
---

This year's BarCamp Canterbury was held at the MakerSpace in the new Engineering building at Canterbury Christ Church university.
I gave a short talk on building EBikes, the slides are available [here](./slides.pdf) (53M PDF).

<!-- # Manifesto: Bikes as a hacking platform -->

# Technical Aspects of EBikes
To make this a somewhat useful (I hope) resource, I will enumerate some of the things I've learned about EBikes, and how to build them.

## EBikes and the law
I live in the UK, so I need to build bikes which fit within the UK law.
I am not a laywer.

The UK law is largely derived from European law, which is useful as European EBikes are largely legal in the UK.
They are technically defined as "Electrically Assisted Pedal Cycles" (EAPCs).
Specifically the laws are derived from British Standard and European Norm BS EN 15194:2017 [@BSEN15194:2017].
EBikes you find in high-street bike shops should all conform to that standard, and the testing methodology specified -- but there's some interesting questions to be raised motor specifications in particular, but more on that in a second.

Mainly, the concern for legality in the UK is how power can be applied by the rider and the maximum power available.
The exact details are available on the GOV.UK website[^1], but I'll outline them here:

> ### What counts as an EAPC
> 
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
The maximum power output of a motor is a slightly odd thing, most motors have a very wide power envelope, and performance will depend on airflow, voltage, and current.
Many 250W labelled motors will work fine at 500W, if cooled adequately.
Many EBike 1000W hub-motors will run at 2.5kW with minor cooling modification[^2].
Similarly, having a 1000W motor run at 250W by a brushless motor controller is totally practical, so building a bike which can work on-road legally and off-road with higher power leads a bike builder to need to label their motor as, say, 1000W even if it's not operated at that wattage.

They don't make sense for other reasons too: a generic motor manufacturer name, and the voltage of the battery have almost no baring on describing the performance of an EBike.
A 72v system connected to a 9Continent motor does not tell you a whether the motor is conformant, what wattage the bike is designed for, whether it is speed limitted etc.

[^1]: Electric Bike Rules on [GOV.UK](https://www.gov.uk/electric-bike-rules)
[^2]: Discussion on understanding EBike motor power and how to measure it on the [Grin technologies website](https://ebikes.ca/learn/power-ratings.html)


## Types of EBike Drive
There's a few drive train architectures for EBikes, you will need to pick one, and I have a favourite, but honestly all of these are mostly okay.

### Brushless vs Brushed
There are two types of motor available: brushed, and brushless.
Brushed motors are cheap, simple, but have a lower power density than their brushless counterparts.
Conversely, brushless motors are typically more powerful, a more complex to drive, and a bit more expensive.
The cost part is counter-acted by the availability of EBike parts designed to work with brushless architectures.
Loads of EBike motors are available on Amazon which can just drop straight into a regular bike, you won't need to build/buy custom mounting brackets for industrial motors.

### Hub vs Bottom Bracket
Another choice is where the motor goes on your bike.
For brushed motors there's little choice: it'd better be a bottom bracket motor, i.e. a motor which mounts at the pedals of the bike.
Those brushed options are normally connected to the back wheel by a chain on the left-hand side (the other side to the pedals' chain).
For brushless motors the motor mounts in a way that the power can be transferred through the pedals as a Pedal Assist system, so you'd only have one chain.


## Understanding Batteries
### Lead acid vs Lithium
There are two common rechargeable battery chemistries, lead acid and lithium ion[^3].
Lead acid is quite cheap, and substantially more forgiving to charge.
It is arguably the 'safe' option, although I would argue that easy management of 


[^3]: There is also lithium iron phosphate (LiFePo) which is a safer version of lithium battery technology, but it has worse energy density. All the same calculations from this section still apply though, but the voltages per cell will be a bit lower.

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

Well, first off is the voltage. You'd like the _nominal_ voltage of the pack to be 24v. The nominal voltage of a single Lithium-ion cell is 3.7v. We shall first calculate the S rating.

$$
\begin{align}
    S &= \left\lceil \frac{V_\text{system}}{V_\text{cell}} \right\rceil \\
    S &= \left\lceil \frac{24v}{3.7v} \right\rceil = \lceil 6.48 \rceil = 7
\end{align}
$$

So, we must build a 7S pack. Okay. 
Now how many strings of cells do we need in parallel?
We need to do some unit conversion for this.
Let's take our 250W motor, running on a 24v pack -- what current does it draw?
Well, $\frac{250W}{24v} = 10.41A$.
We should add a bit of headroom here, let's build a battery pack which can comfortably accommodate a 15A current draw.
Okay, how many cells in parallel do we need?
Consulting the data sheet for the Samsung 29E cells we're using, we can see that they have a continuous discharge rating of 2.75A (1C discharge), but that can hurt the cycle life of the battery, i.e. how quickly the energy storage will deteriorate with charge/discharge cycles.
Let's take that as a maximum though, and find out what P rating we'd need.

$$
\begin{align}
    P &= \left\lceil \frac{I_\text{max}}{I_\text{cell}} \right\rceil\\
    P &= \left\lceil \frac{15\text{A}}{2.75\text{A}} \right\rceil = \lceil 5.45\text{A} \rceil = 6\text{A}
\end{align}
$$

So we should build at a minimum a 7S6P pack, which will contain 42 cells.
We can also now pick a charger: a CC/CV charger which is less than the 0.2C charge rate of the battery will suffice.
Our total Ah capacity of the battery is $P * I_{cell} = 6 * 2.9 = 17.4Ah$, so a 0.2C charge rate would mean the maximum charger size we should use is about 3.5A.

Most commercial batteries are sold by their Ah rating, not their Wh rating, but Wh is the unit of energy, so in my opinion it's more useful.

$$
\begin{align}
    E &= S \times P \times V_\text{cell} \times \text{Ah}_\text{cell} \\
    E &= 7 \times 6 \times 3.7v \times 2.9 \text{Ah} = 450 \text{Wh}
\end{align}
$$

This is a fairly large battery, for context my commute of about 6.5 miles uses about 80 to 100Wh of energy.
A 450Wh pack would last me several days of commuting.
If you plan on using the bike for serious distances, then you can consider adding extra strings in parallel -- this won't change the voltage, only increase the maximum continuous current you can draw, and increase the battery pack's overall energy storage.

### Picking a battery management system

The battery management system is essential for allowing you to safely charge and discharge a lithium battery.
Mistreating lithium batteries, especially when charging can cause fires.
It ensures that each string of parallel cells is charged and discharged evenly with respect to the others (this is called balancing), the BMS also provides under-voltage, over-voltage, and over-current protection.
They are designed for specific S-rated battery packs.
A 7S BMS will balance and maintain a 7S battery.

There's a few dimensions you need to look at to pick a BMS:
 - Your battery's S-rating
 - The maximum current you'd like to draw (plus some margin)
 - Common port vs. discrete ports

The only one that's interesting here is the common vs discrete port: common port BMSes allow you to charge the battery through the same connections that the battery is discharged via.
For EBike applications common port is what I'd recommend, as it means you can do regenerative breaking easily, if your controller supports it.
The downside of common port is that if the battery is in-circuit the bike will be powered up by the charger.


# Building your own custom lithium pack

Okay, so you know what size and configuration battery to build now, how do you actually build it?

## Bill of Materials
Let's make a shopping list for the 7S6P pack that we designed in the previous section.

 - 42 (7*6) Samsung 29E 18650 cells
 - 28 1x3 18650 radiator clips
 - 3 meters of 100% 2mm x 7mm nickel strip.
 - 1 7S BMS, common port, 20A.
 - 1 CC/CV charger, 29.4v, 2.5A 
 - 10 AWG silicone wire
 - XT-60 connectors (one female, two male)
 - Optional barrel connector
 - Kapton tape
 - Large diameter heatshrink
 - Some battery case

Tools:

 - Tin snips (or very heavy-duty scissors)
 - Spot welder
 - Soldering iron
 - Some wide masking tape
 - Multimeter
 - Benchtop power supply

**A note on nickel strip.**
With the nickel strip, there's a lot of fake listings which claim you're buying 100% nickel strip, but actually it's nickel plated steel.
Nickel plated steel has a high resistivity and isn't suitable for high current connections in a battery pack.
To be sure you got nickel, you can test by sanding the surface of the metal, dabbing it with some salt water and leaving it for a few days to see if rust develops.
No rust? It's 100% nickel!

## Step 0: Play with your spot welder
It's worth getting to know your spot welder, cut a handful of short strips of nickel and weld them together.
You should be able to get a feel for the settings for your welder which creates a solid weld without blowing straight through the nickel.
On my k-weld I found 50J about the right energy level for 2 mm nickel strip, but YMMV.

## Step 1: Check your cells are balanced

It is important that all the cells in the pack are at the same state of charge before being assembled, otherwise they'll charge each other at their maximum discharge rate which can be a bit spicy.
Check all the cells with a multimeter, they should ideally be within 10mV of each other. 50mV is probably fine.
If it's more than that, you'll need to charge/discharge them on a CC/CV benchtop power supply.

## Step 2: Arrange the cells in the radiators

Clip together the radiators to make a 7x6 grid, and fill them with cells.
Check the polarity of your cells and arrange them such that the first string of 7 cells has the positives on top, and the next string has negatives, and so on.
Once you're done, clip together the radiators for the top and push that onto the battery pack.

## Step 3: Begin welding parallel packs
I like to mask the cells, so I can drop bits of nickel onto strips and cause potentially dangerous shorts.
Keep just the first parallel strip visible.
Measure out a length of nickel strip a little longer than the pack.
Tin the end of the strip -- this is where the BMS connection will be soldered.
Begin welding! I like to make 2 welds per cell in a cross.

## Step 4: Weld series connections
Cut a bunch of short lengths of nickel, and begin welding each series connection using the same technique.
You might need to dial up the power on your welder a little to get good weld penetration through the extra layer of nickel.

## Step 5: Add the BMS and XT-60 connector
First the BMS balance wires.
Connect the BMS leads to the tinned tabs on the parallel connections from Step 3.
On the 7S BMS there will be 8 balance leads to connect: the first goes to the negative connection for the battery, each of the next 7 go to the positive connection for each string of parallel pack.
Take care not to heat up the nickel strip too much with the soldering iron, that could damage the cells.

Next the charge/discharge cables.
To do this, I grabbed a 10 cm length of nickel, and soldered the 10AWG cable to that, and the cables to the connector.
The BMS common goes to the negative pole of the battery.
The BMS output goes to the negative pin of the XT-60 connector.
XT connectors are marked with + and - on their sides.

Then I welded the nickel strips to the battery.
This prevents damaging the cells by lingering on them with a soldering iron to solder the heavy guage cable.
Typically, batteries get the female connectors, and the load/charger gets the male connector.

Tape down the BMS and the balance leads with kapton tape.
You might need to offer it up to your case to be make sure it's put in a place with enough space.

## Step 6: Heatshrink
Cover your pack in heatshrink to keep it safer from particle ingress.

## Step 7: Pop it in the box
Once it's in the box, you can charge it for the first time, and begin using it!

# References
