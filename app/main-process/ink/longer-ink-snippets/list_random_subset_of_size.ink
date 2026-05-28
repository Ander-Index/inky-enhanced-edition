/*
	Returns a randomised subset of items from a list, up to a given size. / 从列表中随机选取指定数量的子集。

	Returns the empty list () if the source list is empty, and the complete list if it runs out of items to pick. / 如果源列表为空则返回空列表 ()，如果可选数量不足则返回完整列表。

	Dependencies: / 依赖项：

		Requires "pop_random". / 需要 "pop_random"。

	Usage: / 用法：

		LIST fruitBowl = (apple), (banana), (melon)

		I put into my bag: {list_random_subset_of_size(fruitBowl, 2)}. / 我放进包里：{list_random_subset_of_size(fruitBowl, 2)}。


*/

=== function list_random_subset_of_size(sourceList, n)
    { n > 0:
        ~ temp el = pop_random(sourceList)
        { el:
            ~ return el + list_random_subset_of_size(sourceList, n-1)
        }
    }
    ~ return ()
