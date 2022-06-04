_reset:
cpsid if

MRC p15,0,r0,c1,c0,2    // Read CP Access register
ORR r0,r0,#0x00f00000   // Enable full access to NEON/VFP (Coprocessors 10 and 11)
MCR p15,0,r0,c1,c0,2    // Write CP Access register
ISB                     //sync the instruction above
MOV r0,#0x40000000      // Switch on the VFP and NEON hardware
VMSR FPEXC,r0            // Set EN bit in FPEXC

mov sp, #0x4000         //设置栈顶
//这里是测试代码

//测试代码结束
//点亮LED灯，由电路图可知，PL10和PA10都连着灯，我们尝试点亮PL10
//设置GPIO PL10为输出
LDR	R0,=0x1F02C04
LDR	R1,=0x7177
STR	R1,[R0]
//灭掉LED
start:
LDR	R0,=0x1F02C10
LDR	R1,=0x400
STR	R1,[R0]
//延时
MOV		R0,#0x80000
MOV		R1,#0
loop1:
ADD		R1,R1,#1
CMP		R0,R1
BNE		loop1
//点亮LED
LDR	R0,=0x1F02C10
LDR	R1,=0
STR	R1,[R0]
//延时
MOV		R0,#0x80000
MOV		R1,#0
loop2:
ADD		R1,R1,#1
CMP		R0,R1
BNE		loop2
b start