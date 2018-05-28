---
title: Personal Finance
tags: finance, hledger, howto
date: 2018-05-28
audience: Mostly me, & possibly personal finance nerds.
epistemic_status: Documents my way of doing things, doesn't attempt to speak more generally than that.
notice: You may get something out of this if you're rethinking how you manage your finances.
---

I manage my money using [plain-text accounting][] (specifically,
[hledger][]; though the choice of tool is unimportant), following a
[YNABish][ynab] approach.  The four YNAB rules are:

1. *Give every dollar a job*: my money is split into named categories,
   I have no "general savings".
2. *Embrace your true expenses*: large expenses (like a rental
   deposit) are planned and allocated for in advance, as a regular
   monthly contribution.
3. *Roll with the punches*: if things aren't working out, I adjust the
   plan rather than lie to myself.
4. *Age your money*: I save more of each regular expense (rent,
   travel, etc) than I spend in a given period, so I gradually build
   up a buffer.

Rather than importing transactions from my bank or something, I enter
all data manually.  This may sound tedious, but I feel that the
awareness I get from doing so is worth it.

Why track my finances at all?

- Makes me more conscious of my spending.
- Lets me see how my spending has changed over time.
- Lets me plan for the future with some degree of confidence.
- Way less cumbersome than the spreadsheet I used to use.

This memo is concerned with my mechanism for implementing this
approach.  It could serve as a starting point for your financial
planning; but working out what your savings categories are and how to
allocate your income to them requires introspection.

[hledger]: http://hledger.org/
[plain-text accounting]: http://plaintextaccounting.org/
[ynab]: https://www.youneedabudget.com/method/

## Journal files

My journal files are shared with [syncthing][], so I can add
transactions from any machine.  In practice I tend to just do it from
a tmux session I always have open on my VPS (which also has my IRC
client open).

- `current.journal` is the main file.
- `$YEAR.journal` is the journal for the given year.

[syncthing]: https://syncthing.net/

## Accounts

Accounts are broken up into five broad categories:

- `assets`: money I have or am owed
- `equity`: used to start off the ledger for the year
- `expenses`: money I have spent
- `income`: money I have received
- `liabilities`: money I owe

Then `assets` is further subdivided into:

- `cash`: easily liquidated assets
- `investments`: brokerage accounts
- `reimbursements`: money I am owed

Here are all the regular accounts:

- `assets`
    - `cash`
        - `hand`
        - `paypal`
        - `santander`
            - `current`
                - `float`
                - `month`
                    - `food`
                    - `fun`
                    - `other`
                - `saved`
                    - `health`
                    - `household`
                    - `invest`
                    - `monthly`
                    - `rent`
                    - `travel`
                    - `utilities`
                    - `web`
    - `investments`
        - `cavendish`
            - `s&s`
        - `coinbase`
    - `reimbursements`
        - `deposit`
- `equity`
- `expenses`
    - `fees`
    - `tax`
- `income`
    - `interest`
- `liabilities`
    - `loan`
        - `slc`

Inside my current account, `assets:cash:santander:current`, money is
subdivided by use, following [YNAB rule 1][ynab]:

- `float`: cash to be withdrawn (topped up when allocated to a budget category)
- `month`: budget for regular living expenses
- `saved`: budget for everything else

## Transactions

A transaction has a date, a payee, and a list of postings:

```
2018-01-01 Payee
    account1  £amount1
    account2  £amount2
    ...
```

The amounts must sum to zero, which means that the transaction is
balanced.

[hledger][] allows transactions to be marked with a `!` or a `*`.  The
traditional meaning of these is "pending" and "cleared".

I use `!` slightly differently.  I use it for transactions which are
just an artefact of the way I track my finances, which don't involve
any balance changes to a real-world account.  For example, setting up
my monthly budget:

```
2018-01-01 ! Budget
    month:food  £250
    month:fun    £25
    month:other  £25
    saved:monthly
```

I use `*` as normal, although I usually only consider cash
transactions "cleared" when I check that the cash in my wallet matches
what hledger thinks it should be.

### Income

Income is recorded as the pre-tax amount coming from `income:$source`,
and is split across `saved:*`, `expenses:tax:*`, and `liabilities:*`.
All amounts are included.

```
2018-05-30 Company Name
    saved:household       £50
    saved:monthly        £400
    saved:rent          £1300
    saved:web             £50
    expenses:tax:income  £250
    expenses:tax:ni      £200
    liabilities:slc       £75
    income:company     -£2325
```

Income may not necessarily be taxed:

```
2017-10-01 Santander
    saved:monthly  £4.26
    income:interest:santander
```

### Investments

Investments are a transaction from `saved:invest` to the appropriate
investment account.  All amounts are included, using the `@@` form to
exactly specify the overall price.  Trading fees go to
`expenses:fees:$broker`.

```
2017-12-18 Coinbase
    assets:investments:coinbase  0.25 LTC @@ £60.17
    expenses:fees:coinbase  £2.50
    saved:invest          -£62.67
```

A broker may have subaccounts:

```
2018-08-01 Cavendish
    assets:investments:cavendish:s&s  31.19 MCOUA @@ £50
    assets:investments:cavendish:s&s  65.15 MCMEA @@ £100
    assets:investments:cavendish:s&s   7.15 MHMIA @@ £50
    assets:investments:cavendish:s&s   2.56 VADEA @@ £800
    saved:invest  -£1000
```

A broker may charge a management fee by selling some of the assets:

```
2018-01-03 Cavendish
    assets:investments:cavendish:s&s  -0.02 MCMEA @@ £0.03
    expenses:fees:cavendish  £0.03
```

Although it is best to keep some cash in the account, if possible, to
avoid the assets from being whittled away.

### Withdrawing Cash

Cash that can be withdrawn lives in `current:float`.  This is because
it's useful to have cash on hand without necessarily having decided up
front what it's for, but it's also good to bound the amount of
unallocated money I have.

```
2018-05-24 Withdraw
    assets:cash:hand  £20
    current:float
```

Cash can also be withdrawn in a foreign currency, which will have an
exchange rate and may impose an additional fee:

```
2018-05-11 Withdraw
    assets:cash:hand  10000 JPY @@ £70.41
    expenses:fees:currency  £1.99
    current:float
```

### Expenses (bank account)

There are two main types of expenses: expenses from my bank account,
and cash expenses.  The former are straightforward:

```
2018-01-01 Subway
    expenses:food  £5.99
    month:food
```

Foreign currency expenses are recorded like so:

```
2018-01-01 Linode
    expenses:web  $20 @@ £15.31
    expenses:fees:currency  £1.25
    saved:web
```

### Expenses (cash)

Cash expenses require an adjustment to the appropriate budget
category, transferring money back to the float to represent that that
money has been allocated and spent:

```
2018-01-06 Morrisons
    expenses:food  £2.43
    assets:cash:hand
2018-01-06 Cash budget spend
    month:food  -£2.43
    current:float
```

This could be done in one transaction, but I think it's clearer with
two.

Foreign currency cash transactions require picking an appropriate
exchange rate when removing the money from the budget category:

```
2018-05-08 FamilyMart
    expenses:food  548 JPY
    assets:cash:hand
2018-05-08 Cash budget spend
    month:food  -548 JPY @@ £4.60
    current:float
```

The exchange rate is kind of arbitrary, but something reasonably close
to the then-current exchange rate should be used.

### Reimbursements

Reimbursements are much like income, but are generally untaxed.
Income comes from some reimbursement account and is put in some
savings account:

```
2018-01-04 Pusher
    saved:deposit  £186
    assets:reimbursements:pusher
```

As with income, the reimbursement could be split over multiple savings
accounts.

## Predicting the Future

Predicting the future can be the downfall of an otherwise-sound
financial plan.  Always be pessimistic!  Only include income which you
are certain you will get (barring some extreme change in your life
circumstances); but include any expenses you can think of, even if
they are unlikely.  If you can be pessimistic and still have some
wiggle room in your plan, then you are probably in a good place.

### Budgeting

By a "budget" I mean an allocation of current money to expense
categories and new money to savings categories.  I budget on a monthly
basis.

Firstly, my monthly expenses:

```
~ monthly
    month:food        £250
    month:fun          £25
    month:other        £25
    saved:monthly    -£300
    expenses:servers   £40
    saved:web         -£40

~ monthly from 2018-03
    expenses:rent        £1200
    expenses:tax:council  £100
    saved:rent          -£1300
    expenses:utilities    £185
    saved:utilities      -£185
```

This is based on experience, with some speculation.

It's in two chunks because I'll be moving out of my current place and
renting a new flat some time in March.

Now, my monthly income:

```
~ monthly from 2018-06
    saved:invest     £350
    saved:monthly    £350
    saved:travel      £50
    saved:rent      £1500
    saved:utilities  £200
    saved:web         £50
    income:job     -£2500
```

This is based entirely on speculation, so it will almost certainly
change.

Notice how I'm only spending £300 of `saved:monthly` a month, but I'm
adding £350 to it.  I do this with all the savings accounts, gradually
building up a buffer so I will not be living paycheck to paycheck.

### Forecasting

In its simplest form, forecasting is just applying your budget into
the future.  I plan for each calendar year, so I look ahead to the end
of December to see that everything is working out.

However, expected future events can be added to the forecast too:

```
; Dentist
~ 2018-03-08
    expenses:other  £18.80
    saved:health
```

It is essential that none of my savings accounts dip below zero, and
ideally their balance should be increasing every month, due to saving
extra.  When I have enough of a buffer, I will probably remove this
extra allocation (just maintaining the current balance) and put the
extra money to some other use.

In my mind, it doesn't really make sense to talk about budgeting and
forecasting as separate entities.  A budget only makes sense if it
serves your future purposes, so it's not as simple as looking at what
you have vs. looking into the future.  I try to think of it like this
instead: budgeting is the allocation (which may involve planning
ahead) whereas forecasting is looking at how your allocation (plus any
other expected transactions) changes your financial situation over
time.

## Maintenance

In addition to simply recording transactions, there is some
bookkeeping I do occasionally, to keep my records easy to process.

### End of Month

At the end of a month I reconcile the transactions of the
month-just-ended:

1. For every transaction in the online bank statement, find the
   corresponding journal transaction and mark it.
    - If there are transactions missing from the journal, add and mark
      them.
    - If there are transactions missing from the bank statement, the
      bank is being slow; reconcile as they come in over the next few
      days.
    - If the bank balance is below the `current` balance, even
      discarding uncleared transactions, either figure out what
      happened or add a transaction to `expenses:adjustment` (see
      "balance correction").
2. Check the balance in my wallet and mark all `hand` transactions.
    - If the wallet balance is below the `hand` balance, add a
      transaction to `expenses:adjustment` (see "balance correction").

I also set up the budget for the month-just-started:

```
2018-01-01 ! Budget
    month:food  £250
    month:fun    £25
    month:other  £25
    saved:monthly
```

This is just the regular monthly budget, but with a date.

### End of Year

1. Reconcile, as at the end of any other month.
2. Add any necessary balance correction (see "balance correction").
3. Rename the current journal file from "current.journal" to
   "$YEAR.journal".
4. Identify financial goals for the upcoming year.
5. Create a new "current.journal" for the upcoming year with budget
   and forecast transactions.
6. Initialise all accounts on the first of January by transferring from equity.

The budget created in (5) will depend on the goals identified in (4).
Here's an example of a (6) transaction setting up the starting
balances:

```
2018-01-01 ! Start of year
    assets:cash:hand  £242.70
    ;
    current:float    £100
    saved:deposit    £950
    saved:monthly    £324.66
    saved:household  £100
    saved:rent      £1038
    saved:travel     £100
    saved:web        £200
    ;
    assets:investments:cavendish:s&s   2.54  VADEA @@ £800
    assets:investments:cavendish:s&s  65     MCMEA @@ £99.77
    assets:investments:cavendish:s&s  31.19  MCOUA @@  £50
    assets:investments:cavendish:s&s   7.15  MHMIA @@  £50
    assets:investments:coinbase        0.004 BTC   @@  £51.91
    assets:investments:coinbase        0.1   ETH   @@  £62.04
    assets:investments:coinbase        0.25  LTC   @@  £60.17
    assets:investments:coinbase       10     EUR   @@   £9.11
    ;
    assets:reimbursements:deposit     £300
    assets:reimbursements:pusher      £186
    assets:reimbursements:university  £188.38
    ;
    liabilities:loan:overdraft   -£2000
    liabilities:loan:slc        -£28592.25
    ;
    equity
```

This is the template for a new journal file:

```
alias current = assets:cash:santander:current
alias month   = current:month
alias saved   = current:saved

* Forecast
* Starting balances
* Ledger
** January
** February
** March
** April
** May
** June
** July
** August
** September
** October
** November
** December
```

The reason for the `*`-style headings is so that `orgstruct-mode` can
be used to collapse sections.

### Balance Correction

Sometimes I get things wrong.  I will make a mistake recording a
transaction, and a mistake reading that same transaction from my bank
statement at the end of the month.  Because it takes time for
transactions to appear in my online banking, and even then they often
appear out-of-order, just comparing my hledger end-of-month balances
with what my bank thinks they are is not easy.

Tracking down the original error is usually far more trouble than it's
worth.

If I suspect I have made a mistake (or just want to verify that I
haven't), I avoid spending money from my bank account for at least one
working week.  A simple way to achieve this is to withdraw a bunch of
money and just use cash for that week.

After a week, every uncleared transaction should really be in my
online banking, so I can reconcile, and insert a balance adjustment
transaction if I need to:

```
2017-03-01 * Balance adjustment
    expenses:adjustment  £8.51
    saved:monthly

2017-03-31 * Wallet adjustment
    expenses:adjustment  £14.98
    assets:cash:hand

2017-04-30 * Balance adjustment
    saved:monthly  £1.25
    income:adjustment
```

I made 11 transactions to `expenses:adjustment` and 1 from
`income:adjustment` in 2017.  As the year went on, the frequency (and
magnitude) of these adjustments dropped.  Hopefully I won't need any
in 2018.
