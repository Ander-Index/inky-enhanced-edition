/*

    A system for assigning, reading and altering integer values to list items.  / 一个用于为列表项赋值、读取和修改整数值的系统。

    This means you can assign variable runtimes scores to things, such as a quantity to an inventory item, or a value to a player statistic. / 这意味着你可以为事物分配可变的运行时数值，比如物品栏中某物品的数量，或玩家某项属性的值。

*/


LIST Wallet = Coins, Notes, Cards

~ _setValueOfState(Coins, 3) // the player has 3 coins / 玩家有3个硬币
~ _setValueOfState(Cards, 2) // the player has 2 cards / 玩家有2张卡片

I have {_getValueOfState(Coins)} coins and {_getValueOfState(Cards)} cards right now. / 我现在有{_getValueOfState(Coins)}个硬币和{_getValueOfState(Cards)}张卡片。

~ _alterValueForState(Coins, 10)

Now I have {_getValueOfState(Coins)}. / 现在我有{_getValueOfState(Coins)}个。

~ _alterValueForState(Cards, 30)
~ _alterValueForState(Cards, -60)

Now I have {_getValueOfState(Cards)}. Yikes! / 现在我有{_getValueOfState(Cards)}张。哎呀！

-> END



// 1) Storage space  / 1) 存储空间
VAR StatesNegative = () // record which states are currently holding negative values / 记录当前哪些状态持有负值
VAR StatesBinary1 = ()
VAR StatesBinary2 = ()
VAR StatesBinary4 = ()
VAR StatesBinary8 = ()
VAR StatesBinary16 = ()
VAR StatesBinary32 = ()
VAR StatesBinary64 = ()
VAR StatesBinary128 = ()
VAR StatesBinary256 = ()
VAR StatesBinary512 = ()
VAR StatesBinary1024 = ()
VAR StatesBinary2048 = ()   // storage up to 4095, but you can keep going by adding more states / 存储上限为4095，但你可以通过添加更多状态继续扩展
// --> ADDITIONAL STORAGE GOES HERE / --> 额外存储空间在此添加

CONST MAX_BINARY_BIT = 2048

VAR StatesInStorage = ()


// 2) Get value for state being set / 2) 获取待设置状态的值


=== function _getValueOfState(id) // always single / 始终为单值
    // do this the dumb long way rather than a fancy loop / 用笨办法长写，而非花哨的循环
    ~ temp value = 0
    ~ value += (StatesBinary1 ? id) * 1
    ~ value += (StatesBinary2 ? id) * 2
    ~ value += (StatesBinary4 ? id) * 4
    ~ value += (StatesBinary8 ? id) * 8
    ~ value += (StatesBinary16 ? id) * 16
    ~ value += (StatesBinary32 ? id) * 32
    ~ value += (StatesBinary64 ? id) * 64
    ~ value += (StatesBinary128 ? id) * 128
    ~ value += (StatesBinary256 ? id) * 256
    ~ value += (StatesBinary512 ? id) * 512
    ~ value += (StatesBinary1024 ? id) * 1024
    ~ value += (StatesBinary2048 ? id) * 2048
// --> ADDITIONAL STORAGE GOES HERE / --> 额外存储空间在此添加
    { StatesNegative ? id:
            ~ value = value * -1
    }
    ~ return value


// 3) Set value for state being set / 3) 设置待设置状态的值

=== function _setValueOfState(state, value) // always single / 始终为单值
    { value >= 2 * MAX_BINARY_BIT || value <= -2 * MAX_BINARY_BIT:
        [ ERROR - trying to store a value of {value} for {state}, which is outside of the space provided. Please increase {MAX_BINARY_BIT}, and supply additional storage values. / 错误 - 尝试为 {state} 存储值 {value}，超出了提供的空间。请增大 {MAX_BINARY_BIT} 并提供额外的存储值。 ]
    }
    ~ temp currentValue = _getValueOfState(state)
    { currentValue != 0 && currentValue != value:
         ~ _removeValuesForState(state)
    }
    { value != 0:
        ~ StatesInStorage += state
        { value < 0:
            ~ StatesNegative += state
            ~ value = -1 * value         // store the value as a positive / 将值存储为正数
        - else:
            ~ StatesNegative -= state
        }
        ~ _setBinaryValuesForState(state, value, MAX_BINARY_BIT )
    }
    // uncomment the following for test logging / 取消注释以下行以启用测试日志
    // [ {value} - set value for {state} to {getValueOfState(state) } ] / [ {value} - 将 {state} 的值设置为 {getValueOfState(state) } ]


=== function _setBinaryValuesForState(id, value, binaryValue)
    { value >= binaryValue:
        ~ value -= binaryValue
        {binaryValue:
        -  1:   ~ StatesBinary1 += id
        -  2:   ~ StatesBinary2 += id
        -  4:   ~ StatesBinary4 += id
        -  8:   ~ StatesBinary8 += id
        -  16:   ~ StatesBinary16 += id
        -  32:   ~ StatesBinary32 += id
        -  64:   ~ StatesBinary64 += id
        -  128:   ~ StatesBinary128 += id
        -  256:   ~ StatesBinary256 += id
        -  512:   ~ StatesBinary512 += id
        -  1024:   ~ StatesBinary1024 += id
        -  2048:   ~ StatesBinary2048 += id
        }
// --> ADDITIONAL STORAGE LINES GO HERE / --> 额外存储行在此添加
    }
    { binaryValue > 1:
        ~ _setBinaryValuesForState(id, value, binaryValue / 2)
    }


// 3) Removal / 3) 移除

=== function _removeValuesForState(state)
    ~ StatesInStorage -= state
    ~ StatesNegative -= state
    ~ StatesBinary1 -= state
    ~ StatesBinary2 -= state
    ~ StatesBinary4 -= state
    ~ StatesBinary8 -= state
    ~ StatesBinary16 -= state
    ~ StatesBinary32 -= state
    ~ StatesBinary64 -= state
    ~ StatesBinary128 -= state
    ~ StatesBinary256 -= state
    ~ StatesBinary512 -= state
    ~ StatesBinary1024 -= state
    ~ StatesBinary2048 -= state

// 4) alter the value for a state / 4) 修改状态的值

=== function _alterValueForState(state, delta)
    ~ _setValueOfState(state, _getValueOfState(state) + delta)
