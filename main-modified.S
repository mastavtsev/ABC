	.intel_syntax noprefix
	.text
	.globl	timespecDiff
	.type	timespecDiff, @function
timespecDiff:
	
	endbr64
	
	# Пролог 
	push	rbp
	mov	rbp, rsp
	
	
	mov	rax, rsi                        
	mov	r8, rdi                         # r8 = end - окончание работы со строками 
	mov	rsi, r8                         # rsi = end
	mov	rdi, r9                         
	mov	rdi, rax                        # rdi = start - начало работы со строками
	
	mov	QWORD PTR -48[rbp], rsi         # загружаем значение rsi на стек
	mov	QWORD PTR -40[rbp], rdi         # загружаем значение start на стек
	mov	QWORD PTR -64[rbp], rdx         # загружаем на стек значение rdx
	mov	QWORD PTR -56[rbp], rcx         # загружаем на стек значение rcx
	
	mov	rax, QWORD PTR -48[rbp]         # rax = rsi
	mov	rdx, QWORD PTR -64[rbp]         # rdx = rdx
	sub	rax, rdx                        # rax -= rdx
	
	mov	QWORD PTR -32[rbp], rax         # загружаем на стек значение rax
	mov	rax, QWORD PTR -40[rbp]         # rax = start
	mov	rdx, QWORD PTR -56[rbp]         # rdx = rcx 
	sub	rax, rdx                        # rax -= rdx
	
	mov	QWORD PTR -24[rbp], rax         # загружаем на стек значение rax, далее в этом участке памяти будет хранится ellapsed_ns
	mov	rax, QWORD PTR -32[rbp]         # rax = старое значение rax
	
	mov	QWORD PTR -8[rbp], rax          # result = rax, раньше по этому адресу в стеке хранилась переменная k,
	                                    # однако теперь она не нужна и туда можно записать значение rax
	mov	rax, QWORD PTR -8[rbp]          # rax = result 
	
	imul	rax, rax, 1000000000        # rax *= 1000000000
	mov	QWORD PTR -8[rbp], rax          # result = rax
	
	mov	rax, QWORD PTR -24[rbp]         # rax = предыдущие значение rax
	add	QWORD PTR -8[rbp], rax          # result += rax
	
	mov	rax, QWORD PTR -8[rbp]          # rax = result, что будет возвращено return и в последствии из rax
	                                    # будет взято значение и записано в -24[rbp] - ellapsed_ns
	
	# Эпилог 
	pop	rbp
	ret
	.size	timespecDiff, .-timespecDiff
	
	
	.globl	contains
	.type	contains, @function
contains:
	endbr64
	push	rbp     	# Эпилог
	mov	rbp, rsp
	mov	QWORD PTR -24[rbp], rdi # записываем на стек значение 1-ого аргумента функции - строка в которой идёт поиск
	mov	DWORD PTR -28[rbp], esi # записываем на стек значение 2-ого аргумента функции - длина этой строки 
	mov	eax, edx                # rax = rdx = ch - символ для поиска 
	mov	BYTE PTR -32[rbp], al   # записывае на стек значение rax 
	mov	r14, 0    #  flag = 0
	cmp	DWORD PTR -28[rbp], 0   # условие if (len == 0)
	jne	.L4                     # переход к телу цикла for ( i = 0, i < len, i++)
	mov	eax, 0                  # Если длина строки равна 0, то возвращаем 0 = false
	jmp	.L5                     # и идём в эпилог
.L4:
	mov	r13d, 0   # i = 0
	jmp	.L6
.L9:
	mov	eax, r13d  # rax = i
	movsx	rdx, eax            # rdx = rax
	mov	rax, QWORD PTR -24[rbp] # rax = адрес str
	add	rax, rdx                # rax += rdx
	movzx	eax, BYTE PTR [rax] # eax = str[i]
	cmp	BYTE PTR -32[rbp], al   # условие str[i] == ch
	
	jne	.L7                     # если нет, то переходим к следующей итерации цикла
	mov	r14, 1    # flag = 1
	
	jmp	.L8                     # переходим к присвоению возвращаемого значения
.L7:
	add	r13d, 1    # i++
.L6:
	mov	eax, r13d      
	cmp	eax, DWORD PTR -28[rbp]     
	jl	.L9
.L8:
	mov	rax, r14  # eax = flag  - возвращаемое значение
.L5:
	pop	rbp                     # Пролог
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
	push	rbp          # Сохраняем rbp на стек
	mov	rbp, rsp         # rbp = rsp 
	lea	r11, -36864[rsp] 
	
.LPSRL0:
	sub	rsp, 4096
	or	DWORD PTR [rsp], 0
	cmp	rsp, r11
	jne	.LPSRL0
	sub	rsp, 3232
	mov	DWORD PTR -40084[rbp], edi # rdi 1-й аргумент командной строки - args 
	mov	QWORD PTR -40096[rbp], rsi # rsi 2-ой аргумент командной строки - argv 
	mov	r15, 0       # int i = 0
	mov	DWORD PTR -8[rbp], 0       # int k = 0
	mov	DWORD PTR -12[rbp], 0      # int n = 0
	mov	eax, DWORD PTR -40084[rbp] # eax = args
	
	cmp	eax, 3 # / Проверка того, что в командную строку передано необходимое кол-во параметров.
	           # \ [foo.exe, seed, file name]
	
	je	.L11 # Параметры переданы верно, работа программы продолжается.
	
	mov	eax, 1 # Если параметров недостаточно, то в eax = 1
	jmp	.L21   # И выход из программы с кодом ошибки 1
.L11:
	
	lea	rax, .LC0[rip] #  / Вывод в консоль сообщения для пользователя,
	mov	rdi, rax       # <  которое предлагает ему выбрать тип ввода строк.
	call	puts@PLT   #  \
	
	# Считывание из консоли значения переменной type при помощи функции scanf
	lea	rax, -40044[rbp] # Переменная type кладётся в rax для работы функции scanf 
	mov	rsi, rax
	lea	rax, .LC1[rip] # "%d"
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	
	# Подготовка к вызову функции getData, получение указателей на данные
	lea	r8, -40084[rbp]     # адрес argc
	lea	rdi, -40040[rbp]    # адрес len2
	lea	rcx, -40036[rbp]    # адрес len1
	lea	rdx, -20032[rbp]    # адрес str2
	lea	rsi, -10032[rbp]    # адрес str1
	lea	rax, -40044[rbp]    # адрес type
	
	sub	rsp, 8
	
	push	QWORD PTR -40096[rbp] # Передача на стек значения argv для его использования в функции getData
	 
	mov	r9, r8    # r9 = argc
	mov	r8, rdi   # r8 = len2
	mov	rdi, rax  # rdi = type
	call	getData@PLT
	
	
	add	rsp, 16
	
	# вызов функции clock_gettime для подсчёта затраченного времени
	lea	rax, -40064[rbp] # адрес переменной start 
	mov	rsi, rax         # rsi = start - 2-ой аргумент функции (индекс источника)
	mov	edi, 1           # rdi = 1 - 1-ый аргумент функции (индекс приёмника)
	call	clock_gettime@PLT
	
	
	# начало цикла for (i = 0, i < len1, i++)
	mov	r15, 0 # i = 0
	jmp	.L13
	
	# тело цикла for (i = 0, i < len1, i++)
.L15:
	mov	rax, r15 # rax = i
	cdqe
	movzx	eax, BYTE PTR -10032[rbp+rax] # rax = адрес str1[i] 
	movsx	edx, al
	mov	ecx, DWORD PTR -40040[rbp] # rcx = len2
	lea	rax, -20032[rbp]           # rax = адрес начала str2
	mov	esi, ecx                   # rsi = len2 - 2-ой аргумент функции (индекс источника)
	mov	rdi, rax                   # rdi = адрес начала str2 - 1-ый аргумент функции (индекс приёмника)
	call	contains               # вызов функции contains(str2, len2, str1[i])
	
	# В eax лежит результат работы функции contains. 0 - значит str2 не содержит str1[i], 1 - содержит
	test	eax, eax   # Происходит сравнение eax, если 0, то значит str2 не содержит str1[i] и не надо 
	                   # выполнять присваивание res1[k++] = str1[i]
	je	.L14           # Просто переходим к следующей итерации цикла, делая i++
	
	# Если всё же eax != 0, то str2 содержит str1[i] и надо выполнить присваивание 
	
	mov	eax, DWORD PTR -8[rbp]     # rax = k
	lea	edx, 1[rax]                # rdx = k++
	mov	DWORD PTR -8[rbp], edx     # k = rdx 
	mov	rdx, r15     # rdx = i
	movsx	rdx, edx               
	movzx	edx, BYTE PTR -10032[rbp+rdx] # rdx = str1[i]
	cdqe
	mov	BYTE PTR -30032[rbp+rax], dl     # res1[k++] = str1[i]
.L14:
	add	r15, 1  # i++ в цикле for (i = 0, i < len1, i++)
.L13:
    # цикл for (i = 0, i < len1, i++)
    
    # условие if (i < len1)
	mov	eax, DWORD PTR -40036[rbp]  
	cmp	r15, rax     
	# если i ещё меньше, продолжаем выполнять тело цикла
	jl	.L15
	
	# начало цикла for (i = 0, i < k, i++)
	mov	r15, 0 # i = 0
	jmp	.L16
	
	# тело цикла for (i = 0, i < k, i++)
.L18:
	mov	rax, r15 # eax = i
	cdqe
	movzx	eax, BYTE PTR -30032[rbp+rax] # rax = адрес res1[i] 
	movsx	edx, al                       # rdx = rax
	mov	ecx, DWORD PTR -12[rbp]           # rcx = n
	lea	rax, -40032[rbp]                  # rax = адрес начала res2   
	mov	esi, ecx                          # rsi = n - 2-ой аргумент функции (индекс источника)
	mov	rdi, rax                          # rdi = адрес начала res2 - 1-ый аргумент функции (индекс приёмника)
	call	contains                      # вызов функции contains(res2, n, res1[i])
	
	
	# В eax лежит результат работы функции contains. 0 - значит res2 содержит res1[i], 1 - не содержит
	test	eax, eax   # Происходит сравнение eax, если 0, то значит res2 содержит res1[i] и не надо 
	                   # выполнять присваивание res2[n++] = res1[n]
	jne	.L17           # Просто переходим к следующей итерации цикла, делая i++
	
	
	# Если всё же eax != 0, то res2 не содержит res1[i] и надо выполнить присваивание 
	
	mov	eax, DWORD PTR -12[rbp]   # rax = n
	lea	edx, 1[rax]               # rdx = n++
	mov	DWORD PTR -12[rbp], edx   # n = rdx
	mov	rdx, r15    # rdx = i
	movsx	rdx, edx
	movzx	edx, BYTE PTR -30032[rbp+rdx] # rdx = res1[i] 
	cdqe
	mov	BYTE PTR -40032[rbp+rax], dl      # res2[n++] = res1[n]
.L17:
	add	r15, 1 # i++ в цикле  for (i = 0, i < k, i++)
	
.L16:

    # переход к телу цикла for (i = 0, i < k, i++), если i < k
	mov	rax, r15 # eax = i
	cmp	eax, DWORD PTR -8[rbp] # сранение i < k
	jl	.L18
	
	
	lea	rax, -40080[rbp]             # адрес переменной end
	mov	rsi, rax                     # rsi = end - 2-ой аргумент функции (индекс источника)
	mov	edi, 1
	call	clock_gettime@PLT
	mov	rax, QWORD PTR -40064[rbp]   # rax = start
	
	mov	rdx, QWORD PTR -40056[rbp]
	mov	rdi, QWORD PTR -40080[rbp]   # rdi = end - 1-ый аргумент функции (индекс приёмника)
	mov	rsi, QWORD PTR -40072[rbp]   
	mov	rcx, rdx
	mov	rdx, rax                     # rdx = start
	call	timespecDiff # Подсчёт elapsed_ns - общего затраченного времени
	
	mov	QWORD PTR -24[rbp], rax     # elapsed_ns = timespecDiff(end, start)
	
	mov	eax, DWORD PTR -40044[rbp]  # rax = type
	
	cmp	eax, 2                      # type == 2 - в конце программы происходит проверка на тип ввода, от которого зависит тип вывода
	                                # если ввод был не из файла, то переходим к конструкции printf("RESULT:   %s", res2);
	                                    
	                                #  /
	je	.L19                        # < Переход к выводу в файл
	                                #  \
	
	
	mov	edi, 10                     #  / Вывод отступа \n 
	call	putchar@PLT             #  \
	
	lea	rax, -40032[rbp]            # rax = адрес начала res2
	
	mov	rsi, rax                    # rsi = res2
	lea	rax, .LC2[rip]              # адрес фразы  RESULT:
	mov	rdi, rax                    # фраза RESULT:
	mov	eax, 0                      # rax = 0
	
	call	printf@PLT              # printf("RESULT:   %s", res2);
	
	jmp	.L20
.L19:
	mov	eax, DWORD PTR -40044[rbp] # rax = type
	cmp	eax, 2                     # type == 2 - ввод из файла, значит вывод тоже из файла
	
	# если type != 2, то сразу переходи к вывод затраченного времени
	jne	.L20        
	
	# type == 2, значит выводи результирующую строку в файл output.txt
	
	mov	edi, 10         #  / Вывод отступа \n 
	call	putchar@PLT #  \
	
	
	lea	rax, .LC3[rip]   # адрес фразы The resulting string...
	mov	rdi, rax         # фраза The resulting string...
	mov	eax, 0           # rax = 0
	call	printf@PLT   # printf("The resulting string is in the output.txt file."); 
	
	lea	rax, .LC4[rip]   # Адрес символа 'w'
	mov	rsi, rax         # Символ 'w'     
	
	lea	rax, .LC5[rip]   # Адрес имени файла для вывода "output.txt"
	mov	rdi, rax         # Имя файла для вывода "output.txt"        
	
	call	fopen@PLT             # fopen("output.txt", "w")  <- результат работы в rax
	mov	QWORD PTR -32[rbp], rax   # output = fopen("output.txt", "w")
	mov	rdx, QWORD PTR -32[rbp]   # rdx = output 
	
	lea	rax, -40032[rbp]          # rax = адрес начала res2
	mov	rsi, rdx                  # rsi = output - 2-ой аргумент функции (индекс источника) 
	mov	rdi, rax                  # rdi = адрес начала res2 - 1-ый аргумент функции (индекс приёмника)
	call	fputs@PLT             # fprintf(output, "%s", res2)
	
	# вывод времени, затраченного на работу со строками
.L20:
	mov	rax, QWORD PTR -24[rbp]     # rax = ellapsed_ns
	mov	rsi, rax                    # rsi = ellapsed_ns - 2-ой аргумент функции (индекс источника)
	
	lea	rax, .LC6[rip]              # адрес фразы Ellapsed ... 
	mov	rdi, rax                    # rdi = фраза Ellapsed - 1-ый аргумент функции (индекс приёмника)
	
	mov	eax, 0                      # rax = 0
	call	printf@PLT              # printf("\nElapsed: %ld ns\n", elapsed_ns)
	mov	eax, 0                      # rax = 0

# Пролог	
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
