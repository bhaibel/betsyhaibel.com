Hi, everyone!

I've been asked to talk to you about getting a foothold in tech when you've got a non-technical background. There are two main parts to this: learning how to leverage what you already know, and figuring out what to learn next.

First off, though, a little about me.

---

So, I'm a little weird. I've been working as a programmer for six years, five of them in Ruby. Before that, I was doing theater. Before *that*, I went to a STEM-oriented high school, so selling my background as completely nontechnical seems a little like cheating. But the skills that got me my first tech job aren't ones I learned in school, and neither are most of the skills I use day-to-day. Honestly, a lot of the skills I use day-to-day are ones I got in theater.

---

In theater, I worked the backstage side of it -- mostly set design and painting, but I've done pretty much every job that doesn't involve performing. And filling a technical role in theater is as much about negotiation as it is about technical skill. Everyone's working together as a team to make the production be as big an artistic success as possible, and directors like to dream big. They *always* want more than your budget allows, and they sometimes want more than physics really allows. Same for designers, if you're on a production big enough that design and build are carried out by separate people. And it's really easy, when someone tells you to build something that seems to rely on gravity forgetting to *gravity* to feel a little snappish about it in your head for a minute.

So a lot of the work wasn't about actually drafting out set diagrams. It was about working with the rest of the production's technical and artistic staff to figure out solutions that expressed the director's artistic intent, were physically possible, and came in more or less within budget.

---

The thing is, if you replace a few words in that description, you're also describing my job as a Rails engineer. The central deliverable for my job is not "pretty code," or even "working code." It's "a product that serves the needs of users." The end-user does not care how fancy the tech looks under the hood. The Client Success team at my company doesn't either. Your job is to build something that works well enough in a reasonable amount of time, and most of that job is about what figuring out what "well enough" looks like so that you can actually swing "a reasonable amount of time." A lot of the skills you need for that are the bog-standard communication skills that you've picked up in other workplaces; you just need to refocus them. One coder friend of mine used to be a social worker -- it turns out that politely telling clients "no" when they're asking you to build them Google on the cheap is not that different than politely telling them "no" when they're asking for social services that your program can't provide.

---

More specifically, you probably already know about coding than you think you do. You remember how I went to a fancy high school for nerds? Well, the very first thing our first CS class there was designed to do was to level the playing field: to show the people who'd been playing with BASIC for years how little they knew, and to show the people who hadn't done that that they weren't actually hopelessly behind. And the way they did this was by *not letting us touch* "normal" programming languages for all of ninth grade. Instead, the very first programming language we learned in this fancy high school... can anyone guess?

---

Microsoft Excel.

Microsoft Excel, and the related spreadsheet language Google Sheets, are incredibly powerful languages. They use a visual editor and a highly structured programming style -- functional reactive programming, if you want the full technical name -- to allow people to rapidly build applications that serve their immediate business needs. Spreadsheet languages also allow people to rapidly prototype numbers-driven applications and more easily figure out the requirements for production-scale applications written in lower-level languages.

---

The biggest skill you need as an applications programmer is domain modelling, or the ability to break down a user's or a business's problems into small units that a computer can understand, and organize them. There are a bunch of different paradigms you can use to do that, and it's a field that it takes a very long while to get *good* at, but if you know Excel, you've already started learning it.

Okay, so those are the things I'm pretty sure you already know. And I think it's important to remember that you do know them, and that they're the bulk of the actual job -- I'm not going to bullshit you. You know a little Ruby right now. You don't know enough to get hired. It's okay. You just need to figure out what to do *next*.

---

When you try to figure out next steps after today, a lot of people are going to tell you a lot of different things. Modern large-scale applications development is often a lot like wiring together a lot of different puzzle pieces, and everyone has their favorites, and they are going to tell you to learn their favorite next.

It's really easy to get lost. Like, I've been doing this professionally for six years, and the other day I was trying to build something using server-side Javascript, and the Javascript community changes really fast, and so I wound up spending a lot of time figuring out if I needed to use a yeoman generator that bundled in webpack, and what webpack even *did* -- anyway, I'm still honestly not sure about that last one, because after a few hours of that nonsense I realized that I wasn't focusing on the actual thing I was trying to build any more.

---

As a coder, your goal should always be on focusing on a "good enough" solution for the problem at hand, not on the theoretical "best" solution that will take thirty times more time. The definition of "good enough" gets more complex as you move forward, but right now, as raw beginners -- does it work? Then it's probably good enough.

---

The very first next project you should do, after you leave here, is something you can use. If you use Excel a lot at your current job, maybe take a spreadsheet and see if you can build a Rails app that fills the same needs. Or if one thing you do repetitively is scan a given website for changes, learn about Nokogiri and write a script that automates that. Or learn Liquid and make a taggable database of customer-service form letters. Or if you don't want to think about work, maybe something that lets you keep track of books you want to read, and whether you liked them after you finished. The actual thing doesn't matter, so much as: what is a small thing that, I, personally, will find useful?

Congratulations, you've just learned how to solve a real-world problem with Ruby. And you can put it on Github and Heroku, and when an interviewer asks: "hey, what can you do?" you can say "well, I built that."

Next up, build another small thing. Maybe it's a new feature in your first app, or maybe it's another thing entirely.

Now's when it's useful to start looking at new technologies. If at a glance they look relevant to the thing you're building, or to a different thing you *could* build, then try building that in them!

---

suggest some technologies:
    <li>image uploads: carrierwave, s3</li>
    <li>Javascript: use JQuery to add dynamic UIs</li>
    <li>Compass and SCSS: for more prettier websites</li>
    <li>Resque: run long tasks in the background!</li>
    <li>new databases: MongoDB's good for content management.</li>
    <li>geocoding gems: store map data</li>

---

But always remember -- if figuring out how to use a gem or a javascript framework or an anything in an existing project is hard, maybe it's not the right tool for that project; maybe you don't need to learn it yet. At the end of the day, you're not going to get hired based on how many gems you know; you're going to be hired based on whether you know how to learn them, and whether you have the judgement to know whether a tool will make a project easier or harder.


---

After you've built a few things, try reading books on refactoring, or test-driven development, or other things that will make your code *better* -- and then see if you can apply that to the projects you've got. Again, if something is rough going, maybe it's not something you need to know yet. It's always okay to put something down for a while and come back to it later to see if it makes more sense then.

---

This is when things like code katas start to make the most sense -- code katas are small, set exercises that you can solve a few ways, and so trying to make your code kata solutions better is a good way to learn how to write "prettier" code without getting lost in decision paralysis.

---

Also, read other people's code. I used to think that gems were little boxes of magic, written by people who were way better at this than I was. Mostly... they're just code, written by people. And so first off it's really reassuring to be reminded of that. Second off, if you get a *really weird* bug that traces through one of your gems, this will mean you'll know why the fix works when you fix it. Third off, it'll give you new ideas! I got a lot of really cool tricks from reading the Carrierwave codebase, for example.

That said, it might seem natural at first to try to read the Rails codebase. All blessings on you if you go that path, but it is full of dragons. Maybe start with something simpler?

---

Last off -- please do find a community. To be frank, the Ruby community has historically not always been great about women in it. But it's improving, and a lot of Ruby people in DC are great, friendly sorts. I co-run a meetup with my co-worker Chris -- wave, dude -- and Maggie Epps from SocialDriver; we're called Learn Ruby in DC, meet every other Saturday in the afternoons. Women Who Code DC also holds beginner Ruby meetups, and a similar meetup called Learn.JS just started up. There's also all-levels meetups like DC Ruby Users Group, Arlington Ruby, and Ruby LoCo - so you can probably find a group with a location and schedule that works for you. You're going to get stuck sometimes. It's the nature of the work. Being part of the community means that you can have colleagues who get you unstuck, people to vent to when you're really angry at your computer, and people who can help you figure out what to learn next. There's no reason to do this in a vacuum.