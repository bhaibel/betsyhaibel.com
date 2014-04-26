---
title: "ActiveRecord::Base.first is nondeterministic"
---

Recently, at the office, something happened that baffled me. I was doing some third-party integration testing from the rails console, which required multiple test runs of this approximate form:

```ruby
    def test_run
      reload!
      TestedModel.first.update_attribute :callback_triggering_attr, nil
      TestedModel.first.update_attribute :callback_triggering_attr, 'a real value'
    end
```

After a test run succeeded in having the third-party effect I wanted, I checked to see if the callback had also triggered the subsequent resource updates I wanted:

```ruby
    TestedModel.first.some_other_attribute
```

**NOPE.**

![nope-rocket.gif](http://captainawkwarddotcom.files.wordpress.com/2013/08/noperocket.gif)

Several very confused pry-debugger sessions later, I noted that the ids returned by my `self` call in the middle of prying and the id returned by `TestedModel.first` ... did not match.

It turns out that `ActiveRecord::Base.first` is nondetermininistic. It generates SQL that looks something like `select * from table_name limit 1`, and the order of selects when no specific order clause is included is nondeterministic in the official SQL specification. It's easy to forget that. The default order is *typically* creation order and creation order *typically* tracks ascending order by id in a Rails application. However, because computers are computers, it's important to remember that **typically != always**.

Amusingly, `ActiveRecord::Base.last`<% end %>
 *is* deterministic. In order to retrieve the "last" record while still imposing a limit of 1 record retrieved, a descending order on *some* attribute must be imposed, like so: `select * from table_name order by table_name.id desc limit 1`.

A quick check of the Rails docs revealed that the behavior of `ActiveRecord::Base.first`
 has been changed/corrected in Rails 4 so that a specific order clause on the primary key is included. I look forward to its behavior confusing fewer people in the future.