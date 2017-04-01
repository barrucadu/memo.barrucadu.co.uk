---
title: hledger
tags: finance, howto
date: 2017-04-01
---

Since about June 2016 I have been using [hledger](http://hledger.org/) to track my finances. How I
do so has evolved, this memo documents the current process.

**Pros:**

- Makes me more conscious of my spending.
- Lets me see how my spending has changed over time.
- Lets me forecast reasonably easily.
- Way less cumbersome than the massive 7-year spreadsheet I used to use.

**Cons:**

- Not so great for getting insights like "wow, I spent a lot on takeaways last month": I can get
  that data fairly easily, but there isn't really an unconscious awareness of it like there is with
  (eg) food spending in general.


Accounts
--------

I have a number of accounts, some few of which are actual accounts (in **bold**), but most of which
are "virtual" accounts (in *italic*), which I use to get better insights into the flow of my money.

- assets: money I have
    - **hand:** money in my wallet
    - owed: money people owe me (one subaccount per person)
        - (eg) *nathan:* money Nathan owes me
    - santander: money in my Santander accounts
        - **esaver:** money in my esaver account (one subaccount per earmaked purpose)
            - (eg) *rainyday:* saved for a non-specific future "rainy day"
        - **main:** money in my current account (including overdraft)
            - *budget:* money earmarked for a specific short-term expense, such as food (see the
              Budgeting section)
            - *saved:* money earmarked for a specific long-term expense, such as rent (slowly being
              moved into the esaver account)
            - *unallocated:* money in my current account neither budgeted nor saved for specific
              purposes
- equity: used in the start and end of year procedures
- expenses: used to track expenses of different sorts (one subaccount per use)
    - (eg) *books:* money spent on books
- income: used to track income of different sorts (one subaccount per use)
    - (eg) *interest:* bank interest
- liabilities: money I owe people
    - *overdraft:* my bank overdraft, treated as a liability so I remember it's not free money.
    - *slc:* my student loans


Transactions
------------

Most of my transactions fall into one of a few types, so I make heavy use
of [m4](https://memo.barrucadu.co.uk/m4-is-good.html) macros to simplify the ledger.

Most transactions are of the form:

```
$MONTH/$DAY $DESCRIPTION
    $MACRO($ARGS...)
```

Transactions purely between virtual accounts get a `!` between the date and the
description. Transactions reconciled at the end of the month get a `*`.

The macros:

- `bank_spend(account, amount)`: transaction from *unallocated* to *expenses:`$ACCOUNT`*
- `bank_save(account, amount)`: transaction from *saved:`$ACCOUNT`* to *esaver:`$ACCOUNT`*
- `budget_spend(account, amount)`: transaction from *budget:`$ACCOUNT`* to *expenses:$ACCOUNT*
- `saved_spend(account, amount)`: transaction from *saved:`$ACCOUNT`* to *expenses:`$ACCOUNT`*
- `income_from(account, amount)`: transaction from *income:`$ACCOUNT`* to *unallocated*
- `income_from_to(account1, account2, amount)`: transaction from *income:`$ACCOUNT1`* to
  `$ACCOUNT2`
- `cash_spend(account, amount)`: transaction from **assets:hand** to *expenses:`$ACCOUNT`*
- `cash_withdraw(amount)`: transaction from *unallocated* to **assets:hand**
- `cash_budget_spend(account, amount)`: transaction from *budget:`$ACCOUNT`* to
  *expenses:`$ACCOUNT`*, via **assets:hand**
- `foreign_spend(account, foreign_amount, domestic_amount[, transaction fee])`: transaction from
  *unallocated* to *expenses:`$ACCOUNT`* in foreign currency, with an optional transaction fee
- `foreign_budget_spend(account, foreign_amount, domestic_amount[, transaction fee])`: transaction
  from *budget:`$ACCOUNT`* to *expenses:`$ACCOUNT`* in foreign currency, with an optional
  transaction fee


Budgeting
---------

The budget virtual accounts are the most important, as they give me a constant awareness of how much
I have spent on a particular class of thing. I don't often exceed my budget, because when I go to
spend some budgeted money there's now a little voice in the back of my mind which asks "can you
actually afford this?".

There are five budget accounts which get topped up every month:

- *food:* everything edible; groceries, takeaways, snacks, restaurants, etc
- *fun:* entertainment; games, swing dance, etc
- *google apps:* archhurd.org's google apps account
- *household:* a general hodgepodge of things which I need but don't really fall into a sensible
  collection; toiletries, laundry, kitchen equipment, etc
- *servers:* fairly self explanatory.

And one special account (see the end of month procedure):

- *anything:* can be used for anything which calls into the above categories, but would cause an overspend


Forecasting
-----------

I use a relatively simple forecasting process. For every month up until the end of the year (or
maybe until the middle of the next year, if we're near the end of this one), I add transactions:

- For every income (eg, internship payment) I am *certain* of
- For every expense (eg, rent) I am *reasonably confident* of
- Spending the entire budget
- Handling any expected movement between accounts (eg, current account to esaver)

This gives me a reasonably accurate, perhaps slightly pessimistic, forecast of my finances. The
confidence threshold for including expenses is lower than for including income, which is
pessimistic; but I assume I will never overspend my budget, which is typical but not certain.

### An Example Month

Here is the sort of thing that will go in a monthly entry. Of course some things, like rent and
tuition, will be more or less frequent than others:

```
10/01 Budget & Saving
    standard_budget
    saved:tuition  £1350
    unallocated

10/01 eSaver monthly
    bank_save(special, £200)

10/01 Clear budget
    budget_spend(food, £250)
    budget_spend(fun, £25)
    budget_spend(household, £25)

10/01 Servers
    foreign_budget_spend(servers, $20, £18, £1.25)
    foreign_budget_spend(servers, $15, £13, £1.25)

10/02 Arch Hurd Google Apps
    budget_spend([google apps], £2.75)

10/06 Dad money
    income_from(dad, £650)

10/07 Holgate rent
    saved_spend(rent, £1045)

10/31 Tuition
    saved_spend(tuition, £1350)
```

Most months are the same, so adding these sets of transactions for every month remaining in the year
takes very little time.


Start/End of X Procedure
------------------------

### Year

1. Zero all accounts by transferring everything into *equity:closing*
2. Rename the current journal file from "current.journal" to "$YEAR.journal"
    - The ".m4" file can be kept if desired, but is now unimportant
3. If there is a "future.journal.m4" rename that to "current.journal.m4" else make a new file
    - If there is a "future.journal" use that and m4 it up
4. Add forecasting transactions for the new year
5. Initialise all accounts on the first of January by transferring from *equity:opening*

If starting a new journal file, this is the template:

```
; -*- mode: ledger -*-
divert(-1)
include(`macros.m4')
define(`standard_budget', `budget:food  £250
    budget:fun  £25
    budget:google apps  £2.75
    budget:household  £25
    budget:linode  £20
    unallocated  -£322.75')
changequote(`[', `]')
divert(0)dnl
alias main   = assets:santander:main
alias esaver = assets:santander:esaver
alias isa    = assets:santander:isa
alias budget      = main:budget
alias saved       = main:saved
alias unallocated = main:unallocated

* Journal for $YEAR

Y$YEAR

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

Here is an example *equity:opening* transaction:

```
01/01 ! Start-of-year
    assets:hand  £77.81
    assets:owed:nathan  £9.98
    saved:rainyday  £74.90
    saved:rent  £1800
    saved:tuition  £2060
    unallocated  £904.92
    liabilities:overdraft  -£2000
    liabilities:slc  -£28510.01
    liabilities:teasoc  -£1
    equity:opening
```

### Month

1. Reconcile the transactions of the month just ended:
    - For every transaction in the online bank statement, find the corresponding journal transaction
      and mark it.
        - If there are transactions missing from the journal, add and mark them.
        - If there are transactions missing from the bank statement, the bank is being slow;
          reconcile at the end of the month just started.
        - If the bank balance is below the **assets:santander:main** balance, even discarding
          uncleared transactions, (a) figure out what happened and (b) if impossible, add a
          transaction to *expenses:adjustment*
    - Count the balance in my wallet and mark all **assets:hand** transactions.
        - If the wallet balance is below the **assets:hand** balance, add a transaction to
          *expenses:adjustment*
2. Zero all budget accounts by transferring into *budget:anything*.
3. If there was a budget overspend, zero by transferring from *unallocated*.
4. Delete the pessimistic budget-spending transaction of the month just started.
5. Comment all transactions in the month just started other than the budget set-up.
    - Uncomment these as they happen. From now, the balance reported for the current month is the
      current actual balance.

Here are example end-of-month transactions:

```
03/31 * Wallet adjustment
    cash_spend(adjustment, £14.98)

03/31 ! Remaining budget
    budget:domains  -£0.74
    budget:food  £24.70
    budget:fun  £112
    budget:household  -£9.12
    budget:linode  -£2.01
    budget:anything

03/31 ! Budget overspend
    budget:anything  £124.83
    unallocated
```

Ideally, there should be no transaction adjusting the balance.
