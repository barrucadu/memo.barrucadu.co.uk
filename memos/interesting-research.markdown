---
title: Interesting Research
tags: research
date: 2017-11-20
---

Sources
-------

### Groups

- [ACM Special Interest Group on Algorithms and Computation Theory](http://www.sigact.org) (ACM SIGACT)
- [ACM Special Interest Group on Programming Languages](http://www.sigplan.org) (ACM SIGPLAN)
- [ACM Special Interest Group on Software Engineering](http://www.sigsoft.org) (ACM SIGSOFT)
- [IFIP Working Group 2.8](http://www.cs.ox.ac.uk/ralf.hinze/WG2.8)
- [Research in Software Engineering](https://www.microsoft.com/en-us/research/group/research-in-software-engineering-rise/) (RiSE)

### Journals

- [Journal of Functional Programming](https://www.cambridge.org/core/journals/journal-of-functional-programming) (JFP)
- [Transactions on Parallel Computing](http://topc.acm.org) (TOPC)

### Events

- [Conference on Systems, Programming, Languages and Applications: Software for Humanity](http://splashcon.org) (SPLASH)
- [Conference on Programming Language Design and Implementation](http://conf.researchr.org/series/pldi) (PLDI)
- [Dagstuhl](https://www.dagstuhl.de)
- [International Conference on Automated Software Engineering](http://ase-conferences.org) (ASA)
- International Conference on Distributed Computing Systems (ICDCS)
- [International Conference on Functional Programming](http://www.icfpconference.org) (ICFP)
    - [Commercial Users of Functional Programming](http://cufp.org) (CUFP)
    - [Haskell Implementors Workshop](https://wiki.haskell.org/HaskellImplementorsWorkshop) (HIW)
    - [Haskell Symposium / Symposium on Haskell](https://www.haskell.org/haskell-symposium) (Haskell)
- [International Conference on Runtime Verification](http://runtime-verification.org) (RV)
- [International Conference on Testing Software and Systems](https://sites.google.com/site/ictssmain/home) (ICTSS)
- International Conference on Tests and Proofs (TAP)
- [International Symposium on Distributed Computing](http://www.disc-conference.org/wp) (DISC)
- [International Symposium on Memory Management](http://conf.researchr.org/series/ismm) (ISMM)
- [International Symposium on Software Testing and Analysis](http://conf.researchr.org/series/issta) (ISSTA)
- [Joint European Software Engineering Conference and Symposium on the Foundations of Software Engineering](http://www.esec-fse.org) (ESEC/FSE)
- [Principles and Practice of Parallel Programming](http://conf.researchr.org/series/PPoPP) (PPoPP)
- South of England Regional Programming Language Seminar (S-REPLS)
- [Symposium on Principles of Distributed Computing](http://www.podc.org) (PODC)
- [Symposium on Principles of Programming Languages](http://conf.researchr.org/series/POPL) (POPL)

### Mailing lists

- [Haskell](https://mail.haskell.org/cgi-bin/mailman/listinfo/haskell)
- [SREPLS](https://www.jiscmail.ac.uk/cgi-bin/webadmin?A0=SREPLS)

### Blogs

- [The Morning Paper](https://blog.acolyer.org/)


Topics
------

### Swarm testing

Rather than hand-tune a configuration for a complex testing tool (eg, Csmith), generate a diverse
set of random configurations and try them, possibly in parallel. In principle, this will lead to a
better exploration of the space than just one configuration.

#### People

- **[Alex Groce](http://www.cs.cmu.edu/~agroce)**[^bold]
- Arpit Christi
- Chaoqiang Zhang
- [Eric Eide](http://www.cs.utah.edu/~eeide)
- [John Regehr](http://www.cs.utah.edu/~regehr)
- [Mohammad Amin Alipour](http://alipourm.github.io)
- [Rahul Gopinath](https://rahul.gopinath.org)
- [Yang Chen](http://www.cs.utah.edu/~chenyang)

#### Papers

- **Swarm Testing** ([pdf](http://www.cs.cmu.edu/~agroce/issta12.pdf))<br>
    Alex Groce, Chaoqiang Zhang, Eric Eide, Yang Chen, and John Regehr.<br>
    In *International Symposium on Software Testing and Analysis* (ISSTA). 2012.

- **Generating Focused Random Tests Using Directed Swarm Testing** ([pdf](http://www.cs.cmu.edu/~agroce/issta16.pdf))<br>
    Mohammad Amin Alipour, Alex Groce, Rahul Gopinath, and Arpit Christi.<br>
    In *International Symposium on Software Testing and Analysis* (ISSTA). 2016.

#### Venues

- International Symposium on Software Testing and Analysis (ISSTA)

[^bold]: **Bold people** are those who, at the time of writing, I considered to be key figures in the field to keep an eye on.

### Systematic concurrency testing (SCT)

Deterministic testing for concurrent programs, by controlling the scheduling decisions made to
intelligently explore the state space.  Can be complete or incomplete. Draws from model checking and
program verification.

#### People

- **[Alastair F. Donaldson](http://multicore.doc.ic.ac.uk/people/ally-donaldson/)**
- **[Chao Wang](http://www-bcf.usc.edu/~wang626)**
- **[Jeff Huang](https://parasol.tamu.edu/~jeff/)**
- **[Koushik Sen](https://people.eecs.berkeley.edu/~ksen)**
- **[Madanlal (Madan) Musuvathi](https://www.microsoft.com/en-us/research/people/madanm)**
- **[Patrice Godefroid](http://research.microsoft.com/en-us/um/people/pg)**
- **[Sebastian Burckhardt](https://www.microsoft.com/en-us/research/people/sburckha)**
- **[Shaz Qadeer](https://www.microsoft.com/en-us/research/people/qadeer)**
- [Adam Betts](http://www.doc.ic.ac.uk/~abetts/)
- [Akash Lal](https://www.microsoft.com/en-us/research/people/akashl)
- [Cheng Huang](http://research.microsoft.com/en-us/um/people/chengh)
- [Colin Runciman](https://www-users.cs.york.ac.uk/colin)
- [Cormac Flanagan](https://users.soe.ucsc.edu/~cormac)
- [Jeroen Ketema](http://www.ketema.eu)
- John Erickson
- Katherine E. Coons
- [Kathryn S. McKinley](http://www.cs.utexas.edu/users/mckinley)
- [Markus Kusano](https://markus-kusano.github.io)
- [Matt McCutchen](http://web.mit.edu/rmccutch/www)
- [Michael Emmi](http://michael-emmi.github.io)
- [Naling Zhang](https://sites.google.com/site/nalingzhang/vt)
- [Pantazis Deligiannis](http://pdeligia.github.io)
- [Paul Thomson](http://www.doc.ic.ac.uk/~pt1110/)
- [Pravesh Kothari](http://www.cs.princeton.edu/~kothari)
- Rashmi Mudduluru
- [Santosh Nagarakatte](https://www.cs.rutgers.edu/~santosh.nagarakatte)
- [Shuo Chen](https://www.microsoft.com/en-us/research/people/shuochen)
- [Wolfram Schulte](https://www.microsoft.com/en-us/research/people/schulte)
- [Zvonimir Rakamaric](http://www.zvonimir.info)

#### Papers

- **Partial-Order Methods for the Verification of Concurrent Systems: An Approach to the State-Explosion Problem** ([ps](http://research.microsoft.com/en-us/um/people/pg/public_psfiles/thesis.ps))<br>
    Patrice Godefroid.<br>
    PhD thesis, 1996.

- **Dynamic partial-order reduction for model checking software** ([pdf](https://users.soe.ucsc.edu/~cormac/papers/popl05.pdf))<br>
    Cormac Flanagan and Patrice Godefroid.<br>
    In *Symposium on Principles of Programming Languages* (POPL). 2005.

- **Iterative Context Bounding for Systematic Testing of Multithreaded Programs** ([pdf](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/chess-pldi07-iterativecontextbounding.pdf))<br>
    Madanlal Musuvathi and Shaz Qadeer.<br>
    In *Conference on Programming Language Design and Implementation* (PLDI). 2007.

- **Effective Random Testing of Concurrent Programs** ([pdf](https://people.eecs.berkeley.edu/~ksen/papers/fuzzpar.pdf))<br>
    Koushik Sen.<br>
    In *International Conference on Automated Software Engineering* (ASE). 2007.

- **Fair Stateless Model Checking** ([pdf](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/pldi08-FairStatelessModelChecking.pdf))<br>
    Madanlal Musuvathi and Shaz Qadeer.<br>
    In *Conference on Programming Language Design and Implementation* (PLDI). 2008.

- **Race Directed Random Testing of Concurrent Programs** ([pdf](https://www.cs.columbia.edu/~junfeng/10fa-e6998/papers/racefuzz.pdf))<br>
    Koushik Sen.<br>
    In *Conference on Programming Language Design and Implementation* (PLDI). 2008.

- **A Randomized Scheduler with Probabilistic Guarantees of Finding Bugs** ([pdf](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/paper-83.pdf))<br>
    Sebastian Burckhardt, Pravesh Kothari, Madanlal Musuvathi, and Santosh Nagarakatte.<br>
    In *International Conference on Architectural Support for Programming Languages and Operating Systems* (ASPLOS). 2010.

- **Delay-bounded Scheduling** ([pdf](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/msr-tr-2010-123.pdf))<br>
    Michael Emmi, Shaz Qadeer, and Zvonimir Rakamaric.<br>
    In *Symposium on Principles of Programming Languages* (POPL). 2011.

- **Bounded Partial-order Reduction** ([pdf](http://www.cs.utexas.edu/users/mckinley/papers/bpor-oopsla-2013.pdf))<br>
    Katherine E. Coons, Madan Musuvathi, and Kathryn S. McKinley.<br>
    In *International Conference on Object Oriented Programming Systems, Languages & Applications* (OOPSLA). 2013.

- **Concurrency Testing Using Schedule Bounding: an Empirical Study** ([pdf](http://www.doc.ic.ac.uk/~afd/homepages/papers/pdfs/2014/PPoPP.pdf))<br>
    Paul Thomson, Alastair F. Donaldson, and Adam Betts.<br>
    In *Symposium on Principles and Practice of Parallel Programming* (PPoPP). 2014.

- **Dynamic Partial Order Reduction for Relaxed Memory Models** ([pdf](http://www-bcf.usc.edu/~wang626/pubDOC/ZhangKW15.pdf))<br>
    Naling Zhang, Markus Kusano, and Chao Wang.<br>
    In *Conference on Programming Language Design and Implementation* (PLDI 2015). 2015.

- **Asynchronous Programming, Analysis and Testing with State Machines** ([pdf](http://www.doc.ic.ac.uk/~afd/homepages/papers/pdfs/2015/PLDI_PSharp.pdf))<br>
    Pantazis Deligiannis, Alastair F. Donaldson, Jeroen Ketema, Akash Lal, and Paul Thomson.<br>
    In *Conference on Programming Language Design and Implementation* (PLDI). 2015.

- **Stateless Model Checking Concurrent Programs with Maximal Causality Reduction** ([pdf](https://parasol.tamu.edu/~jeff/academic/mcr.pdf))<br>
    Jeff Huang.<br>
    In *Conference on Programming Language Design and Implementation* (PLDI). 2015.

- **Concurrency Testing Using Controlled Schedulers: An Empirical Study** ([pdf](http://www.doc.ic.ac.uk/~afd/homepages/papers/pdfs/2016/TOPC.pdf))<br>
    Paul Thomson, Alastair F. Donaldson, and Adam Betts.<br>
    In *Transactions on Parallel Computing* (TOPC). 2016.

- **Uncovering Bugs in Distributed Storage Systems during Testing (not in Production!)** ([pdf](http://www.doc.ic.ac.uk/~afd/homepages/papers/pdfs/2016/FAST.pdf))<br>
    Pantazis Deligiannis, Matt McCutchen, Paul Thomson, Shuo Chen, Alastair F. Donaldson, John Erickson, Cheng Huang, Akash Lal, Rashmi Mudduluru, Shaz Qadeer, and Wolfram Schulte.<br>
    In *Conference on File and Storage Technologies* (FAST). 2016.

#### My papers

- **Déjà Fu: A Concurrency Testing Library for Haskell** ([pdf](https://www.barrucadu.co.uk/publications/dejafu-hs15.pdf))<br>
    Michael Walker and Colin Runciman.<br>
    In *Symposium on Haskell* (Haskell). 2015.

#### Venues

- Conference on File and Storage Technologies (FAST)
- Conference on Programming Language Design and Implementation (PLDI)
- International Conference on Architectural Support for Programming Languages and Operating Systems (ASPLOS)
- International Conference on Automated Software Engineering (ASA)
- International Conference on Object Oriented Programming Systems, Languages & Applications (OOPSLA, now SPLASH)
- Symposium on Principles and Practice of Parallel Programming (PPoPP)
- Symposium on Principles of Programming Languages (POPL)
- Transactions on Parallel Computing (TOPC)

### Test Generation

Test cases are hard to write by hand, so rather than do that, have a tool attempt to discover
interesting ones. By reading the output, a programmer can (a) add good tests to the testsuite; and
(b) spot potential issues when expected tests don't show up, or when unexpected ones do.

#### People

- **[Koen Claessen](http://www.cse.chalmers.se/~koen/)**
- **[Nicholas Smallbone](http://www.cse.chalmers.se/~nicsma/)**
- **[Rudy Braquehais](https://matela.com.br/)**
- [Aws Albarghouthi](http://pages.cs.wisc.edu/~aws/)
- [Calvin Smith](http://pages.cs.wisc.edu/~cjsmith/)
- [Colin Runciman](https://www-users.cs.york.ac.uk/colin/)
- Gabriel Ferns
- Javier Paris
- [John Derrick](http://staffwww.dcs.shef.ac.uk/people/J.Derrick/)
- [John Hughes](http://www.cse.chalmers.se/~rjmh/)
- [Kirill Bogdanov](http://staffwww.dcs.shef.ac.uk/people/K.Bogdanov/)
- Maximilian Algehed
- [Moa Johansson](http://www.cse.chalmers.se/~jomoa/)
- [Neil Walkinshaw](http://www2.le.ac.uk/departments/informatics/people/neil-walkinshaw)

#### Papers

- **Increasing Functional Coverage by Inductive Testing: A Case Study** ([pdf](https://hal.archives-ouvertes.fr/file/index/docid/1055254/filename/document.pdf))<br>
    Neil Walkinshaw, Kirill Bogdanov, John Derrick, and Javier Paris.<br>
    In *Conference on Testing Software and Systems* (ICTSS). 2010.

- **QuickSpec: Guessing Formal Specifications Using Testing** ([pdf](http://publications.lib.chalmers.se/records/fulltext/local_125255.pdf))<br>
    Koen Claessen, Nicholas Smallbone, John Hughes.<br>
    In *Conference on Tests and Proofs* (TAP). 2010.

- **FitSpec: refining property sets for functional testing** ([pdf](https://matela.com.br/papers/fitspec.pdf))<br>
    Rudy Braquehais and Colin Runciman.<br>
    In *Symposium on Haskell* (Haskell). 2016.

- **Quick Specifications for the Busy Programmer** ([pdf](http://www.cse.chalmers.se/~jomoa/papers/quickspec2016.pdf))<br>
    Nicholas Smallbone, Moa Johansson, Koen Claessen, Maximilian Algehed.<br>
    In *Journal of Functional Programming* (JFP). 2017.

- **Discovering Relational Specifications** ([pdf](http://pages.cs.wisc.edu/~aws/papers/fse17.pdf))<br>
    Calvin Smith, Gabriel Ferns, and Aws Albarghouthi.<br>
    In *Foundations of Software Engineering* (FSE). 2017

- **Speculate: Discovering Conditional Equations and Inequalities about Black-Box Functions by Reasoning from Test Results** ([pdf](https://matela.com.br/papers/speculate.pdf))<br>
    Rudy Braquehais and Colin Runciman.<br>
    In *Symposium on Haskell* (Haskell). 2017.

#### Venues

- Haskell Symposium (Haskell)
- International Conference on Testing Software and Systems (ICTSS)
- International Conference on Tests and Proofs (TAP)
- Joint European Software Engineering Conference and Symposium on the Foundations of Software Engineering (ESEC/FSE)
- Journal of Functional Programming (JFP)
