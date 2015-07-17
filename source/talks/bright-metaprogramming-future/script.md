Hi, everyone. My name's Betsy Haibel, and we're here today to talk about metaprogramming.

---

First, let's get some consensus as to what metaprogramming is. When I was explaining my talk to my parents, I used the shortcut that a lot of people use: "oh, it's code that writes code." There are two problems with this definition. First off, it's overbroad to the point of uselessness. The Rails generators write code, too. The second problem with it is that it makes your parents think you're building Skynet.

---

Then there's the definition of metaprogramming that most of us actually *mean.* This definition is more like a *feeling*, and the feeling is "so much magic! so few variable names! I'm scared and angry now." This is also overly broad; it encompasses Perl.

---

So I like to define metaprogramming as programming that treats the structure of the program itself as a data structure to be manipulated like any other.

---

The first way you can play with program structure in Ruby is using the send method. The most common real-world use case for send is probably as a cheat to invoke private methods, but it has less evil uses too.

----

Ruby relies on what's called a "message passing" model for method invocation. Ordinarily, this is hidden behind syntactic sugar -- the dots you use to invoke methods, behind the scenes, "send" the name of the method as well as any arguments you include in the method invocation.

---

Using Object#send makes this a little more explicit. a.bar and a.send(:bar) are semantically equivalent, but when you visualize a method invocation using "send", it makes it really clear that what you're actually passing to the object is a bag of arguments, the first of which must be a symbol or a string. The "method name" argument has a special status -- it directly determines which block of code is called next, but ultimately, all the arguments in that bag of arguments are just ways of passing information to an object about what you want it to do.

---

Anyway, let's move on to how send can be used and misused in the wild.

When people start pulling in "send" statements, usually it's a reaction to code that looks like this. Incidentally, I wrote this code for money five years ago.

----

And I hated it. It was this pile of copypasta. But I didn't know how to fix it. I'd trained in Java, so I thought method names were these special immutable compiler things, and that  repetition and boilerplate were inevitable.

Then I learned that you could use "send" to call arbitrary methods.
---

Twenty-thirty minutes later, the code looked more like this.

---

Here's a diff, so the changes are easier to follow. I identified a pattern that had been expressed via repetition, and expressed that pattern with code instead - namely, by invoking methods dynamically using "send" rather than statically with copy and paste.

----

This is what we talk about when we say Ruby optimizes for "developer happiness." I *hated* that code, and Ruby's dynamism made the repetition go away.

Unfortunately, now I had a really big hammer -- send -- and every problem started to look like a nail.

----

This next code is an amalgam of code I wrote and code that I've seen other people write that I *could well* have written during this part of my programming career.

---

So, we've got some code that searches within a set of models and then sends their data on to the formatter. This example came out of the  a lot of the time when you're using dynamic method calls you're using them to express a repetition that had previously been expressed with copypasta, and this is definitely what's going on here. Reflexively reaching for dynamic method calls to fix this problem has three traps, though.

---

The biggest is that it breaks grep. Ordinarily when I'm spelunking through new code I search for method names to see where they're defined and invoked, but I can't find where format_whatever_results_for_some_user_type is defined because I don't know what method name is really being sent. Similarly, if I'm looking at the definition for format_pants_results_for_anonymous_users, and I search for where it's used, this instance won't come up.

---

Finally, using a dynamic method call to reduce repetition at the call site often spackles over a far uglier repetition elsewhere in the code. How do we refactor away from this when it happens?

---

Well, the first thing we do is change the method signature up a little. When you do a dynamic method call, you cheat message-passing a little by sending multiple pieces of data in with the method-name argument. Here, these multiple pieces of data are the abstract "format stuff for stuff" method name structure, the garment, and the user type. So, one of the first things we can do is make a new method signature that makes the implicit arguments "garment" and "user_type" explicit arguments instead. The quickest way to do this is move the send call into Formatter, which also isolates it within its class and makes it a bit easier to understand in context.

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

If you hate const_get, you can also get the equivalent effect by using a hash to store explicit class names.

---

We're not fully getting away from dynamism here - we're just choosing which class to instantiate dynamically, instead of which method to invoke. But now the dynamism is encapsulated within a single file and a single family of classes, so its effect on the complexity and searchability of the entire application is significantly reduced. And Ruby's capacity for dynamism is one of the best things about the language -- look at how concise that const_get call is! Think about how many lines you would need to write to do the same thing in a less dynamic language! And the more code there is on the screen, the more code you need to keep in your head.

---

Next up, #method_missing.

---

Most of us have seen methods like this before. These, like most of the rest of ActiveRecord, are defined using method_missing, which allows us to dynamically respond to arbitrary method names. After all, a method name is just a part, like any other, of the bag of arguments sent to an object.

---

In order to explain how method_missing works, we need to examine Ruby's default lookup chain. When you send a bag of arguments to an object, Ruby first looks at the object's eigenclass, which is a little psuedo-class each individual object carries with it, to see if any singleton methods have been defined that match the sent method name.

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

So, in the wild, method_missing looks a little like this. This oversimplifies how actual ActiveRecord looks, but this is the general shape of it. method_missing gets passed the bag of arguments that you sent the object and decides what to do based on them.

Most method_missing implementations are this simple, which unfortunately means they make two small mistakes. With the use of method_missing.

---

The first is that it's not including a call to super. If you don't include a fallback to super somewhere within each method_missing definition, the lookup chain will stop within the first method_missing it finds and potentially bypass something further up the chain that might know how to deal with the given method name.

---

The second is that there's no parallel definition of respond_to_missing. Right now, if you send this method name to respond_to, it will say "false," because no method is defined with this name on the object.

---

respond_to_missing, which looks like this, allows you to expand respond_to's conception of what method names an object responds to. It's necessary whenever you're using method_missing because otherwise you're potentially lying to anyone who uses your object about what it can do.

---

See? Much better.

---

Now for a subtler mistake that I've made with method_missing.

So, let's say you have a mixin that relies on the breed_codes method being defined on an object, and you throw in a NotImplementedError to make that reliance really clear.

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

This is what I did at first. It made the mistake even worse: now, whenever someone made a typo, this method_missing would be part of the error. They'd spend an hour puzzling over how an eleven-line file could have so many issues, and then they'd get mad at me for the confusing error message.

---

If you do this instead, it will work. That's because "super" doesn't care whether something is actually defined further up the method lookup chain, it just defers it one further up

---

so that you can get to the implicit definition perfectly fine.

---

You can also do this, which is a little more explicit and stays within the mixin. Or you can get rid of the quote-unquote convenience of the NotImplementedError.

But the fact that all of these are even questions illuminates some of the hidden costs of making a method_missing-driven dynamic interface -- it doesn't play nicely with strategies for good object-oriented design in Ruby, and so defaulting to it when you want easy dynamism makes your code far less extensible later.

---

So, what is method_missing good for? The traditional use cases for it are pretty dynamic DSLs, like ActiveRecord finders, or pretty global config singletons like Amberbit, or objects that delegate most of their methods, like presenters.

---

But, honestly, I'd argue that none of those are actually good uses. Changeable method names in DSLs fall into the "isn't this another parameter?" trap that our send calls earlier fell into, so I like options hashes better for those. For everything else, there's OpenStruct, and SimpleDelegator, and Forwardable. Some of these use method_missing under the hood, but it's hidden under a nice well-maintained and well-understood interface. That's usually not true of homegrown solutions.

---

So, how then are we to do dynamic method definition? Well, mostly we shouldn't - but if we must, there's define_method. define_method, like method_missing, is *slow* - whenever you call it, you invalidate Ruby's method cache. And, just like send calls, it can be used to hide bad class design. But sometimes, it can make an API much cleaner.

---

Its syntax is really straightforward - you pass it a method name and a block defining the method.

---

So, let's examine how it can be used to clean up code. We have here some nice repetitive method definitions!

---

define_method lets us pull it out into a an each block. This cuts lines, and more importantly illuminates the deeper structure of the code.

Again, this is really clear *at a small scale.* We can see all the pieces, so we don't need to encapsulate the dynamism. If it grew, we'd want to either encapsulate or replace the dynamism by extracting a class.

---

Boring, I know. But if you're reading code, do you want it to be clever, or boring?

---

Anyway. The biggest takeaway I want you to have from this talk is that code is just data to Ruby, and metaprogramming is a technique like any other. Feel free to pull it out and use it, but be mindful of the fact that you are always your own maintenance coder - it's easy to break grep, or to damage your ability to debug or extend things later, so always metaprogram *carefully.* Also, always ask yourself if something is really part of the method *name,* or if it's just another parameter.

---

Now that I've said all these things, here's who I am and where you can find me on the Internet!

Also: I work for Optoro. We're based in DC and are working to make the retail returns process greener and more efficient! We are always hiring.

If you're not looking, please consider our online outlet Blinq.com for all your cheap laptop needs.

---

Ooooh. Wait. We get a bonus round.

Now I'm gonna show you how carrierwave works.

---

Going back to the cat photo code again. Let's say we want to extract a generic AttachmentManager module. This is the obvious thing to do, but it has one really major problem - what happens if you don't like the default behavior of one of the methods that the define_attachment macro sets up? You can override it, but because you're overriding it in the *same* class, you just overwrite the previous method. This means you lose access to the default behavior, you don't get to use super at all. alias_method_chain is traditional here, but it's really gawky.

---

So instead what we do is we dynamically create a *module,* and then include that.

---

This inserts the module into the method lookup chain, which means that if you defer to super within a method it actually has a previous definition to look at.

---

Anonymous modules aren't very polite either, though -- they're a bit harder to debug, and they break Ruby marshalling. So it's better if you use const_set to give your dynamic module a name, and *then* include it.