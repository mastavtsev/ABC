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
	
	# Эпилог
	push	rbp
	mov	rbp, rsp
	sub	rsp, 96
	
	mov	QWORD PTR -56[rbp], rdi     # адрес type
	mov	QWORD PTR -64[rbp], rsi     # адрес str1
	mov	QWORD PTR -72[rbp], rdx     # адрес str2
	mov	QWORD PTR -80[rbp], rcx     # адрес len1
	mov	QWORD PTR -88[rbp], r8      # адрес len2
	mov	QWORD PTR -96[rbp], r9      # адрес argc
	mov	DWORD PTR -4[rbp], 0        #  flag = 0;
	mov	rax, QWORD PTR -56[rbp]     # rax = type
	mov	eax, DWORD PTR [rax]    
	
	cmp	eax, 1 # / if (*type == 1) - происходил ли ввод строк через консоль
	jne	.L2    # \ переход, если не консольный тип ввода
	
    
	lea	rax, .LC0[rip] # / Если тип ввода консольный, то выводим правила ввода строк в консоль. 
	mov	rdi, rax       # | printf("Enter in console two strings. Divide them ..."
	call	puts@PLT   # \
	
	mov	rax, QWORD PTR stdin[rip] # rax  = stdin
	mov	QWORD PTR -16[rbp], rax   # input = rax
	jmp	.L3

    # Работа с файловым вводом 
.L2:
	mov	rax, QWORD PTR -56[rbp] # / 
	mov	eax, DWORD PTR [rax]    # | Проверка на то, что тип ввода является "файловым" (type == -56[rbp] == 2)
	cmp	eax, 2                  # \
	jne	.L4                     #  Тип ввода не файловый, значит случайно сгенерированный 
	
	mov	rax, QWORD PTR 16[rbp]   # / Получение второго аргумента командной строки, 
	mov	rax, QWORD PTR 16[rax]   # \ имени входного файла 
	
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]     # rax = fname
	lea	rdx, .LC1[rip]              # адрес символа "r" 
	mov	rsi, rdx                    # rsi = символ "r" - 2-ой аргумент функции (индекс источника)
	mov	rdi, rax                    # rdi = fname - 1-ый аргумент функции (индекс приёмника)
	call	fopen@PLT               # fopen(fname, "r")
	
	mov	QWORD PTR -16[rbp], rax     # input = fopen(fname, "r");
	jmp	.L3
	
	# Работа со случайной генерацией строк
.L4:
	mov	rax, QWORD PTR 16[rbp]      # rax = input
	mov	rax, QWORD PTR 8[rax]       
	mov	QWORD PTR -32[rbp], rax     
	mov	rdi, QWORD PTR -32[rbp]     # rdi = seed
	mov	rcx, QWORD PTR -88[rbp]     # rcx = len2
	mov	rdx, QWORD PTR -80[rbp]     # rdx = len1
	mov	rsi, QWORD PTR -72[rbp]     # rsi = адрес str2
	mov	rax, QWORD PTR -64[rbp]     # rax = адрес str1
	mov	r8, rdi                     # r8  = seed 
	mov	rdi, rax                    # rdi = адрес str1
	call	getRandomString@PLT
	
.L3:
	mov	rax, QWORD PTR -56[rbp]     # / 
	mov	eax, DWORD PTR [rax]        # | условие if (*type != 3)
	cmp	eax, 3                      # |
	je	.L5                         # \
	
	mov	DWORD PTR -20[rbp], 0       # int i = 0
	
.L9:    
                                    # / Считывание символа из потока 
	mov	rax, QWORD PTR -16[rbp]     # | rax = input
	mov	rdi, rax                    # | rdi = input, аргумент функции fgets
	call	fgetc@PLT               # \ eax = fgetc(input);
	
	mov	DWORD PTR -44[rbp], eax     # ch = eax  
	cmp	DWORD PTR -44[rbp], 59      # условие if (ch != 59), 59 == EOF
	
	# Если равно, значит прекратилось считывание 1-ой строки и началось для второй
	je	.L6
	
	cmp	DWORD PTR -4[rbp], 0     # условие if (!flag)
	jne	.L7                      # записываем символ в str2
	
	# записываем символ в str1
	
	mov	eax, DWORD PTR -20[rbp]     # /
	lea	edx, 1[rax]                 # | Происходит получение адреса str1[i++] и 
	mov	DWORD PTR -20[rbp], edx     # | присванивание данному адрсу значения 
	movsx	rdx, eax                # | символа ch 
	mov	rax, QWORD PTR -64[rbp]     # | 
	add	rax, rdx                    # | str1[i++] = ch
	mov	edx, DWORD PTR -44[rbp]     # |
	mov	BYTE PTR [rax], dl          # \
	
	jmp	.L8
.L7:
	mov	eax, DWORD PTR -20[rbp]     # /
	lea	edx, 1[rax]                 # | Происходит получение адреса str2[i++] и
	mov	DWORD PTR -20[rbp], edx     # | присванивание данному адрсу значения
	movsx	rdx, eax                # | символа ch 
	mov	rax, QWORD PTR -72[rbp]     # |         
	add	rax, rdx                    # | str2[i++] = ch
	mov	edx, DWORD PTR -44[rbp]     # |
	mov	BYTE PTR [rax], dl          # \
	jmp	.L8
	
.L6:
	mov	rax, QWORD PTR -80[rbp] # rax = len1
	mov	edx, DWORD PTR -20[rbp] # rdx = i
	mov	DWORD PTR [rax], edx    # *len1 = i
	mov	DWORD PTR -20[rbp], 0   # i = 0
	mov	DWORD PTR -4[rbp], 1    # flag = 1
.L8:
    
	cmp	DWORD PTR -44[rbp], -1  # / # цикл while (ch != -1)
	jne	.L9                     # \ 
	
	mov	eax, DWORD PTR -20[rbp]     # /
	lea	edx, -1[rax]                # | *len2 = (i-1);
	mov	rax, QWORD PTR -88[rbp]     # |
	mov	DWORD PTR [rax], edx        # \
	
	
	mov	eax, DWORD PTR -20[rbp]     # /
	cdqe                            # |
	lea	rdx, -1[rax]                # | str2[i-1] = '\0'
	mov	rax, QWORD PTR -72[rbp]     # |
	add	rax, rdx                    # |
	mov	BYTE PTR [rax], 0           # \
	
	# Закрытие потока получения данных 
.L5:
	mov	rax, QWORD PTR -56[rbp]     # / 
	mov	eax, DWORD PTR [rax]        # | Проверка условия if (*type == 2)
	cmp	eax, 2                      # |
	jne	.L11                        # \
	
	mov	rax, QWORD PTR -16[rbp]     # rax = input
	mov	rdi, rax                    # rdi = input, аргумент функции fclose
	call	fclose@PLT              #  fclose(input) 
	
	# Пролог
.L11:
	nop
	leave
	ret
