#include "stdlib.h"
#include "stdio.h"
#include "string.h"

#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_rcc.h"
#include "stm32f4xx_tim.h"


#define AD9850_CLK GPIO_Pin_7
#define AD9850_FQUP GPIO_Pin_8
#define AD9850_DATA GPIO_Pin_9
#define AD9850_RESET GPIO_Pin_10

//Welcher Frequenzbereiche
// 1 = 1-250  kHz in 200 Schritten
// 2 = 1-3500 kHz in 200 Schritten

//Wie oft soll jeder einzelne Wert gemessen werden?
int n_measures = 1;

// AD9850 CLK  PE7
// AD9850 FQ   PE8
// AD9850 Data PE9
// AD9850 RST  PE10

// WAVE-STM32 - PD12

// BT-Modul TX PB10
// BT-Modul RX PB11

// Schwingkreis Anschluss Grün   PC4 / AD-Wandler
// Schwingkreis Anschluss Schwarz Ground
// Schwingkreis Anschluss Rot     AD9850-SinA PD12
// Schwingkreis Anschluss Gelb    Objekt

/* --------------------------- Bluetooth Function -----------------*/
void Bluetooth_Init(void) {

	/* --------------------------- System Clocks Configuration -----------------*/
	/* USART3 clock enable */
	/* GPIOB clock enable */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART3, ENABLE);
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);

	/*-------------------------- GPIO Configuration ----------------------------*/
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10 | GPIO_Pin_11;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOB, &GPIO_InitStructure);

	/* Connect USART pins to AF */
	GPIO_PinAFConfig(GPIOB, GPIO_PinSource10, GPIO_AF_USART3);
	GPIO_PinAFConfig(GPIOB, GPIO_PinSource11, GPIO_AF_USART3);

	/* USARTx configuration ------------------------------------------------------*/
	/* USARTx configured as follow:
	 - BaudRate = 115200 baud
	 - Word Length = 8 Bits
	 - Two Stop Bit
	 - Odd parity
	 - Hardware flow control disabled (RTS and CTS signals)
	 - Receive and transmit enabled
	 */
	USART_InitTypeDef USART_InitStructure;
	USART_InitStructure.USART_BaudRate = 115200;
	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl =	USART_HardwareFlowControl_None;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USART_Init(USART3, &USART_InitStructure);

	USART_Cmd(USART3, ENABLE);
	USART_ITConfig(USART3, USART_IT_RXNE, ENABLE);
}

/* --------------------------- ADC Function -----------------*/
// 32 Mhz 12 Bit 4096 Werte 2,5 mV
void Input_ADC_Init() {

	/* --------------------------- System Clocks Configuration -----------------*/
	/* ADC1 clock enable */
	/* GPIOC clock enable */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_ADC1, ENABLE); //ADC1 connected APB2 peripheral bus will use clock source
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOC, ENABLE);

	/*-------------------------- GPIO Configuration ----------------------------*/
	GPIO_InitTypeDef GPIO_initStructre; //Structure for analog input pin
	GPIO_initStructre.GPIO_Pin = GPIO_Pin_4; //The channel 14 is connected to PC4
	GPIO_initStructre.GPIO_Mode = GPIO_Mode_AN; //The PC4 pin is configured in analog mode
	GPIO_initStructre.GPIO_PuPd = GPIO_PuPd_NOPULL; //We don't need any pull up or pull down
	GPIO_Init(GPIOC, &GPIO_initStructre); //Affecting the port with the initialization structure configuration

	/* --------------------------- ADC Configuration -----------------*/
	ADC_CommonInitTypeDef ADC_CommonInitStructure;
	ADC_CommonInitStructure.ADC_Mode = ADC_Mode_Independent;
	ADC_CommonInitStructure.ADC_Prescaler = ADC_Prescaler_Div4;
	ADC_CommonInitStructure.ADC_DMAAccessMode = ADC_DMAAccessMode_Disabled;
	ADC_CommonInitStructure.ADC_TwoSamplingDelay = ADC_TwoSamplingDelay_5Cycles;
	ADC_CommonInit(&ADC_CommonInitStructure);

	ADC_InitTypeDef ADC_InitStructure;
	ADC_InitStructure.ADC_Resolution = ADC_Resolution_12b;
	ADC_InitStructure.ADC_ScanConvMode = DISABLE; // 1 Channel
	ADC_InitStructure.ADC_ContinuousConvMode = ENABLE; // Conversions Triggered
	ADC_InitStructure.ADC_ExternalTrigConvEdge = ADC_ExternalTrigConvEdge_None;
	ADC_InitStructure.ADC_ExternalTrigConv = ADC_ExternalTrigConv_T1_CC1;
	ADC_InitStructure.ADC_DataAlign = ADC_DataAlign_Right;
	ADC_InitStructure.ADC_NbrOfConversion = 1;
	ADC_Init(ADC1, &ADC_InitStructure);

	// ADC1 regular channel 8 configuration: witch adc, witch channel, groupe sequencer, sample time
	//(ADC_TypeDef* ADCx, uint8_t ADC_Channel, uint8_t Rank, uint8_t ADC_SampleTime)
	ADC_RegularChannelConfig(ADC1, ADC_Channel_14, 1, ADC_SampleTime_480Cycles); // PC4

	ADC_Cmd(ADC1, ENABLE);
	ADC_SoftwareStartConv(ADC1); //Start ADC1 Conversion

}

/* --------------------------- Simple Delay Loop  -----------------*/
void Delay_Loop(uint32_t delay) {
	uint32_t delayCount = delay;
	while (delayCount > 0) {
		delayCount--;
	}
}

/* --------------------------- Signal Generator Clock SubFunction -----------------*/
void AD9850_ClockCLK() {
	//Signalflanke CLK generieren
	GPIO_SetBits(GPIOE, AD9850_CLK);
	//Delay_Loop(10000);
	GPIO_ResetBits(GPIOE, AD9850_CLK);
}

/* --------------------------- Signal Generator FQUP SubFunction -----------------*/
void AD9850_ClockFQUP() {
	//Signalflanke FQ generieren
	GPIO_SetBits(GPIOE, AD9850_FQUP);
	//Delay_Loop(10000);
	GPIO_ResetBits(GPIOE, AD9850_FQUP);
}

/* --------------------------- Signal Generator Write Word SubFunction -----------------*/
void AD9850_Write(uint8_t word) {
	//Byte/Bit schreiben auf PE9
	int i;
	for(i=0; i<8; i++) {
		GPIO_WriteBit(GPIOE, AD9850_DATA, (word >> i) & 0x01);
		AD9850_ClockCLK();
	}
}

/* --------------------------- Signal Generator Init Function -----------------*/
void AD9850_Init() {

	/* --------------------------- System Clocks Configuration -----------------*/
	/* GPIOE clock enable */
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOE, ENABLE);

	/*-------------------------- GPIO Configuration ----------------------------*/
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_7 | GPIO_Pin_8 | GPIO_Pin_9 | GPIO_Pin_10;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_Init(GPIOE, &GPIO_InitStructure);

	GPIO_ResetBits(GPIOE, AD9850_CLK | AD9850_FQUP | AD9850_RESET | AD9850_DATA);

	/* --------------------------- Signal Generator RESET - once called during Init -----------------*/
	int i;
	GPIO_ResetBits(GPIOE, AD9850_CLK | AD9850_FQUP);
	GPIO_SetBits(GPIOE, AD9850_RESET);

	for(i=0; i<5; i++) {
		AD9850_ClockCLK();
	}

	GPIO_ResetBits(GPIOE, AD9850_RESET);

	for(i=0; i<2; i++) {
		AD9850_ClockCLK();
	}

	AD9850_ClockFQUP();
}

/* --------------------------- Signal Generator SetFrequency Function -----------------*/
void AD9850_SetFrequency(double freq) {
	double x = 34.35973836;

	freq *= x;

	uint32_t y = (uint32_t)freq;

	AD9850_ClockFQUP();
	int i;
	for(i=0;i<4;i++) {
		uint8_t w = (uint8_t) ((y >> i*8) & 0xff);
		AD9850_Write(w);
	}
	AD9850_Write(0x00);
	AD9850_ClockFQUP();
}

/* --------------------------- Bluetooth Send SubFunction -----------------*/
void Send_String_USART(const char *str) {
	while (*str) {
		while (USART_GetFlagStatus(USART3, USART_FLAG_TXE) == RESET);
		USART_SendData(USART3, *str++);
	}
}


void PWM_init(void)
{
    GPIO_InitTypeDef  GPIO_InitStructure;


    // TIM4 clock enable
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM4, ENABLE);

    // GPIOD Clock enable
    RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);

    // GPIO Config
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_12;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
    GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
    GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL ;
    GPIO_Init(GPIOD, &GPIO_InitStructure);
    GPIO_PinAFConfig(GPIOD, GPIO_PinSource12, GPIO_AF_TIM4); // Verbindet den Pin PD12 über die Multiplexerfunktion mit AF2/TIM4

}

void PWM_set(int period)
{
    TIM_TimeBaseInitTypeDef TIM_TimeBaseInitStructure;
    TIM_OCInitTypeDef  TIM_OCInitStructure;
	// Timer Config

	    TIM_TimeBaseInitStructure.TIM_ClockDivision = 0;
	    TIM_TimeBaseInitStructure.TIM_CounterMode = TIM_CounterMode_Up;
	    TIM_TimeBaseInitStructure.TIM_Period = period; // 10bit Auflösung der PWM
	    TIM_TimeBaseInitStructure.TIM_Prescaler = 0; // 84MHz
	    TIM_TimeBaseInitStructure.TIM_RepetitionCounter = 0;
	    TIM_TimeBaseInit(TIM4, &TIM_TimeBaseInitStructure);

	    int pulse = (period+1)/ 2;

	    TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;
	    TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
	    TIM_OCInitStructure.TIM_Pulse = pulse;
	    TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity_High;
	    TIM_OC1Init(TIM4, &TIM_OCInitStructure);

	    TIM_OC1PreloadConfig(TIM4, TIM_OCPreload_Enable);

	    TIM_ARRPreloadConfig(TIM4, ENABLE);
	    TIM_Cmd(TIM4, ENABLE);

	    // Duty Cycle 50%
	    //TIM4->CCR1 = 500;
}

int main(void)
{
	//Init the Sytem
  SystemInit();

	//Init Bluetooth
	Bluetooth_Init();

	//Init ADC
	Input_ADC_Init();

	//Init LED (Blue)
	//STM32F4_Discovery_LEDInit(LED6);

	//Init and Reset AD9850
	AD9850_Init();
    //UB_DAC_DMA_Init(SINGLE_DAC1_DMA);
    //UB_DAC_DMA_SetWaveform1(DAC_WAVE4_RECHTECK);
	PWM_init();
	PWM_set(2000-1);

	//Init some Variables for while loop ADC/DAC
	int i, k, meas_raw, meas_fin, period;
	char str_output[10], buffer[10];
	double meas_comb;


	//Welcher Frequenzbereich soll genutzt werden?

	// AD9850
		//Frequenzen - 1-250kHz - 200 Schritte
	/*
		long int freq_ary[] = { 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000,
				10000, 11000, 12000, 13000, 14000, 15000, 16000, 17000, 18000,
				19000, 20000, 21000, 22000, 23000, 24000, 25000, 26000, 27000,
				28000, 29000, 30000, 31000, 32000, 33000, 34000, 35000, 36000,
				37000, 38000, 39000, 40000, 41000, 42000, 43000, 44000, 45000,
				46000, 47000, 48000, 49000, 50000, 51000, 52000, 53000, 54000,
				55000, 56000, 57000, 58000, 59000, 60000, 61000, 62000, 63000,
				64000, 65000, 66000, 67000, 68000, 69000, 70000, 71000, 72000,
				73000, 74000, 75000, 76000, 77000, 78000, 79000, 80000, 81000,
				82000, 83000, 84000, 85000, 86000, 87000, 88000, 89000, 90000,
				91000, 92000, 93000, 94000, 95000, 96000, 97000, 98000, 99000,
				100000, 101000, 102000, 103000, 104000, 105000, 106000, 107000,
				108000, 109000, 110000, 111000, 112000, 113000, 114000, 115000,
				116000, 117000, 118000, 119000, 120000, 121000, 122000, 123000,
				124000, 125000, 126000, 127000, 128000, 129000, 130000, 131000,
				132000, 133000, 134000, 135000, 136000, 137000, 138000, 139000,
				140000, 141000, 142000, 143000, 144000, 145000, 146000, 147000,
				148000, 149000, 150000, 151000, 152000, 153000, 154000, 155000,
				156000, 157000, 158000, 159000, 160000, 161000, 162000, 163000,
				164000, 165000, 166000, 167000, 168000, 169000, 170000, 171000,
				172000, 173000, 174000, 175000, 176000, 177000, 178000, 179000,
				180000, 181000, 182000, 183000, 184000, 185000, 186000, 187000,
				188000, 189000, 190000, 191000, 192000, 193000, 194000, 195000,
				196000, 197000, 198000, 199000, 200000, 201000, 202000, 203000,
				204000, 205000, 206000, 207000, 208000, 209000, 210000, 211000,
				212000, 213000, 214000, 215000, 216000, 217000, 218000, 219000,
				220000, 221000, 222000, 223000, 224000, 225000, 226000, 227000,
				228000, 229000, 230000, 231000, 232000, 233000, 234000, 235000,
				236000, 237000, 238000, 239000, 240000, 241000, 242000, 243000,
				244000, 245000, 246000, 247000, 248000, 249000, 250000 };
	*/

		// AD9850
		//Frequenzen - 1-3500kHz - 200 Schritte

		long int freq_ary[] = { 1000,5300,22950,40600,58250,75900,93550,111200,128850,
				146500,164150,181800,199450,217100,234750,252400,270050,287700,305350,
				323000,340650,358300,375950,393600,411250,428900,446550,464200,481850,
				499500,517150,534800,552450,570100,587750,605400,623050,640700,658350,
				676000,693650,711300,728950,746600,764250,781900,799550,817200,834850,
				852500,870150,887800,905450,923100,940750,958400,976050,993700,1011350,
				1029000,1046650,1064300,1081950,1099600,1117250,1134900,1152550,1170200,
				1187850,1205500,1223150,1240800,1258450,1276100,1293750,1311400,1329050,
				1346700,1364350,1382000,1399650,1417300,1434950,1452600,1470250,1487900,
				1505550,1523200,1540850,1558500,1576150,1593800,1611450,1629100,1646750,
				1664400,1682050,1699700,1717350,1735000,1752650,1770300,1787950,1805600,
				1823250,1840900,1858550,1876200,1893850,1911500,1929150,1946800,1964450,
				1982100,1999750,2017400,2035050,2052700,2070350,2088000,2105650,2123300,
				2140950,2158600,2176250,2193900,2211550,2229200,2246850,2264500,2282150,
				2299800,2317450,2335100,2352750,2370400,2388050,2405700,2423350,2441000,
				2458650,2476300,2493950,2511600,2529250,2546900,2564550,2582200,2599850,
				2617500,2635150,2652800,2670450,2688100,2705750,2723400,2741050,2758700,
				2776350,2794000,2811650,2829300,2846950,2864600,2882250,2899900,2917550,
				2935200,2952850,2970500,2988150,3005800,3023450,3041100,3058750,3076400,
				3094050,3111700,3129350,3147000,3164650,3182300,3199950,3217600,3235250,
				3252900,3270550,3288200,3305850,3323500,3341150,3358800,3376450,3394100,
				3411750,3429400,3447050,3464700,3482350,3500000};


	    //Vorgebene Werte für Periode um die Frequenz vorzugeben
	    int period_ary[] = { 64615,11507,6316,4352,3320,2684,2252,1940,1704,1519,1370,1248,
	    1146,1059,985,920,863,813,769,729,692,660,630,603,578,555,534,514,496,479,463,448,
	    435,421,409,398,387,376,366,357,348,340,332,324,317,310,303,297,290,284,279,273,268,
	    263,258,254,249,245,240,236,232,229,225,221,218,215,211,208,205,202,199,197,194,191,
	    189,185,182,179,176,173,170,168,165,162,160,158,155,153,151,149,147,145,143,141,139,
	    137,135,133,132,130,129,127,126,124,123,121,120,118,117,116,115,113,112,111,110,109,
	    108,106,105,104,103,102,101,100,99,98,97,96,95,94,93,92,91,90,89,88,87,86,85,84,83,
	    82,81,80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64,63,62,61,60,59,58,57,56,
	    55,54,53,52,51,50,49,48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,
	    28,27,26,25,24};



		//While don't exit
		while (1) {

			//STM32F4_Discovery_LEDOn(LED6);
			//Delay_Loop(1000000);

			//Wir fahren mit dieser Schleife die Frequnezen ab
			for (i = 1; i <= 200; i++) {

				//AD9850 Frequenz setzen
				AD9850_SetFrequency(freq_ary[i-1]);

				//STM32F4 Frequenz setzen
				period = period_ary[i - 1];
				PWM_set(period-1);

				//Alter kram - subfunktionen sind noch implementiert
				//UB_DAC_DMA_SetFrq1(1 - 1, period - 1);
				//PWM_Config(period - 1, 1 - 1);

				//Mehrfaches Messen um validität der Ergebnisse zu erhöhen
				meas_comb = 0;
				for(k = 1; k <= n_measures; k++)
				{
					meas_raw = ADC_GetConversionValue(ADC1);
					meas_comb = meas_comb + meas_raw;
				}
				meas_comb = meas_comb/n_measures;
				meas_fin = (int)meas_comb;

				//Konvertieren und Senden der gemessenen Ergebnisse
				if (meas_fin < 1000)
				{
					if (meas_fin > 99)
					{
						sprintf(buffer, "%d", (int)meas_fin);
						strcat(str_output, buffer);
						strcat(str_output, "X");
						Send_String_USART(str_output);
					}
					else
					{
						if (meas_fin > 9)
						{
							sprintf(buffer, "%d", (int)meas_fin);
							strcat(str_output, buffer);
							strcat(str_output, "XX");
							Send_String_USART(str_output);
						}
						else
						{
								sprintf(buffer, "%d", (int)meas_fin);
								strcat(str_output, buffer);
								strcat(str_output, "XXX");
								Send_String_USART(str_output);
						}

					}
				}
				else
				{
					sprintf(str_output, "%d", (int)meas_fin);
					Send_String_USART(str_output);
				}

				buffer[0] = '\0';
				str_output[0] = '\0';
			}
			//Sendevorgang abgeschlossen -> END senden
			Send_String_USART("END\r\n");

			//STM32F4_Discovery_LEDOff(LED6);
			//Delay_Loop(300000);
		}
	}
