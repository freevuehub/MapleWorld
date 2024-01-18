dofile("./FX.lua")

local function test(name, input)
	print("-- " .. name .. " Test")

	return function(check)
		if input ~= check then
			error("")
		end

		print("Pass!")
		print("")
	end
end

test(
	"Head",
	Pipe(
		{1, 2, 3, 4},
		Head
	)
)(1)
test(
	"Map",
	Pipe(
		{1, 2, 3, 4},
		Map(
			function(value)
				return value + 1
			end
		),
		Sum
	)
)(14)
test(
	"Reduce",
	Pipe(
		{ "Hello", "World" },
		Reduce(
			function(prev, cur)
				return prev .. cur
			end,
			""
		)
	)
)("HelloWorld")
test(
	"Sum",
	Pipe(
		{ 1, 2, 3, 4, 5 },
		Sum
	)
)(15)
