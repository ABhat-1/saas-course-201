require 'active_record'

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def due_past?
    due_date < Date.today
  end

  def upcoming_due?
    due_date > Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{display_status} #{todo_text} #{display_date}"
  end

  def self.mark_as_complete(todo_id)
    Todo.update(todo_id,completed:true);
  end

  def self.show_list
    puts("Due today\n")
    today_due = all.filter {|todo| todo.due_today?}
    today_due.map {|todo| puts todo.to_displayable_string }

    puts("Past due date\n")
    past_due = all.filter {|todo| todo.due_past?}
    past_due.map {|todo| puts todo.to_displayable_string }

    puts("Upcoming tasks\n")
    upcoming_tasks = all.filter {|todo| todo.upcoming_due?}
    upcoming_tasks.map {|todo| puts todo.to_displayable_string }
  end

  def self.add_task(hash)
    Todo.create!(todo_text: hash[:todo_text], due_date: Date.today + hash[:due_in_days], completed: false)
  end

  def self.to_displayable_list
    all.map {|todo| todo.to_displayable_string }
  end

end
