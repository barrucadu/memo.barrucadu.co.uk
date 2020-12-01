---
title: Personal Finance
taxon: self-systems
tags: finance, hledger
published: 2018-01-07
modified: 2020-12-01
---

I manage my money using [plain-text accounting][] (specifically,
[hledger][]; though the choice of tool is unimportant), following a
[YNABish][ynab] approach.  The four YNAB rules are:

1. **Give every dollar a job:** money is split into named categories,
   don't have any "general savings".
2. **Embrace your true expenses:** large expenses (like a rental
  deposit, or Christmas gifts) are planned and allocated for in
  advance, as a regular monthly contribution.
3. **Roll with the punches:** if things aren't working out, adjust the
   plan rather than lie to yourself.
4. **Age your money:** try to save more of each regular expense (rent,
   travel, etc) than you spend in a given period.

Why track my finances at all?

- Makes me more conscious of my spending.
- Lets me see how my spending has changed over time.
- Lets me plan for the future with some degree of confidence.

This memo is concerned with my mechanism for implementing this
approach.  It could serve as a starting point for your financial
planning; but working out what your savings categories are and how to
allocate your income to them requires introspection.


High-level metrics
------------------

While the most straightforward metric of financial health is the
balance of my budget, and that's the main thing I look at when making
day-to-day spending decisions, there are a few other high-level
metrics I keep an eye on.  These are:

- **Net Worth:** if I paid off all my liabilities right now, how much
  of my assets would I have left?

  `net worth = assets + liabilities`

  With plain-text double-entry accounting, assets are positive and
  liabilities are negative, so you get your net worth by adding them.

  *What good looks like:* this metric is red below 0, green otherwise.

- **Savings Rate:** how much of my income am I saving?

  `savings_rate = (net_income - expenses) / net_income`

  I plot the savings rate for each month on a graph, and use the mean
  monthly savings rate as the high-level metric.

  *What good looks like:* this metric is red below zero, yellow below
  33%, and green otherwise.

- **Runway:** if my income stopped *right now*, how long would I be
  able to survive?

  `runway = assets / average_daily_expense`

  I use two versions of this metric:

  - **Short Runway:** only considering my bank accounts and emergency
    savings (in Premium Bonds).

  - **Long Runway:** taking all my assets into account, as if I sold
    all my investments in one go at their current price.

  *What good looks like:* these metrics are red below 60 days, yellow
  below 90 days, and green otherwise.

- **Student Loan:** I want to get this down (or up, since it's a
  liability) to zero.

  *What good looks like:* this metric is red below -£10k, yellow below
  0, and green otherwise.

- **House Deposit:** I've decided to start saving for a house from the
  2021-22 tax year.  This'll be a very long term thing.

  *What good looks like:* this metric is red below £25k, yellow below
  £50k, and green otherwise.


Dashboard
---------

![My personal finance dashboard](personal-finance-dashboard.png)

I import my hledger data into influxdb [with a script which runs
nightly][], to power [a grafana dashboard on my home server][].  There
are a few parts to it:

1. **High-level metrics:** as explained in the section above.

2. **Overview:** statistics on my hledger journal; my asset
   allocation; a graph of my net worth; a graph of my credit card
   balance; and a graph of my cash flow / savings rate.

3. **Savings targets:** red up to 50%, yellow up to 75%, and then
   green.  I'll hit most of these targets by the end of March 2021.

4. **Commodity values:** scraped daily from the Financial Times and
   the Coinbase API.

[with a script which runs nightly]: https://github.com/barrucadu/hledger-scripts
[a grafana dashboard on my home server]: https://github.com/barrucadu/nixfiles/tree/master/hosts/nyarlathotep/grafana-dashboards


Journal files
-------------

I log all my financial transactions for the current year in a file
called `current.journal`.  There are `$YEAR.journal` files for
historic data.  I also have two files which all my journals include:

- `commodities`, a list of all commodities (currencies,
  cryptocurrencies, funds) I deal with.
- `prices`, end-of-day exchange rates for all of my commodities.

Rather than importing transactions from my bank or something, I enter
all data manually.  This may sound tedious, but I feel that the
awareness I get from doing so is worth it.

This is the template for a new journal file:

```
include commodities
include prices

* Starting balances
YYYY-01-01 ! Opening balances
  ...

* Forecast
~ monthly  Expenses
  ...
~ monthly  Income
  ...

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

[hledger]: http://hledger.org/
[plain-text accounting]: http://plaintextaccounting.org/
[ynab]: https://www.youneedabudget.com/method/


Financial institutions
----------------------

For current accounts I use:

- **Nationwide Flexdirect**, my main bank account.  Pay goes in,
  direct debits and standing orders go out.  I don't do much
  unscheduled spending from this account.

- **Starling**, my backup account.  I use this to store cash to be
  withdrawn and for foreign currency transactions, as Starling doesn't
  charge currency conversion fees.

For investment accounts I use:

- **Cavendish Online**, for my stocks & shares ISA (invested in a
  passive Vanguard fund).

- **Coinbase**, for a very small amount of cryptocurrency.

- **NS&I**, for my emergency fund (invested in Premium Bonds).

For credit cards I use:

- **American Express**, for a cashback card.  There is a small annual
  fee (£25), but my annual cashback covers that.

Almost all of my spending goes on the Amex card, with that paid off in
full every month from the Nationwide account.


Chart of accounts
-----------------

The set of accounts I use is fairly stable: sometimes I'll add one, or
one will cease to be useful, but that's a rare event.  Here are all
the regular accounts, which are mostly self-explanatory:

- `assets`
    - `cash`
        - `paypal`
        - `petty`
            - `hand`---physical cash, in my wallet
                - `budgeted`---...which was withdrawn from my bank account
                - `unbudgeted`---...which was a gift
            - `home`---physical cash, not in my wallet
        - `nationwide`
            - `flexdirect`
                - `goal`
                    - *subaccounts for specific future expenses, like renewing my passport*
                - `float`---cash which can be withdrawn
                - `pending`
                    - *subaccounts for money to be transferred outside of the flexdirect*
                - `saved`
                    - `discretionary`
                    - `food`
                    - `gift`
                    - `graze`---monthly [Graze](https://www.graze.com/uk/) subscription
                    - `health`
                    - `household`
                    - `phone`
                    - `rent`
                    - `social`
                    - `tea`
                    - `travel`
                    - `utilities`
        - `starling`
            - `float`---cash which can be withdrawn
            - `patreon`---monthly [Patreon](https://www.patreon.com/) subscriptions (charged in USD)
            - `protonmail`---annual [ProtonMail](https://protonmail.com/) fee (charged in EUR)
            - `roll20`---monthly [Roll20](https://roll20.net/) subscription (charged in USD)
            - `web`---AWS, domain names, and hosting (all charged in foreign currencies)
    - `investments`
        - `cavendish`
        - `coinbase`
        - `nsi`
    - `receivable`
        - `deposit`---the deposit on my flat
- `equity`---used for initialising balances at the start of the year
- `expenses`
    - *subaccounts for various things*
- `income`
    - `amex`---cashback offers and similar
    - `interest`
    - `job`
- `liabilities`
    - `creditcard`
        - `amex`
    - `loan`
        - `slc`---student loan
    - `owed`
        - *subaccounts for people I owe money to*

An account name is the path to it through the tree, separated by
colons.  For example, `assets:cash`, or
`expenses:utilities:electricity`.

Many of these accounts do not correspond to any real-world bank or
brokerage account, they are used to track the flow of money in more
detail than if I just recorded which bank accounts things came from or
went to.

Money (and other commodities) is only stored in leaf accounts.

### The emergency fund

The emergency fund, stored in Premium Bonds, is used for any
surprising emergency which isn't covered by any other category: for
example, if I suddenly needed to replace my computer, or move to a new
flat.

It's not something I intend to use.

Some people advocate investing your emergency fund into stocks and
shares, as long-term cash savings lose value due to inflation.  But I,
and many others, don't agree with that.  If an emergency struck, it
could be catastrophic if the value of your fund had halved because the
market was down.

So I store mine in Premium Bonds, where it is still likely to lose
value against inflation, but it won't have any sudden losses.  Premium
Bonds can be withdrawn from with about a week's notice, so I make sure
to have enough cash in my bank account (and credit on my credit card)
to cover any emergency for at least that long.


!-transactions
--------------

[hledger][] allows transactions to be marked with a `!` or a `*`.  The
traditional meaning of these is "pending" and "cleared".

I use `!` slightly differently.  I use it for transactions which are
just an artefact of the way I track my finances, which don't involve
any balance changes to a real-world account.  For example,
reallocating my savings:

```
2019-08-25 ! Allocation
    assets:cash:nationwide:flexdirect:saved:gift                         -£14.00
    assets:cash:nationwide:flexdirect:saved:tea                          -£20.00
    assets:cash:nationwide:flexdirect:saved:discretionary
    assets:cash:nationwide:flexdirect:saved:food
```

I use `*` as normal, although I usually only consider cash
transactions "cleared" after I check that the cash in my wallet
matches what hledger thinks it should be.


Modelling income
----------------

Income is recorded as the pre-tax amount coming from `income:$source`,
and is split across `assets:*`, `expenses:*`, and `liabilities:*`.
All amounts are included.

```
2019-08-30 * Cabinet Office
    assets:cash:nationwide:flexdirect:goal:move                          £500.00
    assets:cash:nationwide:flexdirect:pending:cavendish                  £150.00
    assets:cash:nationwide:flexdirect:pending:flexsaver                  £250.00
    assets:cash:nationwide:flexdirect:pending:starling:patreon             £3.00
    assets:cash:nationwide:flexdirect:pending:starling:protonmail          £5.00
    assets:cash:nationwide:flexdirect:pending:starling:roll20              £5.00
    assets:cash:nationwide:flexdirect:pending:starling:web                £45.00
    assets:cash:nationwide:flexdirect:saved:discretionary                £101.42
    assets:cash:nationwide:flexdirect:saved:food                         £200.00
    assets:cash:nationwide:flexdirect:saved:gift                         £139.66
    assets:cash:nationwide:flexdirect:saved:graze                         £15.16
    assets:cash:nationwide:flexdirect:saved:health                         £0.00
    assets:cash:nationwide:flexdirect:saved:household                     £75.00
    assets:cash:nationwide:flexdirect:saved:insurance                     £11.49
    assets:cash:nationwide:flexdirect:saved:phone                         £13.00
    assets:cash:nationwide:flexdirect:saved:rent                        £1400.00
    assets:cash:nationwide:flexdirect:saved:social                        £50.00
    assets:cash:nationwide:flexdirect:saved:tea                           £41.40
    assets:cash:nationwide:flexdirect:saved:travel                        £41.40
    assets:cash:nationwide:flexdirect:saved:utilities                     £71.50
    expenses:tax:income                                                  £839.00
    expenses:tax:ni                                                      £431.83
    liabilities:loan:slc                                                 £314.00
    expenses:pension                                                     £367.50
    income:job                                                         -£5070.36
    expenses:pension                                                    £1395.00
    income:job                                                         -£1395.00
```

Some income transactions may not have anything to do with expenses or
liabilities:

```
2019-07-31 * Nationwide
    assets:cash:nationwide:flexdirect:saved:discretionary                  £8.89
    income:interest
```


Modelling investments
---------------------

The `@@` form is used to exactly specify the overall price.  Trading
fees, if any go to `expenses:fees:$broker`.  Transferring the cash to
the investment account and then investing it may be two separate
steps:

```
2019-07-01 * Cavendish
    assets:investments:cavendish                                         £150.00
    assets:cash:nationwide:flexdirect:pending:cavendish

2019-07-09 * Cavendish
    assets:investments:cavendish                                            0.65 VANEA @@ £150.00
    assets:investments:cavendish
```

A broker will typically charge a management fee:

```
2019-07-01 * Cavendish
    expenses:fees:cavendish                                                £0.06
    assets:investments:cavendish
```

If there isn't enough cash in the account to pay for it, some other
asset will be sold.  That's bad, so I always make sure there's some
cash.


Modelling expenses
------------------

There are three types of expenses: expenses from a bank account,
expenses on a credit card, and cash expenses.  The former are
straightforward:

```
2019-07-01 * Graze
    expenses:food                                                          £3.79
    assets:cash:nationwide:flexdirect:saved:graze
```

Foreign currency expenses are recorded like so:

```
2019-08-05 * Hetzner
    expenses:web                                                           19.08 EUR @@ £17.60
    assets:cash:starling:web
```

Sometimes I'll add a transaction note, which comes after a vertical
bar:

```
2019-01-06 * Steam | 1644277325735538856
    expenses:fun                                                           £9.29
    liabilities:creditcard:amex
```


### Cash

Cash that can be withdrawn lives in `flexdirect:float` and
`starling:float`.  This is because it's useful to have cash on hand
without necessarily having decided up front what it's for, but it's
also good to bound the amount of unallocated money I have.

```
2019-01-25 * Withdraw
    assets:cash:petty:hand:budgeted                                       £10.00
    assets:cash:starling:float
```

Cash can also be withdrawn in a foreign currency, which will have an
exchange rate and may impose an additional fee:

```
2018-05-11 Withdraw
    assets:cash:petty:hand:budgeted                                        10000 JPY @@ £70.41
    expenses:fees:currency                                                 £1.99
    assets:cash:starling:float
```

Cash expenses require an adjustment to the appropriate budget
category, transferring money back to the float to represent that that
money has been allocated and spent:

```
2019-01-25 * Post Office
    expenses:other                                                         £1.01
    assets:cash:petty:hand:budgeted
2019-01-25 ! Bookkeeping
    assets:cash:nationwide:flexdirect:saved:discretionary                 -£1.01
    assets:cash:nationwide:flexdirect:pending:starling:float
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
    expenses:food                                                            548 JPY
    assets:cash:petty:hand:budgeted
2018-05-08 ! Bookkeeping
    assets:cash:nationwide:flexdirect:saved:food                          -£4.60 ; -548 JPY
    assets:cash:nationwide:flexdirect:pending:starling:float
```

The exchange rate is kind of arbitrary, as it's only being used for
budgeting purposes here.  An `@@` posting isn't used, because the bank
operates entirely in GBP.

### Credit cards

When I pay for something on my credit card I add a transaction from
`liabilities` to track the debt, and also remove the money from the
budget category:

```
2019-08-04 * Morrisons
    expenses:food                                                          £4.65
    expenses:tea                                                          £11.70
    liabilities:creditcard:amex                                          -£16.35
2019-08-04 ! Bookkeeping
    assets:cash:nationwide:flexdirect:saved:food                          -£4.65
    assets:cash:nationwide:flexdirect:saved:tea                          -£11.70
    assets:cash:nationwide:flexdirect:pending:amex
```

I pay off my credit card in full every month automatically via direct
debit:

```
2019-08-05 * American Express
    liabilities:creditcard:amex                                          £378.34
    assets:cash:nationwide:flexdirect:pending:amex
```

Every year, I get cashback.  As the cashback goes to the balance on
the card, rather than being paid into my bank account, I treat it as
an pair of an income transaction and an allocation-style transaction:

```
2019-08-14 * American Express | cashback
    liabilities:creditcard:amex                                          £181.41
    income:amex
2019-08-14 ! Allocation | cashback
    assets:cash:nationwide:flexdirect:goal:move                          £100.00
    assets:cash:nationwide:flexdirect:saved:tea                           £80.00
    assets:cash:nationwide:flexdirect:pending:amex
```

Forecasting
-----------

I do some basic forecasting in my ledger, but be wary!  Predicting the
future can be the downfall of an otherwise-sound financial plan!  I am
always pessimistic in my forecasting[^assump], and I never make
spending decisions based on a forecast, it's purely to get an estimate
of what my account balances will become based on my current income
allocation and to see how sensible my savings goals are.

[^assump]: The only income I forecast is from my job (though I do
  assume I won't lose my job), and I forecast spending my entire
  budget every month.

Firstly, I forecast my monthly expenses:

```
~ monthly  Expenses
    (assets:cash:nationwide:flexdirect:saved:food)                      -£200.00
    (assets:cash:nationwide:flexdirect:saved:household)                  -£50.00
    (assets:cash:nationwide:flexdirect:saved:tea)                        -£25.00
    ;
    (assets:cash:nationwide:flexdirect:saved:graze)                      -£15.16 ; graze
    (assets:cash:nationwide:flexdirect:saved:phone)                      -£13.92 ; ee
    (assets:cash:nationwide:flexdirect:saved:rent)                      -£122.17 ; three rivers DC
    (assets:cash:nationwide:flexdirect:saved:rent)                     -£1200.00 ; hamptons
    (assets:cash:nationwide:flexdirect:saved:utilities)                  -£40.00 ; affinity water
    (assets:cash:nationwide:flexdirect:saved:utilities)                  -£52.00 ; virgin media
    (assets:cash:nationwide:flexdirect:saved:utilities)                  -£72.00 ; eon energy
    (assets:cash:starling:patreon)                                        -£8.00 ; patreon
    (assets:cash:starling:roll20)                                         -£5.00 ; roll20
    (assets:cash:starling:web)                                            -£7.00 ; aws
    (assets:cash:starling:web)                                           -£20.00 ; ovh
    (assets:cash:starling:web)                                           -£35.00 ; hetzner
```

Each of those numbers is based on experience and some of them are
rounded up where prices aren't exact, or are in a foreign currency (so
the exchange rate may vary).

Secondly, I have some regular account transfers:

```
~ monthly  Transfers
    assets:cash:nationwide:flexdirect:pending:cavendish                 -£200.00
    assets:cash:nationwide:flexdirect:pending:starling:patreon            -£8.00
    assets:cash:nationwide:flexdirect:pending:starling:protonmail         -£5.00
    assets:cash:nationwide:flexdirect:pending:starling:roll20             -£5.00
    assets:cash:nationwide:flexdirect:pending:starling:web               -£55.00
    assets:cash:starling:patreon                                           £8.00
    assets:cash:starling:protonmail                                        £5.00
    assets:cash:starling:roll20                                            £5.00
    assets:cash:starling:web                                              £55.00
    assets:investments:cavendish                                         £200.00
```

I know the exact amounts of these as they're set up as standing
orders.

Thirdly, I have an allocation of my income:

```
~ monthly  Cabinet Office
    assets:cash:nationwide:flexdirect:unallocated
    assets:cash:nationwide:flexdirect:pending:cavendish                  £200.00
    assets:cash:nationwide:flexdirect:pending:starling:patreon             £8.00
    assets:cash:nationwide:flexdirect:pending:starling:protonmail          £5.00
    assets:cash:nationwide:flexdirect:pending:starling:roll20              £5.00
    assets:cash:nationwide:flexdirect:pending:starling:web                £55.00
    assets:cash:nationwide:flexdirect:saved:discretionary                  £0.00
    assets:cash:nationwide:flexdirect:saved:food                         £200.00 ;= £1000.00
    assets:cash:nationwide:flexdirect:saved:gift                           £0.00 ;=  £150.00
    assets:cash:nationwide:flexdirect:saved:graze                         £15.16 ;=   £50.00
    assets:cash:nationwide:flexdirect:saved:health                         £0.00 ;=   £50.00
    assets:cash:nationwide:flexdirect:saved:household                     £50.00 ;=  £300.00
    assets:cash:nationwide:flexdirect:saved:phone                         £13.92 ;=  £100.00
    assets:cash:nationwide:flexdirect:saved:rent                        £2000.00 ;= £4000.00
    assets:cash:nationwide:flexdirect:saved:social                         £0.00
    assets:cash:nationwide:flexdirect:saved:tea                           £25.00
    assets:cash:nationwide:flexdirect:saved:travel                       £200.00 ;=  £750.00
    assets:cash:nationwide:flexdirect:saved:utilities                    £364.00 ;= £1000.00
    expenses:tax:income                                                  £910.60
    expenses:tax:ni                                                      £427.02
    liabilities:loan:slc                                                 £328.00
    expenses:pension                                                     £387.22
    income:job                                                         -£5268.25
    expenses:pension                                                    £1469.84
    income:job                                                         -£1469.84
```

I tweak this over time depending on what my savings targets are, and
my actual income transactions don't include that `unallocated`
account: that's just so I don't have to forecast every penny up front.

Finally, I may sometimes know a particular expense is coming up, and
so note it down ahead of time:

```
~ 2018-03-08  Dentist
    expenses:health                                                       £18.80
    assets:cash:nationwide:flexdirect:saved:health
```


Maintenance
-----------

In addition to simply recording transactions, there is some
bookkeeping I do occasionally, to keep my records easy to process.

### Weekly

Once a week (or more) I check my financial statements and reconcile
transactions in the journal:

1. For every transaction in the statement, find the corresponding
   journal transaction and mark it.
    - If there are transactions missing from the journal, add and mark
      them.
    - If there are transactions missing from the statement, the
      institution is being slow; reconcile as they come in over the
      next few days.
    - If all transactions have cleared but the balance is not what is
      expected, figure out what happened and fix it.
2. Check the balance in my wallet and mark all `hand` transactions.
    - If the wallet balance is below the `hand` balance and I really
      can't remember what I spent the cash on, add a transaction to
      `expenses:adjustment`.

### Annually

1. Reconcile transactions.
2. Rename the current journal file from `current.journal` to
   `$YEAR.journal`.
3. Create a new `current.journal`.
4. Initialise all accounts on the first of January by transferring from equity.
5. Identify financial goals for the upcoming year.

Here's an example of a (4) transaction setting up the starting
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
    assets:receivable:deposit                                           £1800.00
    ;
    liabilities:creditcard:amex                                        -£2740.00
    liabilities:loan:slc                                              -£26896.25
    liabilities:overdraft:santander:current                            -£2000.00
    ;
    equity
```
