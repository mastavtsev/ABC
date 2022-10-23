	.intel_syntax noprefix
	.text #начинает секцию
	
	.globl	get_from_random #секция с кодом
	.type	get_from_random, @function
get_from_random:
	# Пролог функции
	push	rbp	 # / Сохраняем rbp на стек	
	mov	rbp, rsp # | rbp = rsp
	sub	rsp, 32  # \ rsp -= 32
	
	mov	r12, rdi # rdi - 1-й - n
	
		
	# Вызов atoi
	mov	rdi, rsi
	call	atoi@PLT
	mov	edi, eax
	
	# Вызов srand
	call	srand@PLT
	mov	r10d, 0 # Загружаем i в регистр r10d
		
 	jmp	.L2 #Переходим в цикл for
.L3:
	# Вызов функции rand
	call	rand@PLT

	lea	rcx, 0[0+r10*4] # rcx = r10 * 4
	lea	rdx, A[rip]     # rdx = &A
	mov	DWORD PTR [rcx+rdx], eax # Забираем результат 
				         # работы rand из регистра
				         # rax и кладём в i-ю
				         # ячейку массива A
	
	add	r10d, 1 # Увеличиваем i на единицу 
	
.L2:
	cmp	r10d, r12d
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
