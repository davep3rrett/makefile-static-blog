---
title: Reading about hash functions
date: 26 May 2019 15:18:05 EST
---
## Reading about hash functions

I've finally started to feel ready to follow up on one of the promises in [this post](2018-08-16-c-hashtable-vim-preamble.html) and get going with my project of implementing a hashtable data structure from scratch.

As I had gleaned earlier from my initial searches on the topic, a really important part of a hashmap is having a good ***hash function***.

There's an important distinction between cryptographic hash functions used for encryption / privacy / security etc. and the noncryptographic hash functions used in hashtables. Their goals are different.

One of the main requirements of a hash function used in a hashtable is for it to have a _uniform distribution_ of hash values. Since you ideally want collisions (multiple inputs hashing to the same value) to be low or non-existent, having as close to a uniform distribution as possible is really important so certain inputs won't have a higher likelihood of colliding than others.

A common strategy for dealing with collisions is to keep a linked list at the slot of a particular hash value, which contains all keys that hash to that value. It is therefore in the interest of performance for the linked lists to be kept short.

### Who's who in the world of hash functions

When I started I didn't know anything about hash functions, and articles I would read about hashtables would say things like "It's important to choose a good hash function." and then move on.

Who's coming up with these hash functions?! Are they all figured out and canonically listed out in a textbook somewhere? What's the deal?

After further searching I found [this hash function](http://www.azillionmonkeys.com/qed/hash.html) by Paul Hsieh linked in [this SO answer](https://stackoverflow.com/a/746727).

In Paul's notes about benchmarking performed for his hash function, I saw the name [Bob Jenkins](https://burtleburtle.net/bob/) come up a couple times. It seems he is "the guy" in this particular field, and has himself created a set of widely used noncryptographic hash functions called [lookup3](https://burtleburtle.net/bob/c/lookup3.c).

An interesting takeaway is that the field of hash functions seems to be a somewhat living field, where discoveries are still sometimes made, like prime number research or something. This contradicts the notion I held going in, that hash functions are a "solved" computer science problem immortalized in textbooks.

### Why was it so hard for me to find out about this?
I may have just been searching wrong, but it really took me a while to find information about specific hash functions, how they are created, and who creates them. I found an interesting albeit slightly paranoid blog post, which supported my feeling of _"Why does it seem like this stuff is intentionally being kept secret?"_ on a bioinformatics blog, titled [Why Computer Science Professors Dislike Hash Functions](https://homolog.us/blogs/bioinfo/2013/05/06/why-computer-science-professors-dislike-hash-functions/). I won't try to paraphrase the arguments here, but check it out if you're interested.

### Next steps
The reason I started searching for specifics on hash functions in the first place is that I was hoping to find a relatively simple "beginner" hash function - maybe in pseudocode so I could implement myself in C, or just finding something written in C would be fine too.

Both Hsieh's SuperFastHash and Bob Jenkins' hashes are much more complicated than what I was ready for. However, on Jenkins' site, in his [discussion of hash functions for hash table lookup](https://burtleburtle.net/bob/hash/index.html#lookup), he provides the following:

> The standard reference for this is Knuth's "The Art of Computer Programming", volume 3 "Sorting and Searching", chapter 6.4. He recommends the hash

```
for (hash=len; len--;)
   {
     hash = ((hash<<5)^(hash>>27))^*key++;
   }
   hash = hash % prime;
```

This is the "rotating hash", which gets elucidated further in Bob's other writings:

```
ub4 rotating(char *key, ub4 len, ub4 prime)
{
  ub4 hash, i;
  for (hash=len, i=0; i<len; ++i)
    hash = (hash<<4)^(hash>>28)^key[i];
  return (hash % prime);
}
```

> This takes 8n+3 instructions. This is the same as the additive hash, except it has a mixing step (a circular shift by 4) and the combining step is exclusive-or instead of addition. The table size is a prime, but the prime can be any size.

> On machines with a rotate (such as the Intel x86 line) this is 6n+2 instructions. I have seen the `(hash % prime)` replaced with

```
hash = (hash ^ (hash>>10) ^ (hash>>20)) & mask;
```

> eliminating the % and allowing the table size to be a power of 2, making this 6n+6 instructions. % can be very slow, for example it is 230 times slower than addition on a Sparc 20. 

Also, here is a more in-depth article on hash functions written by Bob Jenkins: [https://burtleburtle.net/bob/hash/doobs.html](https://burtleburtle.net/bob/hash/doobs.html).

This level of analysis, math, and facility with machine instructions is all pretty over my head, but at any rate the Knuth stuff feels like a logical starting point / reference for a relatively simple hash function, although Bob warns that the rotating hash only provides "mediocre" results. I would probably want to use a more modern hash function in a production / "real world" use case, but at this point I'm still just trying to figure out what the heck is going on.

### Update 2019-05-27

I went to check out The Art of Computer Proramming Vol. 3 - which I have admittedly not delved into before - to try and gain some context on the code snippet above. I didn't realize that all of Knuth's code samples are written in [MIX](https://en.wikipedia.org/wiki/MIX) Assembly, an assembly language for a hypothetical computer that he invented. So that's going to take some brushing up on my part &#x1F605;

But I found [this explainer](https://stackoverflow.com/questions/11871245/knuth-multiplicative-hash) on SO of the multiplicative hash that is also outlined in chapter 6.4, and decided to take that function for a spin.

I also took the time to initialize my Git repo that will ultimately house my hashtable project. You can find it hosted [here](https://git.sr.ht/~davep3rrett/hash-table) on the very cool [Sourcehut](https://sourcehut.org/), which I will maybe write more about my experience with in future posts!

