/*
	In a list with values, it can be tricky the get the "next value along", as it may not be equal to the current value + 1 / 在带值的列表中，获取"下一个值"可能比较棘手，因为它不一定等于当前值 + 1。

	e.g. In the following: / 例如，在以下情况中：

	LIST ComboMultipliers = (one = 1), (two = 2), (five = 5), (ten = 10), (twenty = 20), (hundred = 100)

	one + 1 == two

	but / 但是

	two + 1 == (), because there is no list value corresponding to "3". / two + 1 == ()，因为没有对应 "3" 的列表值。

	The following two functions allow us to the find the next value in a list compared to the current one, returning () if the current entry is already the maximum or minimum value, respectively. / 以下两个函数用于查找列表中相对于当前值的下一个值，若当前条目已是最大或最小值，则分别返回 ()。

	So: / 因此：
	LIST_PREV(five) == two
	LIST_NEXT(ten) == twenty

	and / 以及

	LIST_PREV(one) = ()
	LIST_NEXT(hundred) = ()

*/

=== function LIST_PREV(listValue)
	// returns the highest value that's NOT in the range from the current to the maximum / 返回从当前值到最大值范围之外的最高值
    ~ return LIST_MAX(LIST_INVERT(LIST_RANGE(LIST_ALL(listValue),  listValue, LIST_MAX(LIST_ALL(listValue)))))

=== function LIST_NEXT(listValue)
	// returns the lowest value that's NOT in the range from the minimum to the current / 返回从最小值到当前值范围之外的最低值
    ~ return LIST_MIN(LIST_INVERT(LIST_RANGE(LIST_ALL(listValue),  LIST_MIN(LIST_ALL(listValue)), listValue)))
