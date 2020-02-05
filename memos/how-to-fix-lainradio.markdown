---
title: "How to: fix LainRadio"
taxon: techdocs-runbooks
published: 2020-02-05
---

The radio stream on [lainon.life][] stutters or otherwise stops
working.

The backend might also slow down and be unable to respond in time, in
which case playlists won't be available in the UI.

This usually means that there's a resource problem, often MPD using
100% CPU.

[lainon.life]: https://lainon.life

Resolution
----------

1. SSH into lainon.life:

    ```bash
    ssh lainon.life
    ```

2. Restart all the services:

    ```bash
    ! ./restart-all.sh
    ```


### The manual way

Instead of step 2 above:

1. Restart icecast:

    ```bash
    ! systemctl restart icecast
    ```

2. Restart the fallback streams:

    ```bash
    ! systemctl restart fallback-{mp3,ogg}
    ```

3. Restart the MPD streams:

    ```bash
    ! systemctl restart mpd-{cafe,cyberia,everything,swing}
    ```
