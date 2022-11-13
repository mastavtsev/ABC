	.file	"main.c"
	.intel_syntax noprefix
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
	.globl	contains
	.type	contains, @function
contains:
	endbr64
	push	rbp
	mov	rbp, rsp
	mov	QWORD PTR -24[rbp], rdi
	mov	DWORD PTR -28[rbp], esi
	mov	eax, edx
	mov	BYTE PTR -32[rbp], al
	mov	DWORD PTR -4[rbp], 0
	cmp	DWORD PTR -28[rbp], 0
	jne	.L4
	mov	eax, 0
	jmp	.L5
.L4:
	mov	DWORD PTR -8[rbp], 0
	jmp	.L6
.L9:
	mov	eax, DWORD PTR -8[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	cmp	BYTE PTR -32[rbp], al
	jne	.L7
	mov	DWORD PTR -4[rbp], 1
	jmp	.L8
.L7:
	add	DWORD PTR -8[rbp], 1
.L6:
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	jl	.L9
.L8:
	mov	eax, DWORD PTR -4[rbp]
.L5:
	pop	rbp
	ret
	.size	contains, .-contains
	.section	.rodata
	.align 8
.LC0:
	.string	"Type in the console the type of input you want: \n1 - console (output in console) \n2 - file input (output in output.txt) \n3 - random input (output in console) "
.LC1:
	.string	"%d"
.LC2:
	.string	"RESULT:   %s"
	.align 8
.LC3:
	.string	"The resulting string is in the output.txt file."
.LC4:
	.string	"w"
.LC5:
	.string	"output.txt"
.LC6:
	.string	"\nElapsed: %ld ns\n"
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp
	mov	rbp, rsp
	lea	r11, -36864[rsp]
.LPSRL0:
	sub	rsp, 4096
	or	DWORD PTR [rsp], 0
	cmp	rsp, r11
	jne	.LPSRL0
	sub	rsp, 3232
	mov	DWORD PTR -40084[rbp], edi
	mov	QWORD PTR -40096[rbp], rsi
	mov	DWORD PTR -16[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -8[rbp], 0
	mov	DWORD PTR -12[rbp], 0
	mov	eax, DWORD PTR -40084[rbp]
	cmp	eax, 3
	je	.L11
	mov	eax, 1
	jmp	.L21
.L11:
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	puts@PLT
	lea	rax, -40044[rbp]
	mov	rsi, rax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	lea	r8, -40084[rbp]
	lea	rdi, -40040[rbp]
	lea	rcx, -40036[rbp]
	lea	rdx, -20032[rbp]
	lea	rsi, -10032[rbp]
	lea	rax, -40044[rbp]
	sub	rsp, 8
	push	QWORD PTR -40096[rbp]
	mov	r9, r8
	mov	r8, rdi
	mov	rdi, rax
	call	getData@PLT
	add	rsp, 16
	lea	rax, -40064[rbp]
	mov	rsi, rax
	mov	edi, 1
	call	clock_gettime@PLT
	mov	DWORD PTR -4[rbp], 0
	jmp	.L13
.L15:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	movzx	eax, BYTE PTR -10032[rbp+rax]
	movsx	edx, al
	mov	ecx, DWORD PTR -40040[rbp]
	lea	rax, -20032[rbp]
	mov	esi, ecx
	mov	rdi, rax
	call	contains
	test	eax, eax
	je	.L14
	mov	eax, DWORD PTR -8[rbp]
	lea	edx, 1[rax]
	mov	DWORD PTR -8[rbp], edx
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	movzx	edx, BYTE PTR -10032[rbp+rdx]
	cdqe
	mov	BYTE PTR -30032[rbp+rax], dl
.L14:
	add	DWORD PTR -4[rbp], 1
.L13:
	mov	eax, DWORD PTR -40036[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jl	.L15
	mov	DWORD PTR -4[rbp], 0
	jmp	.L16
.L18:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	movzx	eax, BYTE PTR -30032[rbp+rax]
	movsx	edx, al
	mov	ecx, DWORD PTR -12[rbp]
	lea	rax, -40032[rbp]
	mov	esi, ecx
	mov	rdi, rax
	call	contains
	test	eax, eax
	jne	.L17
	mov	eax, DWORD PTR -12[rbp]
	lea	edx, 1[rax]
	mov	DWORD PTR -12[rbp], edx
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	movzx	edx, BYTE PTR -30032[rbp+rdx]
	cdqe
	mov	BYTE PTR -40032[rbp+rax], dl
.L17:
	add	DWORD PTR -4[rbp], 1
.L16:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jl	.L18
	lea	rax, -40080[rbp]
	mov	rsi, rax
	mov	edi, 1
	call	clock_gettime@PLT
	mov	rax, QWORD PTR -40064[rbp]
	mov	rdx, QWORD PTR -40056[rbp]
	mov	rdi, QWORD PTR -40080[rbp]
	mov	rsi, QWORD PTR -40072[rbp]
	mov	rcx, rdx
	mov	rdx, rax
	call	timespecDiff
	mov	QWORD PTR -24[rbp], rax
	mov	eax, DWORD PTR -40044[rbp]
	cmp	eax, 2
	je	.L19
	mov	edi, 10
	call	putchar@PLT
	lea	rax, -40032[rbp]
	mov	rsi, rax
	lea	rax, .LC2[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	jmp	.L20
.L19:
	mov	eax, DWORD PTR -40044[rbp]
	cmp	eax, 2
	jne	.L20
	mov	edi, 10
	call	putchar@PLT
	lea	rax, .LC3[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	lea	rax, .LC4[rip]
	mov	rsi, rax
	lea	rax, .LC5[rip]
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -32[rbp], rax
	mov	rdx, QWORD PTR -32[rbp]
	lea	rax, -40032[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	fputs@PLT
.L20:
	mov	rax, QWORD PTR -24[rbp]
	mov	rsi, rax
	lea	rax, .LC6[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	mov	eax, 0
.L21:
	leave
	ret
	.size	main, .-main
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
