# Takin
Takin is a TA time management system.

The duties of TA time management involve the following steps:
1. Select the subjects from dozens of courses for which TAs need to be assigned.
2. Choose one or more TAs from a pool of candidates (approximately 70 candidates) for each selected subject.
3. Allocate multiple working time slots to the selected candidates.
4. Display various reports reflecting the assignment status.

## Install for developpers

``` shell
git clone git@github.com:ueno12345/Takin.git
cd Takin
bundle install
bundle exec rails db:migrate RAILS_ENV=development
bundle exec rails db:seed
```
