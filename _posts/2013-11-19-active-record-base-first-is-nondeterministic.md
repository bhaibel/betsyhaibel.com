---
layout: post
title: "ActiveRecord::Base.first is nondeterministic"
description: ""
category: 
tags: []
---
{% include JB/setup %}

Recently, at the office, something happened that baffled me. I was doing some third-party integration testing from the rails console, which required multiple test runs of this approximate form:

{% highlight ruby %}
    def test_run
      reload!
      TestedModel.first.update_attribute :callback_triggering_attr, nil
      TestedModel.first.update_attribute :callback_triggering_attr, 'a real value'
    end
{% endhighlight %}

After a test run succeeded in having the third-party effect I wanted, I checked to see if the callback had also triggered the subsequent resource updates I wanted:

{% highlight ruby %}
    TestedModel.first.some_other_attribute
{% endhighlight %}

**NOPE.**

![nope-rocket.gif](http://i1302.photobucket.com/albums/ag137/nelsonmonty/nope_zpsbcc14df0.gif)

Several very confused pry-debugger sessions later, I noted that the ids returned by my {% highlight ruby %}`self`{% endhighlight %} call in the middle of prying and the id returned by {% highlight ruby %}`TestedModel.first`{% endhighlight %} ... did not match.

It turns out that {% highlight ruby %}`ActiveRecord::Base.first`{% endhighlight %} is nondetermininistic. It generates SQL that looks something like {% highlight sql %}`select * from table_name limit 1`{% endhighlight %}, and the order of selects when no specific order clause is included is nondeterministic in the official SQL specification. It's easy to forget that. The default order is *typically* creation order and creation order *typically* tracks ascending order by id in a Rails application. However, because computers are computers, it's important to remember that **typically != always**.

Amusingly, {% highlight ruby %}`ActiveRecord::Base.last`{% endhighlight %} *is* deterministic. In order to retrieve the "last" record while still imposing a limit of 1 record retrieved, a descending order on *some* attribute must be imposed, like so: {% highlight sql %}`select * from table_name order by table_name.id desc limit 1`{% endhighlight %}.

A quick check of the Rails docs revealed that the behavior of {% highlight ruby %}`ActiveRecord::Base.first`{% endhighlight %} has been changed/corrected in Rails 4 so that a specific order clause on the primary key is included. I look forward to its behavior confusing fewer people in the future.