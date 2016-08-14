function wrap(val, min, max)
	if val < min then val = max end
	if val > max then val = min end
	return val
end
