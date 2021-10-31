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
    dvarstring = "";
   
    if (isDefined(getDvar(dvar)))
        dvarstring = getDvar(dvar);
   
    valuearray = strTok(dvarstring, ";");
    dvarstring = "";
   
    foreach(value in valuearray)
    {
        if (!stringContains(value, _getName(player)))
            dvarstring += value + ";";
    }
   
    if (isDefined(dvar_value))
        dvarstring += _getName(player) + "=" + dvar_value + ";";
   
    valuearray = undefined;
    setDvar(dvar, dvarstring);
}
 
_getClientDvar(player, dvar, type)
{
    if (!isDefined(getDvar(dvar)))
        return undefined;
   
    dvarvalue = getDvar(dvar);
    values = strTok(dvarvalue, ";");
   
    foreach(value in values)
    {
        name = _getName(player);
       
        if (stringContains(value, name))
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
 
_getName(player)
{
	name = player.name;
	name = stringReplace( name, ":", "?" );
	name = stringReplace( name, ";", "?" );
	name = stringReplace( name, "=", "?" );
	name = name + ":" + player getGuid();
	name = getSubStr(name, 0, name.size);
	/*for(i = 0; i < name.size; i++)
	{
			if(name[i]=="]")
					break;
	}
	if(name.size != i)
			name = getSubStr(name, i + 1, name.size);
   */
	return name;
}