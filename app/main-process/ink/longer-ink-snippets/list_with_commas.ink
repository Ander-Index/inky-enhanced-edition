/*
	Takes a list and prints it out, using commas. / 获取一个列表并用逗号分隔打印输出。

	Dependenices: / 依赖项：

		This function relies on the "pop" function. / 此函数依赖于 "pop" 函数。

	Usage: / 用法：

		LIST fruitBowl = (apples), (bananas), (oranges)

		The fruit bowl contains {list_with_commas(fruitBowl)}. / 水果碗里有 {list_with_commas(fruitBowl)}。
*/

=== function list_with_commas(list)
	{ list:
		{_list_with_commas(list, LIST_COUNT(list))}
	}

=== function _list_with_commas(list, n)
	{pop(list)}{ n > 1:{n == 2: and / 和 |, }{_list_with_commas(list, n-1)}}
