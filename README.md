Dynamic Settings Experiment
================

Sometimes it's required to change global application settings in run time. Good example - recommendation system,
based on mathematical formulas with empirical factors. In order to have the best recommendations, you need to correct
empirical factors in run time and find the best ones. 

This is new Rails app generated from scratch with implemented Dynamic Settings functionality. It uses [Global](https://github.com/railsware/global)
gem for default settings, RDBMS for permanent data storing and Redis for caching.


Problems? Issues?
-----------

Contact me directly by email romikoops1@gmail.com

Ruby on Rails
-------------

This application requires:

- Ruby 2.0.0
- Rails 4.1.4

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Getting Started
---------------

1. Add desired Global setting to ./config/global directory
2. Add new file name to KNOWN_GLOBAL_SETTINGS in ./app/models/dynamic_setting.rb
3. Start rails server and open web application
4. Update any setting
5. Enjoy it!


Documentation and Support
-------------------------

Issues
-------------

Similar Projects
----------------

Contributing
------------

Credits
-------

License
-------
MIT license
