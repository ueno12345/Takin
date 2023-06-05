#!/usr/bin/env/ruby

require_relative "../config/application"

# Create teaching assistants

def set_grade(num)
  if num%2 == 1
    return "1"
  else
    return "2"
  end
end

def set_labo(num)
  return (num % 5).to_s
end
 
(101..200).each do |name|
  year = rand(2021...2025)
  number = "50M23#{name}"  
  TA_name = "Name #{name}"
  grade = "M#{set_grade(name.to_i)}"
  labo = "labo#{set_labo(name.to_i)}"
  description = "#{name.to_s}"
  teaching_assistant = TeachingAssistant.new(year: year, number: number, name: TA_name, grade: grade, labo: labo, description: description)
  teaching_assistant.save
  puts "Save TeachingAssistant: #{teaching_assistant.name}"
end

