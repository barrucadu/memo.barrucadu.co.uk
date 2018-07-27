---
title: Personal Finance
tags: finance, hledger, howto
date: 2018-07-27
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
        - `santander`
            - `current`
                - `float`<br><em>Cash which can be withdrawn</em>
                - `goal`<br><em>Subaccounts for specific future expenses, like renewing my passport; money added when I am paid</em>
                - `month`<br><em>Living expenses; money added at the start of the month</em>
                    - `food`
                    - `fun`
                    - `other`
                - `pending`<br><em>Money put aside for transactions which have not cleared yet</em>
                - `saved`<br><em>Savings; money added when I am paid</em>
                    - `clothing`
                    - `gift`
                    - `health`
                    - `household`
                    - `insurance`
                    - `invest`
                    - `monthly`
                    - `phone`
                    - `rent`
                    - `tech`
                    - `travel`
                    - `utilities`
        - `starling`
            - `float`<br><em>Cash which can be withdrawn</em>
            - `web`<br><em>Savings for AWS, domain names, and web hosting (all charged in foreign currencies)</em>
    - `investments`
        - `cavendish`
            - `s&s`
        - `coinbase`
    - `pension`
        - `civilservice`
    - `receivable`
        - `deposit`<br><em>The deposit on my flat</em>
- `equity`
- `expenses`
    - `books`
    - `clothing`
    - `fees`
        - `cavendish`<br><em>My investment broker</em>
        - `currency`
        - `customs`
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
    - `donation`
    - `interest`
    - `job`
- `liabilities`
    - `creditcard`
        - `amex`<br><em>My American Express credit card</em>
    - `loan`
        - `slc`<br><em>My student loan</em>
    - `overdraft`
        - `santander`
            - `current`<br><em>My bank account overdraft</em>
    - `payable`<br><em>Subaccounts for people I owe money to</em>

An account name is the path to it through the tree, separated by
colons.  For example, `assets:cash`, or
`expenses:utilities:electricity`.  Because typing these account names
would be pretty tedious, I use some aliases in my journal file:

```
alias hand    = assets:cash:petty:hand
alias current = assets:cash:santander:current
alias month   = current:month
alias saved   = current:saved
alias goal    = current:goal
```

Many of these accounts do not correspond to any real-world bank or
brokerage account, they are used to track the flow of money in more
detail than if I just recorded which bank accounts things came from or
went to.

Money (and other commodities) is only stored in leaf accounts.

## Financial Institutions

I have two bank accounts, two investment accounts, and a credit card.

For bank accounts I use:

- **Santander**, my main bank account.  My pay goes here, almost all
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

For a credit card I use an **American Express** cashback card.  There
is a small annual fee (£25), but I predict (based on my typical
spending patterns) that the cashback will more than cover that.

Most of the time I am dealing with American Express and Santander,
only rarely do I need to touch the others.

## Transactions

A transaction has a date, a payee, and a list of postings:

```
2018-01-01 Payee
    account1                                            £amount1
    account2                                            £amount2
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
2018-06-01 ! Budget
    month:food                                           £250.00
    month:fun                                             £50.00
    month:other                                           £25.00
    saved:monthly                                       -£325.00
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
    goal:tax                                              £50.00
    saved:clothing                                        £13.00
    saved:gift                                            £20.00
    saved:health                                           £7.00
    saved:household                                       £15.00
    saved:insurance                                       £11.49
    saved:invest                                         £116.00
    saved:monthly                                        £385.71
    saved:phone                                           £13.00
    saved:rent                                          £1700.00
    saved:tech                                            £13.00
    saved:travel                                          £25.00
    saved:utilities                                      £100.00
    saved:web                                             £60.00
    expenses:tax:income                                  £788.00
    expenses:tax:ni                                      £385.39
    liabilities:loan:slc                                 £237.00
    assets:pension:civilservice                          £227.08
    income:job                                         -£4166.67
    assets:pension:civilservice                          £920.83
    income:job                                          -£920.83
```

Income may not necessarily be taxed:

```
2018-06-02 * Interest
    saved:monthly                                          £4.00
    income:interest
```

### Investments

Investments are a transaction from `saved:invest` to the appropriate
investment account.  All amounts are included, using the `@@` form to
exactly specify the overall price.  Trading fees go to
`expenses:fees:$broker`.

```
2017-12-18 * Coinbase
    assets:investments:coinbase                             0.25 LTC @@ £60.17
    expenses:fees:coinbase                                 £2.50
    saved:invest                                         -£62.67
```

Transferring the cash to the investment account and then investing it
may be two separate steps:

```
2018-06-01 * Cavendish
    assets:investments:cavendish:s&s                     £100.00
    saved:invest
2018-06-01 * Cavendish
    assets:investments:cavendish:s&s                        0.47 VANEA @@ £100.00
    assets:investments:cavendish:s&s
```

A broker may charge a management fee by selling some of the assets:

```
2018-01-03 Cavendish
    assets:investments:cavendish:s&s                       -0.02 MCMEA @@ £0.03
    expenses:fees:cavendish                                £0.03
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
    hand:budgeted                                            £20
    current:float
```

Cash can also be withdrawn in a foreign currency, which will have an
exchange rate and may impose an additional fee:

```
2018-05-11 Withdraw
    hand:budgeted                                          10000 JPY @@ £70.41
    expenses:fees:currency                                 £1.99
    current:float
```

"£" is the only commodity I give a symbolic name.

### Expenses (bank account)

There are three types of expenses: expenses from my bank account,
expenses on my credit card, and cash expenses.  The former are
straightforward:

```
2018-01-01 Subway
    expenses:food                                          £5.99
    month:food
```

Foreign currency expenses are recorded like so:

```
2018-01-01 Linode
    expenses:web                                              20 USD @@ £15.31
    expenses:fees:currency                                 £1.25
    saved:web
```

Sometimes I'll add a transaction note, which comes after a vertical
bar:

```
2018/06/04 * Steam | Cultist Simulator
    expenses:fun                                       £13.49
    month:other

```

Sometimes transactions take a long time to clear.  For example, if you
buy something out of stock on Amazon, they'll charge you when it
ships.  This could even be months later.  For such transactions, I
want to remove the money from the relevant budget category
immediately, but not from my assets until the charge actually occurs.
The solution is a temporary account:

```
2018-06-09 ! Amazon | 203-1811543-7064312
    current:pending                                       £14.99
    month:fun
```

Later, when the money is taken from my bank account, I can add the
transaction to `expenses`:

```
2018-07-31 Amazon | 203-1811543-7064312
    expenses:books                                        £14.99
    current:pending
```

If this is a transaction with a note, the same note goes on both to
tie them together.

I prefer this approach to [posting dates][], as with posting dates the
ledger does not balance between the two dates.  By simply using an
additional account, balance is maintained.

[posting dates]: http://hledger.org/manual.html#posting-dates

### Expenses (cash)

Cash expenses require an adjustment to the appropriate budget
category, transferring money back to the float to represent that that
money has been allocated and spent:

```
2018-01-06 * Morrisons
    expenses:food                                          £2.43
    hand:budgeted
2018-01-06 ! Cash budget spend
    month:food                                            -£2.43
    current:float
```

This could be done in one transaction, but I think it's clearer with
two.  If I'm using cash I was gifted, the expense comes from
`hand:unbudgeted` and there's no transaction updating `current:float`.

Foreign currency cash transactions require picking an appropriate
exchange rate when removing the money from the budget category:

```
2018-05-08 * FamilyMart
    expenses:food                                            548 JPY
    hand:budgeted
2018-05-08 ! Cash budget spend
    month:food                                              -548 JPY @@ £4.60
    current:float
```

The exchange rate is kind of arbitrary, but something reasonably close
to the then-current exchange rate should be used.

### Expenses (credit card)

I model expenses on my credit card much like cash expenses.

When I pay for something on my credit card I add a transaction from
`liabilities` to track the debt and remove the money from the budget
category:

```
2018-07-27 * Morrisons
    expenses:food                                          £3.50
    liabilities:creditcard:amex
2018-07-27 ! Credit budget spend
    current:pending                                        £3.50
    month:food
```

I pay off my credit card in full every month automatically via direct
debit:

```
2018-08-02 * American Express
    liabilities:creditcard:amex                           £17.45 = £0
    current:pending
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
    saved:deposit                                           £186
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
    month:food                                           £250.00
    month:fun                                             £50.00
    month:other                                           £25.00
    saved:monthly
~ every 1st day of month
    expenses:web                                          £40.00
    saved:web

~ every 1st day of month from 2018-03
    expenses:utilities                                    £75.00
    saved:utilities
~ every 15th day of month from 2018-03
    expenses:rent                                       £1300.00
    expenses:tax:council                                  £82.00
    saved:rent
~ every 16th day of month from 2018-03
    expenses:insurance                                    £15.00
    saved:insurance
```

This is based on experience.  It's in two chunks because I moved to
London in March.

Now, my monthly income:

```
~ every 30th day of month from 2018-04
    saved:clothing                                        £13.00
    saved:gift                                            £20.00
    saved:health                                           £7.00
    saved:household                                       £15.00
    saved:insurance                                       £15.00
    saved:invest                                         £116.00
    saved:monthly                                        £380.46
    saved:phone                                           £13.00
    saved:rent                                          £1700.00
    saved:tech                                            £13.00
    saved:travel                                          £25.00
    saved:utilities                                      £100.00
    saved:web                                             £60.00
    expenses:tax:income                                  £848.20
    expenses:tax:ni                                      £382.61
    liabilities:loan:slc                                 £100.00
    assets:pension:civilservice                          £219.51
    income:job                                         -£4027.78
    assets:pension:civilservice                          £890.14
    income:job                                          -£890.14
```

This is based on my pay in April.  The month-to-month allocation of
cash to `saved:...` categories will vary a little.

Notice how I'm only spending £325 of `saved:monthly` a month, but I'm
adding £380 to it.  I do this with all the savings accounts, gradually
building up a buffer so I will not be living paycheck to paycheck.

### Forecasting

In its simplest form, forecasting is just applying your budget into
the future.  I plan for each calendar year, so I look ahead to the end
of December to see that everything is working out.

However, expected future events can be added to the forecast too:

```
; Dentist
~ 2018-03-20
    expenses:health                                       £20.60
    saved:health
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

Every so often (once or twice a week) I check my various financial
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
      adjust (see "balance correction").
2. Check the balance in my wallet and mark all `hand` transactions.
    - If the wallet balance is below the `hand` balance, add a
      transaction to adjust (see "balance correction").

### End of Month

At the end of a month I reconcile the transactions of the
month-just-ended and set up the budget for the month-just-started:

```
2018-06-01 ! Budget
    month:food                                           £250.00
    month:fun                                             £50.00
    month:other                                           £25.00
    saved:monthly                                       -£325.00
```

This is just the regular monthly budget, but with a date.

### End of Year

1. Reconcile, as at the end of any other month.
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
2018-01-01 ! Start of year
    hand:budgeted                                        £242.70
    ;
    current:float                                         £77.30
    saved:gift                                             £5.00
    saved:household                                      £100.00
    saved:invest                                           £5.00
    saved:monthly                                        £342.36
    saved:moving                                         £950.00
    saved:rent                                          £1038.00
    saved:travel                                         £100.00
    saved:web                                            £195.00
    ;
    assets:investments:cavendish:s&s                        2.54 VADEA @@ £800.00
    assets:investments:cavendish:s&s                       65.00 MCMEA @@  £99.77
    assets:investments:cavendish:s&s                       31.19 MCOUA @@  £50.00
    assets:investments:cavendish:s&s                        7.15 MHMIA @@  £50.00
    assets:investments:coinbase                            0.004 BTC   @@  £51.91
    assets:investments:coinbase                             0.10 ETH   @@  £62.04
    assets:investments:coinbase                             0.25 LTC   @@  £60.17
    assets:investments:coinbase                            10.00 EUR   @@   £9.11
    ;
    assets:receivable:deposit                            £300.00
    assets:receivable:pusher                             £186.00
    assets:receivable:university                         £188.38
    ;
    liabilities:overdraft:santander:current            -£2000.00
    liabilities:loan:slc                              -£28592.25
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
    expenses:adjustment                                    £8.51
    saved:monthly

2017-03-31 * Wallet adjustment
    expenses:adjustment                                   £14.98
    hand:budgeted

2017-04-30 * Balance adjustment
    saved:monthly                                          £1.25
    income:adjustment
```

I made 11 transactions to `expenses:adjustment` and 1 from
`income:adjustment` in 2017.  As the year went on, the frequency (and
magnitude) of these adjustments dropped.  So far in 2018 (as of June),
I have only needed 2.  Hopefully in 2019 I won't need any.
