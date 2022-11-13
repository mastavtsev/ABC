	.file	"getData.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"Enter in console two strings. Divide them by the symbol ';'. The enter process ends with double Ctrl + D press. "
.LC1:
	.string	"r"
	.text
	.globl	getData
	.type	getData, @function
getData:
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 96
	mov	QWORD PTR -56[rbp], rdi
	mov	QWORD PTR -64[rbp], rsi
	mov	QWORD PTR -72[rbp], rdx
	mov	QWORD PTR -80[rbp], rcx
	mov	QWORD PTR -88[rbp], r8
	mov	QWORD PTR -96[rbp], r9
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR -56[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	eax, 1
	jne	.L2
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	rax, QWORD PTR stdin[rip]
	mov	QWORD PTR -16[rbp], rax
	jmp	.L3
.L2:
	mov	rax, QWORD PTR -56[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	eax, 2
	jne	.L4
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 16[rax]
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	lea	rdx, .LC1[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -16[rbp], rax
	jmp	.L3
.L4:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -32[rbp], rax
	mov	rdi, QWORD PTR -32[rbp]
	mov	rcx, QWORD PTR -88[rbp]
	mov	rdx, QWORD PTR -80[rbp]
	mov	rsi, QWORD PTR -72[rbp]
	mov	rax, QWORD PTR -64[rbp]
	mov	r8, rdi
	mov	rdi, rax
	call	getRandomString@PLT
.L3:
	mov	rax, QWORD PTR -56[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	eax, 3
	je	.L5
	mov	DWORD PTR -20[rbp], 0
.L9:
	mov	rax, QWORD PTR -16[rbp]
	mov	rdi, rax
	call	fgetc@PLT
	mov	DWORD PTR -44[rbp], eax
	cmp	DWORD PTR -44[rbp], 59
	je	.L6
	cmp	DWORD PTR -4[rbp], 0
	jne	.L7
	mov	eax, DWORD PTR -20[rbp]
	lea	edx, 1[rax]
	mov	DWORD PTR -20[rbp], edx
	movsx	rdx, eax
	mov	rax, QWORD PTR -64[rbp]
	add	rax, rdx
	mov	edx, DWORD PTR -44[rbp]
	mov	BYTE PTR [rax], dl
	jmp	.L8
.L7:
	mov	eax, DWORD PTR -20[rbp]
	lea	edx, 1[rax]
	mov	DWORD PTR -20[rbp], edx
	movsx	rdx, eax
	mov	rax, QWORD PTR -72[rbp]
	add	rax, rdx
	mov	edx, DWORD PTR -44[rbp]
	mov	BYTE PTR [rax], dl
	jmp	.L8
.L6:
	mov	rax, QWORD PTR -80[rbp]
	mov	edx, DWORD PTR -20[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -20[rbp], 0
	mov	DWORD PTR -4[rbp], 1
.L8:
	cmp	DWORD PTR -44[rbp], -1
	jne	.L9
	mov	eax, DWORD PTR -20[rbp]
	lea	edx, -1[rax]
	mov	rax, QWORD PTR -88[rbp]
	mov	DWORD PTR [rax], edx
	mov	eax, DWORD PTR -20[rbp]
	cdqe
	lea	rdx, -1[rax]
	mov	rax, QWORD PTR -72[rbp]
	add	rax, rdx
	mov	BYTE PTR [rax], 0
.L5:
	mov	rax, QWORD PTR -56[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	eax, 2
	jne	.L11
	mov	rax, QWORD PTR -16[rbp]
	mov	rdi, rax
	call	fclose@PLT
.L11:
	nop
	leave
	ret
	.size	getData, .-getData
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
