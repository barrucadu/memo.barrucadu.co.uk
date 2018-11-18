---
title: "Weeknotes: 009"
tags: weeknotes
date: 2018-11-18
audience: General
---

## Ph.D

- Nothing to report.

## Work

- I was on support on Monday and Tuesday, and then again covering for
  someone on Thursday (after they covered one of my days last week).
  I didn't note anything down during those days, so I guess nothing
  exciting happened.  I handled some tickets about [data.gov.uk][] and
  some about duplicate emails, but nothing stands out.

- I started looking into how we tag content.  For "specialist"
  content, like [AAIB reports][], we have this search-style interface
  where you can look through documents and subscribe to a subset of
  them.  But this only applies to documents which are published by our
  [specialist-publisher][] app.  Most of our content is published by
  [whitehall][], and we want to extend this search/subscribe paradigm
  to whitehall content (and, more generally, to all content).

[data.gov.uk]: https://data.gov.uk/
[AAIB reports]: https://www.gov.uk/aaib-reports
[specialist-publisher]: https://github.com/alphagov/specialist-publisher
[whitehall]: https://github.com/alphagov/whitehall

## Miscellaneous

- I was quite surprised to learn that the [Madeleine McCann
  investigation is still receiving funding][], over 10 years on.  I've
  submitted a Freedom of Information request to the Ministry of
  Justice for missing child investigations which are longer-running or
  more expensive than this one.

- I wrote some Elixir.  It seems a nice language.  I got tripped up by
  the syntax a lot, mostly because I kept trying to write Ruby.  I've
  heard a lot that "Elixir is just Erlang with Ruby syntax!", and I
  have no idea why anyone says that because it's not true at all.  It
  has some keywords in common, but most languages have some keywords
  in common.

- I received a letter from a company which said they'd been awarded
  the contract to clean the vents in these flats.  The letter said
  that I hadn't responded to any of their previous letters (which I
  hadn't received), and that they would be getting in touch with the
  council (who own this block of flats) about it if I don't respond to
  this final letter.  I've ignored it.

  If the council are going to award a maintenance contract to some
  company, who then requires access to my flat, I expect to hear from
  the council about it.  It's unlikely this is some sort of elaborate
  scam, but in any case it's not my problem if I didn't receive their
  letters.

- I got an email about a change to the terms of service to my
  Microsoft account, which will take effect on the 28th of December.
  I thought I'd closed my Microsoft account on the 4th this month, so
  I was quite surprised by this.  I looked at the confirmation email I
  received when I "closed" my account, and found it said that my
  account would only be closed on the 3rd of January.

  The email about the new terms linked to [this FAQ][], which says "If
  you do not agree, you can choose to discontinue using the products
  and services, and close your Microsoft account before 28 December
  2018."

  I decided to contact [Microsoft support on Twitter][], having failed
  to find an email address. They referred me to a [Microsoft support
  live chat][], where I spoke to an agent who was less than helpful:

  > **Ferlyn>** Thank you for contacting Microsoft Support. I am
  > Ferlyn May B. How can I help you today?
  >
  > **Ferlyn>** Please be aware that if you switch apps or change
  > focus to another window while working with us, you may get
  > disconnected from your chat session. To ensure the best support
  > experience, please stay active in this chat window.
  >
  > **Me>** I would like to close my account.
  >
  > **Me>** I marked it for closure earlier this month, and received
  > an email saying it would be closed on 1/3/2019. However yesterday
  > I received an email saying that there would be a change to the
  > terms of service effective on the 28th of December, and to close
  > my account before then if I do not agree with them (see
  > https://www.microsoft.com/en-gb/servicesagreement/upcoming-faq.aspx)
  >
  > **Me>** Microsoft Support on Twitter said that there is a 60-day
  > waiting period on closing an account, so it seems I can't actually
  > close my account before the new terms become effective
  >
  > **Felyn>** Thank you for providing me with these pieces of
  > information. Can I have your name and email address?
  >
  > **Me>** Michael Walker, mike@barrucadu.co.uk
  >
  > **Me>** I just filled these in on the form which sent me to this
  > chat, do you not have access to that information?
  >
  > **Felyn>** Thank you for these pieces of information Michael and
  > just to let you know that we don't have the means to check on the
  > status of your request. And since you received an email for the
  > effectivity date of the closing of your account, I highly
  > recommend for you to wait for that date.
  >
  > **Me>** If I wait for that date, it is after the new terms become
  > effective on the 28th of December.
  >
  > **Me>** Are you saying that Microsoft can make people subject to
  > arbitrary legal agreements, by announcing a change in terms too
  > late to close their account?
  >
  > **Felyn>** Its says that by using or accessing our consumer
  > products or services on or after 28 December 2018, this means you
  > are agreeing to the updated Microsoft Services Agreement. If you
  > do not agree, you can choose to discontinue using the products and
  > services, and close your Microsoft account before 28 December
  > 2018.
  >
  > **Me>** Yes. I would like to close my account before the 28th of
  > December 2018.
  >
  > **Me>** However, I cannot, as Microsoft Support on Twitter have
  > told me that there is a 60-day waiting period to close an account.
  >
  > **Felyn>** You already have a request to close the account. It is
  > already on the process and the email with the effectivity date
  > proves that.
  >
  > **Me>** The effectivity date is after the 28th of December 2018
  > though
  >
  > **Felyn>** You may also discontinue using the product and services
  > indicated in that link as well.
  >
  > **Me>** And I received the email about the new terms after I had
  > already made the request to close my account
  >
  > **Felyn>** Dec 28 pertains to a different matter which is the
  > updated Microsoft Services Agreement and not with the request to
  > close your account.
  >
  > **Me>** I know.
  >
  > **Me>** I would like my account to be closed before the new
  > services agreement comes into effect. The FAQ says that I can do
  > that.
  >
  > **Felyn>** The other email is just an update or helpful
  > information if you wish to keep your account active.
  >
  > **Felyn>** My apologies however their is a fix time frame of 60
  > days before closing your account.
  >
  > **Felyn>** You may refer to this link for this detail:
  >
  > **Felyn>**
  > https://support.microsoft.com/en-gb/help/12412/microsoft-account-how-to-close-account
  >
  > **Me>** Then why does the FAQ say that an account can be closed
  > before the new terms come into effect?
  >
  > **Felyn>** I understand that is pertaining to customers who are
  > still using their accounts and Microsoft product and services.,
  > But on your case, you already have an existing request to close
  > your account. You also received an email for the effectivity date.
  >
  > **Felyn>** Please wait until then or you if you wish, you can
  > simply file another request to close your account.
  >
  > **Felyn>** https://account.live.com/closeaccount.aspx
  >
  > **Felyn>** Your Microsoft expert Ferlyn May B has ended your chat
  > session. Thanks for visiting Microsoft Support.

  I've now got back in touch with them on Twitter to ask if there is
  anyone else I can contact.  If not, I'm not sure who I should
  contact next---maybe the Information Commissioner's Office?

  To clarify, I don't disagree with the new terms.  I haven't even
  read them, but I assume there's nothing particularly objectionable
  in them.  But it's principle of the thing: if an email tells me to
  close my account before a given date if I disagree with the new
  terms, I should be able to close my account before that date.

[Madeleine McCann investigation is still receiving funding]: https://www.bbc.co.uk/news/uk-43550383
[this FAQ]: https://www.microsoft.com/en-gb/servicesagreement/upcoming-faq.aspx
[Microsoft support on Twitter]: https://twitter.com/barrucadu/status/1063883762067521536
[Microsoft support live chat]: https://partner.support.services.microsoft.com/en-us/contact/form/23/msa/

## Link Roundup

- [Enthusiasts vs. Pragmatists: two types of programmers and how they fail](https://codewithoutrules.com/2018/11/12/enthusiasts-vs-pragmatists/)
- [How a Nigerian ISP Accidentally Knocked Google Offline](https://blog.cloudflare.com/how-a-nigerian-isp-knocked-google-offline/)
- [Issue 133 :: Haskell Weekly](https://haskellweekly.news/issues/133.html)
- [Linux Load Averages: Solving the Mystery](http://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html)
- [Medium is a poor choice for blogging](https://medium.com/@nikitonsky/medium-is-a-poor-choice-for-blogging-bb0048d19133)
- [Pleroma, LitePub, ActivityPub and JSON-LD](https://blog.dereferenced.org/pleroma-litepub-activitypub-and-json-ld)
- [This Week in Rust 260](https://this-week-in-rust.org/blog/2018/11/13/this-week-in-rust-260/)
- [mxgmn/WaveFunctionCollapse](https://github.com/mxgmn/WaveFunctionCollapse/)
