/*
	Quick random function for varying choices / 用于随机变化的快速随机函数

	Usage: / 用法：

		*	{maybe()} [Ask about apples / 询问苹果]
		*	{maybe()} [Ask about oranges / 询问橙子]
		*	{maybe()} [Ask about bananas / 询问香蕉]


*/

=== function maybe(list)
	~ return RANDOM(1, 3) == 1
