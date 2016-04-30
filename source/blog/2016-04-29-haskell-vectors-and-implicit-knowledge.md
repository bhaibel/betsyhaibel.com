---
title: "Haskell, Vectors, and Implicit Knowledge"
---

This winter I was teaching myself Haskell.

I'd tried before, with everyone's darling *Learn You a Haskell for Great Good*. My old boss had compared its "offbeat" approach to *_why's Poignant Guide to Ruby*, which I love. Both have an informal tone, but the similarities stop there: where the Poignant Guide has adorable cartoon foxes, *Learn You a Haskell* has upsetting bro humor. I think I snapped at one of the (many) fat jokes.

This time around I tried *Real World Haskell*, and at first things went much better. The material was more usefully organized, and the examples and exercises better suited to my learning style.
Then I came to The Problem.

## The Problem

The problem set at the end of Real World Haskell’s third chapter contains the following sequence:

> 9. Consider three two-dimensional points a, b, and c. If we look at the angle formed by the line segment from a to b and the line segment from b to c, it either turns left, turns right, or forms a straight line. Define a Direction data type that lets you represent these possibilities.
> 10. Write a function that calculates the turn made by three 2D points and returns a Direction.
> 11. Define a function that takes a list of 2D points and computes the direction of each successive triple. Given a list of points [a,b,c,d,e], it should begin by computing the turn made by [a,b,c], then the turn made by [b,c,d], then [c,d,e]. Your function should return a list of Direction.
> 12. Using the code from the preceding three exercises, implement Graham's scan algorithm for the convex hull of a set of 2D points. You can find good description of what a convex hull is, and how the Graham scan algorithm should work, on Wikipedia.

Problem 9 was pretty simple:

``` haskell
data Direction = Left | Right | Straight
```

Problem 10 took me a month.

I figured it had to be simple; if it were a difficult geometry problem, it wouldn’t be in a beginners' Haskell book, it would be in a "Haskell as applied to tricky math" book. But approach after approach after approach failed me. I compared slopes. I tried complicated conditionals based on what quadrant each line was in when its base was set at origin.

Did you know that Haskell has two `Data.Vector` modules? There's one in the standard library that deals with Vectors like the array-like CS concept. There's one on Hackage that deals with Vectors like the geometry and second-year algebra concept. They are called the same thing. I know this now, because I found the docs for the latter, imported `Data.Vector` like a good girl, and spent aeons of subjective time banging my head against arity mismatch errors before giving up on a dot-product-based solution.

Eventually I finally hammered out all of the special cases.

I’d been pushing myself to finish, rather than cutting my losses and moving on in the book, because I figured it would feel good when I finally did. It didn’t. I just felt stupid, because it had taken me a month to figure out what the authors of the book had clearly expected to be simple.

I moved on to Problem 12. Looked up the Graham Scan algorithm on Wikipedia, as ordered. 

> Again, determining whether three points constitute a "left turn" or a "right turn" does not require computing the actual angle between the two line segments, and can actually be achieved with simple arithmetic only. For three points ![p1=(x1,y1)](https://upload.wikimedia.org/math/e/3/8/e38e464b2ad39be72af38cacc8fc17de.png), ![p1=(x2,y2)](https://upload.wikimedia.org/math/a/4/5/a45267c35535663e45d3a0bcc4db16e6.png) and ![p1=(x3,y3)](https://upload.wikimedia.org/math/b/d/b/bdb6d1f831105c159498d203a95c41fb.png), simply compute the z-coordinate of the cross product of the two vectors ![p1p2](https://upload.wikimedia.org/math/a/c/7/ac7a0fe21575792e379eb1caa37d5224.png) and ![p1p3](https://upload.wikimedia.org/math/2/b/5/2b5ba9e273a2f3c0de10b0a07125bd86.png), which is given by the expression ![(x2 - x1)(y3 - y1) - (y2 - y1)(x3 - x1)](https://upload.wikimedia.org/math/4/4/d/44dac4ebbcdd18ed0593418004b5e4c8.png). If the result is 0, the points are collinear; if it is positive, the three points constitute a "left turn" or counter-clockwise orientation, otherwise a "right turn" or clockwise orientation (for counter-clockwise numbered points).

Reader, I saw fire.

At first I was angry at myself, because there had been a straightforward answer and '’d "just been too stupid" to get it. Then I was angry at the authors for not putting that "simple arithmetic" answer in the text for problem 10. Then I was furious at the authors — because I realized why they hadn't.

They thought it was too simple to explain. They thought that anyone learning Haskell would have retained all the random topics that are contained in high school precalculus. They thought that anyone learning Haskell would be the Kind Of Person who just "naturally" remembers that sort of stuff.

And now, because it's a woman writing this, you're probably assuming that this is a rant about how you don't need to know math to computer.

Think again. I am That Kind Of Person. I started programming at either twelve or eight, depending on whether you count HyperCard. I learned Scheme in ninth grade. I am That Kind of Person, and the problem still made me feel like a fucking idiot. Like an impostor. Like I ought to just give up.

Over whether I could remember offhand that vector cross products were not commutative, and what implications this had for turn direction problems.

This could be a rant about the arrogance of the functional programming ivory tower. But a lot of people have made that rant already, and I'm more interested in self-reflection than in being yet another Ruby programmer who’s snotty about non-Rubyists.

## Closer to Home

I teach people to program in my free time. I co-organize a drop-in group called Learn Ruby in DC, so every other week I walk people of all different skill levels through how to code. This includes honest-to-god raw beginners, as well as apprentices and juniors.

There is one understanding gap that every single one of them runs into at some point. They mix up local variables and instance variables, or variables and strings, or ivars and symbols — the exact mixup doesn't matter. They respond by randomly adding and subtracting `@`s and colons and quotation marks until it works, and then they sigh relief. This happens because they don’t have mental scaffolding for the differences between variables and symbols, between locals and ivars — to them, they’re just words that may or may not have magic before them, and so you fiddle with the magic until it runs.

It always takes me a few minutes of observation to figure out that that's what's happening in their heads. I’ve been writing Ruby since 2008; the scope differences between raw ivars and accessors and local variables are like breathing now. My intuitive brain assumes that everyone knows this, and I need to back up and remind it that that’s not true.

I need to do this even though in 2008, as a woman who’d worked with various conventional languages for 8 years, I'd struggled like hell to internalize that difference myself.

Am I making my students feel stupid? I hope not, but… sometimes I probably am.

## Where do we go?

The educational materials we create encode our values -- often accidentally. *_why's Poignant Guide* reflects an ethos where programming is a joyful, creative activity. *Learn You a Haskell* conveys a worldview that fat jokes are hilarious fun. *Real World Haskell* assumes that all truly educated people remember vector-math intricacies off the top of their heads.

The values of our educational materials create our community values. People whose assumptions mesh with theirs proceed onward to community participation; people whose assumptions and values don't leak out of the pipeline. I think Haskell is a really pretty language, but I can't tell if the Haskell community wants me.

It’s human to forget that knowledge one has internalized is not common knowledge. It's human to be a poor teacher. It's human to confuse students; to make them feel terrible. It's still cruel. And when we encode that cruelty into our educational materials -- however accidentally -- we turn surviving that cruelty into something we value above all.

What implicit knowledge is needed in your language of choice? How do you deal with that around juniors?
