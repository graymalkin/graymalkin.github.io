---
title: Energy management
subtitle: Getting used to predbat and games with Octopus
date: 2026-11-19
published: true
toc: false
---


The UK power grid is more or less at its absolute limit in terms of generation and transmission capacity.
We also have extremely high variance in the value of energy depending on the weather.
On windy/sunny days there's significant surplus of cheap energy.
On still and overcast days we have to burn gas to make up much of our energy needs, and thanks to our marginal pricing that means every MW of generation is bought at a premium.

The grid operator and energy companies basically trade energy futures, and its in their interests (and the interests of their customers) to try and shape demand so that more of the energy that's used is from the cheap times when there is a surplus and not in the expensive times when we're at transmission or generation limits.
To that end there's a bunch of quite complicated games that one can play.


# Octopus saving sessions, happy hours, and a 60A fuse
Octopus do saving sessions where they credit you for using less energy, and that's calculated as net energy use so exports are basically paid at a higher rate (the export rate plus the load shifting credits).
Credit varies, but it's between 72 and 144 "octopoints" per kWh, which works out at 9p to 18p per kWh on top of the export rate.
Unsurprisingly this coincides with high export payments as well, so we can get up to 50p/kWh exported.
That's great!
They call these hours of load shifting saving sessions.
We get notified by email, click 'yes' in the email (active assent is required by the grid operator), and PredBat picks up the higher export rate via the Octopus HACS addon.
All works great.

Another reward from these saving sessions is credit towards a "happy hour".
Each saving session where you successfully load shift gets you a token, two (ish) tokens gets you 1 hr of free energy on a Sunday at a timeslot of your choosing.
This is where I've had to be thoughtful about the main fuse.
With the battery charging at 8 kW, and doing all laundry/dishwashing at the same time, our total load peaks at around 12.5 kW.
On a 240v supply that's 52A which is getting fairly close to our 60A maximum.
I definitely shouldn't boil the kettle and/or start baking at the same time!

That will all be better with a 100A fuse, so hopefully by Christmas we can really juice the grid in those happy hours.
Although Octopus have a fair use limit of 15 kWh per happy hour, so we'll stay within that.
15 kWh at our night rate of 14p/kWh is still £2.10, so happy days for us regardless!

# Axle

It's been an unseasonably mild October/November so far this year, we've had the solar setup for a little over month and been able to export for about 3 weeks.
In that time we've had 5 Axle "grid events", which have netted us about £30 in credit plus a £25 sign-up bonus ([referral link][axle] if anyone is interested).
We are still on the 60 A fuse at the time of writing, UKPN are here today and tomorrow to do the upgrade.
Being on just 60 A hasn't been a problem, although I have been cognisant of it...


# Arbitrage

Our energy tariff is fixed import and variable export.
Thanks to there being periods of very high export value (via saving sessions or Axle export events), and very low import costs (via happy hours) we can play games where we buy energy with the sole purpose of selling it again.
This is in some sense a service: we flatten grid peaks, but it's not that obvious that it's actually good for the grid.
In any case, just by the nature of PredBat's goal being the lowest cost energy, the default PredBat settings quite aggressively do arbitrage: buying energy only to sell it later, at a profit.

This can even happen overnight without any special conditions lining up.
Often for the whole night the export rate for our variable export tariff is higher than our fixed overnight import rate, so PredBat will dutifully charge/discharge the battery, eking out a few pennies of profit from each cycle several times a night.
This does put extra cycles on the battery, which is not free unless you consider the manufacturer warrantee of the battery to be good for the lifetime they offer it (which for us would require us to believe that SigEnergy will survive for years to come).
I don't necessarily believe that, nor do I think that wasting energy in conversion losses for a few pennies of profit is a very good thing.
Equally, I would like the payback time for the system to be minimised, and I do see that there's some value in arbitrage for grid stability.

To that end, PredBat supports carbon intensity, and you can model a cost per kg of CO2.
We have configured it at £0.75/kgCO2 -- which is enough to stop the battery doing arbitrage for £0.02 after burning 300 Wh in conversion losses, but low enough that we can still help balance the grid and reduce our payback time.

