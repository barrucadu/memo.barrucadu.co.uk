---
title: Career Levels
date: 2021-04-05
taxon: self
---

This memo is an attempt to judge myself against software development
career levels I've found online.  Even if I never apply to a
particular company whose criteria I've examined, by thinking about
them I can identify areas for improvement.

These levels all overlap a lot.  Evidence is referenced and collected
at the end.

I'm also keeping a separate [brag document][], which will feed into
keeping this memo up to date.

[brag document]: https://jvns.ca/blog/brag-documents/


DDaT Software Development
-------------------------

Skills ([source](https://www.gov.uk/guidance/software-developer)):

1. [Availability and capacity management](career-levels.html#availability-and-capacity-management)
2. [Development process optimisation](career-levels.html#development-process-optimisation)
3. [Information security](career-levels.html#information-security)
4. [Modern standards approach](career-levels.html#modern-standards-approach)
5. [Programming and build (software engineering)](career-levels.html#programming-and-build-software-engineering)
6. [Prototyping](career-levels.html#prototyping)
7. [Service support](career-levels.html#service-support)
8. [Systems design](career-levels.html#systems-design)
9. [Systems integration](career-levels.html#systems-integration)
10. [User focus](career-levels.html#user-focus)

I've used the following abbreviations below:

- **D0:** Apprentice Developer
- **D1:** Junior Developer
- **D2:** Developer
- **D3:** Senior Developer
- **D4:** Lead Developer
- **D5:** Principal Developer
- **M3:** Management-focussed Senior Developer
- **M4:** Management-focussed Lead Developer
- **M5:** Management-focussed Principal Developer

### Availability and capacity management

> You can define, analyse, plan, forecast, measure, maintain and
> improve all aspects of the availability of services, including
> power.  You control and manage service availability to meet the
> needs of the business in a cost-effective manner.  This includes
> managing the capability, functionality and sustainability of service
> components (for example, hardware, software, network resources and
> software/infrastructure as a service).

#### Awareness (D0, D1)

> You know about availability and capacity management processes.

- [Personal experience][], specifically:
  - maintaining internet-connected infrastructure.

#### Working (D2, D3, D4, D5)

> You can manage the service components to ensure they meet business
> needs and performance targets.

- [GOV.UK platform health][], specifically:
  - load testing.
- [GOV.UK search][], specifically:
  - upgrading Elasticsearch 2 to 5,
  - productionising Tensorflow Ranking.
- [GOV.UK accounts][], specifically:
  - monitoring and scaling.

#### Practitioner (M3, M4, M5)

> You ensure the correct implementation of standards and procedures,
> identifying capacity issues, stipulating the required changes and
> instigating these.  You can initiate remedial action.

No evidence.

### Development process optimisation

#### Awareness (D2)

> You can explain the importance of developing process efficiency and
> the common ways in which processes are optimised.  You can support
> specific activities to improve development processes.  You can spot
> or identify obvious deficiencies.

- [GOV.UK accounts][], specifically:
  - alerting on failed deployments.

#### Working (D3, D4, M3)

> You can identify process optimisation opportunities with guidance
> and contribute to the implementation of proposed solutions.

- [GOV.UK accounts][], specifically:
  - the testing strategy.

#### Practitioner (D5, M4)

> You know how to analyse current processes, identify and implement
> opportunities to optimise processes, and lead and develop a team of
> experts to deliver service improvements.  You help to evaluate and
> establish requirements for the implementation of changes by setting
> policy and standards.

No evidence.

#### Expert (M5)

>  You can set strategy and manage resource allocation for solution
>  development programmes.  You liaise with client functions to
>  establish business requirements; you can identify, propose,
>  initiate and lead these programmes.

No evidence.

### Information security

> You maintain the security, confidentiality and integrity of
> information systems through compliance with relevant legislation and
> regulations.  You design, implement and operate controls and
> management strategies to allow this.

#### Awareness (D0)

> You are aware of information security and the security controls that
> can be used to mitigate security threats within solutions and
> services.

- [Personal experience][], specifically:
  - maintaining internet-connected infrastructure.

#### Working (D1)

> You understand information security and the types of security
> controls that can be used to mitigate security threats within
> solutions and services.

- [GOV.UK accounts][], specifically:
  - responding to reported vulnerabilities.

#### Practitioner (D2, D3, D4, M3, M4)

> You can discuss information security.  You can design solutions and
> services with security controls embedded, specifically engineered as
> mitigation against security threats as a core part of the solutions
> and services.

- [GOV.UK accounts][], specifically:
  - collaboration with cybersecurity colleagues & the [NCSC][],
  - collaboration with privacy colleagues,
  - unlinkability.

#### Expert (D5, M5)

> You have a depth of knowledge in information security.  You can
> design, quality review and quality assure solutions and services
> with security controls embedded, specifically engineered as
> mitigation against security threats as a core part of the solutions
> and services.

No evidence.

### Modern standards approach

> You use a modern standards approach throughout automation and
> testing.

#### Awareness (D0)

> You can explain the importance of adopting a modern standards
> approach.

See evidence for Working & Practitioner.

#### Working (D1)

> You understand the central principles of modern standards approach
> and how they apply to the work you are undertaking.  You will be
> able to apply them under guidance.

- [GOV.UK practices][], specifically:
  - use of automated linting,
  - use of automated testing,
  - use of CI & CD.

#### Practitioner (D2, D3, M3)

> You can competently use a modern standards approach and guide others
> in so doing.

- [Ph.D][], specifically:
  - developing a new testing tool for concurrent Haskell.
- [GOV.UK accounts][], specifically:
  - adoption of modern technologies for CI & CD,
  - the testing strategy.

#### Expert (D4, D5, M4, M5)

> You demonstrate strong understanding and application of the most
> appropriate modern standards and practices.  You will take
> responsibility for coaching and guiding others.

No evidence.

### Programming and build (software engineering)

> You can use agreed security standards and specifications to design,
> create, test and document new or amended software.

#### Working (D0, D1)

> You can design, code, test, correct and document simple programs or
> scripts under the direction of others.

See evidence for Practitioner.

#### Practitioner (D2, D3, D4, M3, M4, M5)

> You collaborate with others when necessary to review specifications
> and use these agreed specifications to design, code, test and
> document programs or scripts of medium to high complexity, using the
> right standards and tools.

- [Ph.D][], specifically:
  - developing a new testing tool for concurrent Haskell.
- [Pusher][], specifically:
  - productionising a prototype system.
- [GOV.UK search][], specifically:
  - upgrading Elasticsearch 2 to 5,
  - upgrading Elasticsearch 5 to 6,
  - productionising Tensorflow Ranking.
- [GOV.UK accounts][], specifically:
  - building prototypes,
  - acting as the team expert on OAuth and OpenID Connect,
  - planning & implementing features like MFA and email subscriptions,
  - building consensus with ADRs and RFCs.

#### Expert (D5)

> You can advise on the right way to apply standards and methods,
> ensuring compliance.  You can maintain technical responsibility for
> all the stages and iterations of a software development project.
> You can provide technical advice to stakeholders and set the
> team-based standards for programming tools and techniques.

- [GOV.UK accounts][], specifically:
  - being the technical point-of-contact in the team,
  - participating in meetings with senior non-technical stakeholders.

### Prototyping

> You can apply technical knowledge and experience to create or design
> workable prototypes, both programs and physical outputs.  You
> understand parameters, restrictions and synergies.

#### Awareness (D0)

> You can explain what prototyping is and why and when to use it.  You
> have an understanding of how to work in an open and collaborative
> environment, for example, by pair-working.

See evidence for Practitioner.

#### Working (D1)

> You will know when to use a specific prototyping technique or
> method.  You can show the value of prototyping to your team.

See evidence for Practitioner.

#### Practitioner (D2, D3, D4, M3, M4)

> You see prototyping as a team activity, actively soliciting
> prototypes and testing with others.  You establish design patterns
> and iterate them.  You know a variety of methods of prototyping and
> can choose the most appropriate ones.

- [GOV.UK search][], specifically:
  - prototyping Tensorflow Ranking.
- [GOV.UK accounts][], specifically:
  - prototyping authentication & attribute storage,
  - prototyping a simple service.

#### Expert (D5, M5)

> You have experience of using a variety of methods of prototyping.
> You know how to share best practice and can coach others.  You look
> at strategic service design end to end.

No evidence.

### Service support

> You can maintain and support services.

#### Awareness (D0)

> You can assist in the investigation and resolution of infrastructure
> problems, undertaking specific activities under the direction of
> others.

- [GOV.UK practices][], specifically:
  - keeping dependencies up to date.
- [GOV.UK support][], specifically:
  - shadowing other developers.

#### Working (D1, D2)

> You can help fix faults following agreed procedures.  You can carry
> out agreed infrastructure maintenance tasks.

See evidence for Practitioner.

#### Practitioner (D3, D4, D5, M3, M4, M5)

> You can identify, locate and fix faults.

- [Personal experience][], specifically:
  - maintaining internet-connected infrastructure.
- [GOV.UK support][], specifically:
  - being on the in-hours support rota,
  - being on the on-call support rota.
- [GOV.UK accounts][], specifically:
  - responding to reported vulnerabilities.

### Systems design

> You can create the specification and design of systems to meet
> defined business needs.  You can work with business and technology
> stakeholders to translate business problems into technical designs.
> You can visualise the ideal user service and come up with design
> ideas and possible design approaches.  You feel comfortable
> exploring different approaches to solving problems.

#### Awareness (D1)

> You can assist as part of a team on design of components of larger
> systems.

See evidence for Practitioner.

#### Working (D2)

> You can translate logical designs into physical designs.  You can
> produce detailed designs.  You know how to document all work using
> required standards, methods and tools, including prototyping tools
> where appropriate.  You can design systems characterised by managed
> levels of risk, manageable business and technical complexity, and
> meaningful impact.  You can work with well understood technology and
> identify appropriate patterns.

See evidence for Practitioner.

#### Practitioner (D3, D4, M3, M4)

> You can design systems characterised by medium levels of risk,
> impact, and business or technical complexity.  You can select
> appropriate design standards, methods and tools, and ensure they are
> applied effectively.  You know how to review the systems designs of
> others to ensure the selection of appropriate technology, efficient
> use of resources and integration of multiple systems and technology.

- [GOV.UK accounts][], specifically:
  - choosing appropriate standards & open-source code to bootstrap our work,
  - designing an approach to cross-domain analytics,
  - designing the technical implementation of authentication UX designs,
  - proposed & built consensus on GOV.UK site-wide sign-in.

#### Expert (D5, M5)

> You can design systems characterised by high levels of risk, impact,
> and business or technical complexity.  You control system design
> practice within an enterprise or industry architecture.  You
> influence industry-based models for the development of new
> technology applications.  You develop effective implementation and
> procurement strategies, consistent with business needs.  You ensure
> adherence to relevant technical strategies, policies, standards and
> practices.

No evidence.

### Systems integration

#### Awareness (D1)

> You can talk about the process of integrating systems and the
> challenges of designing, building and testing interfaces between
> systems.

See evidence for Practitioner.

#### Working (D2)

> You can build and test simple interfaces between systems, or work on
> more complex integration as part of a wider team.

See evidence for Practitioner.

#### Practitioner (D3, D4, D5, M3, M4, M5)

> You can define the integration build.  You can coordinate build
> activities across systems and can undertake and support integration
> testing activities.

- [GOV.UK accounts][], specifically:
  - designing the technical implementation of authentication UX designs,
  - proposed & built consensus on GOV.UK site-wide sign-in.

### User focus

> You understand users and can identify who they are and what their
> needs are, based on evidence. You can translate user stories and
> propose design approaches or services to meet these needs and engage
> in meaningful interactions and relationships with users. You put
> users first. You can manage competing priorities.

#### Awareness (D0, D1)

> You know about user experience analysis and its principles.  You can
> explain the purpose of user stories and focus on user needs.

See evidence for Practitioner.

#### Practitioner (D2, D3, D4, D5, M3, M4, M5)

> You know how to collaborate with user researchers and can represent
> users internally.  You understand the difference between user needs
> and the desires of the user.  You can champion user research to
> focus on all users.  You can prioritise and define approaches to
> understand the user story, guiding others in doing so.  You can
> offer recommendations on the best tools and methods to be used.

- [Ph.D][], specifically:
  - working with users to implement desired features.
- [GOV.UK practices][], specifically:
  - acting as a note-taker and observer in user research sessions.
- [GOV.UK accounts][], specifically:
  - acting as a note-taker in user research sessions,
  - working with user-centred design colleagues to come up with feasible designs.


Patreon Engineering Levels
--------------------------

Skills ([source](https://levels.patreon.com/)):

1. Technical
   1. [Scoping](career-levels.html#technical-scoping)
   2. [Code & Tests](career-levels.html#technical-code-tests)
   3. [Code Reviews](career-levels.html#technical-code-reviews)
   4. [Design](career-levels.html#technical-design)
   5. [Oncall](career-levels.html#technical-oncall)
   6. [Domain Mastery](career-levels.html#technical-domain-mastery)
   7. [Context](career-levels.html#technical-context)
   8. [Debugging](career-levels.html#technical-debugging)
2. Execution
   1. [Planning](career-levels.html#execution-planning)
   2. [Oversight & Obstacles](career-levels.html#execution-oversight-obstacles)
   3. [Tools](career-levels.html#execution-tools)
   4. [Ownership](career-levels.html#execution-ownership)
   5. [Business Understanding](career-levels.html#execution-business-understanding)
   6. [Vision & Strategy](career-levels.html#execution-vision-strategy)
3. Collaboration & Communication
   1. [Teamwork](career-levels.html#collaboration-communication-teamwork)
   2. [Communication](career-levels.html#collaboration-communication-communication)
   3. [Issues & Conflict](career-levels.html#collaboration-communication-issues-conflict)
   4. [Feedback](career-levels.html#collaboration-communication-feedback)
   5. [Documentation](career-levels.html#collaboration-communication-documentation)
4. Influence
   1. [Impact](career-levels.html#influence-impact)
   2. [Educate & Empower & Mentor](career-levels.html#influence-educate-empower-mentor)
   3. [Hiring & Onboarding](career-levels.html#influence-hiring-onboarding)
   4. [Leadership](career-levels.html#influence-leadership)
5. Maturity
   1. [Feedback & Conflict](career-levels.html#maturity-feedback-conflict)
   2. [Professionalism](career-levels.html#maturity-professionalism)
   3. [Handling Change](career-levels.html#maturity-handling-change)

I've left out the "Technical: Focus" levels as that's a role
description, not a skill.

### Technical: Scoping

#### IC1

> Works on scoped problems with some guidance, contributing
> meaningfully.

See evidence for IC3 & IC4.

#### IC2

> Scopes and implements project-level solutions with minimal guidance.

See evidence for IC3 & IC4.

#### IC3

> Independently scopes and implements solutions for their
> project/team.

- [GOV.UK accounts][], specifically:
  - I am the tech lead.

#### IC5

> Independently scopes, designs, and delivers solutions for large,
> complex challenges.

- [Ph.D][], specifically:
  - planning and delivering a multi-year independent research task.

But I haven't lead any cross-team initiatives if that's what this
criteria is asking.

### Technical: Code & Tests

#### IC1

> Writes clean code and tests, iterating based on feedback.

See evidence for IC3.

#### IC2

> Consistently follows best practices, able to defend technical
> decisions in code review feedback.  Writes maintainable code.

See evidence for IC3.

#### IC3

> Expert in our processes, also helping to define them. Keeps tests up
> to date.

- Some example PRs:
  - [Add 'attachments' and 'featured_attachments' fields to content items](https://github.com/alphagov/whitehall/pull/5353)
  - [Use lazy enumerators in LTR training data generation](https://github.com/alphagov/search-api/pull/1903)
  - [Add HTTP endpoint to fetch bigquery data, generate SVM files, and upload to S3](https://github.com/alphagov/search-api/pull/1881)
  - [Switch to the account-api attribute endpoints & remove OAuth / OIDC code](https://github.com/alphagov/finder-frontend/pull/2459)
  - [Remove detect-secrets](https://github.com/alphagov/govuk-account-manager-prototype/pull/613)

#### IC4

> Consistently delivers code that sets the standard for quality and
> maintainability.

This is an area I want to improve in.  Sometimes I make mistakes
which, in retrospect, indicate a test I should have added.

### Technical: Code Reviews

#### IC1

> Participates in code reviews and technical design.

See evidence for IC3.

#### IC2

> Provides helpful, timely code reviews.

See evidence for IC3.

#### IC3

> Writes meaningful code reviews.

- Some example PRs:
  - [Add GOV.UK sessions](https://github.com/alphagov/frontend/pull/2668)
  - [Update Learning to Rank documentation](https://github.com/alphagov/search-api/pull/2029)
  - [Learning To Rank](https://github.com/alphagov/search-api/pull/1768)

#### IC4

> Writes highly insightful, comprehensive code reviews.

This is an area I want to improve in.  There are some developers on
GOV.UK who write very good code reviews.

#### IC5

> Provides oversight, coaching and guidance through code and design
> reviews.

No evidence.

### Technical: Design

#### IC1

> Participates in code reviews and technical design.

This is the same as IC1 for "[Technical: Code Reviews](https://misc.barrucadu.co.uk/_site/career-levels.html#technical-code-reviews)".

#### IC2

> Writes eng review proposals and contributes to technical design,
> thinking through failure cases.

See evidence for IC3 & IC4.

#### IC3

> Handles open-ended problems & ambiguity well.  Makes well-reasoned
> design decisions, identifying potential issues, tradeoffs, risks,
> and the appropriate level of abstraction.

- [Ph.D][], specifically:
  - developing a new testing tool for concurrent Haskell.

#### IC4

> Has a broad understanding of our architecture and how their domain
> fits within it.  Systematically thinks through potential design
> impacts on other teams and the company.

- [GOV.UK accounts][], specifically:
  - I am the tech lead,
  - this RFC proposing [a GOV.UK-wide login](https://github.com/alphagov/govuk-rfcs/pull/134).

#### IC5

> Provides oversight, coaching and guidance through code and design
> reviews.  Designs for scale and reliability with the future in mind.
> Can do critical R&D.  Anticipates technical challenges, exploring
> alternatives and tradeoffs thoroughly.

No evidence.

### Technical: Oncall

#### IC1

> May participate in on-call rotation, if applicable for their domain.

See evidence for IC2.

#### IC2

> Participates in on-call rotation, as applicable to their domain.

- [GOV.UK support][], specifically:
  - being on the in-hours support rota,
  - being on the on-call support rota.

### Technical: Domain Mastery

#### IC2

> Understands how code fits into broader technical context.

See evidence for IC3.

#### IC3

> Proficient in all relevant technical skills, and able to move
> quickly because of deep understanding of large portions of codebase.
> Maintains awareness of industry trends and tools.

- I have worked on a variety of areas of GOV.UK:
  - [GOV.UK platform health][] (which involved looking after many
    different apps),
  - [GOV.UK search][],
  - [GOV.UK accounts][].

#### IC4

> Go-to expert in an area, with an increasingly strategic mindset.

- [Ph.D][], specifically:
  - becoming familiar with existing research, and then extending it.
- [GOV.UK search][], specifically:
  - being a team expert on Elasticsearch.
- [GOV.UK accounts][], specifically:
  - I am the tech lead.

#### IC5

> Incredibly knowledgable both inside and outside of the company in
> their area(s).  Has deep understanding of full stack encompassing
> their domain.  Can navigate and make legacy code maintainable.

No evidence.

#### IC6

> Respected leader and contributor across the org.  Primary expert in
> multiple areas of our stack, deeply knowledgeable in several
> domains.

No evidence.

### Technical: Context

#### IC2

> Understands how code fits into broader technical context.

See evidence for IC4.

#### IC4

> Explores technologies with sizable potential impact for Patreon.
> Has a broad understanding of our architecture and how their domain
> fits within it.  Systematically thinks through potential design
> impacts on other teams and the company.

- [GOV.UK accounts][], specifically:
  - working with a technical architect and lead developer,
  - building consensus with ADRs and RFCs,
  - I am the tech lead.

### Technical: Debugging

#### IC2

> Debugs effectively within their primary area to help find root
> cause.

See evidence for IC3.

#### IC3

> Debugs expertly within their primary focus area.

- [Ph.D][], specifically:
  - developing a new testing tool for concurrent Haskell.
- [GOV.UK support][], specifically:
  - being on the in-hours support rota,
  - being on the on-call support rota,
  - dealing with incidents.

#### IC5

> Persistently debugs the toughest issues through entire stack
> regardless of environment, finding root cause or a viable
> workaround.

No evidence.

### Execution: Planning

#### IC1

> Commits to & completes tasks within expected time frame, holding
> themselves accountable.  Building estimation skills.

See evidence for IC2 & IC4.

#### IC2

> Mastering ability to break down tasks, plan, estimate, and cut scope
> to ship on time.  Prioritizes in alignment with company goals.
> Seeks learning through retrospectives.  Engages with Product
> Management on feasibility of requested features, clarifying
> requirements where necessary.

- [Ph.D][], specifically:
  - planning and delivering a multi-year independent research task.

#### IC3

> Estimates methodically, based on iterative learning.  Sets realistic
> deadlines that drive effort but support healthy work habits.  Cuts
> scope as needed, mitigating risk by shipping frequently.

See evidence for IC4.

#### IC4

> Can successfully plan & execute projects involving multiple
> developers and complex requirements, prioritizing strategically.
> Avoids monolithic deliverables and breaks down complex tasks
> quickly.

- [GOV.UK accounts][], specifically:
  - I am the tech lead.

#### IC5

> Can successfully plan and deliver complex, multi-team or system,
> long-term projects, including ones with external dependencies.
> Identifies problems that need to be solved and advocates for their
> prioritization.  Able to reduce complexity and prioritize the most
> important work for the company.

No evidence of working with external dependencies.

#### IC6

> Able to plan & execute large, complex projects with
> interdependencies across teams and systems, spanning months to
> years.  Looked to as a model for balancing product and engineering
> concerns.

No evidence.

### Execution: Oversight & Obstacles

#### IC1

> Asks for help to get unblocked when necessary.

See evidence for IC2 & IC3.

#### IC2

> Seeks input from colleagues with area expertise.  Detects problems
> in requirements.

- [GOV.UK accounts][], specifically:
  - I am the tech lead.

#### IC3

> Asks for guidance in unfamiliar areas, pulls in others as needed,
> and persists in the face of roadblocks.

- [GOV.UK support][], specifically:
  - dealing with incidents.

#### IC6

> Trusted with any critical project or initiative.

No evidence.

### Execution: Tools

#### IC1

> Learning tools and resources.

See evidence for IC2 & IC3.

#### IC2

> Effectively uses tools and dashboards.  Instruments code for
> operations and monitoring.

- [GOV.UK accounts][], specifically:
  - monitoring and alerting.

#### IC3

> Uses analytics and product understanding to inform decisions and
> measure impact.

- [GOV.UK search][], specifically:
  - A/B testing.

### Execution: Ownership

#### IC2

> Takes ownership and can work autonomously on any development task
> within an application or service, delivering code on time and with a
> quality mindset.

- [Ph.D][], specifically:
  - planning and delivering a multi-year independent research task.
- [Pusher][], specifically:
  - developing a tool and process for fuzz testing.

#### IC3

> Accountable end-to-end, through planning, deploy, maintenance, and
> monitoring.  Proactive about potential issues.

- [GOV.UK accounts][], specifically:
  - use of CI and CD,
  - monitoring and alerting.

#### IC4

> Executes pragmatically, consistently delivering high-quality,
> non-disruptive releases.  Identifies, defines, and solves strategic
> problems, thinking holistically about the whole system.  Tackles
> tech debt proactively.  Contributes to all major architectural
> decisions and reads all tech specs within their domain, tracking
> status and considering implications to other systems.

- [GOV.UK practices][], specifically:
  - participating in a regular Tech Debt Review.
- [GOV.UK accounts][], specifically:
  - building consensus with ADRs and RFCs.

#### IC5

> Identifies problems that need to be solved and advocates for their
> prioritization.  Owns 1 or more large, mission-critical systems at
> Patreon or multiple complex, team level projects, overseeing all
> aspects from design through implementation through operation.

- [GOV.UK accounts][], specifically:
  - I am the tech lead.

#### IC6

> Owns capacity and growth of technical systems across multiple
> domains, defining key metrics.

I haven't owned any cross-team initiatives.

### Execution: Business Understanding

#### IC2

> Seeks understanding of how users interact with product/service.

See evidence for IC3 & IC5.

#### IC3

> Understands how people use the product/service(s) they build, and
> how their work fits in.  Exercises user empathy, whether their users
> are internal or external.

- [Ph.D][], specifically:
  - working with commercial users to improve dejafu.
- [GOV.UK practices][], specifically:
  - acting as a note-taker and observer in user research sessions.
- [GOV.UK accounts][], specifically:
  - acting as a note-taker in user research sessions,
  - working with user-centred design colleagues to come up with feasible designs.

#### IC5

> Considers larger company context and potential future implications
> between projects.  Uses expertise in product space to make
> decisions.

- [GOV.UK accounts][], specifically:
  - I am the tech lead.

### Execution: Vision & Strategy

#### IC3

> Starting to form a vision for future directionality of certain
> areas.

See evidence for IC4.

#### IC4

> Identifies, defines, and solves strategic problems, thinking
> holistically about the whole system.  Tackles tech debt proactively.
> Helps define roadmaps and set vision for long-term projects.

- [Ph.D][], specifically:
  - planning and delivering a large independent research task.
- [GOV.UK practices][], specifically:
  - participating in a regular Tech Debt Review.
- [GOV.UK accounts][], specifically:
  - I am the tech lead.

#### IC5

> Plays a key role in defining the company's multi-year tech strategy
> and roadmap, despite uncertainty.  Defines and drives vision for
> their area(s).

No evidence.  While I am the tech lead on the [GOV.UK accounts][]
team, the larger strategy is very much product-driven.

#### IC6

> Creates a compelling technical vision with company-level impact,
> anticipating future needs.

No evidence.

### Collaboration & Communication: Teamwork

#### IC1

> Learning to work collaboratively on a team and communicate in
> meetings.

See evidence for IC5.

#### IC2

> Collaborates professionally with teammates and peers.

See evidence for IC5.

#### IC3

> Partners with product and analytics to drive requirements.
> Identifies and suggests solutions to problems impacting team.
> Builds relationships cross-functionally, with operations and support
> teams, and with senior engineers.

See evidence for IC5.

#### IC5

> Evangelizes and solves with buy-in.  Collaborates with coworkers
> across the org to document and design how systems work and interact.

- [GOV.UK accounts][], specifically:
  - working with cybersecurity colleagues,
  - working with privacy colleagues,
  - working with the [NCSC][],
  - working with a technical architect and lead developer,
  - building consensus with ADRs and RFCs,
  - I am the tech lead.

### Collaboration & Communication: Communication

#### IC1

> Learning to work collaboratively on a team and communicate in
> meetings.  Effectively communicates work status to teammates and
> manager.

- [GOV.UK practices][], specifically:
  - working in an agile way.

#### IC2

> Communicates clearly at team and engineering events, escalating
> blockers quickly, clarifying requirements and sharing assumptions.
> Adapts their message for a diverse technical audience, choosing
> appropriate medium and providing context.

See evidence for IC5 & IC6.

#### IC3

> Communicates technical issues and decisions clearly and proactively
> to a cross-functional audience, sharing bad news quickly as well.
> Mastering ability to express complicated issues simply.

See evidence for IC5 & IC6.

#### IC4

> Spurs and facilitates meaningful discussion around complex issues.
> Works with key stakeholders effectively to solve problems and make
> decisions.  Trusted to always share status with all stakeholders,
> and proactively remedy communication issues.

See evidence for IC5 & IC6.

#### IC5

> Coordinates communication among team & stakeholders, including the
> right people at the right times.  Clearly communicates technical
> issues, and ties work clearly to company objectives.

- [GOV.UK support][], specifically:
  - being an incident lead.
- [GOV.UK accounts][], specifically:
  - working with non-technical members of the team to design and implement solutions,
  - being a technical point-of-contact for senior non-technical stakeholders.

#### IC6

> Comfortably communicates complex issues to diverse audiences inside
> & outside the company.

- [Ph.D][], specifically:
  - giving presentations at international conferences.

### Collaboration & Communication: Issues & Conflict

#### IC1

> Proactively asks questions and reaches out for help when stuck.
> Voices concerns or need for clarification to their manager.

See evidence for IC3.

#### IC2

> Communicates clearly at team and engineering events, escalating
> blockers quickly, clarifying requirements and sharing assumptions.
> Uses team meetings and 1:1s to raise and resolve issues.

See evidence for IC3.

#### IC3

> Engages in productive dialog even when there are conflicting views,
> both inside and outside team.  Seeks to understand other points of
> view.  Identifies and suggests solutions to problems impacting team.

- [GOV.UK accounts][], specifically:
  - running a discussion on testing practices,
  - I am the tech lead.

#### IC6

> Proactively identifies and remedies communication gaps and issues.

No evidence.

### Collaboration & Communication: Feedback

#### IC1

> Accepts feedback graciously and learns from experience.

See evidence for IC2.

#### IC2

> Seeks feedback to improve and receives it well.  Gives timely,
> helpful feedback to peers.

- [GOV.UK practices][], specifically:
  - peer feedback.

### Collaboration & Communication: Documentation

#### IC2

> Proactively adds documentation to help others.

- [Ph.D][], specifically:
  - documenting dejafu.

#### IC3

> Ensures docs exist for all critical systems.

See evidence for IC4 & IC5.

#### IC4

> Writes insightful documentation.

- [GOV.UK support][], specifically:
  - keeping documentation up to date.
- [GOV.UK accounts][], specifically:
  - working with a technical writer.

#### IC5

> Collaborates with coworkers across the org to document and design
> how systems work and interact.

- [GOV.UK accounts][], specifically:
  - building consensus with ADRs and RFCs.

### Influence: Impact

#### IC1

> Has project/team-level impact. Pairs to gain knowledge.

See evidence for IC3 & IC4.

#### IC3

> Elevates testing practices.  Contributes to the foundational good of
> their domain and engineering overall, defining patterns and
> canonical examples, plus paying down tech debt.

- [Ph.D][], specifically:
  - developing a new testing tool for concurrent Haskell.

#### IC4

> Routinely has initiative- to domain-level impact.  Identify and
> advocate for foundational work and practice improvements in their
> domain.  Convinces others about technical tradeoffs & decisions.

- [GOV.UK practices][], specifically:
  - participating in a regular Tech Debt Review.
- [GOV.UK accounts][], specifically:
  - building consensus with ADRs and RFCs,
  - running a discussion on testing practices,
  - I am the tech lead.

#### IC5

> Routinely has engineering-wide impact.  Contributes to external
> engineering brand.  Drives foundational work benefitting their
> domain and engineering overall.

No evidence.

#### IC6

> Routinely has org- to industry-level impact.  May work with exec
> team on high level technical guidance.  Has obvious impact on
> company's technical trajectory.  Influences company goals and
> strategy, identifying new business growth opportunities.  Expert on
> company's platform, architecture, and workflow.

No evidence.

### Influence: Educate & Empower & Mentor

#### IC1

> Represents their team well to others in the company.

See evidence for IC4.

#### IC2

> Mentors more junior engineers.  Finds ways to help teammates achieve
> their goals.  Inspires teamwork.

See evidence for IC4.

#### IC3

> Shares their experience and expertise to help others grow.

See evidence for IC4.

#### IC4

> Sought out as mentor and provider of technical guidance, kind
> coaching.  Motivates and empowers teammates to achieve higher level
> of performance.  Educates others about the work of the team.
> Coaches and helps teammates prioritize.

- [GOV.UK search][], specifically:
  - acting as the team expert on Elasticsearch.
- [GOV.UK accounts][], specifically:
  - acting as the team expert on OAuth and OpenID connect,
  - pair working.

#### IC5

> Acts as a multiplier who shares knowledge and delegates to help
> others grow.  Builds leaders within their team or domain, educates
> across domain.

No evidence.

#### IC6

> Builds leaders at Patreon.  Educates across the org.  Defines and
> models Patreon engineering brand, patterns, and practices.

No evidence.

### Influence: Hiring & Onboarding

#### IC1

> May participate in hiring.

See evidence for IC2.

#### IC2

> Participates in hiring and provides clear, timely feedback on
> candidates.

- [GOV.UK practices][], specifically:
  - sifting CVs,
  - line-managing mid-level developers.

#### IC4

> Analyzes and improves upon interview and onboarding practices.

No evidence yet.  I have been interview trained, but not sat on any
panels yet.

#### IC5

> Actively recruits strong engineers.

No evidence.

#### IC6

> Ambassador for Patreon externally, drawing engineers to the company.

No evidence.

### Influence: Leadership

#### IC3

> Leads and coaches within their team where possible, trusted with
> team decisions.  Starting to broaden impact.  Considers effects of
> their work on other teams, as well as identifying and helping to
> resolve problems facing team.

See evidence for IC4.

#### IC4

> Leads initiatives & meetings within team and domain.  Regularly
> leads multi-person, multi-week projects.

- [GOV.UK accounts][], specifically:
  - I am the tech lead.

#### IC5

> Thought leader for technical decisions, influencing architecture and
> prioritization across multiple teams.  Leads initiatives across
> domains, even outside their core expertise.  Coordinates large &
> complex projects, including with outside partners.  Leads by example
> and inspires others.

I haven't lead any cross-team initiatives.

#### IC6

> Recognized leader within company and possibly in broader technical
> community.  Leads complex initiatives with long-term, strategic
> value.

No evidence.

### Maturity: Feedback & Conflict

#### IC1

> Learns and exhibits Patreon core behaviors, treating others with
> respect, honoring commitments to the team, seeking out & integrating
> feedback.

See evidence for IC2 & IC3 & IC4.

#### IC2

> Trusts teammates, assumes good intent, and able to disagree and
> commit.  Exhibits a growth mindset with regard to feedback.  Able to
> voice concerns in a constructive manner.

- [GOV.UK practices][], specifically:
  - receiving peer feedback.

#### IC3

> Gives feedback to others and trusts them to decide to what extent to
> incorporate it.

- [GOV.UK practices][], specifically:
  - giving peer feedback.

#### IC4

> Builds consensus for decisions.

- [GOV.UK accounts][], specifically:
  - building consensus with ADRs and RFCs.

#### IC5

> Proactively offers regular, constructive feedback to others.
> Trusted to de-escalate conflicts and build consensus between team
> members about technical matters.

No evidence.

### Maturity: Professionalism

#### IC1

> Objectively evaluates whether they've met their goals.

See evidence for IC3.

#### IC2

> Able to deliver their work despite inevitable distractions.

See evidence for IC3.

#### IC3

> Self-aware of strengths and weaknesses.  Trusted to do what they say
> they will do, or communicate promptly if there is an issue.
> Intentional about career and growth.

- [GOV.UK accounts][], specifically:
  - I was trusted to be the tech lead on a priority project, despite
    this being my first time as a tech lead.

#### IC5

> Models and engages others around developing maturity.

No evidence.

### Maturity: Handling Change

#### IC3

> Embraces big challenges as opportunities for growth.  Able to change
> direction quickly based on shifting company needs.

- [GOV.UK search][], specifically:
  - doing one Elasticsearch upgrade and then leading another, despite
    having no Elasticsearch knowledge beforehand.
- [GOV.UK accounts][], specifically:
  - agreeing to be the tech lead, despite having little OAuth or
    OpenID Connect knowledge beforehand.

#### IC4

> Help others maintain resilience in periods of change.

- [GOV.UK accounts][], specifically:
  - I have been the tech lead during coronavirus, and the team has
    kept doing good work.

Evidence
--------

- [Personal experience][]
  - [Linux](career-levels.html#linux)
  - [Personal infrastructure](career-levels.html#personal-infrastructure)
- [Ph.D][]
  - [The Ph.D experience](career-levels.html#the-ph.d-experience)
  - [Engaging with users](career-levels.html#engaging-with-users)
- [Pusher][]
- [GOV.UK practices][]
  - [Peer feedback](career-levels.html#peer-feedback)
  - [Tech community](career-levels.html#tech-community)
  - [Tech practices](career-levels.html#tech-practices)
  - [User research](career-levels.html#user-research)
- [GOV.UK support][]
  - [Dealing with incidents](career-levels.html#dealing-with-incidents)
  - [Reviewing documentation](career-levels.html#reviewing-documentation)
- [GOV.UK platform health][]
  - [Load testing](career-levels.html#load-testing)
- [GOV.UK search][]
  - [A/B testing](career-levels.html#ab-testing)
  - [Upgrading Elasticsearch 2 to 5](career-levels.html#upgrading-elasticsearch-2-to-5)
  - [Upgrading Elasticsearch 5 to 6](career-levels.html#upgrading-elasticsearch-5-to-6)
  - [TensorFlow Ranking](career-levels.html#tensorflow-ranking)
- [GOV.UK accounts][]
  - [ADRs and RFCs](career-levels.html#adrs-and-rfcs)
  - [CI and CD](career-levels.html#ci-and-cd)
  - [Documentation](career-levels.html#documentation)
  - [Monitoring and scaling](career-levels.html#monitoring-and-scaling)
  - [Pair working](career-levels.html#pair-working)
  - [Prototyping](career-levels.html#prototyping-1)
  - [Security and privacy](career-levels.html#security-and-privacy)
  - [Testing practices](career-levels.html#testing-practices)

[Personal experience]: career-levels.html#personal-experience
[Ph.D]: career-levels.html#ph.d
[Pusher]: career-levels.html#pusher
[GOV.UK practices]: career-levels.html#gov.uk-practices
[GOV.UK support]: career-levels.html#gov.uk-support
[GOV.UK platform health]: career-levels.html#gov.uk-platform-health
[GOV.UK search]: career-levels.html#gov.uk-search
[GOV.UK accounts]: career-levels.html#gov.uk-accounts

### Personal experience

I enjoy programming and playing with tech, so I often use time outside
my job to try out new things.

#### Linux

I've used Linux as my primary operating system since 2007.  I started
on [Ubuntu][], went through a variety of distros (including
[Debian][], [openSUSE][], and [Fedora][]), and eventually settled on
[Arch Linux][] for several years.  Since 2016 I've used [NixOS][]
exclusively.

I consider myself very comfortable with Linux and the command line.

I've not used the BSDs much, but I did manage to use [GNU/Hurd][] for
a side project for a couple of years, so I'm capable of adapting to
new UNIX-like systems.

[Ubuntu]: https://ubuntu.com/
[Debian]: https://www.debian.org/
[openSUSE]: https://www.opensuse.org/
[Fedora]: https://getfedora.org/
[Arch Linux]: https://archlinux.org/
[NixOS]: https://nixos.org/
[GNU/Hurd]: https://www.gnu.org/software/hurd/

#### Personal infrastructure

Since 2008 I've operated an internet-connected server on the
`barrucadu.co.uk` domain, and other servers on other domains.  Some of
these have been VPSes, others dedicated servers.

I have run a variety of services on these servers, both self-written
software (using PHP, Python, Haskell, Go, Ruby, and Erlang) and
open-source software (using a variety of technologies), sometimes
dockerised, sometimes not.

Many of these servers have been single-user, but I also operated two
servers for [HackSoc][], the University of York Computer Science
Society, while I was chair.

Running an internet-connected server requires you engage with
security, so I have some basic competence of securing Linux servers,
such as closing ports with iptables, requiring SSH pubkey auth, taking
regular [backups][], and managing user permissions and quotas.

Currently all of my servers run [NixOS][], with
[configuration-as-code][] and, where possible,
[infrastructure-as-code][].

[HackSoc]: https://www.hacksoc.org/
[backups]: backups.html
[configuration-as-code]: https://github.com/barrucadu/nixfiles
[infrastructure-as-code]: https://github.com/barrucadu/ops

### Ph.D

I did a Ph.D in [testing concurrent Haskell programs][] at the
University of York.  As part of that I developed a tool, [dejafu][],
for writing such tests.  It lets you write deterministic tests to
check for race conditions and similar concurrency bugs.  dejafu is
based on "systematic concurrency testing" (or "stateless model
checking"), and is explained in the thesis.

It is a complicated tool, where I have had to determine the Haskell
operational semantics of: shared memory concurrency, synchronous and
asynchronous exceptions, software transactional memory, two relaxed
memory models, locks, and primitive atomic operations.

[testing concurrent Haskell programs]: https://www.barrucadu.co.uk/publications/thesis.pdf
[dejafu]: https://github.com/barrucadu/dejafu

#### The Ph.D experience

A Ph.D is a significant, self-driven and -defined, research task.  The
desired outcome is poorly specified, and changes as the project
progresses.  It is essentially an apprenticeship in conducting novel
research.

I had to learn several skills to complete it:

- reviewing and identifying gaps in existing work,
- time management,
- prioritisation,
- explaining ideas to non-experts, through:
  - writing,
  - presentation,
  - conversation;
- approaching and engaging with other experts,
- convincing senior stakeholders of the merit of my ideas.

I have given presentations at two international conferences: the
Haskell Symposium in 2015, and the Functional and Logic Programming
Symposium in 2018.  Giving a presentation in front of a room of
experts is a very effective way of conquering a fear of public
speaking.

#### Engaging with users

The usual fate of research software is to solve the problem of
generating enough interesting data to get one paper published, and to
then be abandoned.  Maintenance doesn't get papers published.

I wanted to avoid this with [dejafu][], and so from the beginning I
worked hard to make the tool useful to other people, by:

- writing documentation,
- profiling and improving performance,
- simplifying APIs,
- providing integrations for widely used testing frameworks.

And it paid off.  [dejafu][] managed to gain a few users, including
some commercial users I worked with on specific problems they had.
One such user had the following feedback:

> I'd like to add that dejafu tests are by far the most reliable tests
> in our suite, in my experience---I am yet to see a concurrency bug
> that they didn't spot, while some other tests missed them!

### Pusher

During my [Ph.D][] I did an internship with Pusher, working on a
high-performance distributed message bus written in Go, using [Raft
consensus][].  This would potentially be a replacement for the
existing message bus used in Pusher's core product, and had strict
performance and load requirements.

I arrived as the project was leaving early prototype stage, and was
being made more production ready, so I had opportunity to work on
scaling, reliability, and testing (to make sure the new version
behaved the same as the prototype).

Unfortuntely, the code is not available, but during my time there I:

- implemented some missing protocol features, making the message bus
  compatible with Pusher's existing infrastructure;
- implemented a fuzz-testing tool, to generate random sequences of API
  calls and compare the outputs of the old and new systems;
- rewrote various state-management pieces of code, significantly
  reducing allocations, reducing garbage collection pause times by
  enough for the program to meet its latency requirements.

When I left, the code had been deployed to one production cluster.  I
heard a few months later that it had been switched off after an
incident, as the developers had been moved to another project so there
was nobody available to maintain it, but until that time it had been
performing well.

[Raft consensus]: https://raft.github.io/

### GOV.UK practices

GOV.UK teams work in an agile "scrumban" sort of way, and are lead by
a Product Manager, a Delivery Manager, and a Tech Lead.  Each team
does things slightly differently, as it should be.  Common practices
are:

- use of Trello as a kanban board,
- one- or two-week sprints,
- daily standups,
- regular show-and-tells,
- regular retrospectives.

People generally have flexibility to move between teams as they wish,
subject to business requirements.

#### Peer feedback

Soliciting and giving peer feedback roughly quarterly is encouraged,
as is giving one-off feedback outside this cycle if desired, and feeds
into the annual performance review.

#### Tech community

As a senior developer and a tech lead, I participate in things beyond
just individual contributions:

- I line manage mid-level developers, which includes onboarding if
  they are a new starter,
- I attend our regular Tech Debt Review, to ensure that we understand
  what tech debt we have and that we're working on it,
- I attend our regular Tech Lead Standup, to share what the team is
  doing and to keep abreast of changes elsewhere on GOV.UK,
- I help out our informal Developer Tooling Group, working on small
  things like patching our dev tools or updating documentation,
- I give presentations at our Tech Fortnightly event, sharing
  knowledge and progress with the wider community,
- I sift CVs and have been trained to participate in interview panels,
- I am on the [GOV.UK support](career-levels.html#gov.uk-support)
  rotas.

#### Tech practices

GOV.UK is built out of Rails microservices, and there are some
standard conventions, [documented more fully here][], which apply
across all teams:

- we use [rubocop-govuk][] and [stylelint][] for automated linting,
- we use [rspec][] or [minitest][] for automated unit testing,
- we use [Pact][] for automated API contract testing,
- we keep our dependencies up to date,
- we embrace [12 factor conventions][].

There are also other tech practices, beyond just how we write our
apps:

- we use GitHub for code hosting, and [work in the open][],
- we use [Jenkins][] for continuous integration and continuous deployment,
- we use [puppet][] and [terraform][] to manage our infrastructure,
- we write <abbr title="Architecture Decision Record">ADR</abbr>s and <abbr title="Request for Comments">RFC</abbr>s to build consensus for big technical changes.

[All of the GOV.UK RFCs are available online][].

[documented more fully here]: https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html
[work in the open]: https://github.com/alphagov/
[rubocop-govuk]: https://github.com/alphagov/rubocop-govuk
[stylelint]: https://stylelint.io/
[rspec]: https://rspec.info/
[minitest]: http://docs.seattlerb.org/minitest/
[Pact]: https://docs.pact.io/
[Jenkins]: https://www.jenkins.io/
[puppet]: https://puppet.com/
[terraform]: https://www.terraform.io/
[12 factor conventions]: https://12factor.net/
[All of the GOV.UK RFCs are available online]: https://github.com/alphagov/govuk-rfcs

#### User research

We do frequent user research for GOV.UK projects.  There are dedicated
user researchers, but anybody can participate in research as a
note-taker (taking detailed notes of what the participant said or did,
without making judgements or inferences) or as an observer (taking
less detailed notes and including personal observations).

I have participated as both a note-taker and as an observer, for early
work on Brexit and for [GOV.UK
accounts](career-levels.html#gov.uk-accounts).

### GOV.UK support

All GOV.UK developers are expected to join the in-hours support rota,
and all backend developers the on-call rota.  Support consists of
responding to support tickets (only in-hours) and to alerts.  There
are two developers on support at a time, for a week-long shift.

Shadowing another developer on the in-hours rota is a pre-requisite
for getting production access.

I have shadowed, been primary and secondary developer on the in-hours
rota, been primary and secondary developer on the out-of-hours rota,
and have been shadowed.

#### Dealing with incidents

I have been an Incident Lead, the developer tasked with coordinating
the solving of an ongoing incident and pulling in other people as
needed.  This is an organisational role, and doesn't necessarily
involve directly fixing the problem.  Though in practice I have got
stuck into solving as well.

I have also been a Comms Lead, the developer tasked with updating
non-technical stakeholders, some of whom are in other parts of
Government, and with drafting the incident report to form the basis
for discussion at the incident review.

#### Reviewing documentation

Being on support is also an opportunity to review and update
documentation, especially useful as much of our documentation is
supposed to be used when supporting things.

Some example PRs:

- [Document restarting an app](https://github.com/alphagov/govuk-developer-docs/pull/3046)
- [Add docs for manually resizing an EBS volume](https://github.com/alphagov/govuk-developer-docs/pull/2880)
- [Remove pgbouncer / postgres advisory locks docs](https://github.com/alphagov/govuk-developer-docs/pull/2443)
- [Review all the search docs](https://github.com/alphagov/govuk-developer-docs/pull/2281)
- [Add some documentation for how to debug underperforming search](https://github.com/alphagov/govuk-developer-docs/pull/1763)

### GOV.UK platform health

The Platform Health team looks after parts of GOV.UK which don't have
another dedicated team.  It does a mixture of *proactive* and
*reactive* work, working to solve bugs and reduce tech debt, while
also making problems less likely to crop up in the future.  It's not
an infrastructure team, we have separate SREs, but sometimes it does
dabble in infrastructure.

When I joined GOV.UK I started on the Platform Health team, which I
think helped me get up to speed with the whole GOV.UK stack much more
quickly than I would have if I'd joined a team with more tightly
focussed work.

#### Load testing

I did initial investigation and prototyping work for [load testing
GOV.UK][], settling on [Gatling][] and writing the initial
documentation and test plans.

[load testing GOV.UK]: https://github.com/alphagov/govuk-load-testing
[Gatling]: https://gatling.io/

### GOV.UK search

GOV.UK search is powered by an AWS-managed [Elasticsearch][] cluster
and [TensorFlow Ranking][].  I have been on two different GOV.UK
search teams, and have acted as a team expert on Elasticsearch.

[Elasticsearch]: https://www.elastic.co/elasticsearch/
[TensorFlow Ranking]: https://github.com/tensorflow/ranking

#### A/B testing

I supported a performance analyst on the team with running A/B tests
to test the effectiveness of changes to our search algorithm, some of
which I proposed.

#### Upgrading Elasticsearch 2 to 5

We were using Elasticsearch 2 long after its end-of-life, and needed
to upgrade to the then-latest major version, Elasticsearch 5.  We also
decided to migrate to an AWS-managed cluster, from running a
self-managed cluster nobody really understood, at the same time.

I worked with one other developer and a technical architect, and
consulted with our SRE team, to plan and implement a zero-downtime
migration, which involved:

- determining the size of the new cluster and creating it,
- spinning up a copy of our [search-api][] microservice in AWS and
  implementing support for Elasticsearch 5,
- modifying our [finder-frontend][] microservice to support calling
  either the old or the new search-api,
- migrating documents to the new search index, and ensuring it was
  kept up to date through our normal publishing process,
- flipping the switch to direct search queries to the new search-api,
- monitoring for performance and stability,
- tidying up: removing the Elasticsearch 2 cluster, deleting the
  Elasticsearch 2 search-api, and removing now-unneeded VMs.

[search-api]: https://github.com/alphagov/search-api/
[finder-frontend]: https://github.com/alphagov/finder-frontend

#### Upgrading Elasticsearch 5 to 6

After upgrading to Elasticsearch 5, the old search team was split up.
I moved to a new search team, and the other developer moved to a
different team.  So on the new team I was the Elasticsearch expert.

We decided to upgrade to Elasticsearch 6, which had recently come out.
I planned and implemented a zero-downtime migration.

This was a significantly easier upgrade than from Elasticsearch 2 to
5, partly due to having the experience of having done one upgrade, but
mostly because Elasticsearch 5 to 6 was a smaller jump.  The plan
involved:

- updating our [search-api][] microservice and our data schemas to fix
  all the Elasticsearch 6 incompatibilities,
- adding support to [search-api][] for two Elasticsearch clusters: to
  be kept in sync when indexing, and to be chosen by a parameter when
  querying,
- spinning up a new Elasticsearch 6 cluster and importing the existing
  search indices,
- flipping the switch to direct search queries to the new cluster,
- monitoring for performance and stability,
- removing the Elasticsearch 5 cluster and the switch.

This upgrade required making significant changes to our query
structure, as the scoring mechanism changed between the versions.  For
a while we ran an A/B test directing users to either the old or new
cluster, and tweaked until we had something performing roughly the
same.  I prototyped using [particle-swarm optimisation][] to tune our
ranking factors, but this turned out not to be fruitful.

[particle-swarm optimisation]: https://en.wikipedia.org/wiki/Particle_swarm_optimization

#### TensorFlow Ranking

After upgrading to Elasticsearch 6, our search results weren't quite
as good as with Elasticsearch 5.  One developer discovered [TensorFlow
Ranking][] and had promising initial results.

I participated in getting a prototype of this running in our
production infrastructure, a local [Docker][] container on the same VM
as [search-api][].  When we had that up and running with good results,
I worked on productionising it, moving the model to [Amazon
SageMaker][] and implementing a daily pipeline, using [Concourse][] to
fetch analytics data, train, and deploy a new model.

[Docker]: https://www.docker.com/
[Amazon SageMaker]: https://aws.amazon.com/sagemaker/
[Concourse]: https://concourse-ci.org/

### GOV.UK accounts

I have been the tech lead on the GOV.UK accounts and personalisation
work since mid-2020.  This is my first time as a tech lead.  I work
with the product manager and delivery manager to define what the team
wants to achieve, and to break down the work into manageable chunks
which can be given to other developers.

I also work with user-centred design colleagues to ensure we're
building what we need to build, and to advise on relevant technical
constraints and implications.  Sometimes the best UX does not give
rise to the cleanest technical implementation.  During our prototyping
phase, I have been pragmatic about this, and we have implemented
things which we probably wouldn't want to do if we were building this
for real.  But I have communicated these problems, and the team's
product manager has agreed that as we shift to a more mature product,
we will work to reduce these tech debt concerns.

I participate in meetings with senior non-technical stakeholders,
demoing work and discussing the team's progress.  I also work with
other technical stakeholders---a technical architect, a member of our
cybersecurity team, and one of the GOV.UK lead developers---to ensure
that the team has adequate resources and is doing the right thing to
fit in with the work of other teams.

Nobody on the team knew much about OAuth or OpenID Connect before we
started, and we went through a period of reading and learning in the
first few weeks.  Since then I have acted as a team expert on the
specific authentication flows we have been using.

I have also done a lot of the implementation work myself, as the team
is quite small.

#### ADRs and RFCs

We use <abbr title="Architecture Decision Record">ADR</abbr>s and
<abbr title="Request for Comments">RFC</abbr>s to build consensus
amongst the GOV.UK technical community.  ADRs are for team-level
decisions whereas RFCs are for larger decisions.

I have used ADRs to explore architectural decisions and their
implications in the accounts work, reviewed by other developers and
the technical architect on the team.

I have used an RFC to [build consensus for how to implement a
GOV.UK-wide login][].  Developers from other teams commented, and my
proposal had to make sense to someone with no specific context of the
accounts work.  The proposal ended up changing in response to
feedback, and benefited from it.

[build consensus for how to implement a GOV.UK-wide login]: https://github.com/alphagov/govuk-rfcs/pull/134

#### CI and CD

We set up CI using [GitHub Actions][], as soon as we had code to test.
We set up CD, using [Concourse][], shortly afterwards.

CD saved us a lot of time and effort, but it wasn't perfect.  We would
occasionally have a deployment fail, and nobody would notice for a few
hours or days.  Then someone would fix it and a bunch of changes would
get deployed at once.

I implemented some alerting in our deployment pipeline, notifying our
team Slack channel if a deployment failed.  This meant we noticed
issues as soon as they cropped up, and could fix them promptly.

[GitHub Actions]: https://github.com/features/actions

#### Documentation

There is a tech writer on the team.  This is the first time I have
worked with a tech writer.  It's been a useful experience having a
non-developer review docs, especially when the developer reviewer is
usually a member of the same team.  A separate technical writer
doesn't have the same detailed technical knowledge, and so approaches
the review from a different viewpoint.

#### Monitoring and scaling

Our first experiment launched with limited monitoring and no
auto-scaling.  I worked with a cybersecurity colleague and two other
developers to define and implement appropriate monitoring and
auto-scaling, involving:

- setting up basic [Prometheus][] metrics and a [Grafana][] dashboard,
- defining sensible alerting thresholds,
- defining sensible auto-scaling thresholds and limits,
- exporting our application logs to [Splunk][],
- setting up [additional logging][] of relevant events.

[Prometheus]: https://prometheus.io/
[Grafana]: https://grafana.com/
[Splunk]: https://www.splunk.com/
[additional logging]: https://github.com/alphagov/govuk-account-manager-prototype/pull/491

#### Pair working

Since this is a new area for GOV.UK, there have been a lot of
unknowns.  One member of the team has also not worked much with
GOV.UK's existing stack.

I have always been willing to jump on a call with someone and work
through a problem they are having, either just talking through the
concepts, or getting down to the code and doing a little pair
programming.

#### Prototyping

I built initial prototypes for our [identity provider and account
manager][] and [user data store][] microservices, as well as a
microservice to integrate with those.  We first built these prototypes
on top of [Keycloak][], but I rewrote them to be standard Rails apps
using pre-existing Ruby gems to implement the OAuth and OpenID Connect
functionality.  This rewrite was to make it easier for our frontend
devs to do their work, as we have established patterns and tools for
making GOV.UK-style frontends for Rails apps.

After implementing the initial versions of the prototypes, other
developers contributed significantly.  However, there were a few other
large features I independently designed and prototypes, such as:

- **Analytics.**  I implemented an initial approach to cross-domain
  analytics, so that users who have opted into analytics cookies are
  tracked both in services they use and in their authentication
  journey.

- **Multi-factor Authentication.** We decided shortly before release
  that we needed MFA, and that implementing this would likely delay
  our launch.  I implemented a simple SMS-based MFA in a few days,
  allowing us to launch only a week after we had planned.

[identity provider and account manager]: https://github.com/alphagov/govuk-account-manager-prototype/
[user data store]: https://github.com/alphagov/govuk-attribute-service-prototype
[Keycloak]: https://www.keycloak.org/

#### Security and privacy

Most of GOV.UK is indifferent to who is using it.  Only the email
subscription system is comparable to the accounts system, and so we
don't have very good knowledge of how to handle personal data.

To get this right, we have:

- thought about how we can implement privacy in our code by design,
- done threat modelling exercises,
- involved a member of our privacy team as a consultant,
- involved a member of our cybersecurity team as a consultant,
- had meetings with the [NCSC][] to discuss our architecture and
  threat modelling.

On the privacy-by-design point, we decided to enforce unlinkability by
implementing [pairwise subject identifiers][].  This involved giving
our user data store the privileged ability to look up the "true"
subject identifier behind a pairwise one, so that different services
can retrieve data on the same user, even though they each know the
user under a different identifier.

GOV.UK has a quarterly IT Healthcheck (pentest).  This identified
issues in our code, which I worked to resolve, or to mitigate where
full resolution was not possible.  I also received a report, from an
ex-GOV.UK colleague, of an authentication vulnerability which I fixed.

[NCSC]: https://www.ncsc.gov.uk/
[pairwise subject identifiers]: https://openid.net/specs/openid-connect-core-1_0.html#PairwiseAlg

#### Testing practices

One of the developers on the team raised the issue that our testing
practices were inconsistent, each developer had their own
idiosyncrasies.  I lead a session to resolve this issue, where we
examined testing practices elsewhere on GOV.UK.  Ultimately we decided
that since we were building throwaway prototypes, it didn't matter too
much as long as our tests were mutually comprehensible and followed
our overriding style guide (as implemented by a linter), but that when
we started building "real" things, we would strive for consistency.
