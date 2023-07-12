module AssignmentsHelper
	def sort
		work_hours = WorkHour.where(assignment_id: Assignment.where(teaching_assistant_id: @teaching_assistant.id))
		.where(dtstart: Date.new(@teaching_assistant.year,4,1)..)
		.where(dtend: ..Date.new(@teaching_assistant.year+1,4,1))
		.select("strftime('%Y年%m月%d日', dtstart) AS month_day, sum(actual_working_minutes) AS sum_work_time").group("month_day")
	end

	def all_work_time
		work_hours = WorkHour.where(assignment_id: Assignment.where(teaching_assistant_id: @teaching_assistant.id))
		.where(dtstart: Date.new(@teaching_assistant.year,4,1)..)
		.where(dtend: ..Date.new(@teaching_assistant.year+1,4,1))
		.sum(:actual_working_minutes)
	end

	def assigment_course_teacher
		teachers_name = []
		assignments = Assignment.where(teaching_assistant_id: @teaching_assistant.id)

		assignments.each do |assignment| 
			teachers_name.push(Course.where(id: assignment.course_id).first.instructor)
		end

		return teachers_name
	end

	def datetoday(work_hour)
		days = ["日", "月", "火", "水", "木", "金", "土"]

		return days[work_hour.dtstart.wday]
	end

	def datetoymdhm(date)
		return Date.new(date)
	end
end
