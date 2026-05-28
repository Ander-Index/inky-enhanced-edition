/*
    Converts a number between -1,000,000,000 and 1,000,000,000 into its printed (integer) equivalent. / 将 -1,000,000,000 到 1,000,000,000 之间的数字转换为对应的英文（整数）表达。

    Usage: / 用法：

    There are {print_number(RANDOM(100000,10000000))} stars in the sky. / 天上有 {print_number(RANDOM(100000,10000000))} 颗星星。

    Pi is roughly {print_number(3.1417)}. / 圆周率大约是 {print_number(3.1417)}。

*/

=== function print_number(x)
~ x = INT(x) // cast to an int, since this function can only handle ints! / 转换为整数，因为此函数只能处理整数！
{
    - x >= 1000000:
        ~ temp k = x mod 1000000
        {print_number((x - k) / 1000000)} million / 百万{ k > 0:{k < 100: and / 和 |{x mod 100 != 0:<>,}} {print_number(k)}}
    - x >= 1000:
        ~ temp y = x mod 1000
        {print_number((x - y) / 1000)} thousand / 千{ y > 0:{y < 100: and / 和 |{x mod 100 != 0:<>,}} {print_number(y)}}
    - x >= 100:
        ~ temp z = x mod 100
        {print_number((x - z) / 100)} hundred / 百 {z > 0:and / 和 {print_number(z)}}
    - x == 0:
        zero / 零
    - x < 0:
        minus / 负 {print_number(-1 * x)}
    - else:
        { x >= 20:
            { x / 10:
                - 2: twenty / 二十
                - 3: thirty / 三十
                - 4: forty / 四十
                - 5: fifty / 五十
                - 6: sixty / 六十
                - 7: seventy / 七十
                - 8: eighty / 八十
                - 9: ninety / 九十
            }
            { x mod 10 > 0:
                <>-<>
            }
        }
        { x < 10 || x > 20:
            { x mod 10:
                - 1: one / 一
                - 2: two / 二
                - 3: three / 三
                - 4: four / 四
                - 5: five / 五
                - 6: six / 六
                - 7: seven / 七
                - 8: eight / 八
                - 9: nine / 九
            }
        - else:
            { x:
                - 10: ten / 十
                - 11: eleven / 十一
                - 12: twelve / 十二
                - 13: thirteen / 十三
                - 14: fourteen / 十四
                - 15: fifteen / 十五
                - 16: sixteen / 十六
                - 17: seventeen / 十七
                - 18: eighteen / 十八
                - 19: nineteen / 十九
            }
        }
}
