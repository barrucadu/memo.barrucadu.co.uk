---
title: Personal Finance
tags: finance, hledger, howto, systems
date: 2019-01-31
audience: Narrow
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

This memo is concerned with my mechanism for implementing this
approach.  It could serve as a starting point for your financial
planning; but working out what your savings categories are and how to
allocate your income to them requires introspection.

[hledger]: http://hledger.org/
[plain-text accounting]: http://plaintextaccounting.org/
[ynab]: https://www.youneedabudget.com/method/

## Data Files

My hledger data files (the "journal files") are shared with
[syncthing][], so I can add transactions from any machine.

I have one journal for each calendar year:

- `current.journal`, the journal for the current year.
- `$YEAR.journal`, is the journal for a previous year.

I also have two files which all my journals include:

- `commodities`, a list of all commodities (currencies,
  cryptocurrencies, funds) I deal with.
- `prices`, end-of-day exchange rates for all of my commodities.

[syncthing]: https://syncthing.net/

## Chart of Accounts

Accounts are broken up into five broad categories:

- `assets`: money I have or am owed.
- `equity`: used to start off the ledger for the year.
- `expenses`: money I have spent.
- `income`: money I have received.
- `liabilities`: money I owe.

Then `assets` is further subdivided into:

- `cash`: easily liquidated assets.
- `investments`: brokerage accounts.
- `pension`: employer-managed pension funds.
- `receivable`: money I am owed.

The set of accounts I use is fairly stable: sometimes I'll add one, or
one will cease to be useful, but that's a rare event.  Here are all
the regular accounts, which are mostly self-explanatory:

- `assets`
    - `cash`
        - `paypal`
        - `petty`
            - `hand`<br><em>Physical cash, in my wallet</em>
                - `budgeted`<br><em>&hellip; which was withdrawn from my bank account</em>
                - `unbudgeted`<br><em>&hellip; which was a gift</em>
            - `home`<br><em>Physical cash, not in my wallet</em>
        - `nationwide`
            - `flexdirect`
                - `goal`<br><em>Subaccounts for specific future expenses, like renewing my passport; money added when I am paid</em>
                - `pending`<br><em>Subaccounts for money put aside for transactions which have not cleared yet</em>
                - `saved`<br><em>Savings; money added when I am paid</em>
                    - `discretionary`
                    - `food`
                    - `gift`
                    - `graze`<br><em>Subscription to <a href="https://www.graze.com/uk/">Graze</a></em>
                    - `health`
                    - `household`
                    - `insurance`
                    - `invest`
                    - `food`
                    - `phone`
                    - `rent`
                    - `tea`
                    - `travel`
                    - `utilities`
        - `starling`
            - `float`<br><em>Cash which can be withdrawn</em>
            - `patreon`<br><em>Savings for Patreon subscriptions (charged in USD)</em>
            - `web`<br><em>Savings for AWS, domain names, and web hosting (all charged in foreign currencies)</em>
    - `investments`
        - `cavendish`
        - `coinbase`
        - `fundingcircle`
    - `pension`
        - `civilservice`
    - `receivable`
        - `deposit`<br><em>The deposit on my flat</em>
- `equity`
- `expenses`
    - `adjustment`<br><em>See <a href="#balance-correction">Balance Correction</a></em>
    - `beeminder`<br><em>I use <a href="https://www.beeminder.com/">Beeminder</a> to enforce some habits</em>
    - `books`
    - `clothing`
    - `fees`<br><em>Subaccounts for various things</em>
    - `food`
    - `fun`
    - `gift`
    - `health`
    - `household`
    - `insurance`
    - `music`
    - `other`
    - `phone`
    - `rent`
    - `tax`
        - `council`
        - `income`
        - `ni`<br><em>National Insurance</em>
    - `tech`
    - `travel`
    - `utilities`
        - `electricity`
        - `internet`
        - `water`
    - `web`
- `income`
    - `adjustment`<br><em>See <a href="#balance-correction">Balance Correction</a></em>
    - `amex`<br><em>To track cashback offers and similar</em>
    - `donation`
    - `gift`
    - `interest`
    - `job`
- `liabilities`
    - `creditcard`
        - `amex`<br><em>My American Express credit card</em>
    - `loan`
        - `slc`<br><em>My student loan</em>
    - `payable`<br><em>Subaccounts for people I owe money to</em>

An account name is the path to it through the tree, separated by
colons.  For example, `assets:cash`, or
`expenses:utilities:electricity`.

Many of these accounts do not correspond to any real-world bank or
brokerage account, they are used to track the flow of money in more
detail than if I just recorded which bank accounts things came from or
went to.

Money (and other commodities) is only stored in leaf accounts.

## Financial Institutions

I have two bank accounts, three investment accounts, and a credit
card.

For bank accounts I use:

- **Nationwide**, my main bank account.  My pay goes here, almost all
  of my expenses come out of here.

- **Starling**, my backup account.  I keep a small amount of money in
  here to withdraw for if my Santander debit card is not working
  (Santander is Visa, Starling is Mastercard).  I also use it for all
  my foreign currency transactions, as Starling doesn't charge
  currency conversion fees.

For investment accounts I use:

- **Cavendish Online**, who are as far as I can tell just a front-end
  to services provided by Fidelity (who do not themselves offer
  accounts directly), and who provide a reasonable selection of funds
  for my stocks & shares ISA.

- **Coinbase**, who offer a few different cryptocurrencies.  I have
  very little in crypto, because it's so volatile.

- **Funding Circle**, who provide my innovative finance ISA.

For a credit card I use an **American Express** cashback card.  There
is a small annual fee (£25), but by using it for all the transactions
I can, the cashback more than covers that.

Most of the time I am dealing with American Express and Santander,
only rarely do I need to touch the others.

## Transactions

A transaction has a date, a payee, and a list of postings:

```
2018-01-01 Payee
    account1                                                            £amount1
    account2                                                            £amount2
    ...
```

The amounts must sum to zero, which means that the transaction is
balanced.

[hledger][] allows transactions to be marked with a `!` or a `*`.  The
traditional meaning of these is "pending" and "cleared".

I use `!` slightly differently.  I use it for transactions which are
just an artefact of the way I track my finances, which don't involve
any balance changes to a real-world account.  For example, moving
money between different types of savings:

```
2019-01-23 ! Allocation
    assets:cash:santander:current:saved:food                              £25.00
    assets:cash:santander:current:saved:discretionary
```

I use `*` as normal, although I usually only consider cash
transactions "cleared" after I check that the cash in my wallet
matches what hledger thinks it should be.

### Income

Income is recorded as the pre-tax amount coming from `income:$source`,
and is split across `saved:*`, `expenses:tax:*`, and `liabilities:*`.
All amounts are included.

```
2018-06-29 * Cabinet Office
    assets:cash:nationwide:flexdirect:goal:tax                            £50.00
    assets:cash:nationwide:flexdirect:saved:clothing                      £13.00
    assets:cash:nationwide:flexdirect:saved:gift                          £20.00
    assets:cash:nationwide:flexdirect:saved:health                         £7.00
    assets:cash:nationwide:flexdirect:saved:household                     £15.00
    assets:cash:nationwide:flexdirect:saved:insurance                     £11.49
    assets:cash:nationwide:flexdirect:saved:invest                       £116.00
    assets:cash:nationwide:flexdirect:saved:monthly                      £385.71
    assets:cash:nationwide:flexdirect:saved:phone                         £13.00
    assets:cash:nationwide:flexdirect:saved:rent                        £1700.00
    assets:cash:nationwide:flexdirect:saved:tech                          £13.00
    assets:cash:nationwide:flexdirect:saved:travel                        £25.00
    assets:cash:nationwide:flexdirect:saved:utilities                    £100.00
    assets:cash:nationwide:flexdirect:saved:web                           £60.00
    expenses:tax:income                                                  £788.00
    expenses:tax:ni                                                      £385.39
    liabilities:loan:slc                                                 £237.00
    assets:pension:civilservice                                          £227.08
    income:job                                                         -£4166.67
    assets:pension:civilservice                                          £920.83
    income:job                                                          -£920.83
```

Income may not necessarily be taxed:

```
2019-01-01 * Starling
    assets:cash:starling:float                                             £0.12
    income:interest
```

### Investments

The `@@` form is used exactly specify the overall price.  Trading
fees, if any go to `expenses:fees:$broker`.  Transferring the cash to
the investment account and then investing it may be two separate
steps:

```
2019-01-02 * Cavendish
    assets:investments:cavendish                                         £100.00
    assets:cash:santander:current:saved:invest
2019-01-09 * Cavendish
    assets:investments:cavendish                                            0.51 VANEA @@ £100.00
    assets:investments:cavendish
```

A broker may charge a management fee by selling some of the assets:

```
2019-01-15 * Cavendish
    expenses:fees:cavendish                                                £0.10
    assets:investments:cavendish
```

Although it is best to keep some cash in the account, if possible, to
avoid the assets from being whittled away.

### Withdrawing Cash

Cash that can be withdrawn lives in `starling:float`.  This is because
it's useful to have cash on hand without necessarily having decided up
front what it's for, but it's also good to bound the amount of
unallocated money I have.

```
2019-01-25 * Withdraw
    assets:cash:petty:hand:budgeted                                       £10.00
    assets:cash:starling:float
```

Cash can also be withdrawn in a foreign currency, which will have an
exchange rate and may impose an additional fee:

```
2018-05-11 Withdraw
    assets:cash:petty:hand:budgeted                                         10000 JPY @@ £70.41
    expenses:fees:currency                                                  £1.99
    assets:cash:starling:float
```

"£" is the only commodity I give a symbolic name.

### Expenses (bank account)

There are three types of expenses: expenses from my bank account,
expenses on my credit card, and cash expenses.  The former are
straightforward:

```
2019-01-06 * Graze
    expenses:food                                                          £3.79
    assets:cash:santander:current:saved:graze
```

Foreign currency expenses are recorded like so:

```
2019-01-01 * Linode
    expenses:web                                                           20.00 USD @@ £15.77
    assets:cash:starling:web
```

Sometimes I'll add a transaction note, which comes after a vertical
bar:

```
2019-01-06 * Steam | 1644277325735538856
    expenses:fun                                                           £9.29
    liabilities:creditcard:amex
```

### Expenses (cash)

Cash expenses require an adjustment to the appropriate budget
category, transferring money back to the float to represent that that
money has been allocated and spent:

```
2019-01-25 * Post Office
    expenses:other                                                         £1.01
    assets:cash:petty:hand:budgeted
2019-01-25 ! Bookkeeping
    assets:cash:santander:current:saved:discretionary                     -£1.01
    assets:cash:santander:current:pending:starling:float
```

The money in `pending` will be transferred to the appropriate account
at some point.

This could be done in one transaction, but I think it's clearer with
two.  If I'm using cash I was gifted, the expense comes from
`hand:unbudgeted` and there's no transaction updating the float.

Foreign currency cash transactions require picking an appropriate
exchange rate when removing the money from the budget category:

```
2018-05-08 * FamilyMart
    expenses:food                                                             548 JPY
    assets:cash:petty:hand:budgeted
2018-05-08 ! Bookkeeping
    assets:cash:nationwide:flexdirect:food                                 -£4.60 ; -548 JPY
    current:float
```

Ah `@@` posting isn't used, because the bank is operating in GBP.  The
exchange rate is kind of arbitrary, but something reasonably close to
the then-current exchange rate should be used.

### Expenses (credit card)

I model expenses on my credit card much like cash expenses.

When I pay for something on my credit card I add a transaction from
`liabilities` to track the debt and remove the money from the budget
category:

```
2019-01-01 * Morrisons
    expenses:household                                                     £3.00
    expenses:food                                                         £15.21
    liabilities:creditcard:amex                                          -£18.21
2019-01-01 ! Bookkeeping
    assets:cash:santander:current:saved:household                         -£3.00
    assets:cash:santander:current:saved:food                             -£18.21
    assets:cash:santander:current:pending:amex
```

I pay off my credit card in full every month automatically via direct
debit:

```
2018-08-02 * American Express
    liabilities:creditcard:amex                                            £17.45 = £0
    assets:cash:santander:current:pending:amex
```

I like to use balance assertions (the `= £0` bit) for a little extra
error checking when I know exactly how much an account should have in
it.  After the direct debit comes out there should be no balance
remaining on the card.

### Reimbursements

Reimbursements are much like income, but are generally untaxed.
Income comes from some reimbursement account and is put in some
savings account:

```
2018-01-04 * Pusher
    assets:cash:santander:current:goal:deposit                            £186.00
    assets:receivable:pusher
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
~ every 1st day of month
    (assets:cash:starling:patreon)                                        -£3.00 ; HPPodcraft
    (assets:cash:starling:web)                                           -£45.00 ; Linode / OVH / Moniker (estimate)
    (assets:cash:nationwide:flexdirect:saved:food)                      -£185.00 ; Monthly food
    (assets:cash:nationwide:flexdirect:saved:invest)                    -£100.00 ; Cavendish direct debit
    (assets:cash:nationwide:flexdirect:saved:rent)                       -£82.00 ; Council tax
~ every 15th day of month
    (assets:cash:nationwide:flexdirect:saved:rent)                     -£1300.00 ; Haart
~ every 16th day of month
    (assets:cash:nationwide:flexdirect:saved:insurance)                  -£11.49 ; Homelet
~ every 28th day of month
    (assets:cash:nationwide:flexdirect:saved:graze)                      -£15.16 ; Graze
    (assets:cash:nationwide:flexdirect:saved:phone)                      -£13.00 ; EE
    (assets:cash:nationwide:flexdirect:saved:utilities)                  -£25.00 ; TalkTalk
    (assets:cash:nationwide:flexdirect:saved:utilities)                  -£50.00 ; EDF Energy
```

Now, my monthly income:

```
~ every 30th day of month from 2019-03-30
    assets:cash:nationwide:flexdirect:goal:oculus_rift                    £75.00
    assets:cash:nationwide:flexdirect:pending:starling:web                £45.00
    assets:cash:nationwide:flexdirect:pending:starling:patreon             £3.00
    assets:cash:nationwide:flexdirect:saved:discretionary                 £79.34 ;=  £500.00
    assets:cash:nationwide:flexdirect:saved:food                         £225.00 ;= £1000.00
    assets:cash:nationwide:flexdirect:saved:gift                           £0.00 ;=  £150.00
    assets:cash:nationwide:flexdirect:saved:graze                         £15.16 ;=   £50.00
    assets:cash:nationwide:flexdirect:saved:health                         £0.00 ;=   £50.00
    assets:cash:nationwide:flexdirect:saved:household                     £75.00 ;=  £300.00
    assets:cash:nationwide:flexdirect:saved:insurance                     £11.49 ;=   £50.00
    assets:cash:nationwide:flexdirect:saved:invest                       £100.00
    assets:cash:nationwide:flexdirect:saved:phone                         £13.00 ;=   £50.00
    assets:cash:nationwide:flexdirect:saved:rent                        £1800.00 ;= £4200.00
    assets:cash:nationwide:flexdirect:saved:tea                           £15.00 ;=   £30.00
    assets:cash:nationwide:flexdirect:saved:travel                        £15.00 ;=   £50.00
    assets:cash:nationwide:flexdirect:saved:utilities                    £125.00 ;=  £250.00
    expenses:tax:income                                                  £807.60
    expenses:tax:ni                                                      £387.48
    liabilities:loan:slc                                                 £246.00
    assets:pension:civilservice                                          £232.76
    income:job                                                         -£4270.83
    assets:pension:civilservice                                          £943.85
    income:job                                                          -£943.85
```

The month-to-month allocation of money will vary a little.

### Forecasting

In its simplest form, forecasting is just applying your budget into
the future.  I plan for each calendar year, so I look ahead to the end
of December to see that everything is working out.

However, expected future events can be added to the forecast too:

```
; Dentist
~ 2018-03-20
    expenses:health                                                        £20.60
    assets:cash:santander:current:saved:health
```

It is essential that none of my savings accounts dip below zero, and
ideally their balance should be increasing every month, due to saving
extra.  When I have enough of a buffer, I will remove this extra
allocation (just maintaining the current balance) and put the extra
money to some other use.

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

### Once every so often

Every so often (every week or two) I check my various financial
statements and reconcile transactions in the journal:

1. For every transaction in the statement, find the corresponding
   journal transaction and mark it.
    - If there are transactions missing from the journal, add and mark
      them.
    - If there are transactions missing from the statement, the
      institution is being slow; reconcile as they come in over the
      next few days.
    - If all transactions have cleared but the balance is not what is
      expected, either figure out what happened or add transactions to
      adjust (see [Balance Correction](#balance-correction)).
2. Check the balance in my wallet and mark all `hand` transactions.
    - If the wallet balance is below the `hand` balance, add a
      transaction to adjust (see [Balance
      Correction](#balance-correction)).

### End of Year

1. Reconcile transactions.
2. Rename the current journal file from "current.journal" to
   "$YEAR.journal".
3. Identify financial goals for the upcoming year.
4. Create a new "current.journal" for the upcoming year with budget
   and forecast transactions.
5. Initialise all accounts on the first of January by transferring from equity.

The budget created in (4) will depend on the goals identified in (3).
Here's an example of a (5) transaction setting up the starting
balances:

```
2019-01-01 ! Start of year
    assets:cash:petty:hand:budgeted                                        £2.56
    ;
    assets:cash:petty:home                                                  3.35 EUR
    assets:cash:petty:home                                               1853.00 JPY
    ;
    assets:cash:santander:current:float                                   £94.46
    assets:cash:santander:current:goal:passport                           £75.50
    assets:cash:santander:current:goal:thesis                            £300.00
    assets:cash:santander:current:overdraft                             £2000.00
    assets:cash:santander:current:pending:amex                          £1755.29
    assets:cash:santander:current:pending:starling:patreon                 £2.83
    assets:cash:santander:current:pending:starling:web                    £52.59
    assets:cash:santander:current:saved:discretionary                    £100.00
    assets:cash:santander:current:saved:food                             £200.00
    assets:cash:santander:current:saved:graze                             £21.21
    assets:cash:santander:current:saved:health                            £38.51
    assets:cash:santander:current:saved:household                        £100.00
    assets:cash:santander:current:saved:insurance                         £25.00
    assets:cash:santander:current:saved:invest                           £100.00
    assets:cash:santander:current:saved:phone                             £25.00
    assets:cash:santander:current:saved:rent                            £1700.17
    assets:cash:santander:current:saved:travel                            £38.50
    assets:cash:santander:current:saved:utilities                        £150.00
    ;
    assets:cash:starling:float                                           £100.00
    assets:cash:starling:patreon                                          £17.17
    assets:cash:starling:web                                             £135.85
    ;
    assets:investments:cavendish                                            3.29 VANEA
    assets:investments:cavendish                                          £46.95
    assets:investments:coinbase                                            10.00 EUR
    assets:investments:coinbase                                           0.0040 BTC
    assets:investments:coinbase                                           0.1000 ETH
    assets:investments:coinbase                                           0.2500 LTC
    assets:investments:fundingcircle                                    £1028.09
    ;
    assets:pension:civilservice                                         £9344.92
    ;
    assets:receivable:deposit                                           £1800.00
    ;
    liabilities:creditcard:amex                                        -£2740.00
    liabilities:loan:slc                                              -£26896.25
    liabilities:overdraft:santander:current                            -£2000.00
    ;
    equity
```

This is the template for a new journal file:

```
include commodities
include prices

alias hand    = assets:cash:petty:hand
alias current = assets:cash:santander:current
alias month   = current:month
alias saved   = current:saved
alias goal    = current:goal

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
    expenses:adjustment                                                    £8.51
    assets:cash:santander:current:saved:monthly

2017-03-31 * Wallet adjustment
    expenses:adjustment                                                   £14.98
    assets:cash:petty:hand:budgeted

2017-04-30 * Balance adjustment
    assets:cash:santander:current:saved:monthly                            £1.25
    income:adjustment
```

I made 12 adjustment transactions in 2017 and 6 in 2018.  Hopefully in
2019 I won't need any.
