defmodule TodoList do
  require MultiDict
  def new(), do: MultiDict.new()

  def add_entry(todo_list, date, title) do
    MultiDict.add(todo_list, date)
  end

  def entries(todo_list, date) do
    MultiDict.get(todo_list, date)
  end
end
