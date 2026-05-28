/*
	Does a list item originate from a particular list? Returns false if testing (). / 判断某个列表项是否来自特定列表。若测试 () 则返回 false。

	Usage:  / 用法：

	LIST Fruits = apple, banana, melon
	LIST Veggies = carrot, cucumber

	~ temp x = apple
	I eat the {list_item_is_member_of(x, Fruits):fruit|vegetable}. / 我吃的是{list_item_is_member_of(x, Fruits):水果|蔬菜}。

*/

=== function list_item_is_member_of(k, list)
   	~ return k && LIST_ALL(list) ? k
