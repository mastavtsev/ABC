	.intel_syntax noprefix
	.text
	.globl	A
	.bss
	.align 32
	.type	A, @object
	.size	A, 4194304
A:
	.zero	4194304
	.globl	B
	.align 32
	.type	B, @object
	.size	B, 4194304
B:
	.zero	4194304
	.text
	.globl	timespecDiff
	.type	timespecDiff, @function
timespecDiff:
	endbr64
	push	rbp
	mov	rbp, rsp
	mov	rax, rsi
	mov	r8, rdi
	mov	rsi, r8
	mov	rdi, r9
	mov	rdi, rax
	mov	QWORD PTR -48[rbp], rsi
	mov	QWORD PTR -40[rbp], rdi
	mov	QWORD PTR -64[rbp], rdx
	mov	QWORD PTR -56[rbp], rcx
	mov	rax, QWORD PTR -48[rbp]
	mov	rdx, QWORD PTR -64[rbp]
	sub	rax, rdx
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	sub	rax, rdx
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	imul	rax, rax, 1000000000
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	add	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	pop	rbp
	ret
	.size	timespecDiff, .-timespecDiff
	.section	.rodata
	.align 8
.LC0:
	.string	"Type in console the size of A: "
.LC1:
	.string	"%d"
	.align 8
.LC2:
	.string	"Type in the console the type of input you want: \n1 - console (output in console) \n2 - file input.txt (output in output.txt) \n3 - random input (output in console) "
.LC3:
	.string	"Type values in console:"
.LC4:
	.string	"r"
.LC5:
	.string	"input.txt"
.LC6:
	.string	"Elapsed: %ld ns\n"
.LC7:
	.string	"Array B"
.LC8:
	.string	"%d "
.LC9:
	.string	"w"
.LC10:
	.string	"output.txt"
	
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp	  # / Сохраняем rbp на стек
	mov	rbp, rsp  # | rbp = rsp
	add	rsp, -128 # \ rsp -= 128
	
	
	mov	DWORD PTR -116[rbp], edi # args
	mov	QWORD PTR -128[rbp], rsi # argv
	
	mov	DWORD PTR -8[rbp], -1 #neg
	mov	DWORD PTR -12[rbp], -1 #pos
	
	# printf("Type in console the size of A...")
	lea	rax, .LC0[rip] 
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	
	# Получение значения n
	lea	rax, -68[rbp] 
	mov	rsi, rax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	
	# printf("Type of input...")
	lea	rax, .LC2[rip] 
	mov	rdi, rax
	call	puts@PLT #вместо printf используется puts
	
	# Получение значения type
	lea	rax, -72[rbp] 
	mov	rsi, rax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	
	# if type != 1
	mov	eax, DWORD PTR -72[rbp] # if type != 1
	cmp	eax, 1
	jne	.L4
	
	# type == 1 -> Получаем данны из консоли функцией get_from_console
	lea	rax, .LC3[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, DWORD PTR -68[rbp]
	mov	edi, eax
	call	get_from_console@PLT
.L4:
	# if type != 2
	mov	eax, DWORD PTR -72[rbp]
	cmp	eax, 2
	jne	.L5
	
	# if type == 2
	lea	rax, .LC4[rip] # установка режима чтения
	mov	rsi, rax
	lea	rax, .LC5[rip] # получение адреса файла input.txt
	mov	rdi, rax
	
	# чтение из файла iput.txt
	call	fopen@PLT
	mov	QWORD PTR -40[rbp], rax # / rax содержит указатель на файл
					# \ сохранение 'FILE* input' на стек
	
	mov	r15d, 0 # int i = 0     
	jmp	.L6
.L7:
	# чтение из файла input.txt
	mov	eax, r15d
	cdqe
	
	lea	rdx, 0[0+rax*4] #вычисление адреса (rax*4)[0]
	lea	rax, A[rip]  # адрес начала массива А
	add	rdx, rax
	mov	rax, QWORD PTR -40[rbp]
	lea	rcx, .LC1[rip]  #строка "%d"
	mov	rsi, rcx #строка "%d"
	mov	rdi, rax #указатель на файл
	mov	eax, 0
	call	__isoc99_fscanf@PLT #fscanf(input, "%d", %A[i])
	add	r15d, 1 # i++
.L6:
	# if i < n
	mov	eax, DWORD PTR -68[rbp]
	cmp	r15d, eax 
	jl	.L7
.L5:
	# if type != 3
	mov	eax, DWORD PTR -72[rbp] # if type != 3
	cmp	eax, 3
	jne	.L8
	
	# type == 3 - get_from_random
	
	# if argc == 2
	cmp	DWORD PTR -116[rbp], 2 
	jne	.L9 #return with error
	
	mov	rax, QWORD PTR -128[rbp] # rax = argv
	mov	rax, QWORD PTR 8[rax] # rax = argv[8] = seed
	mov	QWORD PTR -48[rbp], rax # кладём на стек значение rax
	mov	eax, DWORD PTR -68[rbp] # rax = n
	mov	rdx, QWORD PTR -48[rbp]	# берём со стека argv[8]
	mov	rsi, rdx # rsi = rdx
	mov	edi, eax # rdi = rax
	call	get_from_random@PLT
	jmp	.L8
.L9:
	#return with error
	mov	eax, 1
	jmp	.L24
.L8:
	# запуск таймера
	lea	rax, -96[rbp] 
	mov	rsi, rax
	mov	edi, 1
	call	clock_gettime@PLT
	mov	DWORD PTR -20[rbp], 0
	jmp	.L11
.L14:
	mov	eax, DWORD PTR -20[rbp] # eax = n
	cdqe
	lea	rdx, 0[0+rax*4] # вычиcляется адрес (rax*4)[0]
	lea	rax, A[rip] # адрес начала массива А
	mov	eax, DWORD PTR [rdx+rax] # rdx[rcx]
	
	# logical AND
	test	eax, eax
	js	.L12
	
	#if (pos == -1)
	cmp	DWORD PTR -12[rbp], -1
	jne	.L13
	
	# pos = i 
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -12[rbp], eax
	jmp	.L13
.L12:
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -8[rbp], eax
.L13:
	# i++
	add	DWORD PTR -20[rbp], 1
.L11:
	mov	eax, DWORD PTR -68[rbp] # eax = n
	
	# if (i < n)
	cmp	DWORD PTR -20[rbp], eax
	jl	.L14
	
	mov	DWORD PTR -4[rbp], 0 # j = 0
	mov	r15d, 0 # i = 0
	jmp	.L15
.L17:
	# if (i == neg) -> если i равно индексу последнего отрицательного
	# числа, т.е. neg, i++ и запись в B не осуществляется
	mov	eax, r15d
	cmp	eax, DWORD PTR -8[rbp]
	je	.L16
	
	# if (i == pos) -> если i равно индексу первого положительного
	# числа, т.е. pos, i++ и запись в B не осуществляется
	mov	eax, r15d
	cmp	eax, DWORD PTR -12[rbp]
	je	.L16
	
	# иначе записываем число в B
	mov	eax, r15d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, A[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*4]
	lea	rdx, B[rip]
	mov	DWORD PTR [rcx+rdx], eax
	add	DWORD PTR -4[rbp], 1 #j++
.L16:
	add	r15d, 1 #i++
.L15:
	mov	eax, DWORD PTR -68[rbp] # eax = n
	
	# if (i < n)
	cmp	r15d, eax
	jl	.L17
	
	
	lea	rax, -112[rbp]
	mov	rsi, rax
	mov	edi, 1
	
	# остановка таймера и получение результа
	# и получение результата его работы
	call	clock_gettime@PLT
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -88[rbp]
	mov	rdi, QWORD PTR -112[rbp]
	mov	rsi, QWORD PTR -104[rbp]
	
	# подсчёт времени работы таймера
	mov	rcx, rdx
	mov	rdx, rax
	call	timespecDiff
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	rsi, rax
	
	
	lea	rax, .LC6[rip] # вывод слова Elapsed и \n  
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT # вывод затраченного времени
	
	mov	edi, 10  # ascii код для \n
	call	putchar@PLT # переход на новую строку
	
	# if (type == 2) 
	mov	eax, DWORD PTR -72[rbp]
	cmp	eax, 2
	
	# type == 2 -> выводи результат в файл output.txt
	je	.L18
	
	
	
	
	# type != 2 -> выводим результат в консоль
	
	lea	rax, .LC7[rip]
	mov	rdi, rax
	call	puts@PLT # вывод фразы Array B
	mov	r15d, 0
	jmp	.L19
.L20:
	mov	eax, r15d
	cdqe
	lea	rdx, 0[0+rax*4] #вычисляется адрес (rax*4)[0]
	lea	rax, B[rip] #адрес начала массива B
	mov	eax, DWORD PTR [rdx+rax] #rdx[rcx]
	
	mov	esi, eax # значение B[i]
	lea	rax, .LC8[rip] # символ "%d"
	mov	rdi, rax # символ "%d"
	mov	eax, 0
	call	printf@PLT
	add	r15d, 1 #i++
.L19:
	mov	eax, DWORD PTR -68[rbp]
	sub	eax, 2
	cmp	r15d, eax # i < n-2 - при выводе массива B в
			  # в консоль
	jl	.L20
	jmp	.L21
.L18:
	lea	rax, .LC9[rip] # "w" - установка режима записи в output.txt
	mov	rsi, rax
	lea	rax, .LC10[rip] # "output.txt"
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -64[rbp], rax #указатель на адрес файла output.txt
	mov	DWORD PTR -32[rbp], 0 # i = 0
	jmp	.L22
.L23:
	mov	eax, DWORD PTR -32[rbp] # eax = i
	cdqe
	lea	rdx, 0[0+rax*4] #вычисляется адрес (rax*4)[0]
	lea	rax, B[rip] #адрес начала массива B
	mov	edx, DWORD PTR [rdx+rax] #rdx[rcx]
	mov	rax, QWORD PTR -64[rbp] # адрес файла output.txt
	lea	rcx, .LC8[rip] # символ "%d"
	mov	rsi, rcx # символ "%d"
	mov	rdi, rax # адрес файла output.txt
	mov	eax, 0
	call	fprintf@PLT
	add	DWORD PTR -32[rbp], 1 #i++
.L22:
	mov	eax, DWORD PTR -68[rbp] # eax = n
	sub	eax, 2 # eax -= 2
	
	# if (i < (n-2 == eax))
	cmp	DWORD PTR -32[rbp], eax # if (i < n-2 ) при выводе В в
					# output.txt
	jl	.L23
.L21:
	mov	edi, 10 # ascii код для \n
	call	putchar@PLT # переход на новую строку
	mov	eax, 0
.L24:
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
