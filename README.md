CalSnap
=======

Introduction
------------

`calsnap` is a minimal shell script that creates backups with [Tarsnap](https://www.tarsnap.com/). Our design goals:

-   Calendar-based backup schedule
-   Each archive contains all backup targets
-   Just backup, no restore
-   Portable
-   Small code footprint

One daily Tarsnap archive is created per run. By default, 31 daily, 26 weekly, 12 monthly and 4 quarterly backups are
kept, and yearly backups are kept indefinitely.

Download
--------

You can use the development version of CalSnap by cloning this repository, or [download the latest stable
release](https://github.com/bannmann/calsnap/releases/).

Usage
-----

1.  Take `calsnap.conf.sample`, customise it for your environment, and save it to `/etc/calsnap.conf` or
    `/usr/local/etc/calsnap.conf`.
2.  Run `calsnap` daily from cron.

Notes on behavior:

-   `calsnap` creates archives of the form `<hostname>-<period>-yyyy-mm-dd_HH:MM:SS`.
    -   For weekly archives, the `period` value is `weekly-<year>W<week>`, e.g. `weekly-2020W53`.
    -   For quarterly archives, the `period` value is `quarterly-<year>Q<quarter>`, e.g. `quarterly-2020Q4`.
    -   The other `period` values are `daily`, `monthly` and `yearly`.
-   Archives are created using the following logic:
    -   Daily archives are created every time `calsnap` is run.
    -   Weekly/monthly/quarterly/yearly archives are copied from the most recent daily archive if they don't exist.
-   Archives are deleted using the following logic by default:
    -   If any backups failed, delete nothing.
    -   For each backup type, keep only the most recent X backups, and delete any older ones:
        -   31 daily
        -   26 weekly
        -   12 monthly
        -   4 quarterly
        -   Unlimited yearly
-   As of 1.2.0, the following limits are recommended instead to increase storage space efficiency while
    maintaining sufficient coverage:
    -   7 daily
    -   4 weekly
    -   3 monthly
    -   4 quarterly
    -   Unlimited yearly

FAQ
---

* **How do I see the `tarsnap` output?** \
  Basically, you don't. `calsnap` only shows `tarsnap` output if tarsnap failed. To see what `calsnap` is doing, you can
  set `verbose=1` in your `calsnap.conf`. You can get some good `tarsnap` info, including exactly how much new data this
  backup consumed, with a **pre**backupscript. Be sure to set `prebackupscript` in `calsnap.conf` to wherever you put
  this script:

```sh
#!/bin/sh

. /etc/calsnap.conf     # Or wherever your calsnap.conf lives
tarsnap --dry-run --quiet --print-stats --humanize-numbers -C / -c $backuptargets 2>&1
```

History & Comparison
--------------------

CalSnap is based on [ACTS](https://github.com/alexjurkiewicz/acts) (Another Calendar-based Tarsnap Script) by
[Alex Jurkiewicz](https://github.com/alexjurkiewicz). The ACTS code is robust and continues to be maintained.

The difference between CalSnap and ACTS is the way they handle multiple backup targets: While CalSnap produces one daily
archive per run, ACTS produces one daily archive per-run per-target (e.g.
MyMachine-daily-...-**etc** and MyMachine-daily-...-**home**). See
[ACTS PR #44](https://github.com/alexjurkiewicz/acts/pull/44) for the detailed rationale of both approaches.

Help
----

Open a [Github issue](https://github.com/bannmann/calsnap/issues).

Building
--------

-   Prerequisites
    -    make
    -    [fpm](https://fpm.readthedocs.io/en/latest/)
    -    shellcheck (optional)
-   Checking
    -    `make check`
-   Release
    -    update `VERSION=` line in `calsnap`
    -    `make`
