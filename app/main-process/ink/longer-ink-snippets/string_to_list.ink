/*
	Converts a string to the corresponding list element from a particular list. Note the element doesn't need to be in the list variable at that moment in time! / 将字符串转换为特定列表中对应的列表元素。注意该元素不必在当时的列表变量中！

	Useful for sending parameters into the ink from the game: the game can store and pass in the string ID of the list element as a parameter. / 用于从游戏向 ink 发送参数：游戏可以存储并以参数形式传入列表元素的字符串 ID。

	Returns the empty list () if the element isn't found. / 如果未找到该元素，则返回空列表 ()。

	Usage: / 用法：

	LIST capitalCities = Paris, London, NewYork

	~ temp thisCity = string_to_list("Paris", capitalCities)
	~ capitalCities += thisCity
	I've now visited {thisCity}. / 我现在已经访问了 {thisCity}。

	Optimisation: / 优化：

	The code below works in inky, but can be externalised to speed up performance in game, with the following external C# function binding: / 以下代码在 inky 中可以运行，但可以通过以下外部 C# 函数绑定来外部化以提高游戏性能：

	story.BindExternalFunction("STRING_TO_LIST", (string itemKey) => {
        try
        {
            return InkList.FromString(itemKey, story);
        }
        catch
        {
            return new InkList();
        }
    }, true);

*/

=== function string_to_list(stringElement, listSource)
    ~ temp retVal = STRING_TO_LIST(stringElement)
    { USED_STRING_TO_LIST_FALLBACK:
    	~ retVal = stringAsPickedFromList(stringElement, LIST_ALL(listSource) )
    }
     ~ return retVal


EXTERNAL STRING_TO_LIST(stringElement)
=== function STRING_TO_LIST(stringElement)
    ~ return USED_STRING_TO_LIST_FALLBACK()

=== function USED_STRING_TO_LIST_FALLBACK()
	// this stub function is used to detect that the game isn't using an external function / 此桩函数用于检测游戏是否未使用外部函数
    ~ return

// fallback system: recurse through the listToTry, trying to string match the element name / 回退系统：递归遍历 listToTry，尝试字符串匹配元素名称
=== function stringAsPickedFromList(stringElement, listToTry)
    ~ temp minElement = LIST_MIN(listToTry)
    {minElement:
        { stringElement == "{minElement}":
            ~ return minElement
        }
        ~ return stringAsPickedFromList(stringElement, listToTry - minElement)
    }
    ~ return ()
