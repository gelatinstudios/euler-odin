
package euler

import "core:os"
import "core:strconv"
import "core:fmt"
import "core:math"
import "core:path/filepath"
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