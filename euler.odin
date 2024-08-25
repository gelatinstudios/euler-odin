
package euler

import "core:os"
import "core:strconv"
import "core:fmt"
import "core:math"
import "core:strings"
import "core:path/filepath"
import "core:unicode"
import ba "core:container/bit_array"

prime_sieve :: proc(n: int) -> (result: ba.Bit_Array) {
    for i in 0..<n {
        ba.set(&result, i)
    }

    ba.unset(&result, 0)
    ba.unset(&result, 1)

    for i := 4; i < n; i += 2 {
        ba.unset(&result, i)
    }

    for i := 3; i <= n/i; i += 2 {
        if ba.get(&result, i) {
            for j := i*i; j <= n; j += i {
                ba.unset(&result, j)
            }
        }
    }

    return result
}

problems := [?]proc() {
    0 = {},

    1 = proc() {
        sum := 0
        for n in 1..<1000 {
            if n%3==0 || n%5==0 {
                sum += n
            }
        }
        fmt.println(sum)
    },

    2 = proc() {
        a := 0
        b := 1
        c := 1

        sum := 0

        for c < 4_000_000 {
            a = b
            b = c
            c = a + b

            if c%2==0 {
                sum += c
            }
        }

        fmt.println(sum)
    },

    3 = proc() {
        N :: 600851475143
    
        result := 0 
        div := 2
        for n := N; n > 1; {
            for n % div == 0 {
                result = max(result, div)
                 n /= div
            }
            div += 1
        }

        fmt.println(result)
    },

    4 = proc() {
        get_digit :: proc(n, digit: int) -> int {
            @(static, rodata) pow10_tab := [?]int{
                1e00, 1e01, 1e02, 1e03, 1e04, 1e05, 1e06, 1e07, 1e08, 1e09,
                1e10, 1e11, 1e12, 1e13, 1e14, 1e15, 1e16,
            }
            return (n / pow10_tab[digit]) % 10
        }
        is_palindrome :: proc(n: int) -> bool {
            digit_count := math.count_digits_of_base(n, 10)
            l := 0
            h := digit_count-1
            for l <= h {
                if get_digit(n, l) != get_digit(n, h) {
                    return false
                }
                l += 1
                h -= 1
            }
            return true
        }

        result: int
        for n in 100..=999 {
            for m in 100..=999 {
                p := n*m
                if is_palindrome(p) {
                    result = max(result, p)
                }
            }
        }

        fmt.println(result)
    },

    5 = proc() {
        result := 1
        for n in 1..=20 {
            result = math.lcm(result, n)
        }
        fmt.println(result)
    },

    6 = proc() {
        a, b: int
        for n in 1..=100 {
            a += n*n
            b += n
        }
        b *= b
        fmt.println(b-a)
    },

    7 = proc() {
        primes: [1<<14]int
        prime_count := 0

        primes[prime_count] = 2
        prime_count += 1

        for n := 3; ; n += 1{
            is_prime := true
            for p in primes[:prime_count] {
                if n % p == 0 {
                    is_prime = false
                    break
                }
            }

            if is_prime {
                primes[prime_count] = n
                prime_count += 1

                if prime_count == 10001 {
                    fmt.println(n)
                    break
                }
            }
        }
    },

    8 = proc() {
        input :: `73167176531330624919225119674426574742355349194934
                  96983520312774506326239578318016984801869478851843
                  85861560789112949495459501737958331952853208805511
                  12540698747158523863050715693290963295227443043557
                  66896648950445244523161731856403098711121722383113
                  62229893423380308135336276614282806444486645238749
                  30358907296290491560440772390713810515859307960866
                  70172427121883998797908792274921901699720888093776
                  65727333001053367881220235421809751254540594752243
                  52584907711670556013604839586446706324415722155397
                  53697817977846174064955149290862569321978468622482
                  83972241375657056057490261407972968652414535100474
                  82166370484403199890008895243450658541227588666881
                  16427171479924442928230863465674813919123162824586
                  17866458359124566529476545682848912883142607690042
                  24219022671055626321111109370544217506941658960408
                  07198403850962455444362981230987879927244284909188
                  84580156166097919133875499200524063689912560717606
                  05886116467109405077541002256983155200055935729725
                  71636269561882670428252483600823257530420752963450`

        nums: [dynamic]int

        for c in input {
            if unicode.is_digit(c) do append(&nums, int(c-'0'))
        }

        N :: 13

        result: int
        for i := 0; i + N < len(nums); i += 1 {
            p := 1
            for j in 0..<N {
                p *= nums[i+j]
            }
            result = max(p, result)
        }

        fmt.println(result)
    },

    9 = proc() {
        for a in 1..=1000 {
            for b in 1..=1000-a {
                for c in 1..=1000-a-b {
                    if a+b+c == 1000 && a*a + b*b == c*c {
                        fmt.println(a*b*c)
                        return
                    }
                }
            }
        }
    },

    10 = proc() {
        sieve := prime_sieve(2_000_000)

        sum := 0

        it := ba.make_iterator(&sieve)
        for n in ba.iterate_by_set(&it) {
            sum += n
        }

        fmt.println(sum)
    },

    11 = proc() {
        input ::   `08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08
                    49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00
                    81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65
                    52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91
                    22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80
                    24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50
                    32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70
                    67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21
                    24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72
                    21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95
                    78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92
                    16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57
                    86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58
                    19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40
                    04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66
                    88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69
                    04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36
                    20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16
                    20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54
                    01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48`

        nums: [20][20]int

        it := input
        for &line in nums {
            for &n in line {
                n_str, _ := strings.fields_iterator(&it)
                n, _ = strconv.parse_int(n_str)
            }
        }

        prod4 :: proc(nums: [20][20]int, x, y, dx, dy: int) -> int {
            x := x
            y := y

            result := 1
            for _ in 0..<4 {
                n := 1
                if x >= 0 && x < len(nums[0]) && 
                   y >= 0 && y < len(nums) 
                {
                    #no_bounds_check {
                        n = nums[y][x]
                    }
                }
                result *= n
                x += dx
                y += dy
            } 
            return result
        }

        result: int
        for _, y in nums {
            for _, x in nums[y] {
                result = max(result, prod4(nums, x, y, 1, 0))
                result = max(result, prod4(nums, x, y, 0, 1))
                result = max(result, prod4(nums, x, y, 1, 1))
                result = max(result, prod4(nums, x, y, 1,-1))
            }
        }

        fmt.println(result)
    },

    12 = {}
}

main :: proc() {
    usage :: proc() {
        exe := filepath.base(os.args[0])
        fmt.printfln("usage: {} NUM", exe)
        fmt.println ("    NUM - euler problem")
        fmt.println ("          must be int from 1 to", len(problems)-1)
        os.exit(0)
    }

    if len(os.args) != 2 {
        usage()
    }

    index, ok := strconv.parse_int(os.args[1])

    if !ok || index <= 0 || index >= len(problems) {
        usage()
    }
    
    problem := problems[index]

    if problem == nil {
        fmt.eprintln(index, "has not been solved yet :(")
        return
    }

    problem()
}