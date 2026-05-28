/*

    This is a long example of a crime scene investigation, from the Writing with Ink chapter on Lists.
    / 这是一个犯罪现场调查的长篇示例，来自《Writing with Ink》关于列表的章节。

*/

-> murder_scene

// Helper function: popping elements from lists / 辅助函数：从列表中弹出元素
=== function pop(ref list)
   ~ temp x = LIST_MIN(list)
   ~ list -= x
   ~ return x

//
//  System: items can have various states
//  Some are general, some specific to particular items
//  系统：物品可以有各种状态
//  有些是通用的，有些是特定物品独有的
//


LIST OffOn = off, on
LIST SeenUnseen = unseen, seen

LIST GlassState = (none), steamed, steam_gone
LIST BedState = (made_up), covers_shifted, covers_off, bloodstain_visible

//
// System: inventory / 系统：物品栏
//

LIST Inventory = (none), cane, knife

=== function get(x)
    ~ Inventory += x

//
// System: positioning things
// Items can be put in and on places
// 系统：物品定位
// 物品可以放在各处
//

LIST Supporters = on_desk, on_floor, on_bed, under_bed, held, with_joe

=== function move_to_supporter(ref item_state, new_supporter) ===
    ~ item_state -= LIST_ALL(Supporters)
    ~ item_state += new_supporter


// System: Incremental knowledge.
// Each list is a chain of facts. Each fact supersedes the fact before
// 系统：增量知识。
// 每个列表是一条事实链。每条事实取代之前的事实

VAR knowledgeState = ()

=== function reached (x)
   ~ return knowledgeState ? x

=== function between(x, y)
   ~ return knowledgeState? x && not (knowledgeState ^ y)

=== function reach(statesToSet)
   ~ temp x = pop(statesToSet)
   {
   - not x:
      ~ return false

   - not reached(x):
      ~ temp chain = LIST_ALL(x)
      ~ temp statesGained = LIST_RANGE(chain, LIST_MIN(chain), x)
      ~ knowledgeState += statesGained
      ~ reach (statesToSet)     // set any other states left to set / 设置任何其他待设置的状态
      ~ return true            // and we set this state, so true / 我们设置了这个状态，所以返回 true

    - else:
      ~ return false || reach(statesToSet)
    }

//
// Set up the game / 设置游戏
//

VAR bedroomLightState = (off, on_desk)

VAR knifeState = (under_bed)


//
// Knowledge chains / 知识链
//


LIST BedKnowledge = neatly_made, crumpled_duvet, hastily_remade, body_on_bed, murdered_in_bed, murdered_while_asleep

LIST KnifeKnowledge = prints_on_knife, joe_seen_prints_on_knife,joe_wants_better_prints, joe_got_better_prints

LIST WindowKnowledge = steam_on_glass, fingerprints_on_glass, fingerprints_on_glass_match_knife


//
// Content / 内容
//

=== murder_scene ===
    The bedroom. This is where it happened. Now to look for clues. / 卧室。这就是案发地点。现在来寻找线索。
- (top)
    { bedroomLightState ? seen:     <- seen_light  }
    <- compare_prints(-> top)

    *   (dobed) [The bed...] / [床铺……]
        The bed was low to the ground, but not so low something might not roll underneath. It was still neatly made. / 床离地面很低，但还不至于低到东西滚不进去。它仍然铺得整整齐齐。
        ~ reach (neatly_made)
        - - (bedhub)
        * *     [Lift the bedcover] / [掀开床罩]
                I lifted back the bedcover. The duvet underneath was crumpled. / 我掀开床罩。下面的羽绒被皱巴巴的。
                ~ reach (crumpled_duvet)
                ~ BedState = covers_shifted
        * *     (uncover) {reached(crumpled_duvet)}
                [Remove the cover] / [取下床罩]
                Careful not to disturb anything beneath, I removed the cover entirely. The duvet below was rumpled. / 小心翼翼地不弄乱下面的任何东西，我完全取下了床罩。下面的羽绒被凌乱不堪。
                Not the work of the maid, who was conscientious to a point. Clearly this had been thrown on in a hurry. / 这不是女仆干的，她一向兢兢业业。显然这是匆忙之中扔上去的。
                ~ reach (hastily_remade)
                ~ BedState = covers_off
        * *     (duvet) {BedState == covers_off} [ Pull back the duvet ] / [拉开羽绒被]
                I pulled back the duvet. Beneath it was a sheet, sticky with blood. / 我拉开羽绒被。下面是一条床单，沾满了粘稠的血迹。
                ~ BedState = bloodstain_visible
                ~ reach (body_on_bed)
                Either the body had been moved here before being dragged to the floor - or this is was where the murder had taken place. / 要么尸体在被拖到地板上前先被移到了这里——要么这就是谋杀发生的地方。
        * *     {BedState !? made_up} [ Remake the bed ] / [重新铺好床]
                Carefully, I pulled the bedsheets back into place, trying to make it seem undisturbed. / 我小心地把床单拉回原位，尽量让它看起来没有被动过。
                ~ BedState = made_up
        * *     [Test the bed] / [测试床铺]
                I pushed the bed with spread fingers. It creaked a little, but not so much as to be obnoxious. / 我用张开的手指推了推床。它吱嘎作响，但还不至于招人烦。
        * *     (darkunder) [Look under the bed] / [看看床底下]
                Lying down, I peered under the bed, but could make nothing out. / 我躺下来，往床底下窥视，但什么也看不清。

        * *     {TURNS_SINCE(-> dobed) > 1} [Something else?] / [别的什么？]
                I took a step back from the bed and looked around. / 我从床边退后一步，环顾四周。
                -> top
        - -     -> bedhub

    *   {darkunder && bedroomLightState ? on_floor && bedroomLightState ? on}
        [ Look under the bed ] / [看看床底下]
        I peered under the bed. Something glinted back at me. / 我往床底下窥视。有东西在闪闪发光。
        - - (reaching)
        * *     [ Reach for it ] / [伸手去够]
                I fished with one arm under the bed, but whatever it was, it had been kicked far enough back that I couldn't get my fingers on it. / 我用一只胳膊在床底下摸索，但不管那是什么，它被踢到了足够远的地方，我的手指够不到。
                -> reaching
        * *     {Inventory ? cane} [Knock it with the cane] / [用手杖把它敲出来]
                -> knock_with_cane

        * *     {reaching > 1 } [ Stand up ] / [站起来]
                I stood up once more, and brushed my coat down. / 我再次站起来，拍了拍外套。
                -> top

    *   (knock_with_cane) {reaching && TURNS_SINCE(-> reaching) >= 4 &&  Inventory ? cane } [Use the cane to reach under the bed ] / [用手杖够床底下]
        Positioning the cane above the carpet, I gave the glinting thing a sharp tap. It slid out from the under the foot of the bed. / 把手杖放在地毯上方，我用力敲了一下那个闪闪发光的东西。它从床脚底下滑了出来。
        ~ move_to_supporter( knifeState, on_floor )
        * *     (standup) [Stand up] / [站起来]
                Satisfied, I stood up, and saw I had knocked free a bloodied knife. / 满意地，我站起来，看到我敲出来的是一把带血的刀。
                -> top

        * *     [Look under the bed once more] / [再看一眼床底下]
                Moving the cane aside, I looked under the bed once more, but there was nothing more there. / 把手杖挪到一边，我又看了一眼床底下，但那里什么也没有了。
                -> standup

    *   {knifeState ? on_floor} [Pick up the knife] / [捡起刀]
        Careful not to touch the handle, I lifted the blade from the carpet. / 小心翼翼地不碰到刀柄，我从地毯上捡起了刀。
        ~ get(knife)

    *   {Inventory ? knife} [Look at the knife] / [查看刀]
        The blood was dry enough. Dry enough to show up partial prints on the hilt! / 血迹已经够干了。干到足以在刀柄上显现出部分指纹！
        ~ reach (prints_on_knife)

    *   [   The desk... ] / [书桌……]
        I turned my attention to the desk. A lamp sat in one corner, a neat, empty in-tray in the other. There was nothing else out. / 我把注意力转向书桌。一盏灯放在一个角落，一个整洁的空文件盘在另一个角落。没有别的东西在外面。
        Leaning against the desk was a wooden cane. / 靠在书桌旁的是一根木制手杖。
        ~ bedroomLightState += seen

        - - (deskstate)
        * *     (pickup_cane) {Inventory !? cane}  [Pick up the cane ] / [拿起手杖]
                ~ get(cane)
              I picked up the wooden cane. It was heavy, and unmarked. / 我拿起木制手杖。它很重，而且没有痕迹。

        * *    { bedroomLightState !? on } [Turn on the lamp] / [打开灯]
                -> operate_lamp ->

        * *     [Look at the in-tray ] / [查看文件盘]
                I regarded the in-tray, but there was nothing to be seen. Either the victim's papers were taken, or his line of work had seriously dried up. Or the in-tray was all for show. / 我审视着文件盘，但什么也看不到。要么受害者的文件被拿走了，要么他的工作已经彻底干涸了。或者那文件盘只是个摆设。

        + +     (open)  {open < 3} [Open a drawer] / [打开一个抽屉]
                I tried {a drawer at random|another drawer|a third drawer}. {Locked|Also locked|Unsurprisingly, locked as well}. / 我试了{随机一个抽屉|另一个抽屉|第三个抽屉}。{锁着的|也锁着|不出所料，也锁着}。

        * *     {deskstate >= 2} [Something else?] / [别的什么？]
                I took a step away from the desk once more. / 我再次从书桌旁退开一步。
                -> top

        - -     -> deskstate

    *     {(Inventory ? cane) && TURNS_SINCE(-> deskstate) <= 2} [Swoosh the cane] / [挥舞手杖]
        I was still holding the cane: I gave it an experimental swoosh. It was heavy indeed, though not heavy enough to be used as a bludgeon. / 我还拿着手杖：我试探性地挥了一下。它确实很重，虽然还不足以用作钝器。
        But it might have been useful in self-defence. Why hadn't the victim reached for it? Knocked it over? / 但它在自卫时可能很有用。为什么受害者没有伸手去拿它？没有把它打翻？

    *   [The window...] / [窗户……]
        I went over to the window and peered out. A dismal view of the little brook that ran down beside the house. / 我走到窗边向外张望。屋旁那条小溪的凄凉景色尽收眼底。

        - - (window_opts)
        <- compare_prints(-> window_opts)
        * *     (downy) [Look down at the brook] / [往下看小溪]
                { GlassState ? steamed:
                    Through the steamed glass I couldn't see the brook. -> see_prints_on_glass -> window_opts / 透过蒙雾的玻璃我看不到小溪。
                }
                I watched the little stream rush past for a while. The house probably had damp but otherwise, it told me nothing. / 我看了一会儿小溪奔流而过。这房子可能潮湿，但除此之外，它什么也没告诉我。
        * *     (greasy) [Look at the glass] / [看看玻璃]
                { GlassState ? steamed: -> downy }
                The glass in the window was greasy. No one had cleaned it in a while, inside or out. / 窗户玻璃油腻腻的。很久没人擦过了，里外都是。
        * *     { GlassState ? steamed && not see_prints_on_glass && downy && greasy }
                [ Look at the steam ] / [看看雾气]
                A cold day outside. Natural my breath should steam. -> see_prints_on_glass -> / 外面天冷。呼出的气自然会在玻璃上凝结成雾。
        + +     {GlassState ? steam_gone} [ Breathe on the glass ] / [朝玻璃哈气]
                I breathed gently on the glass once more. { reached (fingerprints_on_glass): The fingerprints reappeared. } / 我再次轻轻朝玻璃哈气。{ reached (fingerprints_on_glass): 指纹重新出现了。}
                ~ GlassState = steamed

        + +     [Something else?] / [别的什么？]
                { window_opts < 2 || reached (fingerprints_on_glass) || GlassState ? steamed:
                    I looked away from the dreary glass. / 我把目光从沉闷的玻璃上移开。
                    {GlassState ? steamed:
                        ~ GlassState = steam_gone
                        <> The steam from my breath faded. / 我呼出的雾气消散了。
                    }
                    -> top
                }
                I leant back from the glass. My breath had steamed up the pane a little. / 我从玻璃前退后。我的呼吸让玻璃上蒙了一层薄雾。
               ~ GlassState = steamed

        - -     -> window_opts

    *   {top >= 5} [Leave the room] / [离开房间]
        I'd seen enough. I {bedroomLightState ? on:switched off the lamp, then} turned and left the room. / 我看够了。我{bedroomLightState ? on:关掉灯，然后}转身离开了房间。
        -> joe_in_hall

    -   -> top


= operate_lamp
    I flicked the light switch. / 我按下电灯开关。
    { bedroomLightState ? on:
        <> The bulb fell dark. / 灯泡暗了下来。
        ~ bedroomLightState += off
        ~ bedroomLightState -= on
    - else:
        { bedroomLightState ? on_floor: <> A little light spilled under the bed.} { bedroomLightState ? on_desk : <> The light gleamed on the polished tabletop. } / { bedroomLightState ? on_floor: <> 些许光线洒到床下。} { bedroomLightState ? on_desk : <> 灯光在抛光的桌面上闪闪发光。}
        ~ bedroomLightState -= off
        ~ bedroomLightState += on
    }
    ->->


= compare_prints (-> backto)
    *   { between ((fingerprints_on_glass, prints_on_knife),     fingerprints_on_glass_match_knife) }
[Compare the prints on the knife and the window ] / [对比刀和窗户上的指纹]
        Holding the bloodied knife near the window, I breathed to bring out the prints once more, and compared them as best I could. / 我把带血的刀举到窗边，哈气让指纹再次显现，尽我所能地对比它们。
        Hardly scientific, but they seemed very similar - very similiar indeed. / 谈不上科学，但它们看起来非常相似——确实非常相似。
        ~ reach (fingerprints_on_glass_match_knife)
        -> backto

= see_prints_on_glass
    ~ reach (fingerprints_on_glass)
    {But I could see a few fingerprints, as though someone had pressed their palm against it.|The fingerprints were quite clear and well-formed.} They faded as I watched. / {但我能看到一些指纹，好像有人把手掌按在上面。|指纹相当清晰、完整。} 它们在我注视下渐渐消失了。
    ~ GlassState = steam_gone
    ->->

= seen_light
    *   {bedroomLightState !? on} [ Turn on lamp ] / [打开台灯]
        -> operate_lamp ->

    *   { bedroomLightState !? on_bed  && BedState ? bloodstain_visible }
        [ Move the light to the bed ] / [把灯移到床边]
        ~ move_to_supporter(bedroomLightState, on_bed)

        I moved the light over to the bloodstain and peered closely at it. It had soaked deeply into the fibres of the cotton sheet. / 我把灯移到血迹上方，仔细端详。血迹已经深深浸入棉质床单的纤维中。
        There was no doubt about it. This was where the blow had been struck. / 毫无疑问。这就是那一击发生的地方。
        ~ reach (murdered_in_bed)

    *   { bedroomLightState !? on_desk } {TURNS_SINCE(-> floorit) >= 2 }
        [ Move the light back to the desk ] / [把灯移回书桌]
        ~ move_to_supporter(bedroomLightState, on_desk)
        I moved the light back to the desk, setting it down where it had originally been. / 我把灯移回书桌，放在它原来的位置上。
    *   (floorit) { bedroomLightState !? on_floor && darkunder }
        [Move the light to the floor ] / [把灯移到地板上]
        ~ move_to_supporter(bedroomLightState, on_floor)
        I picked the light up and set it down on the floor. / 我拿起灯，把它放在地板上。
    -   -> top

=== joe_in_hall
    My police contact, Joe, was waiting in the hall. 'So?' he demanded. 'Did you find anything interesting?' / 我的警察联络人 Joe 正在大厅等候。"那么？"他问道。"发现什么有趣的东西了吗？"
- (found)
    *   {found == 1} 'Nothing.' / "什么也没有。"
        He shrugged. 'Shame.' / 他耸耸肩。"可惜。"
        -> done
    *   { Inventory ? knife } 'I found the murder weapon.' / "我找到了凶器。"
        'Good going!' Joe replied with a grin. 'We thought the murderer had gotten rid of it. I'll bag that for you now.' / "干得好！" Joe 咧嘴笑着回答。"我们以为凶手已经把它处理掉了。我现在就帮你把它装袋。"
        ~ move_to_supporter(knifeState, with_joe)

    *   {reached(prints_on_knife)} { knifeState ? with_joe }
        'There are prints on the blade[.'],' I told him. / "刀刃上有指纹[。']"我告诉他。
        He regarded them carefully. / 他仔细端详着它们。
        'Hrm. Not very complete. It'll be hard to get a match from these.' / "嗯。不太完整。很难从这些指纹中找到匹配。"
        ~ reach (joe_seen_prints_on_knife)
    *   { reached((fingerprints_on_glass_match_knife, joe_seen_prints_on_knife)) }
        'They match a set of prints on the window, too.' / "它们也和窗户上的一组指纹匹配。"
        'Anyone could have touched the window,' Joe replied thoughtfully. 'But if they're more complete, they should help us get a decent match!' / "任何人都可能碰过窗户，" Joe 若有所思地回答。"但如果它们更完整，应该能帮我们找到一个可靠的匹配！"
        ~ reach (joe_wants_better_prints)
    *   { between(body_on_bed, murdered_in_bed)}
        'The body was moved to the bed at some point[.'],' I told him. 'And then moved back to the floor.' / "尸体在某个时候被移到了床上[。']"我告诉他。"然后又移回了地板上。"
        'Why?' / "为什么？"
        * *     'I don't know.' / "我不知道。"
                Joe nods. 'All right.' / Joe 点点头。"好吧。"
        * *     'Perhaps to get something from the floor?' / "也许是为了从地板上拿什么东西？"
                'You wouldn't move a whole body for that.' / "你不会为了这个去搬动一整具尸体。"
        * *     'Perhaps he was killed in bed.' / "也许他是在床上被杀的。"
                'It's just speculation at this point,' Joe remarks. / "目前这只是猜测，" Joe 说。
    *   { reached(murdered_in_bed) }
        'The victim was murdered in bed, and then the body was moved to the floor.' / "受害者是在床上被谋杀的，然后尸体被移到了地板上。"
        'Why?' / "为什么？"
        * *     'I don't know.' / "我不知道。"
                Joe nods. 'All right, then.' / Joe 点点头。"好吧，那么。"
        * *     'Perhaps the murderer wanted to mislead us.' / "也许凶手想误导我们。"
                'How so?' / "怎么说？"
            * * *   'They wanted us to think the victim was awake[.'], I replied thoughtfully. 'That they were meeting their attacker, rather than being stabbed in their sleep.' / "他们想让我们以为受害者是醒着的[。']"我若有所思地回答。"以为他们是在见袭击者，而不是在睡梦中被刺。"
            * * *   'They wanted us to think there was some kind of struggle[.'],' I replied. 'That the victim wasn't simply stabbed in their sleep.' / "他们想让我们以为发生了某种搏斗[。']"我回答。"以为受害者不是简单地在睡梦中被刺。"
            - - -   'But if they were killed in bed, that's most likely what happened. Stabbed, while sleeping.' / "但如果他们是在床上被杀的，那很可能就是这样发生的。在睡觉时被刺。"
                    ~ reach (murdered_while_asleep)
        * *     'Perhaps the murderer hoped to clean up the scene.' / "也许凶手想清理现场。"
                'But they were disturbed? It's possible.' / "但他们被打断了？有可能。"

    *   { found > 1} 'That's it.' / "就这些。"
        'All right. It's a start,' Joe replied. / "好吧。这是个开始，" Joe 回答。
        -> done
    -   -> found
-   (done)
    {
    - between(joe_wants_better_prints, joe_got_better_prints):
        ~ reach (joe_got_better_prints)
        <> 'I'll get those prints from the window now.' / "我现在就去取窗户上的那些指纹。"
    - reached(joe_seen_prints_on_knife):
        <> 'I'll run those prints as best I can.' / "我会尽我所能去比对那些指纹。"
    - else:
        <> 'Not much to go on.' / "没有太多线索可以跟进。"
    }
    -> END
