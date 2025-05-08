function my_test_function(param1, param2, param3)
  print(param1, param2, param3)
  return param1 + param2 * param3
end

function my_new_test_function(new_param1, new_param2, new_param3)
  print(new_param1, new_param2, new_param3)
  return new_param1 + new_param2 * new_param3
end

-- Simple Lua code for testing a debugger
local function factorial(n)
  if n == 0 then
    return 1
  else
    return n * factorial(n - 1)
  end
end

-- Table to store data
local data = {
  name = "Test",
  value = 42,
  items = { 10, 20, 30 },
}

-- Function with loops and conditions
local function processData(input)
  local result = 0

  -- For loop
  for i = 1, #input.items do
    -- Breakpoint opportunity
    local item = input.items[i]
    result = result + item
  end

  -- Conditional logic
  if input.value > 40 then
    result = result * 2
  else
    result = result / 2
  end

  -- Call another function
  local fact = factorial(4)

  -- Multiple variables to inspect
  local message = "Processed " .. input.name
  local timestamp = os.time()

  -- Return multiple values
  return result, message, fact, timestamp
end

-- Main execution
print("Starting debug test...")
local res1, res2, res3, res4 = processData(data)
print("Results:", res1, res2, res3, res4)

-- Intentional error (uncomment to test error handling)
print(undefinedVariable)
