---
title: M4 is Good
tags: m4, programming
date: 2017-03-31
---

So you're about to type something repetitive for the 20th time are you? Wait!

Repetition is bad:

- It vastly increases the chance of accidental mistakes.
- It wastes time.
- It wastes space.
- It vastly increases the chance of accdental mistakes.


Consider using `m4` for your repetitive text needs
--------------------------------------------------

`m4` is available on pretty much every system and is a pretty sweet macro system. Much nicer than
cpp! For example, here's the result of me `m4`-ing up my [hledger](http://hledger.org/) journal
file:

**Before:**

```
01/05 * Dad money
    unallocated  £650
    income:dad  -£650

01/06 * Shopping
    expenses:food  £4.03
    budget:food  -£4.03
    assets:hand  -£4.03
    unallocated  £4.03

01/08 * Withdrawal
    assets:hand  £40
    unallocated  -£40
```

**After:**

```
01/05 * Dad money
    income_from(dad, £650)

01/06 * Shopping
    cash_budget_spend(food, £4.03)

01/08 * Withdrawal
    cash_withdraw(£40)
```

So much simpler!

Use `m4`.
