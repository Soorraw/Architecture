   .org 0x0
   .set noat
   .global _start
_start:

	ori  $8,$0,0x6f67           # $8 = 0x6f67
	sll  $8,$8,16               # $8 = 0x6f670000
	ori  $8,$8,0xbe90           # $8 = 0x6f67be90

	.word 0xfd001000			# relu 
								# $2 = 0x6f67be90

	ori  $8,$0,0xe17c           # $8 = 0xe17c
	sll  $8,$8,16               # $8 = 0xe17c0000
	ori  $8,$8,0xa886           # $8 = 0xe17ca886
	
	.word 0xfd001000			# relu 
								# $2 = 0x00000000