/*
	Takes a random element from a list, and returns it, modifying the list. / 从列表中随机取出一个元素并返回，同时修改该列表。

	Returns the empty list () if the source list is empty. / 如果源列表为空，则返回空列表 ()。

	Usage:  / 用法：

	LIST fruitBowl = (apple), (banana), (melon)

	I eat the {pop_random(fruitBowl)}. Now the bowl contains {fruitBowl}. / 我吃了{pop_random(fruitBowl)}。现在碗里有{fruitBowl}。

*/

=== function pop_random(ref _list)
    ~ temp el = LIST_RANDOM(_list)
    ~ _list -= el
    ~ return el
