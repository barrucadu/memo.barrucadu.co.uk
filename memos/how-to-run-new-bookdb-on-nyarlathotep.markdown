---
title: "How to: run a new BookDB release on nyarlathotep"
taxon: techdocs-runbooks
published: 2020-02-05
---

There are two ways in which you might want to run a new BookDB release
on nyarlathotep:

1. For testing, using a throwaway database.

2. For real, using the real database.


Deploying a test release
------------------------

1. Stop the systemd service:

    ```bash
    ! systemctl stop bookdb
    ```

2. Build your new bookdb release:

    ```bash
    s b --nix
    ```

3. Start a postgres container:

    ```bash
    din -p 127.0.0.1:5432:5432 -e POSTGRES_USER=bookdb -e POSTGRES_DB=bookdb postgres
    ```

4. Create the database:

    ```bash
    s e --nix -- env BOOKDB_PG_USERNAME=bookdb bookdb makedb
    ```

5. Run the bookdb server:

    ```bash
    s e --nix -- env BOOKDB_WEB_ROOT=http://bookdb.nyarlathotep BOOKDB_PG_USERNAME=bookdb BOOKDB_FILE_ROOT=$(pwd)/static/ bookdb run
    ```


Deploying a real release
------------------------

1. Build a docker image:

    ```bash
    docker build -t localhost:5000/bookdb:latest .
    ```

2. Push the image:

    ```bash
    docker push localhost:5000/bookdb:latest
    ```

3. Restart the systemd service:

    ```bash
    ! systemctl restart bookdb
    ```
