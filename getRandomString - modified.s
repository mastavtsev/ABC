	.file	"getRandomString.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"Input in console size of first and second string, \nthe size should be more than 0 and less than 100. \nYou can find the result of random generation in random_gen.txt file. "
.LC1:
	.string	"%d%d"
.LC2:
	.string	"Wrong values, try again! "
.LC3:
	.string	"w"
.LC4:
	.string	"random_gen.txt"
.LC5:
	.string	"%s \n%s"
	.text
	.globl	getRandomString
	.type	getRandomString, @function
	
getRandomString:
	endbr64
	
	# Пролог
	push	rbp
	mov	rbp, rsp
	sub	rsp, 80
	
	mov	QWORD PTR -40[rbp], rdi     # адрес str1
	mov	QWORD PTR -48[rbp], rsi     # адрес str2
	mov	QWORD PTR -56[rbp], rdx     # len1
	mov	QWORD PTR -64[rbp], rcx     # len2
	mov	QWORD PTR -72[rbp], r8      # arg
	mov	rax, QWORD PTR -72[rbp]     # rax = arg 
	mov	rdi, rax                    # rdi = arg
	call	atoi@PLT                # вызов atoi(arg)
	
	mov	DWORD PTR -12[rbp], eax     # seed = atoi(arg)

	mov	eax, DWORD PTR -12[rbp]     # /
	mov	edi, eax                    # | srand(seed)
	call	srand@PLT               # \
	
	lea	rax, .LC0[rip]              # /
	mov	rdi, rax                    # | printf("Input in console ...")
	call	puts@PLT                # \ 
	
.L4:        
    
    # цикл while(1)
	lea	rdx, -32[rbp]           # /        
	lea	rax, -28[rbp]           # | scanf("%d%d", &n1, &n2);
	mov	rsi, rax                # | 
	lea	rax, .LC1[rip]          # | 
	mov	rdi, rax                # |
	mov	eax, 0                  # |
	call	__isoc99_scanf@PLT  # \
	
	
	mov	eax, DWORD PTR -28[rbp]     # /
	test	eax, eax                # |
	jle	.L2                         # | Тело цикла while 
	mov	eax, DWORD PTR -28[rbp]     # |
	cmp	eax, 100                    # | if ((0 < n1 && n1 <= 100) && (0 < n2 && n2 <= 100)) break;
	jg	.L2                         # | 
	mov	eax, DWORD PTR -32[rbp]     # |
	test	eax, eax                # |
	jle	.L2                         # |
	mov	eax, DWORD PTR -32[rbp]     # |
	cmp	eax, 100                    # |
	jle	.L3                         # \
.L2:
	lea	rax, .LC2[rip]              # /
	mov	rdi, rax                    # | else printf("Wrong values, try again! \n");
	call	puts@PLT                # |
	jmp	.L4                         # \
.L3:
	mov	edx, DWORD PTR -28[rbp]
	mov	rax, QWORD PTR -56[rbp]
	mov	DWORD PTR [rax], edx
	mov	edx, DWORD PTR -32[rbp]
	mov	rax, QWORD PTR -64[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -4[rbp], 0
	jmp	.L5
.L6:

    # цикл for (int i = 0, i < n1, i++) 
    # в котором происходит заполнение случайными символами 
    # стороки str1
	call	rand@PLT
	movsx	rdx, eax
	imul	rdx, rdx, -1370734243
	shr	rdx, 32
	add	edx, eax
	sar	edx, 6
	mov	ecx, eax
	sar	ecx, 31
	sub	edx, ecx
	imul	ecx, edx, 94
	sub	eax, ecx
	mov	edx, eax
	mov	eax, edx
	lea	ecx, 33[rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -40[rbp]
	add	rax, rdx
	mov	edx, ecx
	mov	BYTE PTR [rax], dl
	add	DWORD PTR -4[rbp], 1
.L5:
	mov	eax, DWORD PTR -28[rbp] # условие if (i < n2)
	cmp	DWORD PTR -4[rbp], eax # i++
	jl	.L6
	mov	DWORD PTR -8[rbp], 0
	jmp	.L7
.L8:

    # цикл for (int i = 0, i < n2, i++)
    # в котором происходит заполнение случайными символами 
    # стороки str2
	call	rand@PLT
	movsx	rdx, eax
	imul	rdx, rdx, -1370734243
	shr	rdx, 32
	add	edx, eax
	sar	edx, 6
	mov	ecx, eax
	sar	ecx, 31
	sub	edx, ecx
	imul	ecx, edx, 94
	sub	eax, ecx
	mov	edx, eax
	mov	eax, edx
	lea	ecx, 33[rax]
	mov	eax, DWORD PTR -8[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -48[rbp]
	add	rax, rdx
	mov	edx, ecx
	mov	BYTE PTR [rax], dl
	add	DWORD PTR -8[rbp], 1
.L7:

    # Вывод случайно сгенерированных данных в файл output.txt
	mov	eax, DWORD PTR -32[rbp]
	cmp	DWORD PTR -8[rbp], eax
	jl	.L8
	lea	rax, .LC3[rip]
	mov	rsi, rax
	lea	rax, .LC4[rip]
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -24[rbp], rax
	mov	rcx, QWORD PTR -48[rbp]
	mov	rdx, QWORD PTR -40[rbp]
	mov	rax, QWORD PTR -24[rbp]
	lea	rsi, .LC5[rip]
	mov	rdi, rax
	mov	eax, 0
	call	fprintf@PLT
	
	# Эпилог
	nop
	leave
	ret

