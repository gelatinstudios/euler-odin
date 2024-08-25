
package euler

import "core:os"
import "core:strconv"
import "core:fmt"
import "core:math"
import "core:path/filepath"
import "core:unicode"
import ba "core:container/bit_array"

// 0 = prime, 1 = NOT prime
prime_sieve :: proc(n: int) -> (result: ba.Bit_Array) {
    ba.set(&result, 0)
    ba.set(&result, 1)

    for i := 3; i <= n/i; i += 2 {
        if !ba.get(&result, i) {
            for j := i*i; j <= n; j += i {
                ba.set(&result, j)
            }
        }
    }

    return result
}

problems := []proc() {
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
    }

    9 = proc() {
        
    }
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