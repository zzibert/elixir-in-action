defmodule EIA do
  days = MapSet.new([:monday, :tuesday, :wednesday])
  days = MapSet.put(days, :thursday)
  Enum.each(days, &IO.puts/1)
end
