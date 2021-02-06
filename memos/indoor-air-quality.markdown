---
title: Indoor Air Quality
taxon: general
date: 2021-02-06 21:00:00
tags: smart home
---

I strongly suspect my thermostat is lying to me.

Some days I will be shivering, and it says the temperature is 28C.

Some days I will be sweating, and it says the temperature is 18C.

It's as if it's measuring the temperature of somewhere else, but the
thermostat is in my living room.

So to put the issue to rest, I wanted to get a smart ambient
thermometer, to compare measurements.  Ideally something with an API
which I can use to get the data into [Prometheus][] and graph it.

![The Awair Element, on a bookcase.](indoor-air-quality/awair.jpg)

This is the [Awair Element][], an indoor air quality monitoring smart
device, which measures a bunch of things---including temperature.[^v]
I've got one in my living room, and I plan to get one for my bedroom.

[^v]: [Here's a great video](https://www.youtube.com/watch?v=MRqh8oLY7Ik) on why you should care about the quality of your air.

[It has an API][], so I can [scrape the data][]:

```bash
$ curl http://10.0.20.117/air-data/latest | json_pp

{
   "abs_humid" : 9.06,
   "co2" : 799,
   "co2_est" : 693,
   "dew_point" : 10.05,
   "humid" : 49.91,
   "pm10_est" : 4,
   "pm25" : 3,
   "score" : 90,
   "temp" : 20.89,
   "timestamp" : "2021-02-06T20:39:13.338Z",
   "voc" : 422,
   "voc_baseline" : 2562694386,
   "voc_ethanol_raw" : 38,
   "voc_h2_raw" : 27
}
```

And stick it on a dashboard; here's my Saturday night gaming session:

![A dashboard showing various air quality metrics.](indoor-air-quality/grafana.png)

It's February now, so it's cold.  I had all the windows and my living
room door shut from a little before 16:00.  You can see the <abbr
title="Carbon Dioxide">CO2</abbr> and <abbr title="Volatile Organic
Compounds">VOC</abbr> levels creeping up.

We had a 15-minute break in the middle.  I opened the windows and
door.  You can see the levels drop back down.  And then creep up again
after the break.

The percentage in the top-left is an overall score based on the other
metrics.  80%+ means your air is great, I've been aiming to keep it
above 90%.  The thresholds on the other graphs are based on the
thresholds the Awair Element uses: it goes from 1 to 5 dots, which
I've condensed into three sets of regions (ideal, good, bad).

I find myself glancing at the device (and the dashboard) throughout
the day, and opening a window if it looks like I could do with a bit
more ventilation.

Even if it's making the numbers up[^fake] it's making me get more
fresh air, which can only be a good thing.

[^fake]: Though I hope it's not, and the movements on the graphs do
  correlate with when I have windows open.

And yes, my thermostat *is* lying to me.

[Prometheus]: https://prometheus.io/
[Awair Element]: https://uk.getawair.com/
[It has an API]: https://docs.developer.getawair.com/#local-api
[scrape the data]: https://github.com/barrucadu/prometheus-awair-exporter/
