---
title: Artefact evaluation
subtitle: Repoducabilty and longevity of experimental measurement
date: 2024-04-12
toc: false
published: true
---

I believe in artefact evaluation quite wholeheartedly: papers often cannot contain all the details to replicate a piece of science because of space constraints, especially in conference publications; and measurements shouldn't just be taken on faith, it is important to reproduce them independently.
Submission of artefacts along with papers goes a long way to fixing both concerns.

Sadly, I'm yet to have a positive experience on either side of the review committee.

## As a submitter...
On the submission side it's extremely cumbersome to do double-blind submission, and complex research-ware issues are hard to work around. There is a wide skill range of reviewers and wide range of hardware access.
I think the programming languages community is beginning to find its feet here, maybe artefact evaluation is working better in other communities.

At ECOOP last year they tried artefact-with-paper submission, where the paper reviewers would get access to the artefact reviews when writing their paper review.
This is a cool idea but was very poorly communicated to authors, so artefacts were rushed.
It also necessitated double-blind (rather than single-blind) artefact submission. This was a huge pain for the paper we'd submitted, we had prototype hardware we couldn't make available for testing on (without breaking double-blindness). 

## As a reviewer...
It seems to be consensus that artefacts should, where possible, be made available "forever" so that they can be reproduced/reused by scientists in the future.
Zenodo is a common choice of host for such things.
At ASPLOS I have had an artefact which depends on a large proprietary EDA tool (at a specific version), which cannot be included with the Zenodo upload.
Sadly, I think this means the artefact on Zenodo is doomed to bit rot. As reviewers, we can recommend the artefact is awarded either a "functional" or "reusable".
These choices for badge names do distinguish between artefacts which work today and can be expected to work tomorrow, verses those which cannot.
We need words which reflect that the evaluation of an artefact is a snapshot in time.
If the AEC can be sure the functionality of the artefact won't change over time, then it can be considered "functional/reusable forever(ish)".

## Other concerns across Computer Science
I understand there are similar concerns in HPC and machine learning, where training sets are vast and hard/impossible to host "forever", and the hardware requirements to attempt to reproduce results are prohibitive.
This is assuming the artefact can be shared at all and isn't completely private/proprietary.
This poses a new challenge; how do we make sure the authors are reporting correct/real results without any means for external validation? Perhaps we can't, and trust is the only choice.

All of this also puts to one side the lack of replication studies done in our field.
Despite many conferences having "replication of previous results welcome" in their Call for Papers very few seem to happen, and there is reticence among researchers to spend time doing them for fear of time being "wasted".
ECOOP's Call for Papers [this year](https://2024.ecoop.org/track/ecoop-2024-papers#Call-for-Papers) specifically has a category for Replication:

> **Replication.** An empirical evaluation that reconstructs a published experiment in a different context in order to validate the results of that earlier work.

As it did [last year](https://2023.ecoop.org/track/ecoop-2023-papers#Call-for-Papers), although it seemed no papers were accepted in this category [^replication].

## What are we to do?
I don't know.
There are lots of challenges for replicating science, some due to the complexity of experiments, some because of licensing and protection of IP, and some simply down to access to unusual hardware.
The current approach to artefact evaluation gives coarse descriptions of artefacts as they could be evaluated to the satisfaction of a small committee with somewhat woolly requirements.
The "grades" available through the ACM badging do not tell the whole story, so some work there would be helpful if nothing else.


[^replication]: there was a "replication" track at ECOOP 2023, but it was a different sort of replication.
