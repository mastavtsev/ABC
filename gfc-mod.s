	.intel_syntax noprefix
	.text 		#начинает секцию
	.section	.rodata
.LC0:
	.string	"%d"
	.text
	.globl	get_from_console   #секция с кодом
	.type	get_from_console, @function
	
get_from_console:

	# Пролог функции
	push	rbp	 # / Сохраняем rbp на стек
	mov	rbp, rsp # | rbp = rsp
	sub	rsp, 32	 # \ rsp -= 32
	
	mov	r13, rdi # rdi - 1-й - n
	mov	r14d, 0  # Загружаем i в регистр r14d 
	jmp	.L2
.L3:
	lea	rax, -8[rbp]		# /
	mov	rsi, rax		# |Получение значения из 
	lea	rax, .LC0[rip]		# |консоли при помощи scanf
	mov	rdi, rax		# |и переменной t, которая
	call	scanf@PLT		# |хранится на стеке. Далее
	mov	eax, DWORD PTR -8[rbp]	# \ её значение идёт в eax.
	
	lea	rcx, 0[0+r14d*4] # rcx = r10 * 4
	lea	rdx, A[rip]      # rdx = &A
	mov	DWORD PTR [rcx+rdx], eax # Забираем результат 
				         # работы rand из регистра
				         # rax и кладём в i-ю
				         # ячейку массива A
	
	add	r14d, 1   # Увеличиваем i на единицу
.L2:
	cmp	r14d, r13d
	jl	.L3
	nop
	nop
	
	# Эпилог функции - её завершение
	leave
	ret
	
	
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
