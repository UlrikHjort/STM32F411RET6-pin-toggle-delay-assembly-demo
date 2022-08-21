#include "delay_timing.h"

#define MAX_DELAY 0xFFFFFFFFU
#define TICK_FREQ 1

volatile uint32_t tick = 0;

void inc_tick(void) {  tick += TICK_FREQ;}

uint32_t get_tick(void){ return tick;}


void delay(uint32_t Delay) {
  uint32_t tickstart = get_tick();
  uint32_t wait = Delay;

  /* Add a freq to guarantee minimum wait */
  if (wait < MAX_DELAY) { wait += (uint32_t)(TICK_FREQ);}

  while((get_tick() - tickstart) < wait)  {  }
}
