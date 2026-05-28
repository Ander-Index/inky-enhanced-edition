/*
	Returns a randomised subset of items from a list. / 从列表中返回一个随机子集。

	Returns the empty list () if the source list is empty. Might return () anyway! / 如果源列表为空，则返回空列表 ()。也可能无论如何都返回 ()！

	Dependencies:  / 依赖项：

		Requires "pop". / 需要 "pop" 函数。

	Usage:  / 用法：

		LIST fruitBowl = (apple), (banana), (melon)

		I put into my bag: {list_random_subset(fruitBowl)}.  / 我放进包里：{list_random_subset(fruitBowl)}。



*/

=== function list_random_subset(sourceList)
    ~ temp el = pop(sourceList)
    {el:
        { RANDOM(0,1) == 0:
            ~ el = ()
        }
        ~ return el + list_random_subset(sourceList)
    }
    ~ return ()
