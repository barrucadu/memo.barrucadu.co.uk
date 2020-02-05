---
title: "How to: add new emoji to Pleroma"
taxon: techdocs-runbooks
published: 2020-02-05
---

Pleroma is an ActivityPub server running on both dunwich and
lainon.life:

- [ap.barrucadu.co.uk](https://ap.barrucadu.co.uk)
- [social.lainon.life](https://social.lainon.life)

The process for adding new emoji is the same for both.

1. Stop pleroma:

    ```bash
    ! systemctl stop pleroma
    ```

2. Become the pleroma user:

    ```bash
    ! -upleroma bash
    ```

3. Download or copy the new emoji:

    ```bash
    cd /srv/pleroma/pleroma/priv/static/emoji/custom
    wget ...
    cp ...
    ```

4. Then exit the `sudo` shell and start pleroma:

    ```bash
    ! systemctl start pleroma
    ```
