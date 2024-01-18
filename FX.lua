function MakeIter(iterator)
	local iter = {}

	for _, value in pairs(iterator) do
		iter[#iter + 1] = value
	end

	return iter
end

function Reduce(callback, prev)
	local result = prev

	return function(iterator)
		iterator = MakeIter(iterator)

		for key, value in pairs(iterator) do
			result = callback(result, value, key)
		end

		return result
	end
end

function Pipe(...)
	return Reduce(
		function(prev, cur)
			if prev == nil then
				return cur
			end

			return cur(prev)
		end,
		nil
	)({ ... })
end

function Map(callback)
	local result = {}

	return function(iterator)
		for key, value in pairs(iterator) do
			table.insert(result, callback(value, key))
		end

		return result
	end
end

function Sum(iterator)
	return Pipe(
		iterator,
		Reduce(
			function(prev, cur)
				return prev + cur
			end,
			0
		)
	)
end

function Shuffle(iterator)
	iterator = MakeIter(iterator)

	for index = #iterator, 2, -1 do
		local randomIndex = _UtilLogic:RandomIntegerRange(1, index)

		iterator[index], iterator[randomIndex] = iterator[randomIndex], iterator[index]
	end

	return iterator
end

function Filter(callback)
	local result = {}

	return function(iterator)
		iterator = MakeIter(iterator)

		for key, value in pairs(iterator) do
			if callback(value, key) then
				table.insert(result, value)
			end
		end

		return result
	end
end

function Random(count)
	local result = {}

	return function(iterator)
		iterator = MakeIter(iterator)

		for index = 1, count, 1 do
			local random = _UtilLogic:RandomIntegerRange(1, #iterator)
			local value = iterator[random]

			result[index] = value

			iterator = Pipe(
				iterator,
				Filter(
					function(item)
						return item ~= value
					end
				)
			)
		end

		return result
	end
end

function Range(count)
	local result = {}

	for index = 1, count, 1 do
		result[index] = index
	end

	return result
end

function Head(iterator)
	local list = {}

	for _, value in pairs(iterator) do
		if #list > 1 then
			break
		end

		list[#list + 1] = value
	end

	return list[1]
end

function Join(literal)
	return function(iterator)
		return Pipe(
			iterator,
			Reduce(
				function(prev, cur)
					if prev == "" then
						return tostring(cur)
					end

					prev = prev .. literal .. tostring(cur)

					return prev
				end,
				""
			)
		)
	end
end

function Average(iterator)
	return Pipe(
		iterator,
		Sum
	) / #iterator
end

function Includes(value)
	local result = false

	return function(iterator)
		for _, target in pairs(iterator) do
			if target == value then
				result = true

				break
			end
		end

		return result
	end
end

function Size(iterator)
	return #iterator
end