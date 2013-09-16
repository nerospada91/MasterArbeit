#include "stm32f4xx.h"
#include <stdio.h>
#include "stm32f4xx_tim.h"
#include "usbd_cdc_vcp.h"
#include "stm32f4xx_conf.h"

/* Private macro */
/* Private variables */
uint32_t button_sts;
__ALIGN_BEGIN USB_OTG_CORE_HANDLE  USB_OTG_dev __ALIGN_END;
uint32_t i = 0;
/* Private function prototypes */
/* Private functions */


#define MOTORPWMTIMER      TIM4
#define MOTORPWMTIMCLOCK    RCC_APB1Periph_TIM4
#define MOTORPWMPORTCLOCK    RCC_AHB1Periph_GPIOD
#define MOTORPWMAF         GPIO_AF_TIM4
#define MOTORPWMPORT      GPIOD
#define MOTORPWMBIT        GPIO_Pin_12
#define MOTORPWMTIMBIT      GPIO_PinSource12


// Private typedefs ----------------------------------------------------------
GPIO_InitTypeDef     GPIO_InitStructureLED;
GPIO_InitTypeDef     GPIO_InitStructureTimer;
TIM_TimeBaseInitTypeDef  TIM_TimeBaseStructure;
TIM_OCInitTypeDef    TIM_OCInitStructure;


// Private variables ---------------------------------------------------------
uint32_t TimerCounterClock = 0;
uint32_t TimerOutputClock = 0;
uint16_t PrescalerValue = 0;
uint32_t PulseDurationInMicroSeconds = 0;



// the prototypes ------------------------------------------------------------
int main(void);

// Timer init for PWM
void TimerInit(void);

void Delay(__IO uint32_t nCount);


int main(void)
{
  /*!< At this stage the microcontroller clock setting is already configured,
     this is done through SystemInit() function which is called from startup
     file (startup_stm32f4xx.s) before to branch to application main.
     To reconfigure the default setting of SystemInit() function, refer to
      system_stm32f4xx.c file
  */

  // /dev/tty.usbserial-A900J1T0

  // call my new USART init
  usartInit();


  // call timer init for PWM
  TimerInit();


  // Timer base configuration
  //   Don't know why, but this code has to be here (not in a seperate method)
  TIM_TimeBaseStructure.TIM_Period = (uint16_t) (TimerCounterClock / TimerOutputClock);
  TIM_TimeBaseStructure.TIM_Prescaler = (uint16_t) ((SystemCoreClock /2) / TimerCounterClock) - 1;
  TIM_TimeBaseStructure.TIM_ClockDivision = 0;
  TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up;

  // basic timer init
  TIM_TimeBaseInit(MOTORPWMTIMER, &TIM_TimeBaseStructure);

  // configure PWM mode and duration
  TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;
  TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
  TIM_OCInitStructure.TIM_Pulse = PulseDurationInMicroSeconds; // set the duty cycle / pulse here!
  TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity_High;
  TIM_OC1Init(MOTORPWMTIMER, &TIM_OCInitStructure);
  TIM_OC1PreloadConfig(MOTORPWMTIMER, TIM_OCPreload_Enable);

  // preload timer config
  TIM_ARRPreloadConfig(MOTORPWMTIMER, ENABLE);

  // enable timer / counter
  TIM_Cmd(MOTORPWMTIMER, ENABLE);


  //
  //  motor pwm test ! ! !
  //
  while(1)
  {
    for (i=1; i<70; i++)
    {
      Delay(0x03FFFF);
      TIM_Cmd(MOTORPWMTIMER, DISABLE);

      PulseDurationInMicroSeconds = i;

      TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;
      TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
      TIM_OCInitStructure.TIM_Pulse = PulseDurationInMicroSeconds; // set the duty cycle / pulse here!
      TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity_High;
      TIM_OC1Init(MOTORPWMTIMER, &TIM_OCInitStructure);
      TIM_OC1PreloadConfig(MOTORPWMTIMER, TIM_OCPreload_Enable);

      TIM_ARRPreloadConfig(MOTORPWMTIMER, ENABLE);

      TIM_Cmd(MOTORPWMTIMER, ENABLE);
    }

    for (i=70; i>2; i--)
    {
      Delay(0x03FFFF);
      TIM_Cmd(MOTORPWMTIMER, DISABLE);

      PulseDurationInMicroSeconds = i;

      TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;
      TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
      TIM_OCInitStructure.TIM_Pulse = PulseDurationInMicroSeconds; // set the duty cycle / pulse here!
      TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity_High;
      TIM_OC1Init(MOTORPWMTIMER, &TIM_OCInitStructure);
      TIM_OC1PreloadConfig(MOTORPWMTIMER, TIM_OCPreload_Enable);

      TIM_ARRPreloadConfig(MOTORPWMTIMER, ENABLE);

      TIM_Cmd(MOTORPWMTIMER, ENABLE);
    }
  }
}


/**
  * @brief  Configure the timer for PWM.
  * @param  None
  * @retval None
  */
void TimerInit(void)
{
  // set timer frequencies
  TimerCounterClock = 1000000; //  1 MHz
  TimerOutputClock = 10000;    // 10 kHz = 100 µs period

  // set pulse duration in mili seconds (HIGH time)
  // can be up to from 0 to 99 (due to a TimerOutputClock of 10 kHz)
  PulseDurationInMicroSeconds = 50;

  // Timer clock enable
  RCC_APB1PeriphClockCmd(MOTORPWMTIMCLOCK, ENABLE);

  // Port clock enable
  RCC_AHB1PeriphClockCmd(MOTORPWMPORTCLOCK, ENABLE);

  // Set PWM Port, Pin and method
  GPIO_InitStructureTimer.GPIO_Pin = MOTORPWMBIT;
  GPIO_InitStructureTimer.GPIO_Mode = GPIO_Mode_AF;
  GPIO_InitStructureTimer.GPIO_Speed = GPIO_Speed_100MHz;
  GPIO_InitStructureTimer.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructureTimer.GPIO_PuPd = GPIO_PuPd_UP ;
  GPIO_Init(MOTORPWMPORT, &GPIO_InitStructureTimer);

  // Connect TIM pin to AF
  GPIO_PinAFConfig(MOTORPWMPORT, MOTORPWMTIMBIT, MOTORPWMAF);
}


/**
  * @brief  Delay Function.
  * @param  nCount:specifies the Delay time length.
  * @retval None
  */
void Delay(__IO uint32_t nCount)
{
  while(nCount--)
  {
  }
}
