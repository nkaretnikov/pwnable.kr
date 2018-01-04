set follow-exec-mode new

b *0x080485FE 
commands
echo ">: move right\n"
end

b *0x0804860D
commands
echo "<: move_left\n"
end

b *0x804861C
commands
echo "+: increment\n"
end


b *0x804862B
commands
echo "-: decrement\n"
end

b *0x0804863A
commands
echo ".: output\n"
end

b *0x804864F
commands
echo ",: input\n"
end

b *0x804865E
commands
echo "[: left_bracket\n"
end

b *0x804866B
commands
echo "default: ignored, return result\n"
end

# r < <(cat in | tee in1.log | ./solution.py libc-2.23.so "in" | tee in2.log) > >(tee out1.log | ./solution.py libc-2.23.so "out" | tee out2.log  > in)
