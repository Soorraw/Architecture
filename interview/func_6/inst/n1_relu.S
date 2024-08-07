#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n1_relu_test)
    .set noreorder
    addiu s0, s0 ,1
    addiu s2, zero, 0x0
    lui   t2, 0x1
###test inst
TEST_RELU(0x6f67be90,0x6f67be90)
TEST_RELU(0x6f14c791,0x6f14c791)
TEST_RELU(0x309eb712,0x309eb712)
TEST_RELU(0x5c480fa2,0x5c480fa2)
TEST_RELU(0x5dd6720d,0x5dd6720d)
TEST_RELU(0xfc050dc7,0x00000000)
TEST_RELU(0x1ea83fad,0x1ea83fad)
TEST_RELU(0xe17ca886,0x00000000)
TEST_RELU(0x08f7e363,0x08f7e363)
TEST_RELU(0x7da4063e,0x7da4063e)
TEST_RELU(0x213dbc51,0x213dbc51)
TEST_RELU(0x81e15b30,0x00000000)
TEST_RELU(0xb4c35153,0x00000000)
TEST_RELU(0x76452b5d,0x76452b5d)
TEST_RELU(0xe74ac9d2,0x00000000)
TEST_RELU(0x6900094b,0x6900094b)
TEST_RELU(0x3e69439b,0x3e69439b)
TEST_RELU(0x2fd173b7,0x2fd173b7)
TEST_RELU(0x8646c404,0x00000000)
TEST_RELU(0x86c39366,0x00000000)
TEST_RELU(0x2157f085,0x2157f085)
TEST_RELU(0xf939045d,0x00000000)
TEST_RELU(0xb5b92fec,0x00000000)
TEST_RELU(0x42a3d582,0x42a3d582)
TEST_RELU(0xaaf4d133,0x00000000)
TEST_RELU(0x78920cbb,0x78920cbb)
TEST_RELU(0x97e370a9,0x00000000)
TEST_RELU(0x0e1c6142,0x0e1c6142)
TEST_RELU(0xaab6ea2a,0x00000000)
TEST_RELU(0xd92c516d,0x00000000)
TEST_RELU(0xe5b63212,0x00000000)
TEST_RELU(0xdd87ebf8,0x00000000)
TEST_RELU(0x5ca3198a,0x5ca3198a)
TEST_RELU(0xc9f334eb,0x00000000)
TEST_RELU(0xb381b56a,0x00000000)
TEST_RELU(0x69922fd4,0x69922fd4)
TEST_RELU(0x8a7d8bb6,0x00000000)
TEST_RELU(0xf7e943a5,0x00000000)
TEST_RELU(0x4383337a,0x4383337a)
TEST_RELU(0x2ab59d95,0x2ab59d95)
TEST_RELU(0xeb1da1c4,0x00000000)
TEST_RELU(0xc9717f32,0x00000000)
TEST_RELU(0xb405daa8,0x00000000)
TEST_RELU(0x8788e8ab,0x00000000)
TEST_RELU(0x374d400b,0x374d400b)
TEST_RELU(0x132244f6,0x132244f6)
TEST_RELU(0xa392e3d1,0x00000000)
TEST_RELU(0x6b05faa6,0x6b05faa6)
TEST_RELU(0x54fe9540,0x54fe9540)
TEST_RELU(0x628c91bf,0x628c91bf)
TEST_RELU(0xd90c0616,0x00000000)
TEST_RELU(0x880f520d,0x00000000)
TEST_RELU(0x4132f21e,0x4132f21e)
TEST_RELU(0x0dabd0a3,0x0dabd0a3)
TEST_RELU(0xac31c29e,0x00000000)
TEST_RELU(0x9040c824,0x00000000)
TEST_RELU(0x711928a6,0x711928a6)
TEST_RELU(0x888952fd,0x00000000)
TEST_RELU(0x425b3586,0x425b3586)
TEST_RELU(0x3d83a7aa,0x3d83a7aa)
TEST_RELU(0xb8cbfb50,0x00000000)
TEST_RELU(0xaeda63b6,0x00000000)
TEST_RELU(0x08f84ef6,0x08f84ef6)
TEST_RELU(0xef52aa1d,0x00000000)
TEST_RELU(0xc462fde4,0x00000000)
TEST_RELU(0x2fa0e3b4,0x2fa0e3b4)
TEST_RELU(0x2217bd54,0x2217bd54)
TEST_RELU(0xb4f06a86,0x00000000)
TEST_RELU(0xcd3fcd77,0x00000000)
TEST_RELU(0x990dfd76,0x00000000)
TEST_RELU(0x40e17a42,0x40e17a42)
TEST_RELU(0x1d7de1a0,0x1d7de1a0)
TEST_RELU(0x9cef2c43,0x00000000)
TEST_RELU(0x1083967f,0x1083967f)
TEST_RELU(0xd9bcc6d9,0x00000000)
TEST_RELU(0x0746079c,0x0746079c)
TEST_RELU(0xd8a5439f,0x00000000)
TEST_RELU(0xb5a76b7c,0x00000000)
TEST_RELU(0x62455154,0x62455154)
TEST_RELU(0x6eb330ab,0x6eb330ab)
TEST_RELU(0xe580e9ed,0x00000000)
TEST_RELU(0xa78457e8,0x00000000)
TEST_RELU(0xe0bc1895,0x00000000)
TEST_RELU(0x496b766b,0x496b766b)
TEST_RELU(0x4f1a9efd,0x4f1a9efd)
TEST_RELU(0x5542142e,0x5542142e)
TEST_RELU(0xfc57b680,0x00000000)
TEST_RELU(0x6aeb2336,0x6aeb2336)
TEST_RELU(0x07dd6e75,0x07dd6e75)
TEST_RELU(0xf2f154f0,0x00000000)
TEST_RELU(0x40ff33bd,0x40ff33bd)
TEST_RELU(0x6a6c45d8,0x6a6c45d8)
TEST_RELU(0x13ee548f,0x13ee548f)
TEST_RELU(0xa929e286,0x00000000)
TEST_RELU(0x69f752a2,0x69f752a2)
TEST_RELU(0xf78eb653,0x00000000)
TEST_RELU(0x6396b9f9,0x6396b9f9)
TEST_RELU(0x574c209d,0x574c209d)
TEST_RELU(0xbc5bce68,0x00000000)
TEST_RELU(0x5016640c,0x5016640c)
TEST_RELU(0x0fa10937,0x0fa10937)
TEST_RELU(0x17ba0045,0x17ba0045)
TEST_RELU(0x0ee35ce9,0x0ee35ce9)
TEST_RELU(0xae8c7826,0x00000000)
TEST_RELU(0x2a4742de,0x2a4742de)
TEST_RELU(0x594e6ed5,0x594e6ed5)
TEST_RELU(0x4207ba3a,0x4207ba3a)
TEST_RELU(0xddaca9e9,0x00000000)
TEST_RELU(0x46964536,0x46964536)
TEST_RELU(0x26f1b24a,0x26f1b24a)
TEST_RELU(0x142bdfec,0x142bdfec)
TEST_RELU(0x8d642267,0x00000000)
TEST_RELU(0x3b7390cb,0x3b7390cb)
TEST_RELU(0x878b4ff0,0x00000000)
TEST_RELU(0x12145efd,0x12145efd)
TEST_RELU(0x35fe4650,0x35fe4650)
TEST_RELU(0x9d14d3d6,0x00000000)
TEST_RELU(0xb111589a,0x00000000)
TEST_RELU(0x5b5010cc,0x5b5010cc)
TEST_RELU(0x58036ff6,0x58036ff6)
TEST_RELU(0x59b976e9,0x59b976e9)
TEST_RELU(0x1b24f409,0x1b24f409)
TEST_RELU(0x19f5ab00,0x19f5ab00)
TEST_RELU(0x31ae1137,0x31ae1137)
TEST_RELU(0x5d1633bc,0x5d1633bc)
TEST_RELU(0xd1739609,0x00000000)
TEST_RELU(0xb03593b8,0x00000000)
TEST_RELU(0x641fe686,0x641fe686)
TEST_RELU(0xf452b518,0x00000000)
TEST_RELU(0xcc98e73c,0x00000000)
TEST_RELU(0x7dcde130,0x7dcde130)
TEST_RELU(0x2a2337cf,0x2a2337cf)
TEST_RELU(0x56afd3c0,0x56afd3c0)
TEST_RELU(0x9fb44ee4,0x00000000)
TEST_RELU(0xbe745247,0x00000000)
TEST_RELU(0xe3374012,0x00000000)
TEST_RELU(0xc194d51d,0x00000000)
TEST_RELU(0xa2bc65a3,0x00000000)
TEST_RELU(0x42d69095,0x42d69095)
TEST_RELU(0x53c72b98,0x53c72b98)
TEST_RELU(0xc288ae3a,0x00000000)
TEST_RELU(0x755ca080,0x755ca080)
TEST_RELU(0xe6e17f95,0x00000000)
TEST_RELU(0xf3f1b7a7,0x00000000)
TEST_RELU(0x457dd4ac,0x457dd4ac)
TEST_RELU(0xdd937db3,0x00000000)
TEST_RELU(0xfccbcb82,0x00000000)
TEST_RELU(0xe30f3f9c,0x00000000)
TEST_RELU(0xccacd5b8,0x00000000)
TEST_RELU(0x43d00b6c,0x43d00b6c)
TEST_RELU(0xcb9152c0,0x00000000)
TEST_RELU(0x3bb2084b,0x3bb2084b)
TEST_RELU(0x19efe88e,0x19efe88e)
TEST_RELU(0xd448346e,0x00000000)
TEST_RELU(0x6a700485,0x6a700485)
TEST_RELU(0x36667144,0x36667144)
TEST_RELU(0x4246934c,0x4246934c)
TEST_RELU(0x87ea7c40,0x00000000)
TEST_RELU(0x69a07708,0x69a07708)
TEST_RELU(0x788214fa,0x788214fa)
TEST_RELU(0xfc37240e,0x00000000)
TEST_RELU(0x793f726a,0x793f726a)
TEST_RELU(0xa472b6d8,0x00000000)
TEST_RELU(0xd384230d,0x00000000)
TEST_RELU(0xf9434e28,0x00000000)
TEST_RELU(0x2eef96c2,0x2eef96c2)
TEST_RELU(0xf7e4d472,0x00000000)
TEST_RELU(0xa85ad6c8,0x00000000)
TEST_RELU(0xca3f7548,0x00000000)
TEST_RELU(0xbf45942c,0x00000000)
TEST_RELU(0xe7f2604b,0x00000000)
TEST_RELU(0xe763ec42,0x00000000)
TEST_RELU(0xf01e38e2,0x00000000)
TEST_RELU(0x90734a60,0x00000000)
TEST_RELU(0x5ff53fa8,0x5ff53fa8)
TEST_RELU(0xa72e1e63,0x00000000)
TEST_RELU(0x7c567157,0x7c567157)
TEST_RELU(0xaa9979da,0x00000000)
TEST_RELU(0x61be8735,0x61be8735)
TEST_RELU(0x2cc692a2,0x2cc692a2)
TEST_RELU(0x51021af9,0x51021af9)
TEST_RELU(0x0bd48210,0x0bd48210)
TEST_RELU(0x2f35fb28,0x2f35fb28)
TEST_RELU(0xadb8f5d7,0x00000000)
TEST_RELU(0x79bae8aa,0x79bae8aa)
TEST_RELU(0x4d0a1e34,0x4d0a1e34)
TEST_RELU(0xfb15d10f,0x00000000)
TEST_RELU(0x934a2ab8,0x00000000)
TEST_RELU(0x843223db,0x00000000)
TEST_RELU(0xd39e808c,0x00000000)
TEST_RELU(0x511efa38,0x511efa38)
TEST_RELU(0xc871bc77,0x00000000)
TEST_RELU(0xbb368986,0x00000000)
TEST_RELU(0x24f6afa8,0x24f6afa8)
TEST_RELU(0xacbb7e25,0x00000000)
TEST_RELU(0x6a92370e,0x6a92370e)
TEST_RELU(0xb2e021e2,0x00000000)
TEST_RELU(0x04e55257,0x04e55257)
TEST_RELU(0xfd145dbb,0x00000000)
TEST_RELU(0x26db0bbd,0x26db0bbd)


###detect exception
    bne s2, zero, inst_error
    nop
###score ++
    addiu s3, s3, 1
###output (s0<<24)|s3
inst_error:  
    sll t1, s0, 24
    or t0, t1, s3 
    sw t0, 0(s1)
    jr ra
    nop
END(n1_relu_test)
