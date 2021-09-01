---
title: "Incident Report: nyarlathotep zpool degraded"
taxon: techdocs-incidents
date: 2021-09-01
---

Overview
--------

Automated monitoring alerted me that the `local` zpool in nyarlathotep
was in the `DEGRADED` state, with a significant number of write
errors.  The `data` zpool also had a single error (a read error), but
was still in the `ONLINE` state, with the specific device
`(repairing)`.

As there were no SMART errors, and no further errors occurred (during
X hours of monitoring) after cleaning dust out of nyarlathotep and
checking the SATA cable connections, I judged that this was a physical
connectivity issue, and not an indication of impending drive failure.

But, in case it is an indication of drive failure, there are some
actions to lessen the potential impact.

I haven't discovered any data loss.  It's likely that no important
data was lost, as the only things which frequently write to the
`local` zpool are Prometheus (for metrics) and rTorrent (for session
files), both of which are inconvenient but not catastrophic to lose.


Timeline
--------

### 2021-09-01 12:00:00 BST - Alert fires

I receive an alert that the zpool health check has failed:

```
  pool: data
 state: ONLINE
status: One or more devices has experienced an unrecoverable error.  An
    attempt was made to correct the error.  Applications are unaffected.
action: Determine if the device needs to be replaced, and clear the errors
    using 'zpool clear' or replace the device with 'zpool replace'.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-9P
  scan: scrub in progress since Wed Sep  1 00:00:01 2021
    12.2T scanned at 295M/s, 11.5T issued at 278M/s, 16.3T total
    4K repaired, 70.43% done, 05:02:21 to go
config:

    NAME                                         STATE     READ WRITE CKSUM
    data                                         ONLINE       0     0     0
      mirror-0                                   ONLINE       0     0     0
        ata-ST10000VN0004-1ZD101_ZA206882-part2  ONLINE       0     0     0
        ata-ST10000VN0004-1ZD101_ZA27G6C6-part2  ONLINE       0     0     0
      mirror-1                                   ONLINE       0     0     0
        ata-ST10000VN0004-1ZD101_ZA22461Y        ONLINE       1     0     0  (repairing)
        ata-ST10000VN0004-1ZD101_ZA27BW6R        ONLINE       0     0     0
      mirror-2                                   ONLINE       0     0     0
        ata-ST10000VN0008-2PJ103_ZLW0398A        ONLINE       0     0     0
        ata-ST10000VN0008-2PJ103_ZLW032KE        ONLINE       0     0     0

errors: No known data errors

  pool: local
 state: DEGRADED
status: One or more devices has experienced an unrecoverable error.  An
    attempt was made to correct the error.  Applications are unaffected.
action: Determine if the device needs to be replaced, and clear the errors
    using 'zpool clear' or replace the device with 'zpool replace'.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-9P
  scan: scrub repaired 0B in 00:03:02 with 0 errors on Wed Sep  1 00:03:05 2021
config:

    NAME                            STATE     READ WRITE CKSUM
    local                           DEGRADED     0     0     0
      wwn-0x5002538e3053a94f-part1  DEGRADED     0   490     0  too many errors

errors: No known data errors
```

(The running scrub is the automatic monthly scrub run at midnight on
the 1st.)

The devices are of different makes and ages and are connected to different
controllers on the motherboard:

- `ata-ST10000VN0004-1ZD101_ZA27BW6R` is a 10TB Seagate IronWolf (an
  HDD), is about 4 years old, and is connected to the motherboard SATA
  controller.

- `wwn-0x5002538e3053a94f` is a 250GB Samsung 860 EVO (an SSD), is
  about 1 year old, and is connected to a PCI-e SATA controller.

Additionally, they're in a different zpools holding different sorts of
data.  So a correlated failure looks unlikely.

### 2021-09-01 12:09 BST - SMART data

The SMART report for each device is fine, suggesting that the drives
themselves are healthy.

For the HDD:

```
$ sudo smartctl -a /dev/disk/by-id/ata-ST10000VN0004-1ZD101_ZA22461Y
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.60] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate IronWolf
Device Model:     ST10000VN0004-1ZD101
Serial Number:    ZA22461Y
LU WWN Device Id: 5 000c50 0a3e77dd9
Firmware Version: SC60
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-3 T13/2161-D revision 5
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Sep  1 12:11:08 2021 BST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                (  575) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 874) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x50bd) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   083   064   044    Pre-fail  Always       -       188088864
  3 Spin_Up_Time            0x0003   089   086   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       172
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   095   060   045    Pre-fail  Always       -       3289159452
  9 Power_On_Hours          0x0032   062   062   000    Old_age   Always       -       33789 (68 199 0)
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       181
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   100   098   000    Old_age   Always       -       20
189 High_Fly_Writes         0x003a   075   075   000    Old_age   Always       -       25
190 Airflow_Temperature_Cel 0x0022   059   044   040    Old_age   Always       -       41 (Min/Max 31/51)
191 G-Sense_Error_Rate      0x0032   098   098   000    Old_age   Always       -       5573
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       115
193 Load_Cycle_Count        0x0032   091   091   000    Old_age   Always       -       19545
194 Temperature_Celsius     0x0022   041   056   000    Old_age   Always       -       41 (0 18 0 0 0)
195 Hardware_ECC_Recovered  0x001a   009   001   000    Old_age   Always       -       188088864
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Pressure_Limit          0x0023   100   100   001    Pre-fail  Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       29531 (13 52 0)
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       78126395859
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       375155158238

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Conveyance offline  Completed without error       00%     11903         -
# 2  Short offline       Completed without error       00%     11903         -
# 3  Short offline       Completed without error       00%     11903         -
# 4  Extended offline    Aborted by host               80%     11903         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
```

And for the SSD:

```
$ sudo smartctl -a /dev/disk/by-id/wwn-0x5002538e3053a94f
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.60] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Samsung based SSDs
Device Model:     Samsung SSD 860 EVO 250GB
Serial Number:    S3YJNS0N501806D
LU WWN Device Id: 5 002538 e3053a94f
Firmware Version: RVT04B6Q
User Capacity:    250,059,350,016 bytes [250 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
TRIM Command:     Available, deterministic, zeroed
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-4 T13/BSR INCITS 529 revision 5
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 1.5 Gb/s)
Local Time is:    Wed Sep  1 12:16:36 2021 BST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                (    0) seconds.
Offline data collection
capabilities:                    (0x53) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        No Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  85) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   098   098   000    Old_age   Always       -       8080
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       27
177 Wear_Leveling_Count     0x0013   094   094   000    Pre-fail  Always       -       102
179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail  Always       -       0
181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age   Always       -       0
182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age   Always       -       0
183 Runtime_Bad_Block       0x0013   100   100   010    Pre-fail  Always       -       0
187 Uncorrectable_Error_Cnt 0x0032   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0032   071   054   000    Old_age   Always       -       29
195 ECC_Error_Rate          0x001a   200   200   000    Old_age   Always       -       0
199 CRC_Error_Count         0x003e   100   100   000    Old_age   Always       -       0
235 POR_Recovery_Count      0x0012   099   099   000    Old_age   Always       -       8
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       42218038812

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
```

### 2021-09-01 12:36 BST - Temporally locating the failure

Prometheus shows that the `local` pool entered `DEGRADED` state at
06:09 UTC (05:09 BST):

![Prometheus graph showing a state change to `DEGRADED` at 06:09 UTC](incident-20210901-nyarlathoteop-zpool-degraded/prometheus-state-change.png)

Prometheus doesn't appear to record error counts, so I can't tell when
the read error for the `data` pool appeared, or whether the errors for
the `local` pool appeared in one spike or gradually.

### 2021-09-01 13:15 BST - Monitoring

The error counts in `zpool status` haven't changed since the initial
alert, so the plan now is to wait approximately 5 hours for the ZFS
scrub to finish, periodically checking the status.

While waiting I manually checked the following services, which all
store data in the `local` zpool:

- bookdb
- bookmarks
- prometheus
- flood
- rtorrent
- grafana
- influxdb
- syncthing

All worked fine, adding support to this not being an actual disk
failure.

### 2021-09-01 15:00 BST - More errors for the SSD

The write error count in `zpool status` for the SSD has gone up to
611, an increase of 121 since the initial alert.

In `dmesg`, there is a repeating sequence of errors for `ata9` and
`sdd` next to a ZFS error for the SSD:

```
$ dmesg
...
[720033.773938] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[720033.773947] ata9.00: failed command: WRITE DMA EXT
[720033.773952] ata9.00: cmd 35/00:c0:00:0b:0a/00:00:18:00:00/e0 tag 3 dma 98304 out
                         res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[720033.773958] ata9.00: status: { DRDY }
[720033.773962] ata9: hard resetting link
[720034.243928] ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[720034.244143] ata9.00: supports DRM functions and may not be fully accessible
[720034.247265] ata9.00: supports DRM functions and may not be fully accessible
[720034.250024] ata9.00: configured for UDMA/33
[720034.250038] sd 8:0:0:0: [sdd] tag#3 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=30s
[720034.250041] sd 8:0:0:0: [sdd] tag#3 Sense Key : Illegal Request [current]
[720034.250043] sd 8:0:0:0: [sdd] tag#3 Add. Sense: Unaligned write command
[720034.250045] sd 8:0:0:0: [sdd] tag#3 CDB: Write(10) 2a 00 18 0a 0b 00 00 00 c0 00
[720034.250047] blk_update_request: I/O error, dev sdd, sector 403311360 op 0x1:(WRITE) flags 0x700 phys_seg 13 prio class 0
[720034.250057] zio pool=local vdev=/dev/disk/by-id/wwn-0x5002538e3053a94f-part1 error=5 type=2 offset=205958545408 size=98304 flags=40080c80
[720034.250067] ata9: EH complete
[720034.257336] ata9.00: Enabling discard_zeroes_data
...
```

This same pattern (with different timestamps) is happening a lot.  The
[libata error messages][] page says about "timeout":

> Controller failed to respond to an active ATA command. This could be
> any number of causes. Most often this is due to an unrelated
> interrupt subsystem bug (try booting with 'pci=nomsi' or 'acpi=off'
> or 'noapic'), which failed to deliver an interrupt when we were
> expecting one from the hardware.

[libata error messages]: https://ata.wiki.kernel.org/index.php/Libata_error_messages

`ata9` is `/dev/sdd`:

```
$ ls -l /sys/block/sd* | sed -e 's^.*-> \.\.^/sys^' -e 's^/host^ ^' -e 's^/target.*/^ ^' | while read Path HostNum ID do echo ${ID}: $(cat $Path/host$HostNum/scsi_host/host$HostNum/unique_id) done
sda: 1
sdb: 2
sdc: 5
sdd: 9
sde: 10
sdf: 13
sdg: 17
```

And `/dev/sdd` is the SSD:

```
$ file /dev/disk/by-id/wwn-0x5002538e3053a94f
/dev/disk/by-id/wwn-0x5002538e3053a94f: symbolic link to ../../sdd
```

So these are errors for the SSD, which means something is wrong with
the hardware itself or with the kernel.

### 2021-09-01 15:10 BST - Check hardware

I shut down nyarlathotep and check that the power and data cables for
the SSD are firmly in place, and clean out excess dust.  A thorough
cleaning isn't possible as I don't have any compressed air.

### 2021-09-01 15:57 BST - Monitoring

I start a long SMART test:

```
$ sudo smartctl -t long /dev/disk/by-id/wwn-0x5002538e3053a94f
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.60] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF OFFLINE IMMEDIATE AND SELF-TEST SECTION ===
Sending command: "Execute SMART Extended self-test routine immediately in off-line mode".
Drive command "Execute SMART Extended self-test routine immediately in off-line mode" successful.
Testing has begun.
Please wait 85 minutes for test to complete.
Test will complete after Wed Sep  1 17:24:13 2021 BST
Use smartctl -X to abort test.
```

And return to periodically checking `zpool status` and `dmesg` for SSD
errors.

### 2021-09-01 16:00 BST - Uptime

The reboot reset the ZFS error counts to zero.  So by looking at the
uptime *before* the reboot we can determine the duration in which the
previous errors appeared:

![Prometheus graph showing uptime](incident-20210901-nyarlathoteop-zpool-degraded/uptime.png)

Previous uptime was 720870 seconds, or about 8.3 days.  That window is
too wide to do anything useful with.

### 2021-09-01 17:25 BST - SMART long test finishes

The test completes without error:

```
$ sudo smartctl -l selftest /dev/disk/by-id/wwn-0x5002538e3053a94f
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.60] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF READ SMART DATA SECTION ===
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      8085         -
```

There have been no errors since checking the hardware.

### 2021-09-01 20:10 BST - ZFS scrub finishes

The ZFS scrub finishes, with no additional errors:

```
$ zpool status
  pool: data
 state: ONLINE
  scan: scrub repaired 4K in 20:10:00 with 0 errors on Wed Sep  1 20:10:01 2021
config:

        NAME                                         STATE     READ WRITE CKSUM
        data                                         ONLINE       0     0     0
          mirror-0                                   ONLINE       0     0     0
            ata-ST10000VN0004-1ZD101_ZA206882-part2  ONLINE       0     0     0
            ata-ST10000VN0004-1ZD101_ZA27G6C6-part2  ONLINE       0     0     0
          mirror-1                                   ONLINE       0     0     0
            ata-ST10000VN0004-1ZD101_ZA22461Y        ONLINE       0     0     0
            ata-ST10000VN0004-1ZD101_ZA27BW6R        ONLINE       0     0     0
          mirror-2                                   ONLINE       0     0     0
            ata-ST10000VN0008-2PJ103_ZLW0398A        ONLINE       0     0     0
            ata-ST10000VN0008-2PJ103_ZLW032KE        ONLINE       0     0     0

errors: No known data errors

  pool: local
 state: DEGRADED
status: One or more devices has experienced an unrecoverable error.  An
        attempt was made to correct the error.  Applications are unaffected.
action: Determine if the device needs to be replaced, and clear the errors
        using 'zpool clear' or replace the device with 'zpool replace'.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-9P
  scan: scrub repaired 0B in 00:04:33 with 0 errors on Wed Sep  1 16:55:14 2021
config:

        NAME                            STATE     READ WRITE CKSUM
        local                           DEGRADED     0     0     0
          wwn-0x5002538e3053a94f-part1  DEGRADED     0     0     0  too many errors

errors: No known data errors
```

### 2021-09-01 20:10 BST - End

Since there have been no errors in `dmesg` or `zpool status` since
checking the hardware, I think the issue has been resolved, at least
for now.

The ZFS error state is cleared:

```
$ sudo zpool clear local
```


Analysis
--------

Given the symptoms:

- Frequent ATA timeouts, which the [libata error messages][] page says
  could be "any number of causes"
- No SMART failures, even after a long test
- No noticeable data corruption

Which disappeared after clearing out dust and checking cable
connections, I think this is more likely a temporary hardware failure
than an actual issue with the disk.  The cable management inside the
case isn't great.

The fact that *two* disks showed errors added some confusion, but
given how unrelated the disks are:

- Different models
- Different ages
- Different SATA controllers
- Different usage patterns

And that they had very different error counts (1 on the HDD vs 490 on
the SSD), I think that the HDD error was likely a coincidence, which
`zpool scrub` repaired as it should.

I was only alerted seven hours after the `local` zpool entered
`DEGRADED` state, but that's by design.  Since the pool only has a
single disk, I might not be alerted to a failure-in-progress in time
to salvage things, but the pool only has a little persistent state,
and most of that is backed up weekly.

Diagnosing the problem was difficult because I so rarely need to think
about disk failure modes, so I had to look those things up again.  And
also "any number of causes" is annoyingly vague: it would be nice if
the libata error went into more (human-readable) detail.

On the whole, while this ended up not being a "real" problem, it was
good to run through a potential disk failure scenario.


Actions
-------

- **Get error counts into Prometheus:** This could have shed more
  light in the investigation: for instance, if both pools had an error
  spike at the same time, that would strongly suggest it's *not* the
  drives themselves which are having issues.

- **Review backup scripts for completeness:** I think everything from
  the `local` volume which needs to be backed up is, but I should
  confirm that.  Most of `data` is intentionally not backed up.

- **Clean nyarlathotep and network cabinet:** nyarlathotep was very
  dusty.  It sits on top of the network cabinet, so that's also likely
  very dusty.
