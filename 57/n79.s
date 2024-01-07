bfc308a0 <n79_bne_ds_ex_test>:
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:7
bfc308a0:	26100001 	addiu	s0,s0,1
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:8
bfc308a4:	3c08800d 	lui	t0,0x800d
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:10
bfc308a8:	40805800 	mtc0	zero,$11
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:11
bfc308ac:	3c170040 	lui	s7,0x40
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:12
bfc308b0:	40976000 	mtc0	s7,c0_sr
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:13
bfc308b4:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:16
bfc308b8:	24120001 	li	s2,1
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:17
bfc308bc:	3c170001 	lui	s7,0x1
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:18
bfc308c0:	ad120000 	sw	s2,0(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:19
bfc308c4:	3c14bfc3 	lui	s4,0xbfc3
bfc308c8:	269408cc 	addiu	s4,s4,2252
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:20
bfc308cc:	140000af 	bnez	zero,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:21
bfc308d0:	0000000c 	syscall
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:22
bfc308d4:	165700ad 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:23
bfc308d8:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:24
bfc308dc:	24120001 	li	s2,1
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:25
bfc308e0:	3c14bfc3 	lui	s4,0xbfc3
bfc308e4:	269408e8 	addiu	s4,s4,2280
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:26
bfc308e8:	150000a8 	bnez	t0,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:27
bfc308ec:	0000000c 	syscall
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:28
bfc308f0:	165700a6 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:29
bfc308f4:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:31
bfc308f8:	24120002 	li	s2,2
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:32
bfc308fc:	3c170002 	lui	s7,0x2
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:33
bfc30900:	ad120000 	sw	s2,0(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:34
bfc30904:	3c14bfc3 	lui	s4,0xbfc3
bfc30908:	2694090c 	addiu	s4,s4,2316
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:35
bfc3090c:	1400009f 	bnez	zero,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:36
bfc30910:	0000000d 	break
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:37
bfc30914:	1657009d 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:38
bfc30918:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:39
bfc3091c:	24120002 	li	s2,2
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:40
bfc30920:	3c14bfc3 	lui	s4,0xbfc3
bfc30924:	26940928 	addiu	s4,s4,2344
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:41
bfc30928:	15000098 	bnez	t0,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:42
bfc3092c:	0000000d 	break
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:43
bfc30930:	16570096 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:44
bfc30934:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:46
bfc30938:	24120003 	li	s2,3
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:47
bfc3093c:	3c170003 	lui	s7,0x3
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:48
bfc30940:	ad120000 	sw	s2,0(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:49
bfc30944:	3c14bfc3 	lui	s4,0xbfc3
bfc30948:	2694095c 	addiu	s4,s4,2396
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:50
bfc3094c:	3c04ba03 	lui	a0,0xba03
bfc30950:	34844f60 	ori	a0,a0,0x4f60
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:51
bfc30954:	3c05b615 	lui	a1,0xb615
bfc30958:	34a5fd67 	ori	a1,a1,0xfd67
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:52
bfc3095c:	1400008b 	bnez	zero,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:53
bfc30960:	0085b820 	add	s7,a0,a1
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:54
bfc30964:	16570089 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:55
bfc30968:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:56
bfc3096c:	24120003 	li	s2,3
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:57
bfc30970:	3c14bfc3 	lui	s4,0xbfc3
bfc30974:	26940978 	addiu	s4,s4,2424
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:58
bfc30978:	15000084 	bnez	t0,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:59
bfc3097c:	0085b820 	add	s7,a0,a1
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:60
bfc30980:	16570082 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:61
bfc30984:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:62
bfc30988:	24120003 	li	s2,3
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:63
bfc3098c:	3c14bfc3 	lui	s4,0xbfc3
bfc30990:	2694099c 	addiu	s4,s4,2460
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:64
bfc30994:	3c047fff 	lui	a0,0x7fff
bfc30998:	3484c19e 	ori	a0,a0,0xc19e
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:65
bfc3099c:	1400007b 	bnez	zero,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:66
bfc309a0:	20976512 	addi	s7,a0,25874
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:67
bfc309a4:	16570079 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:68
bfc309a8:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:69
bfc309ac:	24120003 	li	s2,3
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:70
bfc309b0:	3c14bfc3 	lui	s4,0xbfc3
bfc309b4:	269409b8 	addiu	s4,s4,2488
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:71
bfc309b8:	15000074 	bnez	t0,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:72
bfc309bc:	20976512 	addi	s7,a0,25874
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:73
bfc309c0:	16570072 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:74
bfc309c4:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:75
bfc309c8:	24120003 	li	s2,3
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:76
bfc309cc:	3c14bfc3 	lui	s4,0xbfc3
bfc309d0:	269409e4 	addiu	s4,s4,2532
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:77
bfc309d4:	3c04a85e 	lui	a0,0xa85e
bfc309d8:	34847d00 	ori	a0,a0,0x7d00
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:78
bfc309dc:	3c056b7e 	lui	a1,0x6b7e
bfc309e0:	34a58e36 	ori	a1,a1,0x8e36
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:79
bfc309e4:	14000069 	bnez	zero,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:80
bfc309e8:	0085b822 	sub	s7,a0,a1
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:81
bfc309ec:	16570067 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:82
bfc309f0:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:83
bfc309f4:	24120003 	li	s2,3
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:84
bfc309f8:	3c14bfc3 	lui	s4,0xbfc3
bfc309fc:	26940a00 	addiu	s4,s4,2560
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:85
bfc30a00:	15000062 	bnez	t0,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:86
bfc30a04:	0085b822 	sub	s7,a0,a1
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:87
bfc30a08:	16570060 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:88
bfc30a0c:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:90
bfc30a10:	24120004 	li	s2,4
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:91
bfc30a14:	3c170004 	lui	s7,0x4
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:92
bfc30a18:	ad120000 	sw	s2,0(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:93
bfc30a1c:	3c14bfc3 	lui	s4,0xbfc3
bfc30a20:	26940a24 	addiu	s4,s4,2596
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:94
bfc30a24:	14000059 	bnez	zero,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:95
bfc30a28:	8d170002 	lw	s7,2(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:96
bfc30a2c:	ad170000 	sw	s7,0(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:97
bfc30a30:	16570056 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:98
bfc30a34:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:99
bfc30a38:	24120004 	li	s2,4
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:100
bfc30a3c:	ad120000 	sw	s2,0(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:101
bfc30a40:	3c14bfc3 	lui	s4,0xbfc3
bfc30a44:	26940a48 	addiu	s4,s4,2632
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:102
bfc30a48:	15000050 	bnez	t0,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:103
bfc30a4c:	8d170002 	lw	s7,2(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:104
bfc30a50:	1657004e 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:105
bfc30a54:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:106
bfc30a58:	24120004 	li	s2,4
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:107
bfc30a5c:	3c14bfc3 	lui	s4,0xbfc3
bfc30a60:	26940a64 	addiu	s4,s4,2660
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:108
bfc30a64:	14000049 	bnez	zero,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:109
bfc30a68:	85170001 	lh	s7,1(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:110
bfc30a6c:	16570047 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:111
bfc30a70:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:112
bfc30a74:	24120004 	li	s2,4
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:113
bfc30a78:	3c14bfc3 	lui	s4,0xbfc3
bfc30a7c:	26940a80 	addiu	s4,s4,2688
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:114
bfc30a80:	15000042 	bnez	t0,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:115
bfc30a84:	85170001 	lh	s7,1(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:116
bfc30a88:	16570040 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:117
bfc30a8c:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:118
bfc30a90:	3c14bfc3 	lui	s4,0xbfc3
bfc30a94:	26940a98 	addiu	s4,s4,2712
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:119
bfc30a98:	1400003c 	bnez	zero,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:120
bfc30a9c:	95170003 	lhu	s7,3(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:121
bfc30aa0:	1657003a 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:122
bfc30aa4:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:123
bfc30aa8:	24120004 	li	s2,4
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:124
bfc30aac:	3c14bfc3 	lui	s4,0xbfc3
bfc30ab0:	26940ab4 	addiu	s4,s4,2740
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:125
bfc30ab4:	15000035 	bnez	t0,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:126
bfc30ab8:	95170003 	lhu	s7,3(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:127
bfc30abc:	16570033 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:128
bfc30ac0:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:130
bfc30ac4:	24120005 	li	s2,5
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:131
bfc30ac8:	3c170005 	lui	s7,0x5
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:132
bfc30acc:	ad120000 	sw	s2,0(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:133
bfc30ad0:	3c14bfc3 	lui	s4,0xbfc3
bfc30ad4:	26940ad8 	addiu	s4,s4,2776
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:134
bfc30ad8:	1400002c 	bnez	zero,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:135
bfc30adc:	ad170002 	sw	s7,2(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:136
bfc30ae0:	02f2001b 	divu	zero,s7,s2
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:137
bfc30ae4:	16570029 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:138
bfc30ae8:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:139
bfc30aec:	24120005 	li	s2,5
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:140
bfc30af0:	3c14bfc3 	lui	s4,0xbfc3
bfc30af4:	26940af8 	addiu	s4,s4,2808
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:141
bfc30af8:	15000024 	bnez	t0,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:142
bfc30afc:	ad170002 	sw	s7,2(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:143
bfc30b00:	16570022 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:144
bfc30b04:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:145
bfc30b08:	24120005 	li	s2,5
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:146
bfc30b0c:	3c14bfc3 	lui	s4,0xbfc3
bfc30b10:	26940b14 	addiu	s4,s4,2836
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:147
bfc30b14:	1400001d 	bnez	zero,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:148
bfc30b18:	a5170001 	sh	s7,1(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:149
bfc30b1c:	1657001b 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:150
bfc30b20:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:151
bfc30b24:	24120005 	li	s2,5
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:152
bfc30b28:	3c14bfc3 	lui	s4,0xbfc3
bfc30b2c:	26940b30 	addiu	s4,s4,2864
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:153
bfc30b30:	15000016 	bnez	t0,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:154
bfc30b34:	a5170001 	sh	s7,1(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:155
bfc30b38:	16570014 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:156
bfc30b3c:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:159
bfc30b40:	24120007 	li	s2,7
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:160
bfc30b44:	3c170007 	lui	s7,0x7
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:161
bfc30b48:	ad120000 	sw	s2,0(t0)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:162
bfc30b4c:	3c14bfc3 	lui	s4,0xbfc3
bfc30b50:	26940b54 	addiu	s4,s4,2900
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:163
bfc30b54:	1400000d 	bnez	zero,bfc30b8c <inst_error>
bfc30b58:	9e3c56aa 	0x9e3c56aa
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:165
bfc30b5c:	02f20018 	mult	s7,s2
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:166
bfc30b60:	1657000a 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:167
bfc30b64:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:168
bfc30b68:	24120007 	li	s2,7
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:169
bfc30b6c:	3c14bfc3 	lui	s4,0xbfc3
bfc30b70:	26940b78 	addiu	s4,s4,2936
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:170
bfc30b74:	02f20018 	mult	s7,s2
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:171
bfc30b78:	15000004 	bnez	t0,bfc30b8c <inst_error>
bfc30b7c:	ec1ba960 	swc3	$27,-22176(zero)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:173
bfc30b80:	16570002 	bne	s2,s7,bfc30b8c <inst_error>
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:174
bfc30b84:	00000000 	nop
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:176
bfc30b88:	26730001 	addiu	s3,s3,1

bfc30b8c <inst_error>:
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:179
bfc30b8c:	00104e00 	sll	t1,s0,0x18
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:180
bfc30b90:	01334025 	or	t0,t1,s3
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:181
bfc30b94:	ae280000 	sw	t0,0(s1)
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:182
bfc30b98:	03e00008 	jr	ra
/home/rain/loongson/func_board/inst/n79_bne_ds_ex.S:183
bfc30b9c:	00000000 	nop