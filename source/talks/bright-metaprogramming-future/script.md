Hi, everyone. My name's Betsy Haibel, and we're here today to talk about metaprogramming.

---

First, let's get some consensus as to what metaprogramming is. When I was explaining my talk to my parents, I used the shortcut that a lot of people use: "oh, it's code that writes code." There are two problems with this definition. First off, it's overbroad to the point of wrongness, or at best meaninglessness. Are C generators metaprogramming? What about quines? The second problem with it is that it makes your parents think you're building Skynet.

---

Then there's the definition of metaprogramming, that, experientially, most of us actually *use* when we talk about metaprogramming. This definition, like many internalized engineering definitions, is fuzzy and handwavy and hard to pull out into the light and air, but when we as developers say "metaprogramming" we mostly seem to mean "stuff that does magic and uses too few words to grep easily." This is also an over broad definition. It encompasses Perl.

---

Metaprogramming is instead programming that treats the structure of the program itself as a data structure to be manipulated like any other.

---

The first way you can play with program structure in Ruby is using the send method. The most common in-the-wild use case for send is probably invoking private methods — Ruby's privacy model, like most other Ruby structures, exists to make suggestions to developers rather than bind thim.

But, send is good for so much more.

----

Ruby relies on what's called a "message passing" model for method invocation. Ordinarily, this is hidden behind syntactic sugar -- the dots you use to invoke methods, behind the scenes, "send" the name of the method as well as any arguments you include in the method invocation.

---

Using Object#send makes this a little more explicit. a.bar and a.send(:bar) are semantically equivalent, but when you visualize a method invocation using "send", it makes it really clear that what you're actually passing to the object is a bag of arguments, the first of which must be a symbol or a string. The "method name" argument has a special status -- it directly determines which block of code is called next,

---

almost as though an object is just a giant case statement --

---

-- but ultimately, all the arguments in that bag of arguments are just ways of passing information to an object about what you want it to do.

---

Anyway, let's move on to how send can be used and misused in the wild.

When I was a wee baby coder - Friday, the first week of my first Ruby job - I discovered Object#send and what it could do. I'd been working with delayed_job all day to do asynchronous transactional email. For those of you not familiar with the library, its core was the method `send_later`, which looked like this and which did, more or less, what it looks like  queued a job that would invoke the sent method name.

---

I was using it in the context of a method that looked something like this - a straightforward observer that looked for attribute changes that would trigger emails, and queued them for sending if appropriate. I say "something like" this because actually the method looked more like this:

----

(pause)

----

I did not like this code. It got the job done, but I didn't like how it got it done. I'd trained in C and Java and Perl, so I was used to the idea that method names were these magic computer things, entirely separate from the data that the methods were acting upon. When you're coming from that mindset, you accept a certain amount of repetition and boilerplate as inevitable. You write thirty getter and setter methods for a class's attributes, individually, each one line long and formulaic as a Garfield strip.

I resented the hell out of this, but I didn't know how to improve on it. I thought you couldn't.

And then I looked at the `#send_later` method, and cocked my head, and asked myself if its name was riffing off of something named `#send`....

---

Some Googling and twenty-thirty minutes later, the code looked more like this. I identified a pattern that had been expressed via repetition, and expressed that pattern with code instead - namely, by invoking methods dynamically using "send" rather than statically with copy and paste.

----

And I felt like this. Or, really - uh, animated gif warning, for the epileptics in the room - 

----

more like this. (pause)

---

Okay, open your eyes again now.

And this is how it's supposed to work, right? I came from this background where I couldn't do a thing, and then I learned more Ruby and I could and it was a frabjous day. And also, I did something cool at 4:30 on the Friday of my first week ever doing Ruby professionally, and I was just some kid with no college degree they'd taken on on a trial basis, so those twenty minutes probably did wonders for my job security.

Alas and alack, for I learned the wrong lesson:

----

This next code is an amalgam of code I wrote and code that I've seen other people write that I *could well* have written during this part of my programming career. Names have been changed to protect the guilty.

---

So, we've got some code that searches within a set of models and then sends their data on to the formatter. Now, like I was saying earlier, a lot of the time when you're using dynamic method calls you're using them to express a repetition that had previously been expressed with copypasta, and this is definitely what's going on here. Reflexively reaching for dynamic method calls to fix this problem has three traps, though.

---

The first is that it breaks grep. Ordinarily when I'm spelunking through new code I search for method names to see where they're defined and invoked, but I can't find where format_whatever_results_for_some_user_type is defined because I don't know what method name is really being sent. Similarly, if I'm looking at the definition for format_pants_results_for_anonymous_users, and I search for where it's used, this instance won't come up.

----

The second is that it introduces cyclomatic complexity. Cyclomatic complexity is, approximately, the number of paths that data can take through your code, and high cyclomatic complexity is a bad thing because it means you need to keep track of more things to figure out what your code's doing. Conditional statements like "if" and "case" increase it. Shoving an implicit conditional under a rug by using send doesn't make the cyclomatic complexity thus introduced go away.

---

The third thing is that using a dynamic method call to reduce repetition at the call site often spackles over a far uglier repetition elsewhere in the code, which has happened here. Let's fix it!

Now, this is a refactoring in which things are going to get uglier before they get prettier, but eventually things are gonna clear up here.

---

The first thing we do is change the method signature up a little. When you do a dynamic method call, you cheat message-passing a little by sending multiple pieces of data in with the method-name argument. Here, these multiple pieces of data are the abstract "format stuff for stuff" method name structure, the garment, and the user type. So, one of the first things we can do is make a new method signature that makes the implicit arguments "garment" and "user_type" explicit arguments instead. The quickest way to do this is move the send call into Formatter, which also isolates it within its class and makes it a bit easier to understand in context.

---

The second thing we do is recognize the repetition of the "results" argument and remove it by turning Formatter into a real class rather than a bag of class methods.

---

Next we look for more repetition. There's some low-hanging fruit here: both of the format_sweater_results methods share a lot of data returned. 

---

We extract that into a sweater_attributes method.

---

Then we move that onto Sweater, where it actually goes. That makes a ridiculous indirection that we have here really obvious - we're asking the Sweater class what data we want out of a sweater object, and then retrieving that data from it, rather than just asking the sweater object "what data do we want out of you? Why don't you just give it to us?"

---

So we switch to doing that, and also do that on Hat for good measure.

---

And of course we update the Formatter to reflect this.

---

The Formatter class now looks like this; it's much smaller and prettier. Since it's smaller, we can see other repetitions that were harder to see before. Now, both the format_whatever_for_user methods are identical!

---

So we collapse into just two methods, format_for_user and format_for admin

---

and get rid of the garment argument as superfluous.

---

If we want, we can also get rid of that last dynamic method call by moving to a polymorphic approach for the formatters - here, we use const_get to pick out the right formatter.

---

If you hate const_get, you can also get the equivalent effect by using a hash to store explicit class names, but for the most part I think that's overkill.

---

We're not fully getting away from dynamism here - we're just choosing which class to instantiate dynamically, instead of which method to invoke. But now the dynamism is encapsulated within a single file and a single family of classes, so its effect on the cyclomatic complexity and searchability of the entire application is significantly reduced. And Ruby's capacity for dynamism is one of the best things about the language -- look at how concise and pretty that const_get call is! Think about how many lines you would need to write to do the same thing in a less dynamic language! And the more code there is on the screen, the more code you need to keep in your head.

---

Next up, #method_missing.

---

So, let's go back and look at these methods again.
These. like most of the rest of ActiveRecord, are defined using method_missing, which allows us to dynamically respond to arbitrary method names. After all, a method name is just a part, like any other, of the bag of arguments sent to an object.

---

In order to explain how method_missing works, we need to examine Ruby's default lookup chain. When you send a bag of arguments to an object, Ruby first looks at the object itself, or rather at its eigenclass, to see if any singleton methods have been defined that match the sent method name.

---

Next, it looks at the object's class.

---

Then, it looks at the object's inheritance chain: at all the modules that have been inserted into the lookup chain with include or extend, and at the object's superclass --

---

and at it's superclass's superclass, and so on and so forth, all the way up to Object.

----

It may find nothing, which is where method_missing comes in. method_missing is a special method that allows you to describe fallback handling in the case that no method matching the sent name is found within the object's lookup chain.

----

So, after Ruby has gone all the way up to Object in the ordinary lookup chain, it starts over and looks for method_missing on the object's eigenclass

---

and on its class

---

and so on and so forth

---

again, all the way up to Object.

---

If and only if nothing is found, it gives up and spits out a NoMethodError.

---

So, in the wild, method_missing looks a little like this. This is an oversimplification of how ActiveRecord uses it, but this is the general shape of it. method_missing gets passed the bag of arguments that you sent the object and decides what to do based on them.

This oversimplified version of it that I'm showing here is making three really common mistakes with the use of method_missing.

---

The first is that it's not including a call to super. If you don't include a fallback to super somewhere within each method_missing definition, the lookup chain will stop within the first method_missing it finds and potentially bypass something further up the chain that might know how to deal with the given method name.

---

The second is that there's no parallel definition of respond_to_missing. Right now, if you send this method name to respond_to, it will say "false," because no method is defined with this name on the object.

---

respond_to_missing, which looks like this, allows you to expand respond_to's conception of what method names an object responds to. It's necessary whenever you're using method_missing because otherwise you're potentially lying to anyone who uses your object about what it can do.

---

See? Much better.

---

The third mistake is that we're not defining the method in the method_missing call. method_missing-based method lookup can be slow if you use the method multiple times, because you need to go alllll the way through the lookup chain each time. If you're going to be using a method defined this way frequently, it's good practice to, in effect, cache the method by explicitly defining it using define_method within method_missing.

---

Now for a subtler mistake you can make in and around method_missing. This is one I've made relatively recently - if any of my old colleages from LearnZillion are watching this, I'm *really sorry.*

So, let's say you have a mixin that relies on the breed_codes method being defined on an object.

---

And two objects, one of which explicitly defines breed_codes and the other of which implicitly defines it using ActiveRecord's method_missing-based strategy. If you call breed_codes on a Cat right now, what happens? 

---

breed_codes is defined all the way up in the superclass's method_missing.

---

So, first the method is looked up on the eigenclass

---

And then on the class

---

And then it finds a definition! Unfortunately the definition is "throw a NotImplementedError." The explicit definition of the NotImplementedError is before the implict definition in the method lookup chain, and so it takes precedence. So, how do we get around this?

---

This is what I did at LZ. Please don't do this. It means that poor HasBreeds, or whatever, will unfairly become a part of every single debugging session when you typo a method name, since its method_missing call will be an attractively late part of the backtrace.

---

If you do this instead, it will work. That's because "super" doesn't care whether something is actually defined further up the method lookup chain, it just defers it one further up

---

so that you can get to the implicit definition perfectly fine.

---

You can also do this, which is a little more explicit and stays within the mixin. Or you can get rid of the debugging convenience of the NotImplementedError.

But the fact that all of these are even questions illuminates some of the hidden costs of making a method_missing-driven dynamic interface -- it doesn't play nicely with strategies for good object-oriented design in Ruby, and so defaulting to it when you want easy dynamism makes your code far less extensible later.

---

So, what is method_missing good for? The traditional use cases for it are pretty dynamic DSLs, like ActiveRecord finders, or pretty global config singletons like Amberbit, or objects that delegate most of their methods.

But, honestly, I'd argue that none of those are actually good uses - pretty dynamic DSLs are usually better expressed with options hashes than method names, you can use OpenStruct for extensible config objects, and Ruby has a nice built-in delegator class. Some of these use method_missing under the hood, but it's hidden under a nice well-maintained and well-understood interface, which isn't necessarily true of a more homegrown solution.

---

So, how then are we to do dynamic method definition? define_method is slow, and like dynamic method calls with send it's frequently used to hide bad class design, but it's both a lot more flexible and a lot more explicit than method_missing so I prefer it.

---

Its syntax is really straightforward - you pass it a method name and a block defining the method.

---

So, let's examine how it can be used to clean up code. We have here some nice repetitive method definitions!

---

define_method lets us pull it out into a an each block. This cuts lines, and more importantly illuminates the deeper structure of the code.

---

Later on in this theoretical project, we decide to isolate the attachment-definition code in its own module for later reuse.

---

despite the fact that most good photos are of cats.

---

This code isn't awful, but we can take it a bit further. Right now, it's not very extensible. If someone using this module wants to override our definition of photo_url, their redefinition will be on the same class that our definition is on, because define_method is called by a macro within the context of the including class. If they want to include our definition within their extension, they won't have access to super with which to do so. Instead, they'll either need to copypaste our definition in or resort to an ugly workaround like rails's alias_method_chain.

---

Luckily, there's a way to fix that for them -- dynamic module inclusion! Here, instead of directly defining methods on the class, we define them on a dynamically created anonymous module and then include that.

---

This anonymous module sits within the lookup chain for us, which means that calls to super will work fine. Credit goes to the author of carrierwave for introducing me to this technique.

---

Anonymous modules break Ruby object marshalling, so you should be polite and name them, too. To do this, you can assign dynamic modules to a constant with const_set before inclusion.

---

Dynamic module inclusion is, to be honest, probably the coolest trick I've learned in the past year, so now I'm out of things to talk about. Let's sum up.

Metaprogramming is awesome because it lets us treat code as data. It lets us pretend to be Lisp programmers without spending all day matching parentheses. We shouldn't be scared of it, but like all powerful tools we should treat it with the appropriate respect.

We should make sure that in our attempts to codify patterns using metaprogramming techniques we consider our poor maintenance coders, who we will ourselves be in four months,
and do what we can to make sure that our metaprogramming doesn't kill the ability to search for code, extend code, or debug code -- since surely we will need to do at least one of these.


Finally, because this is an awesome Ruby language feature, we should treat it with the joy appropriate to a language optimized for developer happiness.

---

Now that I've said all these things, here's who I am and where you can find me on the Internet!

Also: I work for Optoro. We're based in DC and are working to make the retail returns process greener and more efficient! We are awesome and pretty much always hiring, so if you're looking please talk to one of our posse.

If you're not looking, please consider our online outlet Blinq.com for all your cheap laptop needs.

---

All cat photos used in this talk are credit Nikki Murray.

Questions?