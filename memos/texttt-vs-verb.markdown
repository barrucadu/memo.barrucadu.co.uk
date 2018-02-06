---
title: \texttt{foo} vs \verb#foo#
date: 2017-05-31
tags: latex, writing
audience: Not you.
epistemic_status: Totally unsubstantiated opinions.
---

The LaTeX commands `\texttt` and `\verb` are very similar, but not the same:

- `\verb` uses the next character as the delimiter, not braces
- `\verb` will not break over a line (and will happily encroach into the margin)
- `\verb` (and the `verbatim` environment) in a Beamer slide needs the `fragile` attribute

I tend to prefer `\verb`, as I never want monospaced text to be broken over a line.
