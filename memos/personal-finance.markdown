---
title: Personal Finance
taxon: self-systems
tags: finance, hledger
published: 2018-01-07
modified: 2020-03-15
---

I manage my money using [plain-text accounting][] (specifically,
[hledger][]; though the choice of tool is unimportant), following a
[YNABish][ynab] approach.  The four YNAB rules are:

1. **Give every dollar a job:** money is split into named categories
   don't have any "general savings".
2. **Embrace your true expenses:** large expenses (like a rental
  deposit) are planned and allocated for in advance, as a regular
  monthly contribution.
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
                    - `emergency`---any unexpected large expense not covered by another category
                    - `food`
                    - `gift`
                    - `graze`---monthly [Graze](https://www.graze.com/uk/) subscription
                    - `health`
                    - `household`
                    - `move`---money for any future deposit, moving fees, etc
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
