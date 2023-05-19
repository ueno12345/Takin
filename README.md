# Takin

## Install for developpers

``` shell
git clone git@github.com:ueno12345/Takin.git
cd Takin
bundle install
bundle exec rake db:migrate RAILS_ENV=development
# 以下追加予定
# Insert dummy data:
# bin/rails runner scripts/create_dummy_data.rb
```
