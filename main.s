	.file	"main.c"
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
	push	rbp
	mov	rbp, rsp
	add	rsp, -128
	mov	DWORD PTR -116[rbp], edi
	mov	QWORD PTR -128[rbp], rsi
	mov	DWORD PTR -8[rbp], -1
	mov	DWORD PTR -12[rbp], -1
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	lea	rax, -68[rbp]
	mov	rsi, rax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	lea	rax, .LC2[rip]
	mov	rdi, rax
	call	puts@PLT
	lea	rax, -72[rbp]
	mov	rsi, rax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	mov	eax, DWORD PTR -72[rbp]
	cmp	eax, 1
	jne	.L4
	lea	rax, .LC3[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, DWORD PTR -68[rbp]
	mov	edi, eax
	call	get_from_console@PLT
.L4:
	mov	eax, DWORD PTR -72[rbp]
	cmp	eax, 2
	jne	.L5
	lea	rax, .LC4[rip]
	mov	rsi, rax
	lea	rax, .LC5[rip]
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -40[rbp], rax
	mov	DWORD PTR -16[rbp], 0
	jmp	.L6
.L7:
	mov	eax, DWORD PTR -16[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, A[rip]
	add	rdx, rax
	mov	rax, QWORD PTR -40[rbp]
	lea	rcx, .LC1[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_fscanf@PLT
	add	DWORD PTR -16[rbp], 1
.L6:
	mov	eax, DWORD PTR -68[rbp]
	cmp	DWORD PTR -16[rbp], eax
	jl	.L7
.L5:
	mov	eax, DWORD PTR -72[rbp]
	cmp	eax, 3
	jne	.L8
	cmp	DWORD PTR -116[rbp], 2
	jne	.L9
	mov	rax, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -48[rbp], rax
	mov	eax, DWORD PTR -68[rbp]
	mov	rdx, QWORD PTR -48[rbp]
	mov	rsi, rdx
	mov	edi, eax
	call	get_from_random@PLT
	jmp	.L8
.L9:
	mov	eax, 1
	jmp	.L24
.L8:
	lea	rax, -96[rbp]
	mov	rsi, rax
	mov	edi, 1
	call	clock_gettime@PLT
	mov	DWORD PTR -20[rbp], 0
	jmp	.L11
.L14:
	mov	eax, DWORD PTR -20[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, A[rip]
	mov	eax, DWORD PTR [rdx+rax]
	test	eax, eax
	js	.L12
	cmp	DWORD PTR -12[rbp], -1
	jne	.L13
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -12[rbp], eax
	jmp	.L13
.L12:
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -8[rbp], eax
.L13:
	add	DWORD PTR -20[rbp], 1
.L11:
	mov	eax, DWORD PTR -68[rbp]
	cmp	DWORD PTR -20[rbp], eax
	jl	.L14
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -24[rbp], 0
	jmp	.L15
.L17:
	mov	eax, DWORD PTR -24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	je	.L16
	mov	eax, DWORD PTR -24[rbp]
	cmp	eax, DWORD PTR -12[rbp]
	je	.L16
	mov	eax, DWORD PTR -24[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, A[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*4]
	lea	rdx, B[rip]
	mov	DWORD PTR [rcx+rdx], eax
	add	DWORD PTR -4[rbp], 1
.L16:
	add	DWORD PTR -24[rbp], 1
.L15:
	mov	eax, DWORD PTR -68[rbp]
	cmp	DWORD PTR -24[rbp], eax
	jl	.L17
	lea	rax, -112[rbp]
	mov	rsi, rax
	mov	edi, 1
	call	clock_gettime@PLT
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -88[rbp]
	mov	rdi, QWORD PTR -112[rbp]
	mov	rsi, QWORD PTR -104[rbp]
	mov	rcx, rdx
	mov	rdx, rax
	call	timespecDiff
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	rsi, rax
	lea	rax, .LC6[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	mov	edi, 10
	call	putchar@PLT
	mov	eax, DWORD PTR -72[rbp]
	cmp	eax, 2
	je	.L18
	lea	rax, .LC7[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	DWORD PTR -28[rbp], 0
	jmp	.L19
.L20:
	mov	eax, DWORD PTR -28[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, B[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	esi, eax
	lea	rax, .LC8[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	add	DWORD PTR -28[rbp], 1
.L19:
	mov	eax, DWORD PTR -68[rbp]
	sub	eax, 2
	cmp	DWORD PTR -28[rbp], eax
	jl	.L20
	jmp	.L21
.L18:
	lea	rax, .LC9[rip]
	mov	rsi, rax
	lea	rax, .LC10[rip]
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -64[rbp], rax
	mov	DWORD PTR -32[rbp], 0
	jmp	.L22
.L23:
	mov	eax, DWORD PTR -32[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, B[rip]
	mov	edx, DWORD PTR [rdx+rax]
	mov	rax, QWORD PTR -64[rbp]
	lea	rcx, .LC8[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 0
	call	fprintf@PLT
	add	DWORD PTR -32[rbp], 1
.L22:
	mov	eax, DWORD PTR -68[rbp]
	sub	eax, 2
	cmp	DWORD PTR -32[rbp], eax
	jl	.L23
.L21:
	mov	edi, 10
	call	putchar@PLT
	mov	eax, 0
.L24:
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
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
