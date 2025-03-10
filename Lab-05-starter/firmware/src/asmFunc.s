/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
@ Define the globals so that the C code can access them
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Jeremiah McNamee"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */
 
/* define and initialize global variables that C can access */

.global dividend,divisor,quotient,mod,we_have_a_problem
.type dividend,%gnu_unique_object
.type divisor,%gnu_unique_object
.type quotient,%gnu_unique_object
.type mod,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
dividend:          .word     0  
divisor:           .word     0  
quotient:          .word     0  
mod:               .word     0 
we_have_a_problem: .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
    
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmFunc.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 5 Division
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/

    /* store the input values of dividend and divisor in memory for later use*/
    /*first load the dividend and divisor address, then store each value*/
    LDR R4, =dividend
    STR R0, [R4]
    LDR R4, =divisor
    STR R1, [R4]
    
    /* initialize the values for quotient and remainder*/
    /* reg 2 will hold the quotient*/
    MOV R2, 0
    /* reg 3 will hold the remainder(mod)*/
    MOV R3, 0
    /* save the input for quotient in memory */
    LDR R4, =quotient
    STR R2, [R4]
    /* save the input for remainder (mod) in memory */
    LDR R4, =mod
    STR R3, [R4]
    
    /* error handling check for division by 0 */
    /* by comparing the value of the dividend and divisor to 0 */
    CMP R0, 0
    /*if true and r0 == 0 branch away to handle error*/
    BEQ error_case
    CMP R1, 0
    BEQ error_case
    
   /* perform division case by method of successive subtraction*/ 
   division_loop:
    /*check if we are in operating limits seeing if the dividend < divisor */
    CMP R0, R1
    /*if yes, then we are done mathing and can exit the loop & store the mod */
    BLT store_remainder
    
    /* otherwise r0 > r1 and we can sub the divisor from the dividend*/
    SUB R0, R0, R1
    /* increment the quotient by 1 indicating a round of division completed*/
    ADD R2, R2, 1
    
    /*we need to repeat the process until dividend < divisor,
     branch back to beginning of loop */
    B division_loop
    
    /* After exiting div loop, r0 has the mod, and r2 has the quotient count.*/
    store_remainder:
    /* we need to save the mod and final quotient in the mem*/
    LDR R4, =mod
    STR R0, [R4]

    LDR R4, =quotient
    STR R2, [R4]
    
    /* mark for completion and reset any flags for error*/
    MOV R4, 0
    LDR R5, =we_have_a_problem
    STR R4, [R5]
    
    /*we can now return the final quotient value */
    LDR R0, =quotient
    /*and leave the function*/
    B done
    
    error_case:
    /*we can handle any division error by setting the we_have_a_problem flag,
    and returning only the address of the quotient*/
    /*set error flag*/
    MOV R4, 1
    LDR R5, =we_have_a_problem
    STR R4, [R5]
    
    /* make sure I am returning the address of quotient */
    LDR R0, =quotient
    B done
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




