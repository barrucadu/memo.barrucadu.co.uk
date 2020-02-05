---
title: "How to: update Pleroma"
taxon: techdocs-runbooks
published: 2020-02-05
---

Pleroma is an ActivityPub server running on both dunwich and
lainon.life:

- [ap.barrucadu.co.uk](https://ap.barrucadu.co.uk)
- [social.lainon.life](https://social.lainon.life)

The process for updating is the same for both.

1. Stop pleroma:

    ```bash
    ! systemctl stop pleroma
    ```

2. Run the update script:

    ```bash
    ! -upleroma /srv/pleroma/update-pleroma.sh $VERSION
    ```

3. Start pleroma:

    ```bash
    ! systemctl start pleroma
    ```


### The manual way

Instead of step 2 above:

2. Become the pleroma user:

    ```bash
    ! -upleroma bash
    ```

3. Change to the pleroma directory:

    ```bash
    cd /srv/pleroma
    ```

4. **(optional)** Take a database backup:

    ```bash
    pg_dump pleroma_dev | gzip -9 > `date +"%Y-%m-%d"`.sql.gz
    ```

5. Pull the update:

    ```bash
    cd pleroma
    git stash
    git fetch --prune --all
    git checkout $VERSION
    git stash pop
    ```

6. Build the update:

    ```bash
    MIX_ENV=prod mix clean
    MIX_ENV=prod mix deps.get
    MIX_ENV=prod mix compile
    ```

7. Run any database migrations:

    ```bash
    MIX_ENV=prod mix ecto.migrate
    ```

Then exit the `sudo` shell and start pleroma again as above.
