---
title: "More C: Treating an array of chars as an int"
date: 02 Jun 2019 14:41 EST
---

## More C: Treating an array of chars as an int

In Exercise 9 (Arrays & Strings) of [Learn C The Hard Way](https://learncodethehardway.org/c/) Zed poses a cool extra credit question:

> If an array of characters is 4 bytes long, and an int is 4 bytes long, then can you treat the whole `name` array like it's just an integer? How might you accomplish this crazy hack?

My first thought that it would be as simple as defining a `char[]` array and then just `printf()`-ing it using a `%d` format specifier.

This first attempt compiled, but the result of `printf()` was different each time I ran my program, so no dice.

I decided to search the question, and [this SO answer](https://stackoverflow.com/questions/23001591/treating-a-character-array-as-an-integer-learn-c-the-hard-way-extra-credit) showed me the crucial step I was missing: use an integer pointer to point to the memory address of the character array.

I haven't gotten to the pointers chapter in LCTHW yet, and I do remember pointers a little bit from my first couple semesters doing C++ at Brooklyn College, but it's been a while.

So I reworked my original attempt and came up with the below code. (I did make a test program that printed out the result of `sizeof (int)` and confirmed that `int`s are 4 bytes on my system, but I decided to use `uint32_t` in my code anyway, to be explicit about the need for 4 bytes and to make my code more portable).

```c
#include <stdio.h>
#include <stdint.h>

// https://stackoverflow.com/questions/23001591/treating-a-character-array-as-an-integer-learn-c-the-hard-way-extra-credit

int main(int argc, char *argv[])
{
	/*
	 * ASCII values: '@' == 64, 'A' == 65
	 *
	 * If we're dealing with a big-endian int representation, the
	 * below should be represented as 1094729792.
	 * (65 << 24) + (64 << 16) + (64 << 8) + 64
	 *
	 * In little endian, it would be 1077952577.
	 * (64 << 24) + (64 << 16) + (64 << 8) + 65
	 *
	 */
	char myArr[4] = {'@', '@', '@', 'A'};

	// Point an int pointer at the memory address of myArr
	uint32_t *myIntPtr = &myArr;

	printf("myArr: %c, %c, %c, %c\n", myArr[0], myArr[1], myArr[2], myArr[3]);

	printf("myInt: %d\n", *myIntPtr);

	return 0;
}
```

Pretty cool! That's it! Thanks for reading, see you next time :~}
