/* Includes ------------------------------------------------------------------*/
#include "stm32f4xx.h"
#include <stdio.h>
#include "stm32f4xx_tim.h"


int main(void)
{
SystemInit(); // 25 MHz


/*
* Servo min(1ms) = 1580
* Servo max(2ms) = 3160
*
*/

GPIO_InitTypeDef GPIO_InitStructure;
TIM_TimeBaseInitTypeDef TIM_TimeBaseStructure;
TIM_OCInitTypeDef TIM_OCInitStructure;

/* TIM1 clock enable */
RCC_APB2PeriphClockCmd(RCC_APB2Periph_TIM1, ENABLE);

/* GPIOE clock enable */
RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOE, ENABLE);

/* TIM1 channel 2 pin (PE.9) configuration */
GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9;
GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
GPIO_Init(GPIOE, &GPIO_InitStructure);

/* Connect TIM pins to AF2 */
GPIO_PinAFConfig(GPIOE, GPIO_PinSource9, GPIO_AF_TIM1);

TIM_TimeBaseStructInit (&TIM_TimeBaseStructure);
TIM_TimeBaseStructure.TIM_Prescaler = SystemCoreClock/5000000; // pers 33.6
TIM_TimeBaseStructure.TIM_Period = 31600; // 20ms for servo period
TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up;
TIM_TimeBaseInit(TIM1 , &TIM_TimeBaseStructure);
// PWM1 Mode configuration: Channel1
// Edge -aligned; not single pulse mode
TIM_OCStructInit (& TIM_OCInitStructure);
TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;
TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
TIM_OC1Init(TIM1 , &TIM_OCInitStructure);

TIM_BDTRInitTypeDef bdtr;
TIM_BDTRStructInit(&bdtr);
bdtr.TIM_AutomaticOutput = TIM_AutomaticOutput_Enable;
TIM_BDTRConfig(TIM1, &bdtr);


// Enable Timer Interrupt and Timer
TIM_ITConfig(TIM1, TIM_IT_Update, ENABLE); //
TIM_Cmd(TIM1 , ENABLE);

TIM_SetCompare1(TIM1, 2370);    // 2370 = 1.5ms - for Servo


while(1);

}
