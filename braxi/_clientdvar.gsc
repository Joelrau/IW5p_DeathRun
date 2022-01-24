//SetClientDvar and GetClientDvar functionality for saving strings and integers for clients even after game has ended.
//YouViolateMe

//_setClientDvar parameters = player, dvar name, dvar value (set to undefined if you want to remove the client value)
//_getClientDvar parameters = player, dvar name, dvar value type to return back ("int" or "string" for now)
//_resetDvar should be pretty easy to understand....
//make sure you are NOT saving to a host-only (predefined) dvar! must be a custom dvar!
 
//_getIndexOf parameters = string, char or string you want the index of, starting index to search at (0 if you don't know)

#include braxi\_common;
 
_resetDvar(dvar)
{
    setDvar(dvar, "");
}

_setClientDvar(player, dvar, dvar_value)
{
    cvarstring = "";
	
	cvar = "cvar_" + player getGuid();
   
    if (isDefined(getDvar(cvar)))
        cvarstring = getDvar(cvar);
   
    valuearray = strTok(cvarstring, ";");
    cvarstring = "";
   
    foreach(value in valuearray)
    {
		if (!stringContains(value, dvar))
        cvarstring += value + ";";
    }
   
    if (isDefined(dvar_value))
        cvarstring += dvar + "=" + dvar_value + ";";
   
    valuearray = undefined;
    setDvar(cvar, cvarstring);
}

_getClientDvar(player, dvar, type)
{
	cvar = "cvar_" + player getGuid();
	
    if (!isDefined(getDvar(cvar)))
        return undefined;
   
    cvarvalue = getDvar(cvar);
    values = strTok(cvarvalue, ";");
   
    foreach(value in values)
    {
        if (stringContains(value, dvar))
        {
            string_value = getSubStr(value, _getIndexOf(value, "=", 0) + 1, value.size);
           
            if (type == "int")
            {
                return int(string_value);
            }
            else if (type == "string")
            {
                return string_value;
            }
            else if(type == "float")
			{
				setDvar("float", string_value);
				return getDvarFloat("float");
			}
        }
    }
   
    values = undefined;
    return undefined;
}

_getIndexOf(string, value, startingIndex)
{
    index = startingIndex;
    while( index <= string.size - value.size - 1)
    {
        if (!isDefined(string[index + value.size - 1]))
            return -1;
       
        if (getSubStr(string, index, index + value.size) == value)
            return index;
        else
            index++;
    }
   
    return -1;
}