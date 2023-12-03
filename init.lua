local otype = type

---Modified from vanilla lua, and attempts to checks for the existence of a `.__type`
---metavalue or metafunction. Thus, the possible return values can be anything.
---@param value any The value to check.
---@return any #While usually a string, `.__type` metafunctions may return non-string values.
type = function(value)
	local mt, ot, t, success
    
    ot = otype(value)
    
    if ot ~= "userdata" and ot ~= "table" then return ot end   
    
    --If it's userdata, it's likely a love type, so we call the
    --:type() method.
    if ot == "userdata" then
        success, t = pcall(value.type, value)

        if success then return t end
    end

    --While Classy does have a .type getter, due to the conflict
    --with the :type method from love (and due to the fact that type
    --is an often used key name), we check for the __type
    --metavalue/metafunction directly.
    mt = getmetatable(value)
    
    if not mt        then return ot end
    if not mt.__type then return ot end

    ot = otype(mt.__type)
    
    --While you can technically call pretty much anything in lua,
    --if you return a table or something and you expect it to be
    --called, you should be shot lol. It's a type. Don't
    --overcomplicate it bro.
    if ot == "function" then return mt.__type(value) end

	return mt.__type
end