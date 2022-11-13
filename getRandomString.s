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
	push	rbp
	mov	rbp, rsp
	sub	rsp, 80
	mov	QWORD PTR -40[rbp], rdi
	mov	QWORD PTR -48[rbp], rsi
	mov	QWORD PTR -56[rbp], rdx
	mov	QWORD PTR -64[rbp], rcx
	mov	QWORD PTR -72[rbp], r8
	mov	rax, QWORD PTR -72[rbp]
	mov	rdi, rax
	call	atoi@PLT
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	edi, eax
	call	srand@PLT
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	puts@PLT
.L4:
	lea	rdx, -32[rbp]
	lea	rax, -28[rbp]
	mov	rsi, rax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	mov	eax, DWORD PTR -28[rbp]
	test	eax, eax
	jle	.L2
	mov	eax, DWORD PTR -28[rbp]
	cmp	eax, 100
	jg	.L2
	mov	eax, DWORD PTR -32[rbp]
	test	eax, eax
	jle	.L2
	mov	eax, DWORD PTR -32[rbp]
	cmp	eax, 100
	jle	.L3
.L2:
	lea	rax, .LC2[rip]
	mov	rdi, rax
	call	puts@PLT
	jmp	.L4
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
	mov	eax, DWORD PTR -28[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jl	.L6
	mov	DWORD PTR -8[rbp], 0
	jmp	.L7
.L8:
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
	nop
	leave
	ret
	.size	getRandomString, .-getRandomString
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
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
