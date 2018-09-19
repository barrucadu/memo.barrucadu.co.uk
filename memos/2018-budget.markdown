---
title: I Need A Budget
tags: finance, hledger, howto
date: 2017-12-16
audience: General
notice: You may get something out of this if you're rethinking how you manage your finances.
---

It's hard to believe it's only been around a year and a half since I
started budgeting and rigorously tracking my finances.  It's truly
been life-changing.  But, with the end of my Ph.D looming, my
financial situation is soon to change.  I can expect both my income
and expenses to increase significantly, and I have my doubts that my
current system will scale.

So this is a post about how I plan to manage my finances in 2018, with
a YNAB ([You Need a Budget][1]) inspired approach.  But first, let's
talk about budgeting in general and how I've done it in 2017.

## Budgeting for Dummies

A budget is a model of your financial situation and how it changes
over time.  A budget is an abstraction which doesn't need to exactly
match reality.  For example, your bank account is one big pot of
money, but in your budget you might divide that pot up into different
categories for different expenses: rent, bills, food, and so on.
Those categories don't really exist---your bank won't stop you from
buying a sandwich if you've still got money in your account, just
because you've exhausted your food budget---but they help you to think
about your finances.

Creating a basic budget has three steps:

1. **Recording:** it's essential to know where your money is going
   before you can try to change your habits.  So for a month or two,
   just note down every transaction you make.  Round to pounds or tens
   of pounds if you don't care about being exact: the level of detail
   is up to you.

2. **Categorising:** now that you have a month or two of transactions,
   go through them and assign them to categories.  How you break
   things up is up to you, but here are some categories you'll
   probably want to start with: rent, bills, food, and social.

3. **Planning:** now look at how much you spend on each category in a
   month.  Is there anything surprising?  Does your daily sandwich
   from the café near work add up to more than you were expecting?
   Pick an amount for each category: this is your budget.  This is
   also the time to think about changing your behaviour.  Perhaps you
   should try making lunch once or twice a week to save some money
   that way.  Perhaps you should start putting some money aside every
   month for an upcoming large expense.  What do you want?

Most importantly, don't beat yourself up when things go wrong.  You
will go over your budget on occasion.  Just accept that, adjust the
budget, and try not to do it again.  If you're regularly going over,
perhaps you didn't allocate enough to that category in the first
place.

You're just starting out, it would be strange not to make mistakes!


## The Poor Postgrad System

Let's talk about my 2017 system.  It's worked pretty well for me, and
is a significant modification of the system I came up with when I
first started in mid-2016.  I use [hledger][2] to manage everything,
but this should be transferable to any [double-entry accounting
system][3].

I have a number of accounts, grouped into four categories:

- **Assets:** what I have or am owed.
- **Liabilities:** what I owe.
- **Income:** money moves out of here and into assets.
- **Expenses:** money moves out of assets and into here.

The **assets** category is then broken down into three subcategories:

- **Cash:** normal bank accounts, my PayPal account, and my wallet.
- **Investments:** my Stocks and Shares ISA.
- **Reimbursements:** money people owe me.

Let's have some examples.  hledger is a plain-text accounting tool, so
transactions are described in a simple text file like so:

```
2017/09/28 Overleaf
    assets:cash:santander:current  £1783.40
    expenses:tax:income             £257
    expenses:tax:ni                 £195.60
    liabilities:slc                  £74
    income:overleaf               -£2310
```

This transaction is recording the pay I got from [Overleaf][4] in
September.  The first line has a date and a description.  The indented
lines are called *postings*, and each adjusts the balance of an
account.  Overleaf paid me a total of £2310, of which I saw £1783.40.
The rest goes to tax (£257 in income tax and £195.60 in national
insurance) and the Student Loan Company (£74).

The income amount is negative because transactions need to balance:
the postings must sum to zero.  Plain-text double-entry accounting
uses signed amounts rather than the traditional debit and credit
system.  I found it pretty intuitive to get started with, but someone
from a more traditional accounting background might need to mentally
adjust.

Here's how I record investing some money in my ISA, which is provided
by Cavendish Online and managed by Fidelity:

```
2017/08/01 Fidelity
    assets:investments:cavendish:s&s  31.19 MCOUA @@ £50
    assets:investments:cavendish:s&s  65.15 MCMEA @@ £100
    assets:investments:cavendish:s&s   7.15 MHMIA @@ £50
    assets:investments:cavendish:s&s   2.56 VADEA @@ £800
    assets:cash:santander:current  -£1000
```

Here I'm removing cash from my Santander current account to buy
commodities in my ISA.  I'm buying units in four different funds
("MCOUA", "MCMEA", "MHMIA", and "VADEA") for the listed amounts.  So,
I'm spending £50 of my £1000 total to get 31.19 units of MCOUA.
Account and commodity names are arbitrary, they are created when first
named; there's no need to declare them up front.

Finally, here's how I record an expense:

```
2017/11/26 Amazon
    expenses:books  £12.98
    assets:cash:santander:current
```

A single amount can be omitted, hledger can calculate it because it
knows transactions must balance.  For transactions with more than two
real-world accounts involved, I like to include all the amounts to
make sure I haven't made a mistake.

**Budgeting:** ok, that's the basic workflow, so now on to how I
budget on top of this.  Well, firstly, I don't have transactions to or
from `assets:cash:santander:current`, I have a bunch of subaccounts.
These aren't *real* accounts, they don't correspond to anything
Santander knows about, they are just to help me manage things.

I have four subaccounts:

- **Accum:** "accumulating" budgets, I add a fixed amount of money to
  each subaccount of this every month, and any unspent rolls over.
- **Month:** the normal monthly budgets, I top each subaccount of this
  up to a predetermined amount every month.
- **Saved:** money put aside for specific purposes.
- **Unallocated:** money not budgeted or saved yet.

My income goes into the unallocated account:

```
2017/09/28 Overleaf
    current:unallocated  £1783.40
    expenses:tax:income   £257
    expenses:tax:ni       £195.60
    liabilities:slc        £74
    income:overleaf     -£2310
```

I have `current` defined as an alias for
`assets:cash:santander:current`, because typing that out would be
tedious.

At the start of every month I distribute some money to my budget
accounts:

```
2017/12/01 Budget underspend
    current:month:household  -£14.30
    current:month:servers     -£3.94
    current:unallocated

2017/12/01 Budget
    current:accum:fun        £25
    current:accum:other      £75
    current:month:food      £250
    current:month:household  £30
    current:month:servers    £39.50
    current:unallocated
```

As you can see in the first transaction, I clear out any unspent
budget from the **month** accounts first.  I don't bother including
the amount for `current:unallocated` as the postings here all refer to
the same real-world account (my Santander current account).

I also include every future transaction I know about: rent, tuition,
dentist appointments, and so on.  I can forecast by assuming I spend
my entire budget every month, which is a pessimistic assumption (the
best sort of assumption to make in financial planning).  If the
balance of `current:unallocated` is always nonzero, I have enough
money.

That's it!


## The Employed Programmer System

The 2017 system is simple, and works well because I have a low
cashflow.  I don't have much income, but I don't have many expenses
either.  But the way I use the **saved** and **unallocated** accounts
leaves much to be desired.

**Savings:** I have a `current:saved:rent` account, which is always
enough to pay the next rent instalment.  When I do pay rent, money
comes out of there (and goes to `expenses:rent`), and I top it up
again from the unallocated money.  Because my rent is not monthly, but
rather in four instalments across the year, it's been easy to be lazy
and justify not bothering to save for multiple instalments at once.

**Purpose:** the **unallocated** account serves at least three
purposes at the moment: it's where income goes to, it's where my
budget and savings come from, and it's where cash I withdraw comes
from.  Again, this works because my cashflow is low, but if I'm
dealing with a monthly cashflow in the thousands rather than the
hundreds, having everything go through a single account sounds like a
recipe for error.

**The 2018 system:** so to manage my money next year, I'm using a
YNAB-style allocation of cash to categories.  The four YNAB rules are:

1. **Give every dollar a job:** allocate money as soon as you get it.
2. **Embrace your true expenses:** budget for uncommon expenses before
   they happen, not when.
3. **Roll with the punches:** be flexible and update your budget as
   you need to.
4. **Age your money:** only spend money that is at least 30 days old.

Rather than have a catch-all account which income goes to before being
distributed elsewhere, I'm just going to distribute income directly.
Pay day looks something like this:[^1]

[^1]: This is an estimate assuming I get a certain job.  There's some
    slack in the budget so I can manage making a bit less than this.
    When I have a job offer, I'll update everything and see what
    adjustments need to be made.

```
2018/06/29 Job
    current:saved:household   £50
    current:saved:invest     £200
    current:saved:monthly    £500
    current:saved:rent      £1500
    current:saved:utilities  £200
    current:saved:web         £50
    income:job             -£2500
```

By saving a little more than a month's expenses in each category, I
will gradually build up a buffer so I'm not living
paycheck-to-paycheck.  When I hit three months expenses saved, I'm
going to adjust this income allocation and put the excess towards
something else.  For things that aren't a fixed monthly expense (like
healthcare: medicine, dentist trips, and so on), I'm going to maintain
a minimum balance which gets topped up when I spend some of it.

I still want to limit my monthly spending on things like food, while
also building up a savings buffer.  I've opted to handle this with
separate accounts.  A savings account for monthly expenses, from which
I draw a fixed amount for my monthly budget categories:

```
2018/07/01 Budget
    current:month:food  £225
    current:month:fun    £50
    current:month:other  £75
    current:saved:monthly
```

I'm also switching all my monthly budgets to accumulating budgets,
rolling over any unspent money.  After doing it for a while, I don't
think there's much point in not allowing extra spending in a month if
I underspent previously.  The average monthly expenditure is still
limited.

Finally, I've set aside an amount of money to withdraw as cash.  This
account is going to start at £100, and I'll top it up every time I
budget a cash expense, like so:

```
2018/01/01 Withdraw
    assets:cash:hand  £50
    current:float

; ...

2018/01/12 Morrisons
    expenses:food  £32
    assets:cash:hand

2018/01/12 Cash spend
    current:float  £32
    current:month:food
```

This limits the maximum amount of cash I can withdraw without spending
it in some budgeted category.  Needing an extra transaction may look
tedious, but I currently do the same thing with `current:unallocated`,
so I'm used to it.  In practice I buy most things with my debit card,
cash transactions are infrequent enough such that it's not much of a
pain.

**Isn't predicting the future bad?** A standard piece of financial
advice is to not try to predict the future.  And here I am, with my
plan for all of 2018, when I don't even have a job offer yet.  Pure
speculation!

The point of budgeting is to introduce artificial scarcity into your
finances.  Scarcity makes us better at planning.  Introducing
abundance by assuming favourable things happen defeats the point.

I think predicting the future can be fine, as long as you're aware
that that is what you're doing and that things may work out worse than
you'd like.  If you can still afford everything with pessimistic
assumptions (expenses are large and early in the month, income is
small and late in the month), then you're probably in a good position.
I admit, I've assumed a good income.  So, here are my assumptions:

1. A one-time moving cost of £250.
2. Monthly take-home pay of £2500 (after tax and pension
   contributions).
3. Monthly rent of £1200, with a £1600 one-time deposit.
4. Monthly council tax of £100.
5. Monthly utilities bill (total) of £185, with a £100 one-time set-up
   fee.
6. Monthly living costs (food, entertainment, etc) of £350.
7. Monthly server costs of £40.

The living costs and server costs are based on my current budget, but
everything else is a best guess based on the evidence I could find.
If we ignore the one-time costs, my monthly expenses come to £1875,
which is rather below my income.  This is based on living by myself.
If I live with a housemate, rent and bills would roughly half.  So
there's quite a bit of room.

The most dangerous time is the first six months of the year.  I'll get
my first paycheck at the end of April, but before then I'll have to
pay all the one-time costs and one or two months rent, depending on
what the timings are.  Furthermore, my £2000 overdraft goes away in
June so I need to have the spare cash to pay that off.  I've worked
out two forecasts with different rent timings, to make sure I can
afford both.

So while there is a lot of speculation, and money allocations will
undoubtedly change as I progress through next year, doing this
exercise has given me a lot of peace of mind.

[1]: https://www.youneedabudget.com/method/
[2]: http://hledger.org/
[3]: https://en.wikipedia.org/wiki/Double-entry_bookkeeping_system
[4]: https://www.overleaf.com/
