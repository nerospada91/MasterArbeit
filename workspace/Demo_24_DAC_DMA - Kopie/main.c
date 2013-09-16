//--------------------------------------------------------------
// File     : main.c
// Datum    : 24.03.2013
// Version  : 1.0
// Autor    : UB
// EMail    : mc-4u(@)t-online.de
// Web      : www.mikrocontroller-4u.de
// CPU      : STM32F4
// IDE      : CooCox CoIDE 1.7.0
// Module   : CMSIS_BOOT, M4_CMSIS_CORE
// Funktion : Demo der DAC-DMA Library
// Hinweis  : Diese zwei Files muessen auf 8MHz stehen
//              "cmsis_boot/stm32f4xx.h"
//              "cmsis_boot/system_stm32f4xx.c"
//--------------------------------------------------------------

#include "main.h"
#include "stm32_ub_dac_dma.h"
//#include "stm32f4_discovery.h"

int main(void)
{
  SystemInit(); // Quarz Einstellungen aktivieren -> CPU 168MHz


  //STM32F4_Discovery_LEDInit(LED3); //Orange
  //	STM32F4_Discovery_LEDInit(LED4); //Green
  //	STM32F4_Discovery_LEDInit(LED5); //Red
  //	STM32F4_Discovery_LEDInit(LED6); //Blue

  // init vom DAC im DMA-Mode (DAC-1 und DAC-2)
  UB_DAC_DMA_Init(DUAL_DAC_DMA);

  // an DAC1 (PA4) ein Sinus-Signal ausgeben
  UB_DAC_DMA_SetWaveform1(DAC_WAVE1_SINUS);

  // an DAC2 (PA5) ein Rechteck-Signal ausgeben
  UB_DAC_DMA_SetWaveform2(DAC_WAVE_OFF);


  // an DAC2 (PA5) ein Dreieck-Signal ausgeben
  // UB_DAC_DMA_SetWaveform2(DAC_WAVE3_DREIECK);

  // Frq vom Sinus-Signal auf 1 KHz stellen
  // !!!!!!!!!!!!!!!! 1 KHz SINUS
  //OLD
  // Das Sinus-Signal ist 32 Werte lang -> GEÄNADERT AUF 16 WERTE!
  // -> Das hier ist aktuell f=84MHz/300/8750/16 = 1 Hz
  // -> NICHT AKTUELLf=84MHz/300/8750/32 = 1 Hz
  //OLD
  //UB_DAC_DMA_SetFrq1(83,30);
  UB_DAC_DMA_SetFrq1(83,20000);


  // Frq vom Dreieck-Signal auf 1 KHz stellen
  // Das Dreieck-Signal ist 1 Wert lang
  // f=84MHz/30/8750 = 10 Hz
  UB_DAC_DMA_SetFrq2(83,999);


  // Frq vom Dreieck-Signal auf 10 Hz stellen
  // Das Dreieck-Signal ist 32 Werte lang
  // f=84MHz/30/8750/32 = 10 Hz
  //UB_DAC_DMA_SetFrq2(29,8749);
  /*
  TIM3 Channel1 duty cycle = (TIM3_CCR1/ TIM3_ARR)* 100 = 50%

    TIM3 Channel2 duty cycle = (TIM3_CCR2/ TIM3_ARR)* 100 = 37.5%

    TIM3 Channel3 duty cycle = (TIM3_CCR3/ TIM3_ARR)* 100 = 25%

    TIM3 Channel4 duty cycle = (TIM3_CCR4/ TIM3_ARR)* 100 = 12.5%
    */

  while(1)
  {

  }
}

