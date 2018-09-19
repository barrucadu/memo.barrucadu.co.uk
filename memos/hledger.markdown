---
title: hledger
tags: finance, hledger, howto
date: 2017-09-29
deprecated_by: personal-finance
audience: Narrow
notice: You may get something out of this if you're rethinking how you manage your finances.
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


Journal Files
-------------

My journal files are shared with [syncthing](https://syncthing.net/), so I can add transactions from
any machine.

I have a few files:

- "current.journal" is the journal for the current year, structured as an org datetree (even though
  it's not an org file).
- "$YEAR.journal" is the journal for the named year.
- "future.journal" is the journal for the next year, which only includes big things I am certain of,
  like rent payments for a signed contract.


Accounts
--------

I have a number of accounts, some few of which are actual accounts (in **bold**), but most of which
are "virtual" accounts (in *italic*), which I use to get better insights into the flow of my money.

- assets: money I have
    - cash: easily-accessible money
        - **hand:** money in my wallet
        - **paypal:** money in my paypal account
        - santander: money in my Santander accounts
            - **esaver:** money in my esaver account (one subaccount per earmaked purpose)
                - (eg) *rainyday:* saved for a non-specific future "rainy day"
            - **current:** money in my current account (including overdraft)
                - *accum:* see the Budgeting section.
                - *month:* see the Budgeting section.
                - *saved:* money put aside for a specific transaction, such as rent.
                - *unallocated:* money in my current account not allocated for anything in
                  particular.
    - investments: money in the hands of an investment broker
        - cavendish: money with Cavendish Online
            - **s&s:** my stocks&shares ISA.
    - reimbursements: money people owe me (one subaccount per person)
        - (eg) *nathan:* money Nathan owes me
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

Transactions are of the form:

```
$MONTH/$DAY $PAYEE
    $POSTINGS...
```

Transactions purely between virtual accounts get a `!` between the date and the
description. Transactions reconciled at the end of the month get a `*`.


Budgeting
---------

The "accum" and "month" virtual accounts are the most important, as they give me a constant
awareness of how much I have spent on a particular class of thing. I don't often exceed my budget,
because when I go to spend some budgeted money there's now a little voice in the back of my mind
which asks "can you actually afford this?".

There are five "month" accounts which get set to a fixed value at the start of each month:

- *food:* everything edible; groceries, takeaways, snacks, restaurants, etc
- *google apps:* archhurd.org's google apps account
- *household:* a general hodgepodge of things which I need but don't really fall into a sensible
  collection; toiletries, laundry, kitchen equipment, etc
- *servers:* fairly self explanatory.

And there are two "accum" accounts which get a fixed amount transferred to them at the start of each
month (accumulating unspent money):

- *fun:* entertainment; games, swing dance, etc
- *other:* anything not covered by another category


Forecasting
-----------

I use a relatively simple forecasting process. For every month up until the end of the year (or
maybe until the middle of the next year, if we're near the end of this one), I add transactions:

- For every income (eg, internship payment) I am *certain* of
- For every expense (eg, rent) I am *reasonably confident* of
- Spending the entire budget
- Handling any expected movement between accounts (eg, current account to ISA)

This gives me a reasonably accurate, perhaps slightly pessimistic, forecast of my finances. The
confidence threshold for including expenses is lower than for including income, which is
pessimistic; but I assume I will never overspend my budget, which is typical but not certain.

### An Example Month

Here is the sort of thing that will go in a monthly entry. Of course some things, like rent and
tuition, will be more or less frequent than others:

```
10/01 Budget & Saving
    accum:fun           £25
    accum:other         £75
    month:food        £200
    month:google apps   £2.75
    month:household    £25
    month:servers      £39.50
    saved:invest      £400
    unallocated

10/01 Linode
    expenses:servers  $20 @@ £18
    expenses:servers          £1.25
    month:servers

10/01 OVH
    expenses:servers  EUR 20.39 @@ £18.05
    expenses:servers                £1.25
    month:servers

10/02 Arch Hurd Google Apps
    expenses:google apps  £2.75
    month:google apps

10/06 Dad money
    unallocated  £650
    income:dad

10/07 Holgate rent
    expenses:rent  £1045
    saved:rent

10/24 Dentist
    expenses:other  £18.80
    unallocated

10/31 Tuition
    expenses:tuition  £1398
    saved:tuition
```

Most months are the same, so adding these sets of transactions for every month remaining in the year
takes very little time.


Start/End of X Procedure
------------------------

### Year

1. Zero all accounts by transferring everything into equity.
2. Rename the current journal file from "current.journal" to "$YEAR.journal"
3. Take the "future.journal" and rename to "current.journal".
4. Add forecasting transactions for the new year
5. Initialise all accounts on the first of January by transferring from equity.

If starting a new journal file, this is the template:

```
alias current = assets:cash:santander:current
alias budget  = current:month
alias saved   = current:saved
alias accum   = current:accum
alias unallocated = current:unallocated

* $YEAR
Y$YEAR
** $YEAR-01 January
** $YEAR-02 February
** $YEAR-03 March
** $YEAR-04 April
** $YEAR-05 May
** $YEAR-06 June
** $YEAR-07 July
** $YEAR-08 August
** $YEAR-09 September
** $YEAR-10 October
** $YEAR-11 November
** $YEAR-12 December
```

Here are example equity transactions:

```
01/01 ! Start-of-year (assets)
    assets:cash:hand                £77.81
    assets:reimbursements:nathan     £9.98
    saved:rainyday                  £74.90
    saved:rent                    £1800
    saved:tuition                 £2060
    unallocated                    £904.92
    equity:carried forward

01/01 ! Start-of-year (liabilities)
    liabilities:overdraft   -£2000
    liabilities:slc        -£28510.01
    liabilities:teasoc         -£1
    equity:liabilities
```

### Month

1. Reconcile the transactions of the month just ended:
    - For every transaction in the online bank statement, find the corresponding journal transaction
      and mark it.
        - If there are transactions missing from the journal, add and mark them.
        - If there are transactions missing from the bank statement, the bank is being slow;
          add posting dates and reconcile as they come in.
        - If the bank balance is below the **assets:cash:santander:current** balance, even
          discarding uncleared transactions, (a) figure out what happened and (b) if impossible, add
          a transaction to *expenses:adjustment*
    - Count the balance in my wallet and mark all **assets:cash:hand** transactions.
        - If the wallet balance is below the **assets:cash:hand** balance, add a transaction to
          *expenses:adjustment*
2. Zero the monthly budget by adding transactions to the month just started:
    - Transfer "month" accounts into *unallocated*
    - If there was an overspend, zero by transferring from *unallocated*
3. Delete the pessimistic budget-spending transaction of the month just started.
4. Comment all transactions in the month just started other than the budget set-up.
    - Uncomment these as they happen. From now, the balance reported for the current month is the
      current actual balance.

Here are example end-of-month transactions:

```
03/31 * Wallet adjustment
    expenses:adjustment  £14.98
    assets:cash:hand

04/01 ! Remaining budget
    month:food        £24.70
    month:fun        £112
    month:household   -£9.12
    month:servers     -£2.01
    month:anything

04/01 ! Budget overspend
    month:anything  £125.57
    unallocated
```

Ideally, there should be no transaction adjusting the balance.
