---
layout: post
title: "Type Mismatch errors and RSpec"
description: ""
category: 
tags: []
---
{% include JB/setup %}

Some notes, for the public benefit, on some RSpec troubleshooting I've been doing lately. The error was ultimately a really dumb error, but the error messages I was getting were not helpful.

My integration tests for [Rated R for Rapist](http://github.com/irregulargentlewomen/ratedrforrapist) had been consistently failing, every last one, even the most basic:

{% highlight ruby %}
    require_relative '../spec_helper_integration'
    
    describe "serving the root page" do
      before do
        get '/'
      end
    
      it "should respond with a 200" do
        last_response.should be_ok
      end
    end
{% endhighlight %}

with a somewhat cryptic error:

    1) serving the root page should respond with a 200
       Failure/Error: get '/'
       TypeError:
         type mismatch: String given
       # ./spec/integration/render_page_spec.rb:5:in `block (2 levels) in <top (required)>'

At first, given that tests were consistently failing when I made a get request, I assumed the issue was some obscure Rack::Test thing, one that perhaps had to do with Sinatra integration and/or regexp parsing. Google was unhelpful on this point, as was reading the Rack::Test source.

What was helpful was going into spec_helper_integration.rb.

{% highlight ruby %}
    require 'rack/test'
    ENV['RACK_ENV'] = 'test'
    
    require_relative '../server'
    
    # setup test environment
    set :environment, :test
    set :run, false
    set :raise_errors, true
    set :logging, false
    
    def app
      Sinatra::Application
    end
    
    RSpec.configure do |config|
      config.include Rack::Test::Methods
    end
    
    before(:all) do
      DB[:blacklist].multi_insert(YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'blacklist.yml')))
    end
{% endhighlight %}

Wait, what's that? A before block outside of an RSpec context? Naturally, putting it in the config block where it belonged solved the problem entirely.

{% highlight ruby %}
    RSpec.configure do |config|
      config.include Rack::Test::Methods

      config.before(:suite) do
        DB[:blacklist].multi_insert(YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'blacklist.yml')))
      end
    end
{% endhighlight %}

Some errors aren't so puzzling after all. Some day I ought to probably follow up on this, and figure out *why* it was manifesting in precisely this way. I'm not entirely sure how to patch RSpec to give a more helpful error message in this context, since the error was caused by me defining things out of RSpec's scope. This is unfortunate.