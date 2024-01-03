bfc04cb0 <n52_bgez_ds_test>:
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:7
bfc04cb0:	26100001 	addiu	s0,s0,1  // TODO s0
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:8
bfc04cb4:	24120000 	li	s2,0
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:10
bfc04cb8:	3c048000 	lui	a0,0x8000
bfc04cbc:	04810006 	bgez	a0,bfc04cd8 <n52_bgez_ds_test+0x28>
bfc04cc0:	3c08800d 	lui	t0,0x800d  // TODO t0
bfc04cc4:	3c16800d 	lui	s6,0x800d
bfc04cc8:	1516019c 	bne	t0,s6,bfc0533c <inst_error>
bfc04ccc:	00000000 	nop
bfc04cd0:	04010003 	b	bfc04ce0 <n52_bgez_ds_test+0x30>
bfc04cd4:	3c17800d 	lui	s7,0x800d
bfc04cd8:	10000198 	b	bfc0533c <inst_error>
bfc04cdc:	00000000 	nop
bfc04ce0:	16f60196 	bne	s7,s6,bfc0533c <inst_error>
bfc04ce4:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:11
bfc04ce8:	3c048000 	lui	a0,0x8000
bfc04cec:	04810006 	bgez	a0,bfc04d08 <n52_bgez_ds_test+0x58>
bfc04cf0:	25098123 	addiu	t1,t0,-32477
bfc04cf4:	25168123 	addiu	s6,t0,-32477
bfc04cf8:	15360190 	bne	t1,s6,bfc0533c <inst_error>
bfc04cfc:	00000000 	nop
bfc04d00:	04010003 	b	bfc04d10 <n52_bgez_ds_test+0x60>
bfc04d04:	25178123 	addiu	s7,t0,-32477
bfc04d08:	1000018c 	b	bfc0533c <inst_error>
bfc04d0c:	00000000 	nop
bfc04d10:	16f6018a 	bne	s7,s6,bfc0533c <inst_error>
bfc04d14:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:12
bfc04d18:	3c048000 	lui	a0,0x8000
bfc04d1c:	04810006 	bgez	a0,bfc04d38 <n52_bgez_ds_test+0x88>
bfc04d20:	ad098ee0 	sw	t1,-28960(t0)
bfc04d24:	ad168ee0 	sw	s6,-28960(t0)
bfc04d28:	15360184 	bne	t1,s6,bfc0533c <inst_error>
bfc04d2c:	00000000 	nop
bfc04d30:	04010003 	b	bfc04d40 <n52_bgez_ds_test+0x90>
bfc04d34:	ad178ee0 	sw	s7,-28960(t0)
bfc04d38:	10000180 	b	bfc0533c <inst_error>
bfc04d3c:	00000000 	nop
bfc04d40:	16f6017e 	bne	s7,s6,bfc0533c <inst_error>
bfc04d44:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:13
bfc04d48:	3c048000 	lui	a0,0x8000
bfc04d4c:	04810006 	bgez	a0,bfc04d68 <n52_bgez_ds_test+0xb8>
bfc04d50:	8d0a8ee0 	lw	t2,-28960(t0)
bfc04d54:	8d168ee0 	lw	s6,-28960(t0)
bfc04d58:	15560178 	bne	t2,s6,bfc0533c <inst_error>
bfc04d5c:	00000000 	nop
bfc04d60:	04010003 	b	bfc04d70 <n52_bgez_ds_test+0xc0>
bfc04d64:	8d178ee0 	lw	s7,-28960(t0)
bfc04d68:	10000174 	b	bfc0533c <inst_error>
bfc04d6c:	00000000 	nop
bfc04d70:	16f60172 	bne	s7,s6,bfc0533c <inst_error>
bfc04d74:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:14
bfc04d78:	3c048000 	lui	a0,0x8000
bfc04d7c:	04810006 	bgez	a0,bfc04d98 <n52_bgez_ds_test+0xe8>
bfc04d80:	012a5821 	addu	t3,t1,t2
bfc04d84:	012ab021 	addu	s6,t1,t2
bfc04d88:	1576016c 	bne	t3,s6,bfc0533c <inst_error>
bfc04d8c:	00000000 	nop
bfc04d90:	04010003 	b	bfc04da0 <n52_bgez_ds_test+0xf0>
bfc04d94:	012ab821 	addu	s7,t1,t2
bfc04d98:	10000168 	b	bfc0533c <inst_error>
bfc04d9c:	00000000 	nop
bfc04da0:	16f60166 	bne	s7,s6,bfc0533c <inst_error>
bfc04da4:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:15
bfc04da8:	3c048000 	lui	a0,0x8000
bfc04dac:	04810006 	bgez	a0,bfc04dc8 <n52_bgez_ds_test+0x118>
bfc04db0:	02326025 	or	t4,s1,s2
bfc04db4:	0232b025 	or	s6,s1,s2
bfc04db8:	15960160 	bne	t4,s6,bfc0533c <inst_error>
bfc04dbc:	00000000 	nop
bfc04dc0:	04010003 	b	bfc04dd0 <n52_bgez_ds_test+0x120>
bfc04dc4:	0232b825 	or	s7,s1,s2
bfc04dc8:	1000015c 	b	bfc0533c <inst_error>
bfc04dcc:	00000000 	nop
bfc04dd0:	16f6015a 	bne	s7,s6,bfc0533c <inst_error>
bfc04dd4:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:16
bfc04dd8:	3c048000 	lui	a0,0x8000
bfc04ddc:	04810006 	bgez	a0,bfc04df8 <n52_bgez_ds_test+0x148>
bfc04de0:	0253682a 	slt	t5,s2,s3
bfc04de4:	0253b02a 	slt	s6,s2,s3
bfc04de8:	15b60154 	bne	t5,s6,bfc0533c <inst_error>
bfc04dec:	00000000 	nop
bfc04df0:	04010003 	b	bfc04e00 <n52_bgez_ds_test+0x150>
bfc04df4:	0253b82a 	slt	s7,s2,s3
bfc04df8:	10000150 	b	bfc0533c <inst_error>
bfc04dfc:	00000000 	nop
bfc04e00:	16f6014e 	bne	s7,s6,bfc0533c <inst_error>
bfc04e04:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:17
bfc04e08:	3c048000 	lui	a0,0x8000
bfc04e0c:	04810006 	bgez	a0,bfc04e28 <n52_bgez_ds_test+0x178>
bfc04e10:	2a4e8011 	slti	t6,s2,-32751
bfc04e14:	2a568011 	slti	s6,s2,-32751
bfc04e18:	15d60148 	bne	t6,s6,bfc0533c <inst_error>
bfc04e1c:	00000000 	nop
bfc04e20:	04010003 	b	bfc04e30 <n52_bgez_ds_test+0x180>
bfc04e24:	2a578011 	slti	s7,s2,-32751
bfc04e28:	10000144 	b	bfc0533c <inst_error>
bfc04e2c:	00000000 	nop
bfc04e30:	16f60142 	bne	s7,s6,bfc0533c <inst_error>
bfc04e34:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:18
bfc04e38:	3c048000 	lui	a0,0x8000
bfc04e3c:	04810006 	bgez	a0,bfc04e58 <n52_bgez_ds_test+0x1a8>
bfc04e40:	2e4f8011 	sltiu	t7,s2,-32751
bfc04e44:	2e568011 	sltiu	s6,s2,-32751
bfc04e48:	15f6013c 	bne	t7,s6,bfc0533c <inst_error>
bfc04e4c:	00000000 	nop
bfc04e50:	04010003 	b	bfc04e60 <n52_bgez_ds_test+0x1b0>
bfc04e54:	2e578011 	sltiu	s7,s2,-32751
bfc04e58:	10000138 	b	bfc0533c <inst_error>
bfc04e5c:	00000000 	nop
bfc04e60:	16f60136 	bne	s7,s6,bfc0533c <inst_error>
bfc04e64:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:19
bfc04e68:	3c048000 	lui	a0,0x8000
bfc04e6c:	04810006 	bgez	a0,bfc04e88 <n52_bgez_ds_test+0x1d8>
bfc04e70:	0253c02b 	sltu	t8,s2,s3
bfc04e74:	0253b02b 	sltu	s6,s2,s3
bfc04e78:	17160130 	bne	t8,s6,bfc0533c <inst_error>
bfc04e7c:	00000000 	nop
bfc04e80:	04010003 	b	bfc04e90 <n52_bgez_ds_test+0x1e0>
bfc04e84:	0253b82b 	sltu	s7,s2,s3
bfc04e88:	1000012c 	b	bfc0533c <inst_error>
bfc04e8c:	00000000 	nop
bfc04e90:	16f6012a 	bne	s7,s6,bfc0533c <inst_error>
bfc04e94:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:20
bfc04e98:	3c048000 	lui	a0,0x8000
bfc04e9c:	04810006 	bgez	a0,bfc04eb8 <n52_bgez_ds_test+0x208>
bfc04ea0:	00124c40 	sll	t1,s2,0x11
bfc04ea4:	0012b440 	sll	s6,s2,0x11
bfc04ea8:	15360124 	bne	t1,s6,bfc0533c <inst_error>
bfc04eac:	00000000 	nop
bfc04eb0:	04010003 	b	bfc04ec0 <n52_bgez_ds_test+0x210>
bfc04eb4:	0012bc40 	sll	s7,s2,0x11
bfc04eb8:	10000120 	b	bfc0533c <inst_error>
bfc04ebc:	00000000 	nop
bfc04ec0:	16f6011e 	bne	s7,s6,bfc0533c <inst_error>
bfc04ec4:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:21
bfc04ec8:	3c048000 	lui	a0,0x8000
bfc04ecc:	04810006 	bgez	a0,bfc04ee8 <n52_bgez_ds_test+0x238>
bfc04ed0:	01105020 	add	t2,t0,s0
bfc04ed4:	0110b020 	add	s6,t0,s0
bfc04ed8:	15560118 	bne	t2,s6,bfc0533c <inst_error>
bfc04edc:	00000000 	nop
bfc04ee0:	04010003 	b	bfc04ef0 <n52_bgez_ds_test+0x240>
bfc04ee4:	0110b820 	add	s7,t0,s0
bfc04ee8:	10000114 	b	bfc0533c <inst_error>
bfc04eec:	00000000 	nop
bfc04ef0:	16f60112 	bne	s7,s6,bfc0533c <inst_error>
bfc04ef4:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:22
bfc04ef8:	3c048000 	lui	a0,0x8000
bfc04efc:	04810006 	bgez	a0,bfc04f18 <n52_bgez_ds_test+0x268>
bfc04f00:	220b8002 	addi	t3,s0,-32766
bfc04f04:	22168002 	addi	s6,s0,-32766
bfc04f08:	1576010c 	bne	t3,s6,bfc0533c <inst_error>
bfc04f0c:	00000000 	nop
bfc04f10:	04010003 	b	bfc04f20 <n52_bgez_ds_test+0x270>
bfc04f14:	22178002 	addi	s7,s0,-32766
bfc04f18:	10000108 	b	bfc0533c <inst_error>
bfc04f1c:	00000000 	nop
bfc04f20:	16f60106 	bne	s7,s6,bfc0533c <inst_error>
bfc04f24:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:23
bfc04f28:	3c048000 	lui	a0,0x8000
bfc04f2c:	04810006 	bgez	a0,bfc04f48 <n52_bgez_ds_test+0x298>
bfc04f30:	01106022 	sub	t4,t0,s0
bfc04f34:	0110b022 	sub	s6,t0,s0
bfc04f38:	15960100 	bne	t4,s6,bfc0533c <inst_error>
bfc04f3c:	00000000 	nop
bfc04f40:	04010003 	b	bfc04f50 <n52_bgez_ds_test+0x2a0>
bfc04f44:	0110b822 	sub	s7,t0,s0
bfc04f48:	100000fc 	b	bfc0533c <inst_error>
bfc04f4c:	00000000 	nop
bfc04f50:	16f600fa 	bne	s7,s6,bfc0533c <inst_error>
bfc04f54:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:24
bfc04f58:	3c048000 	lui	a0,0x8000
bfc04f5c:	04810006 	bgez	a0,bfc04f78 <n52_bgez_ds_test+0x2c8>
bfc04f60:	01106823 	subu	t5,t0,s0
bfc04f64:	0110b023 	subu	s6,t0,s0
bfc04f68:	15b600f4 	bne	t5,s6,bfc0533c <inst_error>
bfc04f6c:	00000000 	nop
bfc04f70:	04010003 	b	bfc04f80 <n52_bgez_ds_test+0x2d0>
bfc04f74:	0110b823 	subu	s7,t0,s0
bfc04f78:	100000f0 	b	bfc0533c <inst_error>
bfc04f7c:	00000000 	nop
bfc04f80:	16f600ee 	bne	s7,s6,bfc0533c <inst_error>
bfc04f84:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:25
bfc04f88:	3c048000 	lui	a0,0x8000
bfc04f8c:	04810006 	bgez	a0,bfc04fa8 <n52_bgez_ds_test+0x2f8>
bfc04f90:	01107024 	and	t6,t0,s0
bfc04f94:	0110b024 	and	s6,t0,s0
bfc04f98:	15d600e8 	bne	t6,s6,bfc0533c <inst_error>
bfc04f9c:	00000000 	nop
bfc04fa0:	04010003 	b	bfc04fb0 <n52_bgez_ds_test+0x300>
bfc04fa4:	0110b824 	and	s7,t0,s0
bfc04fa8:	100000e4 	b	bfc0533c <inst_error>
bfc04fac:	00000000 	nop
bfc04fb0:	16f600e2 	bne	s7,s6,bfc0533c <inst_error>
bfc04fb4:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:26
bfc04fb8:	3c048000 	lui	a0,0x8000
bfc04fbc:	04810006 	bgez	a0,bfc04fd8 <n52_bgez_ds_test+0x328>
bfc04fc0:	320f8ff2 	andi	t7,s0,0x8ff2
bfc04fc4:	32168ff2 	andi	s6,s0,0x8ff2
bfc04fc8:	15f600dc 	bne	t7,s6,bfc0533c <inst_error>
bfc04fcc:	00000000 	nop
bfc04fd0:	04010003 	b	bfc04fe0 <n52_bgez_ds_test+0x330>
bfc04fd4:	32178ff2 	andi	s7,s0,0x8ff2
bfc04fd8:	100000d8 	b	bfc0533c <inst_error>
bfc04fdc:	00000000 	nop
bfc04fe0:	16f600d6 	bne	s7,s6,bfc0533c <inst_error>
bfc04fe4:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:27
bfc04fe8:	3c048000 	lui	a0,0x8000
bfc04fec:	04810006 	bgez	a0,bfc05008 <n52_bgez_ds_test+0x358>
bfc04ff0:	0110c027 	nor	t8,t0,s0
bfc04ff4:	0110b027 	nor	s6,t0,s0
bfc04ff8:	171600d0 	bne	t8,s6,bfc0533c <inst_error>
bfc04ffc:	00000000 	nop
bfc05000:	04010003 	b	bfc05010 <n52_bgez_ds_test+0x360>
bfc05004:	0110b827 	nor	s7,t0,s0
bfc05008:	100000cc 	b	bfc0533c <inst_error>
bfc0500c:	00000000 	nop
bfc05010:	16f600ca 	bne	s7,s6,bfc0533c <inst_error>
bfc05014:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:28
bfc05018:	3c048000 	lui	a0,0x8000
bfc0501c:	04810006 	bgez	a0,bfc05038 <n52_bgez_ds_test+0x388>
bfc05020:	36098ff2 	ori	t1,s0,0x8ff2
bfc05024:	36168ff2 	ori	s6,s0,0x8ff2
bfc05028:	153600c4 	bne	t1,s6,bfc0533c <inst_error>
bfc0502c:	00000000 	nop
bfc05030:	04010003 	b	bfc05040 <n52_bgez_ds_test+0x390>
bfc05034:	36178ff2 	ori	s7,s0,0x8ff2
bfc05038:	100000c0 	b	bfc0533c <inst_error>
bfc0503c:	00000000 	nop
bfc05040:	16f600be 	bne	s7,s6,bfc0533c <inst_error>
bfc05044:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:29
bfc05048:	3c048000 	lui	a0,0x8000
bfc0504c:	04810006 	bgez	a0,bfc05068 <n52_bgez_ds_test+0x3b8>
bfc05050:	01105026 	xor	t2,t0,s0
bfc05054:	0110b026 	xor	s6,t0,s0
bfc05058:	155600b8 	bne	t2,s6,bfc0533c <inst_error>
bfc0505c:	00000000 	nop
bfc05060:	04010003 	b	bfc05070 <n52_bgez_ds_test+0x3c0>
bfc05064:	0110b826 	xor	s7,t0,s0
bfc05068:	100000b4 	b	bfc0533c <inst_error>
bfc0506c:	00000000 	nop
bfc05070:	16f600b2 	bne	s7,s6,bfc0533c <inst_error>
bfc05074:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:30
bfc05078:	3c048000 	lui	a0,0x8000
bfc0507c:	04810006 	bgez	a0,bfc05098 <n52_bgez_ds_test+0x3e8>
bfc05080:	3a0b8ff2 	xori	t3,s0,0x8ff2
bfc05084:	3a168ff2 	xori	s6,s0,0x8ff2
bfc05088:	157600ac 	bne	t3,s6,bfc0533c <inst_error>
bfc0508c:	00000000 	nop
bfc05090:	04010003 	b	bfc050a0 <n52_bgez_ds_test+0x3f0>
bfc05094:	3a178ff2 	xori	s7,s0,0x8ff2
bfc05098:	100000a8 	b	bfc0533c <inst_error>
bfc0509c:	00000000 	nop
bfc050a0:	16f600a6 	bne	s7,s6,bfc0533c <inst_error>
bfc050a4:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:31
bfc050a8:	3c048000 	lui	a0,0x8000
bfc050ac:	04810006 	bgez	a0,bfc050c8 <n52_bgez_ds_test+0x418>
bfc050b0:	02086004 	sllv	t4,t0,s0
bfc050b4:	0208b004 	sllv	s6,t0,s0
bfc050b8:	159600a0 	bne	t4,s6,bfc0533c <inst_error>
bfc050bc:	00000000 	nop
bfc050c0:	04010003 	b	bfc050d0 <n52_bgez_ds_test+0x420>
bfc050c4:	0208b804 	sllv	s7,t0,s0
bfc050c8:	1000009c 	b	bfc0533c <inst_error>
bfc050cc:	00000000 	nop
bfc050d0:	16f6009a 	bne	s7,s6,bfc0533c <inst_error>
bfc050d4:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:32
bfc050d8:	3c048000 	lui	a0,0x8000
bfc050dc:	04810006 	bgez	a0,bfc050f8 <n52_bgez_ds_test+0x448>
bfc050e0:	00106a03 	sra	t5,s0,0x8
bfc050e4:	0010b203 	sra	s6,s0,0x8
bfc050e8:	15b60094 	bne	t5,s6,bfc0533c <inst_error>
bfc050ec:	00000000 	nop
bfc050f0:	04010003 	b	bfc05100 <n52_bgez_ds_test+0x450>
bfc050f4:	0010ba03 	sra	s7,s0,0x8
bfc050f8:	10000090 	b	bfc0533c <inst_error>
bfc050fc:	00000000 	nop
bfc05100:	16f6008e 	bne	s7,s6,bfc0533c <inst_error>
bfc05104:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:33
bfc05108:	3c048000 	lui	a0,0x8000
bfc0510c:	04810006 	bgez	a0,bfc05128 <n52_bgez_ds_test+0x478>
bfc05110:	02087007 	srav	t6,t0,s0  ## t0=0x800d0000 s0=0x34 // TAG
bfc05114:	0208b007 	srav	s6,t0,s0
bfc05118:	15d60088 	bne	t6,s6,bfc0533c <inst_error>
bfc0511c:	00000000 	nop
bfc05120:	04010003 	b	bfc05130 <n52_bgez_ds_test+0x480>
bfc05124:	0208b807 	srav	s7,t0,s0
bfc05128:	10000084 	b	bfc0533c <inst_error>
bfc0512c:	00000000 	nop
bfc05130:	16f60082 	bne	s7,s6,bfc0533c <inst_error>
bfc05134:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:34
bfc05138:	3c048000 	lui	a0,0x8000
bfc0513c:	04810006 	bgez	a0,bfc05158 <n52_bgez_ds_test+0x4a8>
bfc05140:	00107a02 	srl	t7,s0,0x8
bfc05144:	0010b202 	srl	s6,s0,0x8
bfc05148:	15f6007c 	bne	t7,s6,bfc0533c <inst_error>
bfc0514c:	00000000 	nop
bfc05150:	04010003 	b	bfc05160 <n52_bgez_ds_test+0x4b0>
bfc05154:	0010ba02 	srl	s7,s0,0x8
bfc05158:	10000078 	b	bfc0533c <inst_error>
bfc0515c:	00000000 	nop
bfc05160:	16f60076 	bne	s7,s6,bfc0533c <inst_error>
bfc05164:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:35
bfc05168:	3c048000 	lui	a0,0x8000
bfc0516c:	04810006 	bgez	a0,bfc05188 <n52_bgez_ds_test+0x4d8>
bfc05170:	0208c006 	srlv	t8,t0,s0
bfc05174:	0208b006 	srlv	s6,t0,s0
bfc05178:	17160070 	bne	t8,s6,bfc0533c <inst_error>
bfc0517c:	00000000 	nop
bfc05180:	04010003 	b	bfc05190 <n52_bgez_ds_test+0x4e0>
bfc05184:	0208b806 	srlv	s7,t0,s0
bfc05188:	1000006c 	b	bfc0533c <inst_error>
bfc0518c:	00000000 	nop
bfc05190:	16f6006a 	bne	s7,s6,bfc0533c <inst_error>
bfc05194:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:36
bfc05198:	3c088000 	lui	t0,0x8000  // TODO t0
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:37
bfc0519c:	34098000 	li	t1,0x8000
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:38
bfc051a0:	3c048000 	lui	a0,0x8000
bfc051a4:	24020000 	li	v0,0
bfc051a8:	24030000 	li	v1,0
bfc051ac:	0481000a 	bgez	a0,bfc051d8 <n52_bgez_ds_test+0x528>
bfc051b0:	0109001a 	div	zero,t0,t1
bfc051b4:	00001012 	mflo	v0
bfc051b8:	00800013 	mtlo	a0
bfc051bc:	0109001a 	div	zero,t0,t1
bfc051c0:	0000b012 	mflo	s6
bfc051c4:	1456005d 	bne	v0,s6,bfc0533c <inst_error>
bfc051c8:	00000000 	nop
bfc051cc:	00800013 	mtlo	a0
bfc051d0:	04010003 	b	bfc051e0 <n52_bgez_ds_test+0x530>
bfc051d4:	0109001a 	div	zero,t0,t1
bfc051d8:	10000058 	b	bfc0533c <inst_error>
bfc051dc:	00000000 	nop
bfc051e0:	00001812 	mflo	v1
bfc051e4:	14760055 	bne	v1,s6,bfc0533c <inst_error>
bfc051e8:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:39
bfc051ec:	3c048000 	lui	a0,0x8000
bfc051f0:	24020000 	li	v0,0
bfc051f4:	24030000 	li	v1,0
bfc051f8:	0481000a 	bgez	a0,bfc05224 <n52_bgez_ds_test+0x574>
bfc051fc:	0109001b 	divu	zero,t0,t1
bfc05200:	00001012 	mflo	v0
bfc05204:	00800013 	mtlo	a0
bfc05208:	0109001b 	divu	zero,t0,t1
bfc0520c:	0000b012 	mflo	s6
bfc05210:	1456004a 	bne	v0,s6,bfc0533c <inst_error>
bfc05214:	00000000 	nop
bfc05218:	00800013 	mtlo	a0
bfc0521c:	04010003 	b	bfc0522c <n52_bgez_ds_test+0x57c>
bfc05220:	0109001b 	divu	zero,t0,t1
bfc05224:	10000045 	b	bfc0533c <inst_error>
bfc05228:	00000000 	nop
bfc0522c:	00001812 	mflo	v1
bfc05230:	14760042 	bne	v1,s6,bfc0533c <inst_error>
bfc05234:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:40
bfc05238:	3c048000 	lui	a0,0x8000
bfc0523c:	24020000 	li	v0,0
bfc05240:	24030000 	li	v1,0
bfc05244:	0481000a 	bgez	a0,bfc05270 <n52_bgez_ds_test+0x5c0>
bfc05248:	01090018 	mult	t0,t1
bfc0524c:	00001012 	mflo	v0
bfc05250:	00800013 	mtlo	a0
bfc05254:	01090018 	mult	t0,t1
bfc05258:	0000b012 	mflo	s6
bfc0525c:	14560037 	bne	v0,s6,bfc0533c <inst_error>
bfc05260:	00000000 	nop
bfc05264:	00800013 	mtlo	a0
bfc05268:	04010003 	b	bfc05278 <n52_bgez_ds_test+0x5c8>
bfc0526c:	01090018 	mult	t0,t1
bfc05270:	10000032 	b	bfc0533c <inst_error>
bfc05274:	00000000 	nop
bfc05278:	00001812 	mflo	v1
bfc0527c:	1476002f 	bne	v1,s6,bfc0533c <inst_error>
bfc05280:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:41
bfc05284:	3c048000 	lui	a0,0x8000
bfc05288:	24020000 	li	v0,0
bfc0528c:	24030000 	li	v1,0
bfc05290:	0481000a 	bgez	a0,bfc052bc <n52_bgez_ds_test+0x60c>
bfc05294:	01090019 	multu	t0,t1
bfc05298:	00001012 	mflo	v0
bfc0529c:	00800013 	mtlo	a0
bfc052a0:	01090019 	multu	t0,t1
bfc052a4:	0000b012 	mflo	s6
bfc052a8:	14560024 	bne	v0,s6,bfc0533c <inst_error>
bfc052ac:	00000000 	nop
bfc052b0:	00800013 	mtlo	a0
bfc052b4:	04010003 	b	bfc052c4 <n52_bgez_ds_test+0x614>
bfc052b8:	01090019 	multu	t0,t1
bfc052bc:	1000001f 	b	bfc0533c <inst_error>
bfc052c0:	00000000 	nop
bfc052c4:	00001812 	mflo	v1
bfc052c8:	1476001c 	bne	v1,s6,bfc0533c <inst_error>
bfc052cc:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:42
bfc052d0:	3c048000 	lui	a0,0x8000
bfc052d4:	04810006 	bgez	a0,bfc052f0 <n52_bgez_ds_test+0x640>
bfc052d8:	00007810 	mfhi	t7
bfc052dc:	0000b010 	mfhi	s6
bfc052e0:	15f60016 	bne	t7,s6,bfc0533c <inst_error>
bfc052e4:	00000000 	nop
bfc052e8:	04010003 	b	bfc052f8 <n52_bgez_ds_test+0x648>
bfc052ec:	0000b810 	mfhi	s7
bfc052f0:	10000012 	b	bfc0533c <inst_error>
bfc052f4:	00000000 	nop
bfc052f8:	16f60010 	bne	s7,s6,bfc0533c <inst_error>
bfc052fc:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:43
bfc05300:	3c048000 	lui	a0,0x8000
bfc05304:	04810006 	bgez	a0,bfc05320 <n52_bgez_ds_test+0x670>
bfc05308:	00007012 	mflo	t6
bfc0530c:	0000b012 	mflo	s6
bfc05310:	15d6000a 	bne	t6,s6,bfc0533c <inst_error>
bfc05314:	00000000 	nop
bfc05318:	04010003 	b	bfc05328 <n52_bgez_ds_test+0x678>
bfc0531c:	0000b812 	mflo	s7
bfc05320:	10000006 	b	bfc0533c <inst_error>
bfc05324:	00000000 	nop
bfc05328:	16f60004 	bne	s7,s6,bfc0533c <inst_error>
bfc0532c:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:45
bfc05330:	16400002 	bnez	s2,bfc0533c <inst_error>
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:46
bfc05334:	00000000 	nop
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:48
bfc05338:	26730001 	addiu	s3,s3,1

bfc0533c <inst_error>:
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:51
bfc0533c:	00104e00 	sll	t1,s0,0x18
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:52
bfc05340:	01334025 	or	t0,t1,s3 // TODO t0
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:53
bfc05344:	ae280000 	sw	t0,0(s1)
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:54
bfc05348:	03e00008 	jr	ra
/home/rain/loongson/func_board/inst/n52_bgez_ds.S:55
bfc0534c:	00000000 	nop