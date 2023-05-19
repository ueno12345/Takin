json.extract! course, :id, :year, :term, :number, :name, :instructor, :time_budget, :description, :created_at, :updated_at
json.url course_url(course, format: :json)
