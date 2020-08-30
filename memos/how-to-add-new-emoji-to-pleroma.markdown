---
title: "How to: add new emoji to Pleroma"
taxon: techdocs-runbooks
published: 2020-02-05
modified: 2020-08-30
---

Pleroma is an ActivityPub server running on both dunwich and
lainon.life:

- [ap.barrucadu.co.uk](https://ap.barrucadu.co.uk)
- [social.lainon.life](https://social.lainon.life)

To add a new emoji:

1. Download the emoji onto the docker volume
2. Restart the service

```bash
docker exec -i -w /var/lib/pleroma/static/emoji/custom  pleroma_pleroma_1 wget ...
! systemctl restart pleroma
```
