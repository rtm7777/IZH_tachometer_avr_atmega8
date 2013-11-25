#include <mega8.h>
#include <delay.h>


#define line1 PORTB.1
#define line2 PORTB.7
#define line3 PORTB.6
#define line4 PORTB.0 

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
interrupt [EXT_INT0] void ext_int0_isr(void)
{
indication=TCNT1;

TCNT1=0x00;
}   

interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
indication=3760;
TCNT1=0x00;
}

interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
switch (cur_line)
  {
  case 0:{line4=0;line1=1;PORTD=diodes[l_o[cur_line]];break;};
  case 1:{line1=0;line2=1;PORTD=diodes[l_o[cur_line]];break;};
  case 2:{line2=0;line3=1;PORTD=diodes[l_o[cur_line]];break;};
  case 3:{line3=0;line4=1;PORTD=diodes[l_o[cur_line]];break;};
  }
  
  cur_line++;
  if (cur_line==4) cur_line=0;

}

// Timer 2 output compare interrupt service routine
interrupt [TIM2_COMP] void timer2_comp_isr(void)
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