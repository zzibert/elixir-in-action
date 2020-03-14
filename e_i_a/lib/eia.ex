defmodule EIA do
  outisde_var = 5
  lambda = fn -> IO.puts(outside_var) end
  outside_var = 6
  lambda.()
end
