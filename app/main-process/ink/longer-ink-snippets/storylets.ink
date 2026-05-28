/* "Storylet" implementation. / "故事片段"实现

    Based on https://github.com/smwhr/ink-storylets/tree/main by smwhr. / 基于 smwhr 的 https://github.com/smwhr/ink-storylets/tree/main

    This allows you to create content as "storylets" - little chunks / scenes, which are gated by preconditions. The game offers a choice of which one the player can look at, by picking the top N that are available now. / 这允许你将内容作为"故事片段"——小块/场景来创建，它们由前置条件控制。游戏通过选择当前可用的前 N 个故事片段，让玩家选择一个来查看。

    The machinery is fairly light, and the data is kept "with" the story content, so its easy to use as an extendable template. / 这套机制相当轻量，数据与故事内容一起保存，因此很容易作为可扩展模板使用。

*/



The beginning! / 开始！

- (opts)
    // pick top 2 stories to choose from / 选择前 2 个故事供玩家挑选
    <- listAvailableStorylets(2, -> opts)

    // provide a fallback if there's nothing available / 如果没有可用内容，提供一个后备选项
    * ->

-   There was nothing else to do. / 没什么别的事可做了。
    -> END

// The following functions run through the storylet database
// and find acceptable storylets, in priority order
// 以下函数遍历故事片段数据库，按优先级顺序找到合适的故事片段

VAR AvailableStorylets = ()

== listAvailableStorylets(max, -> backTo)
    ~ AvailableStorylets = ()
    ~ computeStorylets(LIST_ALL(Storylets), max)
    -> offerStorylets(AvailableStorylets, backTo)

== function computeStorylets(list, max)
    ~ temp current = LIST_MIN(list)
    { current && max > 0:
        ~ list -= current
        ~ temp storyletFunction = StoryletDatabase(current)

        { storyletFunction(Condition):
            ~ AvailableStorylets += current
            ~ max--
        }
        ~ computeStorylets(list, max)
    }

=== offerStorylets(list, -> backTo)===
    ~ temp current = LIST_MIN(list)  // in ascending storylet order / 按故事片段升序
    {current:
        ~ list -= current
        ~ temp storyletFunction = StoryletDatabase(current)

        +   [{storyletFunction(ChoiceText)}]
            ~ temp whereTo = storyletFunction(Content)
            -> whereTo -> backTo
    }
    { list:
        -> offerStorylets(list, backTo)
    }
    -> DONE


// The database, linking storylet LIST values to their index functions
// 数据库，将故事片段 LIST 值映射到其索引函数

LIST Props = Content, Condition, ChoiceText

LIST Storylets = StoryA, StoryB, StoryC         // in priority order / 按优先级排序

=== function StoryletDatabase(storylet)
   { storylet:
   -  StoryA:   ~ return -> StoryletData_Avocado
   -  StoryB:   ~ return -> StoryletData_Bananas
   -  StoryC:   ~ return -> StoryletData_Crumpets
   }

// Story Content: each storylet is a database function / content pair.
// 故事内容：每个故事片段是一个数据库函数/内容对。

=== function StoryletData_Avocado(prop)
    { prop:
    -   ChoiceText: Visit the Avocado Witch / 拜访牛油果女巫
    -   Condition:  ~ return not witch_content  // once only / 仅一次
    -   Content:    ~ return -> witch_content
    }

=== witch_content
    You visit the witch. / 你拜访了女巫。
    ->->



=== function StoryletData_Bananas(prop)
    { prop:
    -   ChoiceText:  Now you have met the King, visit the Banana Boy! / 既然你已经见过国王，去拜访香蕉男孩吧！
    -   Condition:  ~ return not boy_content && king_content // once only / 仅一次
    -   Content:    ~ return -> boy_content
    }

=== boy_content
    You visit the boy. / 你拜访了男孩。
    ->->


=== function StoryletData_Crumpets(prop)
    { prop:
    -   ChoiceText: Visit the Crumpet King / 拜访煎饼国王
    -   Condition:  ~ return not king_content  // once only / 仅一次
    -   Content:    ~ return -> king_content
    }

=== king_content
    You visit the king. / 你拜访了国王。
    ->->
