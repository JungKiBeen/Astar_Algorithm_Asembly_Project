
.data
space: .asciiz "	"
line: .asciiz "\n"
goal: .asciiz "Goal"
info: .asciiz "Travel							dist"

#next
next	: .space 108 

#Travel[7]
Travel	: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14

#path P_pq[1000];
P_pq	: .space 108000

#path P_pq_index[1000];
P_pq_index : .space 4000

#int current;
current	: .word	1

#int now;
now		: .word 1	

#path Sholtest ( 0 [0] 8 [1] 16 [2] 24 [3] 32 [4] 40 [5] 48 [6] 56 cost 64 distant 72 current 76 size 80... list[7]...108)
Sholtest : .space 108

	.text							# begin 	
				
	.globl main

main:	addi	$sp, $sp, -8		# Make room for 2 words on the stack.
		sw	$s0, 0($sp)					# Preserve $s0 in the first slot.	
		sw	$ra, 4($sp)					# Preserve $ra in the second slot.
		
		 li $v0, 4
		 la $a0, info
		 syscall

		 li $v0, 4
		 la $a0, line
		 syscall
		  li $v0, 4
		 la $a0, line
		 syscall

		la $t0, current
		sw $zero, 0($t0)
		
		la $t0, now
		sw $zero, 0($t0)

		
		li  $t1, 5
		li  $t2, 5

		la  $t0, Travel

		sw  $t1, 0($t0)
		sw  $t2, 4($t0)

		li  $t1, 2
		li  $t2, 3
		sw  $t1, 8($t0)
		sw  $t2, 12($t0)

		li  $t1, 8
		li  $t2, 4
		sw  $t1, 16($t0)
		sw  $t2, 20($t0)

		li  $t1, 7
		li  $t2, 2
		sw  $t1, 24($t0)
		sw  $t2, 28($t0)

		li  $t1, 1
		li  $t2, 6
		sw  $t1, 32($t0)
		sw  $t2, 36($t0)

		li  $t1, 9
		li  $t2, 6
		sw  $t1, 40($t0)
		sw  $t2, 44($t0)

		li  $t1, 3
		li  $t2, 2
		sw  $t1, 48($t0)
		sw  $t2, 52($t0)		
		
		# Travel initializing 
		


		la	$t0, Sholtest

		li $t1, 0
		mtc1.d $t1, $f0
  		cvt.d.w $f0, $f0	# $f0 = 0

		s.d $f0, 72($t0)	# Sholtest.curret = 0
		s.d $f0, 64($t0)	# Sholtest.distant = 0
		s.d $f0, 0($t0)	# Sholtest.city[0] = 0
		
		li.d $f0, 1.41421	# Sholtest.city[1] = 1.41421
		s.d $f0, 8($t0)

		li.d $f0, 2.23607	# Sholtest.city[2] = 2.23607
		s.d $f0, 16($t0)

		li.d $f0, 2.23607	# Sholtest.city[3] = 2.23607
		s.d $f0, 24($t0)

		li.d $f0, 3.16228	# Sholtest.city[4] = 3.16228
		s.d $f0, 32($t0)

		li.d $f0, 2.23607	# Sholtest.city[5] = 2.23607
		s.d $f0, 40($t0)

		li.d $f0, 1.41421	# Sholtest.city[6] = 1.41421
		s.d $f0, 48($t0)

		sw	$zero, 80($t0)	# Sholtest.list[0] = 0

		li	$t1, -1
		sw	$t1, 84($t0)	# Sholtest.list[1] = -1
		sw	$t1, 88($t0)	# Sholtest.list[2] = -1
		sw	$t1, 92($t0)	# Sholtest.list[3] = -1
		sw	$t1, 96($t0)	# Sholtest.list[4] = -1
		sw	$t1, 100($t0)	# Sholtest.list[5] = -1
		sw	$t1, 104($t0)	# Sholtest.list[6] = -1
		
		li	$t1, 1
		sw	$t1, 76($t0)	# Sholtest.size = 1


		# Sholtest initializing

		la $a0, Sholtest

		addi $sp, $sp, -4
		sw $ra, 0($sp)


		jal ppq_push
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		addi $sp, $sp, -4
		sw $ra, 0($sp)

		move $a1, $a0

		jal A_star

		lw $ra, 0($sp)
		addi $sp, $sp, 4
		

		lw	$s0, 0($sp)					# recovery 
		lw	$ra, 4($sp)					
		addi $sp, $sp, 8			

		jr $ra
	


	.globl ppq_push
# parameter  $a0(adress of path k)
# result is none

ppq_push: 
			la $t0, P_pq		# P_pq[0]
			li $t2,	108			# index
			la $t3, current
			lw $t4, 0($t3)
			mul $t2, $t2, $t4   # index * current
			add $t0, $t0, $t2 

			l.d $f0, 0($a0)		# k.city[0]
			l.d $f2, 8($a0)		# k.city[1]
			
			s.d $f0, 0($t0)		# P_pq.city[0] = k.city[0]
			s.d $f2, 8($t0)		# P_pq.city[1] = k.city[1]
			
			l.d $f0, 16($a0)		# k.city[2]
			l.d $f2, 24($a0)		# k.city[3]
			
			s.d $f0, 16($t0)		# P_pq.city[2] = k.city[2]
			s.d $f2, 24($t0)		# P_pq.city[3] = k.city[3]

			l.d $f0, 32($a0)		# k.city[4]
			l.d $f2, 40($a0)		# k.city[5]
			
			s.d $f0, 32($t0)		# P_pq.city[4] = k.city[4]
			s.d $f2, 40($t0)		# P_pq.city[5] = k.city[5]

			l.d $f0, 48($a0)		# k.city[6]
			s.d $f0, 48($t0)		# P_pq.city[6] = k.city[6]
		
			l.d $f0, 56($a0)		# k.cost
			s.d $f0, 56($t0)		# P_pq.cost = k.cost

			l.d $f0, 64($a0)		# k.distant
			s.d $f0, 64($t0)		# P_pq.distant = k.distant

			lw $t3, 72($a0)			# k.current
			sw $t3, 72($t0)			# P_pq.current = k.current

			lw $t3, 76($a0)			# k.size
			sw $t3, 76($t0)			# P_pq.size = k.size

			lw $t3, 80($a0)			# k.list
			sw $t3, 80($t0)			# P_pq.list = k.list

			lw $t3, 84($a0)			# k.list
			sw $t3, 84($t0)			# P_pq.list = k.list

			lw $t3, 88($a0)			# k.list
			sw $t3, 88($t0)			# P_pq.list = k.list

			lw $t3, 92($a0)			# k.list
			sw $t3, 92($t0)			# P_pq.list = k.list

			lw $t3, 96($a0)			# k.list
			sw $t3, 96($t0)			# P_pq.list = k.list

			lw $t3, 100($a0)		# k.list
			sw $t3, 100($t0)		# P_pq.list = k.list

			lw $t3, 104($a0)		# k.list
			sw $t3, 104($t0)		# P_pq.list = k.list
		
			la $t1, P_pq_index	# load P_pq_index
			sll $t3, $t4, 2		# current*4
			add $t1, $t1, $t3	# &P_pq_index[current]
			sw  $t0, 0($t1)		# P_pq_index[current] = &P_pq[current]
		
			la $t1, current 
			lw $t3, 0($t1)
			addi, $t3, $t3, 1
			sw $t3, 0($t1)


			 
			la $t0, current		
			lw $t1, 0($t0)		# $t1 = current  .. i=current
			addi $t1, $t1, -1	# i = current - 1

			la $t3, now

			lw $t6, ($t3)
	
			li $s4, 1

loop_ppq_push:
			slt $t3, $t6, $t1 
			bne $t3, $s4, exit_loop_ppq_push
			
			la $t0, P_pq_index
			sll $t3, $t1, 2		# i*4

			add $t0, $t0, $t3	# &P_pq_index[i]
			addi $t0, $t0, -4	# &P_pq_index[i-1]
			
			lw	$t2, 0($t0)		# P_pq_index[i-1]
			lw	$t4, 4($t0)		# P_pq_index[i]

		
			addi $t3, $t2, 56   # P_pq_index[i-1]->cost
			addi $t5, $t4, 56   # P_pq_index[i]->cost
			
			ldc1 $f0, 0($t3)
			ldc1 $f2, 0($t5)    
			 
			c.lt.d $f2, $f0
			bc1f exit_if_ppq_push 
	
			sw $t2, 4($t0)
			sw $t4, 0($t0)

exit_if_ppq_push:
			addi $t1, $t1, -1 
			j loop_ppq_push

exit_loop_ppq_push:

			jr $ra


				.globl sqrt

# parameter ; double a
# result is $f0, input is in $f2

sqrt:		addi $sp, $sp, -4
			sw $ra, 0($sp)		
			
			li $t0, 1
			mtc1.d $t0, $f0
  			cvt.d.w $f0, $f0
			
			move $s0, $zero 			# i = 0


forsqrt:	slti $t0, $s0, 10			# $t0 = 0 if i >= 10
			beq $t0, $zero, exitsqrt 		

			div.d $f6, $f2, $f0	# $f6 = input / x
			add.d $f6, $f6, $f0		# $f6 = x + (input / x)
		
			li $t1, 2
			mtc1.d $t1, $f8
  			cvt.d.w $f8, $f8			# $f8 = 2
			div.d $f0, $f6, $f8			# $f0 = x + (input / x) / 2	
		
			addi $s0, $s0, 1			# i = i + 1
			j forsqrt
exitsqrt:	
			lw $ra, 0($sp)	
			addi $sp, $sp, 4
			jr $ra



			
	.globl dist
# parameter  $a0(adress of city a), $a2(adress of city b)
# result is $f0

dist :  
		addi $sp, $sp, -4
		sw $ra, 0($sp)	
			
		lw $t0, 0($a0)		# a.x
		lw $t1, 4($a0)		# a.y
		lw $t2, 0($a2)		# b.x
		lw $t3, 4($a2)		# b.y

		sub $t4, $t0, $t2	# a.x-b.x
		sub $t7, $t1, $t3	# a.y-b.y

		mul $t5, $t4, $t4	# (a.x-b.x)*(a.x-b.x)
		mul $t6, $t7, $t7	# (a.y-b.y)*(a.y-b.y)
		add $t7, $t5, $t6	# (a.y-b.y)*(a.y-b.y) + (a.x-b.x)*(a.x-b.x)
		
		mtc1 $t7, $f0
		cvt.d.w $f2, $f0

		jal sqrt

		lw $ra, 0($sp)	
		addi $sp, $sp, 4

		jr $ra

	.globl A_star
# parameter  $a1(adress of path a)
# result is Printed

A_star : 
		 lw $t0, 80($a1)	#	a.list[0]
		 lw $t1, 84($a1)	#	a.list[1]  
		 lw $t2, 88($a1)	#	a.list[2]
		 lw $t3, 92($a1)	#	a.list[3]  
		 lw $t4, 96($a1)	#	a.list[4]
		 lw $t5, 100($a1)	#	a.list[5]  
		 lw $t6, 104($a1)	#	a.list[6]  
		 
		 addi $t0, $t0, 1
		 addi $t1, $t1, 1
		 addi $t2, $t2, 1
		 addi $t3, $t3, 1
		 addi $t4, $t4, 1
		 addi $t5, $t5, 1
		 addi $t6, $t6, 1




		 li $v0, 1
		 move $a0, $t0
		 syscall

		 li $v0, 4
		 la $a0, space
		 syscall

		 li $v0, 1
		 move $a0, $t1
		 syscall

		 li $v0, 4
		 la $a0, space
		 syscall

		 li $v0, 1
		 move $a0, $t2
		 syscall

		 li $v0, 4
		 la $a0, space
		 syscall

		 li $v0, 1
		 move $a0, $t3
		 syscall

		 li $v0, 4
		 la $a0, space
		 syscall	
		 
		 li $v0, 1
		 move $a0, $t4
		 syscall

		 li $v0, 4
		 la $a0, space
		 syscall	

		 li $v0, 1
		 move $a0, $t5
		 syscall

		 li $v0, 4
		 la $a0, space
		 syscall	

		 li $v0, 1
		 move $a0, $t6
		 syscall
		 
		  li $v0, 4
		 la $a0, space
		 syscall	


		 l.d $f12, 64($a1) 
		 li $v0, 3
		 syscall 


		 li $v0, 4
		 la $a0, line
		 syscall		
		
		 # cout << distant

		 addi $sp, $sp, -4
		 sw $ra, 0($sp)

		 jal check_goal   

		 lw $ra, 0($sp)
		 addi $sp, $sp, 4

		 bne $v0, $zero, end_A

		 li $v0, 4
		 la $a0, goal
		 syscall

		 li $v0, 10
		 syscall

end_A :
		addi $sp, $sp, -4
		sw $ra, 0($sp)

		 jal Move

		lw $ra, 0($sp)
		addi $sp, $sp, 4

		la $t6, now 
		lw $t0, 0($t6)
		sll $t1, $t0, 2 # now*4
		la $t0, P_pq_index
		add $t2, $t1, $t0 
		lw $t1, 0($t2)

		move $a1, $t1

		addi $sp, $sp, -4
		sw $ra, 0($sp)

		jal A_star

		lw $ra, 0($sp)
		addi $sp, $sp, 4

		jr $ra

	.globl check_goal
# parameter  $a1(adress of path a)
# result is $v0

check_goal :	lw $t0, 104($a1) # a.list[6]
				li $t1, 6
				bne $t1, $t0,  end_check
				li $v0, 0
				jr $ra

end_check :		li $v0, 1
				jr $ra
			


	.globl Move
# parameter  $a1(adress of path a)
# result is None

Move :
		
		la $t0, current 
		la $t1, now 
		lw $t2, 0($t0)
		lw $t3, 0($t1)

		beq $t2, $t3, move_if_end
		addi $t3, $t3, 1
		sw $t3, 0($t1)

move_if_end :
		
		move $s7, $zero 

for_move :
		li $t0, 7
		beq  $s7, $t0, end_for_move
		
		addi $sp, $sp, -4
		sw $ra, 0($sp)

		jal is_visited

		lw $ra, 0($sp)
		addi $sp, $sp, 4
	

		beq $v0, $zero, end_if_move		# if true -> end_if_move

		addi $sp, $sp, -4
		sw $ra, 0($sp)

		jal PUSH

		lw $ra, 0($sp)
		addi $sp, $sp, 4

end_if_move :
		addi $s7, $s7, 1
		j for_move
end_for_move :

		jr $ra


	.globl is_visited
# parameter  $a1(adress of path a) $s7(i)
# result is $v0
is_visited:	move $t0, $zero
			li $t2, 4
			li $t1, 7
			li $v0, 1
for_visited :
		beq $t0, $t1, end_for_visited
		mul $t3, $t2, $t0	# 4*i
		add $t3, $t3, $a1 
		addi $t3, $t3, 80	
		
		lw $t4, 0($t3)   # P.list[i]

		bne $t4, $s7, end_if_visited
		move $v0, $zero
		jr $ra
		 
end_if_visited:
		addi $t0, $t0, 1
		j for_visited

end_for_visited: 
		jr $ra



	
	
	
	
	.globl PUSH
# parameter  $a1(adress of path a) $s7(i)
# result is none
PUSH:	
		addi $sp, $sp, -108

		ldc1 $f0, 0($a1)	#city[0]
		sdc1 $f0, 0($sp)
			
		ldc1 $f0, 8($a1)	#city[1]
		sdc1 $f0, 8($sp)
	
		ldc1 $f0, 16($a1)	#city[2]
		sdc1 $f0, 16($sp)

		ldc1 $f0, 24($a1)	#city[3]
		sdc1 $f0, 24($sp)

		ldc1 $f0, 32($a1)	#city[4]
		sdc1 $f0, 32($sp)

		ldc1 $f0, 40($a1)	#city[5]
		sdc1 $f0, 40($sp)

		ldc1 $f0, 48($a1)	#city[6]
		sdc1 $f0, 48($sp)

		ldc1 $f0, 56($a1)	# cost
		sdc1 $f0, 56($sp)

		ldc1 $f0, 64($a1)	# distant
		sdc1 $f0, 64($sp)

		lw $t1, 72($a1)		# current
		sw $t1, 72($sp)
		
		lw $t1, 76($a1)		# size
		sw $t1, 76($sp)
		
		lw $t1, 80($a1)		# list[0]
		sw $t1, 80($sp)
		
		lw $t1,	84($a1)		# list[1]
		sw $t1, 84($sp)
		
		lw $t1, 88($a1)		# list[2]
		sw $t1, 88($sp)
		
		lw $t1, 92($a1)		# list[3]
		sw $t1, 92($sp)
		
		lw $t1, 96($a1)		# list[4]
		sw $t1, 96($sp)
		
		lw $t1, 100($a1)	# list[5]
		sw $t1, 100($sp)

		lw $t1, 104($a1)	# list[6]
		sw $t1, 104($sp)

		
		lw $t0, 72($a1)		# now.current
		move $t2, $s7		# n_city
		
		sll $t0, $t0, 3			# now.current * 8
		sll $t2, $t2, 3			# n_city * 8

		addi $sp, $sp, -8
		
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		
		la $a0, Travel		# addr
		la $a2, Travel		# addr

		add $a0, $a0, $t0
		add $a2, $a2, $t2		

		jal dist				# $f0
		
	


		lw $a0, 4($sp)
		lw $ra, 0($sp)

	

		addi $sp, $sp, 8 


		l.d $f10, 64($sp)
		add.d $f10, $f10, $f0
		s.d $f10, 64($sp)
		 
		sll $t1, $s7, 3
		add $t0, $sp, $t1

		s.d $f0, 0($t0)		# next.city[n_city] = $f0 

		sw $s7, 72($sp)	    # next.current = n_city


		mtc1 $zero, $f2
		cvt.d.w $f4, $f2
		
		l.d $f0, 0($sp)
		add.d $f4, $f4, $f0
		l.d $f0, 8($sp)  
		add.d $f4, $f4, $f0
		l.d $f0, 24($sp)  
		add.d $f4, $f4, $f0
		l.d $f0, 16($sp)  
		add.d $f4, $f4, $f0
		l.d $f0, 32($sp)  
		add.d $f4, $f4, $f0
		l.d $f0, 40($sp)  
		add.d $f4, $f4, $f0
		l.d $f0, 48($sp)  
		add.d $f4, $f4, $f0      

		s.d $f4, 56($sp)	# cost += all city


		lw $t1, 76($a1)
		sll $t1, $t1, 2 
		
		addi $t1, $t1, 80
		add $t1, $t1, $sp
		
		sw $s7, 0($t1)		# next.list + now.size*4 =  n_city

		lw $t1, 76($a1)
		addi, $t1, $t1, 1

		sw $t1, 76($sp)

		move $a0, $sp
		
		
		addi $sp, $sp, -8
		sw $a0, 4($sp)
		sw $ra, 0($sp)

	
		jal ppq_push

		sw $a0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 8

		addi $sp, $sp, 108
		 
		jr $ra

