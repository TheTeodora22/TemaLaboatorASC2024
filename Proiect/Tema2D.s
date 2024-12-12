.data
    n: .space 4
    nr: .space 4
    d: .space 1
    pr: .long 0
    i: .long 0
    j: .long 0
    dif: .long 0
    i1: .long 0
    i2: .long 0
    j1: .long 0
    j2: .long 0
    index: .long 64
    lin: .long 0
    col: .long 0
    ult: .long 0
    size: .space 4
    instr: .space 4
    memory: .space 4096
    formatString: .asciz "%ld"
    byteformatString: .asciz "%d"
    addOutput: .asciz "%d: ((%d,%d),(%d, %d))\n"
    getOutput: .asciz "((%d,%d),(%d, %d))\n"
    noSpaceMsg: .asciz "(0, 0)\n"
    nothing: .asciz "((0, 0),(0, 0))\n"
    debugMsg: .asciz "SUNT AICI\n"
    debugMsg2: .asciz "%d "
    newLine: .asciz "\n"
    

.text
    FADD:
        lea memory, %edi 
        ;// citeste nr
        pushl $nr
        pushl $formatString
        call scanf
        addl $8, %esp
        LOOP_ADD:
            movl nr, %eax
            cmpl $0, %eax
            je fexit

            pushl $d
            pushl $byteformatString
            call scanf
            popl %ebx
            popl %ebx

            pushl $size
            pushl $formatString
            call scanf
            popl %ebx
            popl %ebx

            subl $1, nr
            

            xorl %edx, %edx
            movl size, %eax
            addl $7, %eax
            movl $8, %ecx
            divl %ecx

            movl %eax, size

            movl $-1,i
        i_loop:
            addl $1, i
            movl i, %eax
            cmp $64, %eax
            je afisare_nimic
            movl $0, j1
            movl $0, j2
            movl $-1, j
            j_loop:
                addl $1, j
                movl j,%eax
                cmpl $64, %eax
                je i_loop
                movl $64, %eax
                movl i, %ebx
                mul %ebx
                addl j, %eax

                xorl %edx, %edx
                movb (%edi,%eax,1), %dl
                cmp $0, %edx
                jne j_loop
            j1_atr:
                movl j, %eax
                movl %eax, j1
            j2_loop:
                addl $1, j
                movl j,%eax
                cmp $64, %eax
                je j2_atr

                movl $64, %eax
                movl i, %ebx
                mul %ebx
                addl j, %eax

                xorl %edx, %edx
                movb (%edi,%eax,1), %dl
                cmp $0, %edx
                je j2_loop
            j2_atr:
                subl $1, j
                movl $64, %eax
                movl i, %ebx
                mul %ebx
                addl j, %eax

                xorl %edx, %edx
                movb (%edi,%eax,1), %dl
                cmp $0, %edx
                jne i_loop

                movl j, %eax
                movl %eax, j2
            space_check:
                addl $1, %eax
                subl j1, %eax
                movl %eax, dif

                cmp %eax, size
                ja i_loop
            
                movl j1, %ecx
                addl size, %ecx
                movl %ecx, ult
                movl j1, %ecx
            add_loop:
                cmp ult, %ecx
                je afisare
                movl $64, %eax
                movl i, %ebx
                mul %ebx
                addl %ecx, %eax

                xorl %edx, %edx
                movb d, %dl
                movb %dl, (%edi, %eax, 1)
                addl $1, %ecx
                jmp add_loop    
            afisare:
                subl $1, ult
                pushl ult
                pushl i
                pushl j1
                pushl i
                xorl %eax,%eax
                movb d, %al
                pushl %eax
                pushl $addOutput
                call printf
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx

                pushl $0
                call fflush
                popl %ebx

                jmp LOOP_ADD
            afisare_nimic:
                pushl $nothing
                call printf
                popl %ebx

                pushl $0
                call fflush
                popl %ebx
                jmp LOOP_ADD
        fexit:
            ret
    FGET:
        pushl $d
        pushl $byteformatString
        call scanf
        popl %ebx
        popl %ebx

        xorl %edx, %edx
        movb d, %dl

        movl $-1,i
        movl $0, j1
        movl $0, j2
        line_loop:
            addl $1, i
            movl i, %eax
            cmpl $64, %eax
            je afisare_nimic_get
            movl $-1,j
            j_loop_get:
                addl $1, j
                movl j, %eax
                cmpl $64, %eax
                je line_loop
                movl $64, %eax
                movl i, %ebx
                mul %ebx
                addl j, %eax

                xorl %ebx, %ebx
                movb (%edi, %eax, 1),%bl

                xorl %edx, %edx
                movb d, %dl

                cmpl %edx, %ebx
                jne j_loop_get

                movl j, %eax
                movl %eax,j1
            j2_loop_get:
                addl $1, j
                movl j, %eax
                cmpl $64, %eax
                je afisareget
                movl $64, %eax
                movl i, %ecx
                mul %ecx
                addl j, %eax

                xorl %ecx, %ecx
                movb (%edi, %eax, 1),%cl

                xorl %edx, %edx
                movb d, %dl

                cmpl %ecx, %edx
                je j2_loop_get 
            afisareget:
                movl j, %eax
                subl $1, %eax
                movl %eax, j2

                pushl j2
                pushl i
                pushl j1
                pushl i
                pushl $getOutput
                call printf
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx

                jmp getexit
            afisare_nimic_get:
                pushl $nothing
                call printf
                popl %ebx

                pushl $0
                call fflush
                popl %ebx
        getexit:
            ret
    FDELETE:
        pushl $d
        pushl $byteformatString
        call scanf
        popl %ebx
        popl %ebx
        xorl %edx,%edx
        movb d, %dl
        movl $-1, i
        del_line_loop:
            addl $1, i
            movl i, %ecx
            cmp $4096, %ecx
            je afisare_mem
            xorl %ebx, %ebx
            movb (%edi, %ecx, 1), %bl
            cmpl %edx, %ebx
            je delete_loop
            jmp del_line_loop
        delete_loop:
            xorl %eax, %eax
            xorl %ebx, %ebx
            movb (%edi, %ecx, 1), %bl
            cmpl %edx, %ebx
            jne afisare_mem
            cmpl $4096, %ecx
            je afisare_mem
            xorl %ebx, %ebx
            movb $0, (%edi, %ecx, 1)
            addl $1, %ecx
            jmp delete_loop
        afisare_mem:
            movl $-1, i
            mem_loop_i:
                addl $1, i
                movl i, %eax
                cmpl $64, %eax
                je delexit
                movl $-1,j
                dif_0:
                    addl $1, j
                    movl j, %eax
                    cmpl $64, %eax
                    je mem_loop_i
                    movl $64, %eax
                    movl i, %ebx
                    mul %ebx
                    addl j, %eax

                    xorl %ebx, %ebx
                    movb (%edi, %eax, 1),%bl

                    cmpl $0, %ebx
                    je dif_0

                    movl j, %eax
                    movl %eax,j1
                j2_find:
                    addl $1, j
                    movl j, %eax
                    cmpl $64, %eax
                    je mem_afis
                    movl $64, %eax
                    movl i, %ecx
                    mul %ecx
                    addl j, %eax

                    xorl %ecx, %ecx
                    movb (%edi, %eax, 1),%cl

                    cmpl %ecx, %ebx
                    je j2_find
                mem_afis:
                    movl j, %eax
                    subl $1, %eax
                    movl %eax, j2

                    pushl j2
                    pushl i
                    pushl j1
                    pushl i
                    pushl %ebx
                    pushl $addOutput
                    call printf
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    popl %ebx

                    jmp mem_loop_i
        delexit:
            ret
    FAFIS:
        movl $0, %ebx
        loop:
            cmpl $4096, %ebx
            je fexitafis

            xorl %edx, %edx
            movl %ebx, %eax
            movl $64, %ecx
            divl %ecx
            cmp $0, %edx
            jne testafis

            pushl $newLine
            call printf
            popl %eax
        testafis:
            movb (%edi,%ebx,1), %dl
            pushl %edx
            pushl $debugMsg2
            call printf
            popl %eax
            popl %eax

            addl $1, %ebx
            jmp loop
        fexitafis:
            ret

.global main
main:
    pushl $n
    pushl $formatString
    call scanf
    popl %ebx
    popl %ebx

    lea memory, %edi
instructiuni:
    movl n, %eax
    cmpl $0, %eax
    je  etexit 

    subl $1, n

    pushl $instr
    pushl $formatString
    call scanf
    popl %ebx
    popl %ebx

    cmpl $1, instr 
    je ADD

    cmpl $2, instr
    je GET

    cmpl $3, instr
    je DELETE
ADD:
    call FADD
    jmp instructiuni
GET:
    call FGET
    jmp instructiuni
DELETE:
    call FDELETE
    call FAFIS
    jmp instructiuni
etexit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
