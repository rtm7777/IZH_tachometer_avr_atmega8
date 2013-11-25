// CodeVisionAVR C Compiler
// (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega8
#pragma used+
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   // 16 bit access
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// Needed by the power management functions (sleep.h)
#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
flash char diodes[] = {  
0b01111011,
0b01111010,
0b01111000,
0b01110000,
0b01100000,
0b01000000,
0b00000000
};
char l_o[4], cur_line;
unsigned int indication;
int x, y;
int num;
int l;
int s;
void recoding(void)
{
switch (l)
  {
  case 0:{l_o[0]=s;l_o[1]=0;l_o[2]=0;l_o[3]=0;break;};
  case 1:{l_o[0]=7;l_o[1]=s;l_o[2]=0;l_o[3]=0;break;};
  case 2:{l_o[0]=7;l_o[1]=7;l_o[2]=s;l_o[3]=0;break;};
  case 3:{l_o[0]=7;l_o[1]=7;l_o[2]=7;l_o[3]=s;break;};
  case 4:{l_o[0]=7;l_o[1]=7;l_o[2]=7;l_o[3]=7;break;};
  }
}
// External Interrupt 0 service routine
interrupt [2] void ext_int0_isr(void)
{
indication=TCNT1;
TCNT1=0x00;
}   
interrupt [7] void timer1_compa_isr(void)
{
indication=3760;
TCNT1=0x00;
}
interrupt [5] void timer2_ovf_isr(void)
{
switch (cur_line)
  {
  case 0:{PORTB.0 =0;PORTB.1=1;PORTD=diodes[l_o[cur_line]];break;};
  case 1:{PORTB.1=0;PORTB.7=1;PORTD=diodes[l_o[cur_line]];break;};
  case 2:{PORTB.7=0;PORTB.6=1;PORTD=diodes[l_o[cur_line]];break;};
  case 3:{PORTB.6=0;PORTB.0 =1;PORTD=diodes[l_o[cur_line]];break;};
  }
    cur_line++;
  if (cur_line==4) cur_line=0;
}
// Timer 2 output compare interrupt service routine
interrupt [4] void timer2_comp_isr(void)
{
PORTB=0x00;
}
// Declare your global variables here
void main(void)
{
// Declare your local variables here
// Input/Output Ports initialization
// Port B initialization
PORTB=0x00;
DDRB=0xC3;
// Port C initialization
PORTC=0x00;
DDRC=0x00;
// Port D initialization
PORTD=0x04;
DDRD=0x7B;
// Timer/Counter 1 initialization
TCCR1A=0x00;
TCCR1B=0x05;
TCNT1=0x0000;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x07;
OCR1AL=0xB7;
OCR1BH=0x00;
OCR1BL=0x00;
// Timer/Counter 2 initialization
ASSR=0x00;
TCCR2=0x04;
TCNT2=0x00;
OCR2=0x60;
// External Interrupt(s) initialization
GICR|=0x40;
MCUCR=0x03;
GIFR=0x40;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x40;
// Analog Comparator initialization
ACSR=0x80;
SFIOR=0x00;
// Global enable interrupts
#asm("sei")
l_o[0]=7;l_o[1]=7;l_o[2]=7;l_o[3]=7;
delay_ms(300);
for (y=4;y>0;y--)
  {
  for (x=6;x>=1;x--)
    {
    l_o[y-1]=x-1;
    delay_ms(25);
    }
  }
TIMSK=0x50;
while (1)
      {
      if (PINC.0==1) TIMSK=0xD0;
      else TIMSK=0x50;
      num = 1875/indication;  // 1875 for value of division 250 | 2343 - 200 | 1562 - 300 
      l = (num-(num%6))/6;
      s = num%6;
      recoding();
      }
}
