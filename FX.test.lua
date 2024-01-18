dofile("./FX.lua")

Pipe(
	{1, 2, 3, 4},
	Map(
		function(value)
			return value + 1
		end
	),
	Sum,
	print
)