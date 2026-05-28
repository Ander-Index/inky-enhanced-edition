/*

    This is a simplified version of the pontoon game from Overboard! / 这是《Overboard!》中 pontoon 牌局的简化版

    A deck of cards is properly simulated and dealt. The player can then bet on additional cards, before the AI characters (Carstairs, an English gentleman and card shark) will play.
    / 一副牌被正确地模拟并发牌。玩家可以押注额外的牌，然后 AI 角色（Carstairs，一位英国绅士兼牌局高手）才会出牌。

    In the real game (www.inklestudios.com/overboard) conversation options are added between hands, and there a few other more nefarious strategies for tilting the game in your favour!
    / 在实际游戏（www.inklestudios.com/overboard）中，各手牌之间会加入对话选项，还有一些更邪恶的策略可以让你在牌局中占据优势！

*/


-> play_game -> END

/* ---------------------------------------------

    Functions and Definitions / 函数与定义

--------------------------------------------- */

VAR myCards = ()
VAR hisCards = ()
VAR faceUpCards = ()

VAR money = 400


VAR CstrsBank = 1000

 LIST PackOfCards =
    A_Spades = 1, 2_Spades, 3_Spades, 4_Spades,
    5_Spades, 6_Spades, 7_Spades, 8_Spades,
    9_Spades, 10_Spades, J_Spades, Q_Spades, K_Spades,
    A_Diamonds = 101 , 2_Diamonds, 3_Diamonds, 4_Diamonds,
    5_Diamonds, 6_Diamonds, 7_Diamonds, 8_Diamonds,
    9_Diamonds, 10_Diamonds, J_Diamonds, Q_Diamonds, K_Diamonds,
    A_Hearts = 201, 2_Hearts, 3_Hearts, 4_Hearts,
    5_Hearts, 6_Hearts, 7_Hearts, 8_Hearts,
    9_Hearts, 10_Hearts, J_Hearts, Q_Hearts, K_Hearts,
    A_Clubs = 301, 2_Clubs, 3_Clubs, 4_Clubs,
    5_Clubs, 6_Clubs, 7_Clubs, 8_Clubs,
    9_Clubs, 10_Clubs, J_Clubs, Q_Clubs, K_Clubs

LIST Suits = Spades = 0, Diamonds, Hearts, Clubs

LIST Values = Ace = 1, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King




=== function suit(x)
    ~ return Suits(INT(FLOOR(LIST_VALUE(x) / 100)))

=== function number(x)
    ~ return Values(LIST_VALUE(x) mod 100)



=== function value(x)
    ~ return MIN(LIST_VALUE(x) mod 100, 10)

=== function shuffle()
    ~ PackOfCards = LIST_ALL(PackOfCards)

=== function addSpecificCardOfValue(ref toHand, val, faceUp)
    ~ temp x = pullCardOfValue(val)
    ~ return addSpecificCard( toHand, x, faceUp)

=== function addSpecificCard(ref toHand, x, faceUp)
    ~ toHand += x
    {faceUp:
        ~ faceUpCards += x
    }
    ~ return x

=== function addCard(ref toHand, faceUp)
    ~ temp x = pullCardOfValue(LIST_ALL(Values))
    ~ temp retVal = addSpecificCard( toHand, x, faceUp)
    ~ return retVal


=== function pullCardOfValue(valuesAllowed)
    ~ temp card = pop_random(PackOfCards)
    { card:
        { valuesAllowed !? number(card):
            ~ return pullCardOfValue(valuesAllowed)
        }
        ~ return card
    }
    [ Error: couldn't find a card of value {valuesAllowed}! ] / [错误：找不到值为 {valuesAllowed} 的牌！]
    ~ shuffle()
    ~ return pullCardOfValue(valuesAllowed)

=== function nameCard(x)
    {_nameCard(x, true) }

=== function _nameCard(x, allowVariants)
    ~ temp num = number(x)
    {allowVariants:
        { RANDOM(1, 3) == 1:
            a{(Eight, Ace) ? num :<>n} {num} in {suit(x)}
        - else:
            the {num} of {suit(x)}
        }
    - else:
        {num} of {suit(x)}
    }

=== function printHandDescriptively(x, mine)
    {printHand(faceUpCards ^ x)} face up / 明牌
    ~ temp faceDownCards = x - faceUpCards
    {faceDownCards:
        <>, and <> / <>, 以及 <>
        { mine:
            {printHand(faceDownCards)}
        - else:
            {print_number(LIST_COUNT(faceDownCards))} <> more / 更多
        }
        <> {~{mine:hidden|}|face down|blind} / {~{mine:暗|}|暗牌|盲牌}
    }

=== function printHand(x)
    ~ _printHand(x)
=== function _printHand(x)
    ~ temp y = pop(x)
    {y:
        {nameCard(y)}
        {LIST_COUNT(x):
        - 0:
            ~ return
        - 1:
            <> and {_printHand(x)}
        - else:
            <>, {_printHand(x)}
        }
    }

== function listMyCards()
    ~ _listOfCards(myCards)
== function _listOfCards(hand)
    ~ temp y = pop(hand)
    { y:
        <>{_nameCard(y, false)}
        {hand:
            <><br>
            ~ _listOfCards(hand)
        }
    }



=== function isPontoon(x)
    ~ return handContains(x, Ace) && ( handContains(x, King) || handContains(x, Queen) || handContains(x, Jack) ) && LIST_COUNT(x) == 2

=== function handContains(x, card)
    ~ temp y = pop(x)
    { y:
        { number(y) == card:
            ~ return true
        - else:
            ~ return handContains(x, card)
        }
    }
    ~ return false

=== function minTotalOfHand(x)
    ~ temp y = pop(x)
    {y:
        ~ return minTotalOfHand(x) + value(y)
    }
    ~ return 0

=== function maxTotalOfHand(x)
    ~ temp minTot = minTotalOfHand(x)
    {handContains(x, Ace) && minTot <= 11:
        ~ return minTot + 10
    - else:
        ~ return minTot
    }

=== function sayTotalOfHand(x)
    ~ temp minTot = minTotalOfHand(x)
    { shuffle:
    -   for a total of / 总计
    -   total of / 总计
    -   giving / 得出
    -   making / 合计
    }
    <> {print_number(minTot)}
    { handContains(x, Ace)  && minTot <= 11:
        ~ temp max = maxTotalOfHand(x)
        <>, or {print_number(maxTotalOfHand(x))} / <>, 或 {print_number(maxTotalOfHand(x))}
    }
=== function finalTotalOfHand(x)
    { isPontoon(x):
        pontoon
    - else:
        {print_number(maxTotalOfHand(x))}
    }


=== function describeMyCards()
    { shuffle:
    -   V:      ... {printHandDescriptively(myCards, true)}. #thought
    - { shuffle:
        -   CARSTAIRS:  {~First {~card|out|up} {!for you} is|} / {~你的第一张{~牌|明牌|牌}是|}

        -   CARSTAIRS:  The lady {~has|gets} / 这位女士{~有|拿到}

        }
        <> {nameCard(faceUpCards ^ myCards)}
        V:  ... and face down, {nameCard(myCards - faceUpCards)} ... #thought / ... 暗牌是 {nameCard(myCards - faceUpCards)} ... #thought
    }
    V:      ... {sayTotalOfHand(myCards)} ... #thought




== function describePot(bet)
    { shuffle:
    -   CARSTAIRS:  The {~bet|stake|pot} is {print_number(bet)} pounds. / {~赌注|筹码|底池}是 {print_number(bet)} 英镑。
    -   CARSTAIRS:  {~That makes|{~There|That}'s} {print_number(bet)} pounds {~in the pot|on the table}. / {~那就是|{~桌子上有|那是}} {print_number(bet)} 英镑{~在底池中|在桌上}。
    }


/*------------------------------------------

    GAMEPLAY CONTENT LOOP / 游戏内容循环

------------------------------------------*/

=== play_game

- (top_of_game)

    ~ temp startingMoney = money

    ~ myCards = ()

    ~ hisCards = ()
    ~ faceUpCards = ()

    ~ temp bet = 20

    { once:
    -   VO:     I throw two ten-pound notes onto the table. / 我把两张十英镑钞票扔到桌上。
    -   V:  Twenty pounds. / 二十英镑。
        CARSTAIRS:     The pot stands at twenty pounds. / 底池为二十英镑。
    -   VO:     I toss in my ante. / 我扔进了我的底注。



    }
    {

    - LIST_COUNT(PackOfCards) < 10:
        ~ shuffle()
        ~ temp plural = RANDOM(1,2)

        VO:         Carstairs {~collects together|gathers up} {plural:{~all|} the cards|the deck}, and {~riffles|shuffles} {plural:them|it} {~thoroughly|expertly|quickly|carelessly||} before dealing the first two cards. / Carstairs {~收起|聚拢} {plural:{~所有的|}牌|整副牌}，然后{ ~彻底地|娴熟地|快速地|随意地||} {~洗了洗|洗牌}，之后发出了前两张牌。

    - else:

        VO:     Carstairs {~passes me|spins me|tosses over|deals out} {~{~an opening|a new} card|my first card} {~face up|} {~from the {~top of the|} deck|}. / Carstairs {~递给我|转给我|扔给我|发出} {~{~一张起手|一张新}牌|我的第一张牌} {~明牌| } {~从{~牌堆顶部|}发来|}。
    }
    ~ temp myNewCard = ()

    ~ myNewCard = addCard(myCards, true)


    { shuffle:
    -   CARSTAIRS:  {~First {~card|out} is|} {nameCard(myNewCard)}. / {~第一张{~牌|明牌}是|} {nameCard(myNewCard)}。

    -   CARSTAIRS:  The lady {~has|gets|receives} {nameCard(myNewCard)}. / 这位女士{~有|拿到|收到} {nameCard(myNewCard)}。
    }

    ~ temp hisNewCard =  addCard(hisCards, true)
    { stopping:
    -   CARSTAIRS:  And the dealer... gets {nameCard(hisNewCard)}. / 而庄家……拿到了 {nameCard(hisNewCard)}。
        -
        { shuffle:
        -   CARSTAIRS: And it's {nameCard(hisNewCard)} for me. / 而我是 {nameCard(hisNewCard)}。

        -   CARSTAIRS:  {~Dealer {~gets...|has}|And I have} {nameCard(hisNewCard)}. / {~庄家{~拿到……|有}|而我有} {nameCard(hisNewCard)}。
        }
    }

    {once:
    -   CARSTAIRS:      You can fold, or make a bet to stay in. / 你可以弃牌，或者下注继续。
    }

    ~ temp incr = 0
- (bet_opts)
    +   [ Fold ] / [弃牌]

        V:  {~Pass|Fold}. / {~过|弃牌}。
        -> i_lost

    +   [ Bet 50  ] / [下注 50]
        ~ incr =  50
    +   {money - bet < 200} [ Bet 100   ] / [下注 100]
        ~ incr = 100
    +   {money - bet >= 200} [ Bet higher... ] / [下注更高……]
        + + {CHOICE_COUNT() < 2 }  {money - bet <= 300} [   Bet 100   ] / [下注 100]
            ~ incr = 100
        + + {CHOICE_COUNT() < 2 } {money - bet <= 250} [   Bet 150    ] / [下注 150]
            ~ incr =  150
        + + {CHOICE_COUNT() < 2 } [   Bet 200   ] / [下注 200]
            ~ incr =  200
        + + {CHOICE_COUNT() < 2 } {money - bet >= 300} [   Bet 300   ] / [下注 300]
            ~ incr = 300
        + + [ Bet lower... ] / [下注更低……]
            -> bet_opts


-
    { shuffle:
    -   V:  I put in {print_number(incr)} pounds {incr > 50: more}. / 我投入 {print_number(incr)} 英镑{incr > 50: 更多}。
    -   V:  I raise {print_number(incr)} pounds. / 我加注 {print_number(incr)} 英镑。
    }
    { incr >= 200:

        { shuffle once:
        -   VO:     Carstairs raises an eyebrow. / Carstairs 挑了挑眉毛。
        -   CARSTAIRS:  Crikey. / 天哪。
        -   CARSTAIRS:  Well, now. / 哎呀呀。
        -   CARSTAIRS:  Someone's feeling lucky. / 有人觉得自己运气不错。
        }

    }
 -      ~ bet += incr

        { describePot(bet) }

        { shuffle:
        -   VO:     He {~hands|deals} {~me|out} a second card, face-down. / 他{~递给我|发出}第二张牌，暗牌。
        -   CARSTAIRS:  Here's your next card. / 这是你的下一张牌。
            { RANDOM(1, 2):
               VO:     He slides it across the table to me, face down. / 他把牌从桌上滑到我面前，暗牌。
            }
        }

        {once:
        -   CARSTAIRS:  Take a look, don't let me see. / 看看吧，别让我看到。
        }

        ~ myNewCard = addCard(myCards, false)


        V:  ... {nameCard(myNewCard)}: {sayTotalOfHand(myCards)} ... #thought

        ~ addCard(hisCards , false)

        { shuffle:
        -   VO:     He deals one more for himself, face down. / 他给自己也发了一张，暗牌。
        -   CARSTAIRS:  One more blind for me, too. / 我也再来一张盲牌。
        }

- (myplay)

    { minTotalOfHand(myCards) > 21:
        { shuffle:
        -   V:  I'm bust. / 我爆了。
        -   V:  Damn. / 该死。
        -   VO:     I {~toss|throw} my cards down. / 我把牌{~扔掉|摔下}。
        }
        { i_lost mod 3 == 2:
            { shuffle:
            -   V:  You're rigging this. / 你在作弊。
            -   V:  How are you doing this? / 你是怎么做到的？
            -   V:  This can't be fair. / 这不可能是公平的。
            }
            { shuffle:
            -   CARSTAIRS:  I assure you I'm not! / 我向你保证我没有！
            -   CARSTAIRS:  I play the odds, Ma'am, not the player. / 我玩的是概率，女士，不是玩家。
            -   CARSTAIRS:  I promise you, I'm as square as they come! / 我向你保证，我最老实不过了！
            }


        }
        -> i_lost
    }
    { LIST_COUNT(myCards) == 5:
        CARSTAIRS:  A five card trick! / 五张牌戏法！
        CARSTAIRS:  That beats the same value on fewer cards. / 这胜过相同点数但更少牌的情况。
    }

 - (check_for_burn)
    { LIST_COUNT(myCards) == 2 && minTotalOfHand(myCards) == 13 && money - bet >= 20:
        +   {came_from(-> burny)}
            [ Burn again ] / [再次烧牌]
            -> burny
        +   (burny) {not came_from(-> burny)}
            [ Burn for twenty more ] / [再烧二十英镑]
            ~ bet += 20
            V:  Burn. / 烧牌。
            >>> AUDIO CardCollectAndDealTwoCards
            VO:     Carstairs collects in the cards and deals two more. / Carstairs 收回牌，又发了两张。
            ~ faceUpCards -= myCards
            ~ myCards = ()
            ~ addCard(myCards, true)
            ~ addCard(myCards, false)
            V:      ... {printHandDescriptively(myCards, true)} ... #thought
            V:      ... {sayTotalOfHand(myCards)} ... #thought

            -> check_for_burn

        *   [ Keep them ] / [保留这些牌]
            -> bid_loop
    - else:
        -> bid_loop
    }
    -> DONE

- (bid_loop)

    { not seen_very_recently(->  describePot):
        { describePot(bet) }
    }
    ~ temp gotTwentyOne = (maxTotalOfHand(myCards) == 21)
    {gotTwentyOne:
        {isPontoon(myCards):
            V:  ... It's a pontoon..!  #thought / ... 是 pontoon..！ #thought
        - else:
            V:  ... Twenty-one!   #thought / ... 二十一！ #thought
        }

    }

    +   [ Stick {not gotTwentyOne: on {finalTotalOfHand(myCards)}} ] / [停牌 {not gotTwentyOne: 在 {finalTotalOfHand(myCards)}}]
        CARSTAIRS:  Final bet is {print_number(bet)} pounds. / 最终赌注是 {print_number(bet)} 英镑。
        -> hisplay_begins

    *   (gloat) {gotTwentyOne} [ Gloat ] / [得意]
        >>> AUDIO: V Chuckle 1
        V:  You're in trouble now, Mr Carstairs... / 你现在麻烦大了，Carstairs 先生……
        CARSTAIRS:  Is that so? / 是吗？
        -> hisplay_begins

    *   {gotTwentyOne} [ Give nothing away ] / [不动声色]
        >>> AUDIO: V Clear Throat 1
        V:          Your turn, then. / 轮到你了，那么。
        CARSTAIRS:  I take it you're sticking, then? / 我猜你是要停牌了？
        -> hisplay_begins

    +   {not gotTwentyOne} [ Twist ] / [要牌]
        { shuffle:
        -   V:  Twist. / 要牌。
        -   V:  Another card. / 再来一张。
        -   V:  Give me another. / 再给我一张。
        -   V:  One more, face up. / 再来一张，明牌。
        }
        ~ temp newUpCard = addCard(myCards, true)

        CARSTAIRS:  {nameCard(newUpCard)}.

        V:  ... {sayTotalOfHand(myCards)}. #thought
        -> myplay

    +   { (money - bet) >= 50 }  {not gotTwentyOne}
        [ Buy for fifty ] / [花五十买牌]
        ~ bet += 50
        ~ temp newDownCard = addCard(myCards, false)
        {shuffle:
        -   V:  Buy. / 买牌。
        -   V:  I'll buy one. / 我买一张。
        -   V:  One more, face down. / 再来一张，暗牌。
        }
        {shuffle:
        -   CARSTAIRS:  The stake is now {print_number(bet)}. / 现在赌注是 {print_number(bet)}。
        -   CARSTAIRS:   {print_number(bet)} in the pot. / 底池中有 {print_number(bet)}。
        }

        { shuffle:
        -   VO:     Carstairs passes me another card, face-down. / Carstairs 又递给我一张牌，暗牌。
        -   CARSTAIRS:   Here's your card. / 这是你的牌。
        }

        V:  ... {nameCard(newDownCard)}. #thought
        V:  ... {sayTotalOfHand(myCards)}. #thought
        -> myplay

- (hisplay_begins)

    ~ faceUpCards += hisCards
    { shuffle:
    -   CARSTAIRS:  Let's see what I have... / 让我看看我有什么……
        CARSTAIRS:  {printHandDescriptively(hisCards, false)}.
    -   CARSTAIRS:  Dealer has... {printHandDescriptively(hisCards, false)}. / 庄家有…… {printHandDescriptively(hisCards, false)}。
    }

    CARSTAIRS:  {sayTotalOfHand(hisCards)}.

- (hisplay_main)
    // AI plays / AI 出牌

    ~ temp hes_scared = seen_more_recently_than(-> gloat, -> top_of_game)

    ~ temp hisTotal = minTotalOfHand(hisCards)

    { hisTotal > 21:
        { shuffle:
        -   CARSTAIRS:  I'm bust! / 我爆了！
        -   CARSTAIRS:  Too high! / 太高了！
        -   CARSTAIRS:  No luck there! / 运气不好啊！
        }
        -> i_won
    }

    ~ temp hisMaxTotal = maxTotalOfHand(hisCards)

    ~ temp yourVisibleTotal = maxTotalOfHand(myCards ^ faceUpCards)
    ~ temp yourBestTotal = 21

    // edge case. You have ? - 3 - 5 => your best is 19. / 边界情况。你有 ？- 3 - 5 => 你的最佳是 19。
    { LIST_COUNT(myCards - faceUpCards) == 1 && yourVisibleTotal < 10:
        ~ yourBestTotal = 11 + yourVisibleTotal
    }

    +   {hisMaxTotal > yourBestTotal || (hisMaxTotal == yourBestTotal && LIST_COUNT(myCards) < 5)} ->
        - - (he_sticks)
            CARSTAIRS:  Dealer sticks on {finalTotalOfHand(hisCards)}. / 庄家停牌在 {finalTotalOfHand(hisCards)}。
            -> hisplayover
    +   { hisMaxTotal >= 18 && !handContains(hisCards, Ace)}   -> he_sticks

    +   { hisTotal == 10 || hisTotal == 11 } -> he_twists

    +   { hisMaxTotal <= 15 || (hisMaxTotal <= 17 && handContains(hisCards, Ace)) || (hisMaxTotal <= 18 && hes_scared) } ->
        - - (he_twists)
            { shuffle:
            -   CARSTAIRS: I'll take another. / 我再要一张。
            -    CARSTAIRS: Dealer twists. / 庄家要牌。
            -    CARSTAIRS: One more... / 再来一张……
            }

            ~ temp newHisCard = addCard(hisCards, true)
            CARSTAIRS:  {nameCard(newHisCard)}, {sayTotalOfHand(hisCards)}.
            -> hisplay_main

    +   {RANDOM(1, 3) == 1} ->
        -> he_sticks

    +   -> he_twists

- (hisplayover)

    ~ temp facedownCards = myCards - faceUpCards

- (dealoutcards)
    { pop(facedownCards):
        -> dealoutcards
    }


    ~ temp scoreDiff = maxTotalOfHand(myCards) - maxTotalOfHand(hisCards)
    { cycle:
    -   VO:     I lay my cards down. / 我把牌摊开。
    -  VO:     I {~turn|flip} my cards {~face-up|over}. / 我把牌{~翻开|翻过来}。
      -
    }

    { cycle:
    -   V:  I've got {scoreDiff < 0:only} {finalTotalOfHand(myCards)}{scoreDiff==0:<> too}. / 我有{scoreDiff < 0: 只有} {finalTotalOfHand(myCards)}{scoreDiff==0:<> 也一样}。
    -  V:      {finalTotalOfHand(myCards)}.
    }

    {
    - scoreDiff > 0 && maxTotalOfHand(myCards) < 21:
        {stopping:
        -   V:  I won? / 我赢了？
        -   {cycle:
                - V:  I won. / 我赢了。
                -
            }
        }
        -> i_won
    - scoreDiff < 0:
        CARSTAIRS:  Dealer wins! / 庄家赢！
        -> i_lost
    - scoreDiff == 0:
        { LIST_COUNT(myCards) >= 5 && LIST_COUNT(hisCards) < 5:
            CARSTAIRS:  Five card trick wins! / 五张牌戏法赢！
            -> i_won
        }
        CARSTAIRS:  It's a draw. Dealer wins, I'm afraid. / 平局。恐怕是庄家赢。
        -> i_lost
    }


- (i_won)
    ~ money += bet
    ~ CstrsBank -= bet

    VO:     I collect up the money from the table. / 我从桌上收起钱。
    {
    - isPontoon(myCards):
        CARSTAIRS:  And pontoon earns double. / pontoon 赢双倍。
        ~ money += bet
        ~ CstrsBank -= bet

        VO:     He counts out another {print_number(bet)} pounds. / 他又数出 {print_number(bet)} 英镑。
    - maxTotalOfHand(myCards) == 21 && LIST_COUNT(myCards) == 2:
        { once:
        -   CARSTAIRS:  But it's not a pontoon, I'm afraid. / 但恐怕这不是 pontoon。
            CARSTAIRS:  Need a face card for that. / 那需要一张花牌才行。

        }
    }

    { shuffle:
    -   VO:     I've now got {print_number(money)} pounds. / 我现在有 {print_number(money)} 英镑了。
    -   V:      ... I've now got {print_number(money)} pounds. / ... 我现在有 {print_number(money)} 英镑了。
    }

    -> done

- (i_lost)

    ~ money -= bet
    ~ CstrsBank += bet
    VO:     Carstairs {~takes|{~collects|scoops} {~up|}} the {~pot|stake|money {~{~off|from} the table|}} and gathers up the cards. / Carstairs {~拿走|{~收走|舀起}} {~底池|赌注|{~{~从桌上|}}钱}，收起了牌。
    { money < 50:
        V:  You've cleaned me out! / 你把我榨干了！
        CARSTAIRS:  I'm sorry to hear that, Mrs V. / 听到这个我很遗憾，V 夫人。
        CARSTAIRS:  Thanks for the game. / 谢谢这场牌局。


        VO:     He tucks his winnings into his waistcoat pocket and grins like an idiot. / 他把赢来的钱塞进马甲口袋，像个傻瓜一样咧嘴笑着。
        -> finished
    }
    { money >= startingMoney:
        { shuffle:
        -   VO:     I've still got {print_number(money)} pounds. / 我还有 {print_number(money)} 英镑。
        }
    - else:
        { shuffle:
        -   V:      ... I'm down to {print_number(money)} pounds ... #thought / ... 我只剩下 {print_number(money)} 英镑了 ... #thought
        -   V:     ... {print_number(money)} pounds left ...  #thought / ... 还剩 {print_number(money)} 英镑 ... #thought
        }
    }
    -> done

- (done)

    ~ temp wasPontoon = isPontoon(myCards)
    ~ myCards = ()

    { CstrsBank <= 50:
        CARSTAIRS:  Well, you've cleaned me out of spending money, Mrs Villensey! / 好吧，你把我的零花钱都赢光了，Villensey 夫人！
        CARSTAIRS:  I must say; a much better show than your husband achieved. / 我必须说，比你丈夫的表现好得多。
        -> finished
    }

    {
    - came_from(-> i_lost):
        {shuffle:
        -   CARSTAIRS:       Have you had enough? / 你够了吗？
        -   CARSTAIRS:       Keep going? / 继续？
        -   CARSTAIRS:       Again? / 再来？
        }
    - came_from(-> i_won):
        { shuffle:
        -    CARSTAIRS:      Another round? / 再来一局？
        -    CARSTAIRS:      Again? / 再来？
        -    CARSTAIRS:      Another? / 再来一局？
        }
    - else:
        { cycle:
        -   VO:     Carstairs {~has been squaring up|is fiddling with} the {~pack|deck}. / Carstairs {~一直在整理|在摆弄} {~牌|牌堆}。
        -   VO:     Carstairs is shuffling idly. / Carstairs 在漫不经心地洗牌。
            ~ shuffle()
        }
        { shuffle:
         -    CARSTAIRS:      Are we still playing? / 我们还在玩吗？
         -    CARSTAIRS:      Another hand, Mrs Villensey? / 再来一手，Villensey 夫人？
        }
    }

 - (replay_opts)

    +   [ Play another round ] / [再玩一局]
        {
        - money >= 250:
            { shuffle:
            -   V:  Hit me. / 发牌。

            -   V:  Deal. / 发吧。

            -   V:  Let's try again. / 我们再试一次。

            -   V:  Another! / 再来！

            }
        - money >= 100:
            { shuffle:
            -   V:  I'll play another round. / 我再玩一局。

            -   V:  I'll play a little more. / 我再玩一会儿。

            -   V:  I'm not finished yet. / 我还没完呢。
            }
        -  money >= 70:
            { shuffle:
            -   V:  I can afford one more round. / 我还能再来一局。
            -   V:  I'd better be lucky this time! / 这次我最好运气好点！
            }
        }
        -> top_of_game



    +   [ Stop playing ] / [不玩了]
        {shuffle:
        -   V:  Perhaps later. / 也许以后吧。
        -   V:  Another time, perhaps. / 改天吧，也许。
        }

    - (finished)
        ~ myCards = ()

        ->->


/*------------------------------------------

    STOCK FUNCTIONS / 库存函数

    These functions are all available from the ink snippet menu in inky 0.12.0 and above
    / 这些函数都可以在 inky 0.12.0 及以上版本的 ink 片段菜单中找到

------------------------------------------*/

/*
	Tests if the flow passes a particular gather on this turn.
	/ 测试流程在本回合是否经过了某个特定的汇聚点。

	Usage: / 用法：

	- (welcome)
		"Welcome!" / "欢迎！"
	- (opts)
		*	{came_from(->welcome)}
			"Welcome to you!" / "欢迎你！"
		*	"Er, what?" / "呃，什么？"
			-> opts
		*	"Can we get on with it?" / "我们能继续了吗？"

*/

=== function came_from(-> x)
    ~ return TURNS_SINCE(x) == 0

/*
	Tests if the flow passes a particular gather "very recently" - that is, within the last 3 turns.
	/ 测试流程是否"最近"经过了某个特定的汇聚点——即最近 3 个回合内。

	Usage: / 用法：

	- (welcome)
		"Welcome!" / "欢迎！"
	- (opts)
		*	{seen_very_recently(->welcome)}
			"Sorry, hello, yes." / "抱歉，你好，是的。"
		+	"Er, what?" / "呃，什么？"
			-> opts
		*	"Can we get on with it?" / "我们能继续了吗？"

*/

=== function seen_very_recently(-> x)
    ~ return TURNS_SINCE(x) >= 0 && TURNS_SINCE(x) <= 3

/*
	Tests if the flow has reached one divert more recently than another.
	/ 测试流程到达一个转向是否比另一个更近。

	If we have never reached the first divert, we return false. / 如果我们从未到达过第一个转向，返回 false。
	If we have never reached the second divert, we return true. / 如果我们从未到达过第二个转向，返回 true。

	This is especially useful for testing "have we done X this scene".
	/ 这对于测试"我们是否在本场景中做了 X"特别有用。

	Usage: / 用法：

	- (start_of_scene)
		"Welcome!" / "欢迎！"

	- (opts)
		<- cough_politely(-> opts)

		*	{ seen_more_recently_than(-> cough_politely.cough, -> start_of_scene) }
			"Hello!" / "你好！"

		+	{ not seen_more_recently_than(-> cough_politely.cough, -> start_of_scene) }
			["Hello!"] / ["你好！"]
			I try to speak, but I can't get the words out! / 我试着说话，但说不出话来！
			-> opts



	=== cough_politely(-> go_to)
		*	(cough) [Cough politely] / [礼貌地咳嗽]
			I clear my throat. / 我清了清嗓子。
			-> go_to

*/

=== function seen_more_recently_than(-> link, -> marker)
	{ TURNS_SINCE(link) >= 0:
        { TURNS_SINCE(marker) == -1:
            ~ return true
        }
        ~ return TURNS_SINCE(link) < TURNS_SINCE(marker)
    }
    ~ return false





/*
	Takes the bottom element from a list, and returns it, modifying the list.
	/ 从列表中取出最底部的元素并返回，同时修改列表。

	Returns the empty list () if the source list is empty.
	/ 如果源列表为空则返回空列表 ()。

	Usage: / 用法：

	LIST fruitBowl = (apple), (banana), (melon)

	I eat the {pop(fruitBowl)}. Now the bowl contains {fruitBowl}. / 我吃了 {pop(fruitBowl)}。现在碗里有 {fruitBowl}。

*/

=== function pop(ref _list)
    ~ temp el = LIST_MIN(_list)
    ~ _list -= el
    ~ return el


/*
	Takes a random element from a list, and returns it, modifying the list.
	/ 从列表中随机取出一个元素并返回，同时修改列表。

	Returns the empty list () if the source list is empty.
	/ 如果源列表为空则返回空列表 ()。

	Usage: / 用法：

	LIST fruitBowl = (apple), (banana), (melon)

	I eat the {pop_random(fruitBowl)}. Now the bowl contains {fruitBowl}. / 我吃了 {pop_random(fruitBowl)}。现在碗里有 {fruitBowl}。

*/

=== function pop_random(ref _list)
    ~ temp el = LIST_RANDOM(_list)
    ~ _list -= el
    ~ return el




/*
    Converts an integer between -1,000,000,000 and 1,000,000,000 into its printed equivalent.
    / 将 -1,000,000,000 到 1,000,000,000 之间的整数转换为对应的打印文本。

    Usage: / 用法：

    There are {print_number(RANDOM(100000,10000000))} stars in the sky. / 天空中有 {print_number(RANDOM(100000,10000000))} 颗星星。

*/

=== function print_number(x)
{
    - x >= 1000000:
        ~ temp k = x mod 1000000
        {print_number((x - k) / 1000000)} million{ k > 0:{k < 100: and|{x mod 100 != 0:<>,}} {print_number(k)}}
    - x >= 1000:
        ~ temp y = x mod 1000
        {print_number((x - y) / 1000)} thousand{ y > 0:{y < 100: and|{x mod 100 != 0:<>,}} {print_number(y)}}
    - x >= 100:
        ~ temp z = x mod 100
        {print_number((x - z) / 100)} hundred {z > 0:and {print_number(z)}}
    - x == 0:
        zero
    - x < 0:
        minus {print_number(-1 * x)}
    - else:
        { x >= 20:
            { x / 10:
                - 2: twenty
                - 3: thirty
                - 4: forty
                - 5: fifty
                - 6: sixty
                - 7: seventy
                - 8: eighty
                - 9: ninety
            }
            { x mod 10 > 0:
                <>-<>
            }
        }
        { x < 10 || x > 20:
            { x mod 10:
                - 1: one
                - 2: two
                - 3: three
                - 4: four
                - 5: five
                - 6: six
                - 7: seven
                - 8: eight
                - 9: nine
            }
        - else:
            { x:
                - 10: ten
                - 11: eleven
                - 12: twelve
                - 13: thirteen
                - 14: fourteen
                - 15: fifteen
                - 16: sixteen
                - 17: seventeen
                - 18: eighteen
                - 19: nineteen
            }
        }
}
