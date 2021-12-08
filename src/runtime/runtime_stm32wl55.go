//go:build stm32 && stm32wl55
// +build stm32,stm32wl55

package runtime

import (
	"device/stm32"
	"machine"
)

type arrtype = uint32

func init() {
	// Main Clock
	initCLK()

	// UART init
	machine.Serial.Configure(machine.UARTConfig{})

	// Timers init
	initTickTimer(&machine.TIM1)
}

func putchar(c byte) {
	machine.Serial.WriteByte(c)
}

const (
	FLASH_ACR_LATENCY_WS2 = 0x2
	RCC_CFGR_PPRE1_Div2   = 0x4
	RCC_CFGR_PPRE2_Div1   = 0x0

	RCC_CFGR_SW_MASK   = 0x3
	RCC_CFGR_SW_POS    = 0x0
	RCC_CFGR_SW_MSI    = 0x0
	RCC_CFGR_SW_HSI    = 0x1
	RCC_CFGR_SW_HSE    = 0x2
	RCC_CFGR_SW_PLLCLK = 0x3

	RCC_CFGR_SWS_PLLCLK = 0x3
	RCC_CFGR_SWS_HSI    = 0x1

	HSE_STARTUP_TIMEOUT = 0x0500

	/* PLL Options - See RMN0461 Reference Manual pg. 247 */
	PLL_M = 1
	PLL_N = 8
	PLL_R = 2
	PLL_P = 7
	PLL_Q = 2
)

func initCLK() {

	if machine.OSC_PLLHSE == true { // HSE

		// Set Power Voltage Regulator Range 2
		stm32.PWR.CR1.ReplaceBits(0b10, stm32.PWR_CR1_VOS_Msk, stm32.PWR_CR1_VOS_Pos)

		// Set HSE division factor : HSE clock not divided
		stm32.RCC.CR.ReplaceBits(0b000, 0b1111, stm32.RCC_CR_HSEPRE_Pos)

		// enable external Clock HSE32 TXCO (RM0461p226)
		stm32.RCC.CR.SetBits(stm32.RCC_CR_HSEBYPPWR)
		stm32.RCC.CR.SetBits(stm32.RCC_CR_HSEON)
		for !stm32.RCC.CR.HasBits(stm32.RCC_CR_HSERDY) {
		}

		// Disable PLL
		stm32.RCC.CR.ClearBits(stm32.RCC_CR_PLLON)
		for stm32.RCC.CR.HasBits(stm32.RCC_CR_PLLRDY) {
		}

		// Configure PLL
		stm32.RCC.PLLCFGR.Set(0x22020613)

		// Enable PLL
		stm32.RCC.CR.SetBits(stm32.RCC_CR_PLLON)
		for !stm32.RCC.CR.HasBits(stm32.RCC_CR_PLLRDY) {
		}

		// Enable PLL System Clock output.
		stm32.RCC.PLLCFGR.SetBits(stm32.RCC_PLLCFGR_PLLREN)
		for !stm32.RCC.CR.HasBits(stm32.RCC_CR_PLLRDY) {
		}

		// Set Flash Latency of 2 and wait until it's set properly
		stm32.FLASH.ACR.ReplaceBits(0b010, 0b111, stm32.Flash_ACR_LATENCY_Pos)
		for (stm32.FLASH.ACR.Get() & 0b11) != 0x2 {
		}

	}

	//****************** CLOCK Dividers

	// HCLK1 Configuration (DIV1)
	stm32.RCC.CFGR.ReplaceBits(0x0000, 0b1111, stm32.RCC_CFGR_HPRE_Pos)
	for !stm32.RCC.CFGR.HasBits(stm32.RCC_CFGR_HPREF) {
	}

	// HCLK3 Configuration (DIV1)
	stm32.RCC.EXTCFGR.ReplaceBits(0x0000, 0b1111, stm32.RCC_EXTCFGR_SHDHPRE_Pos)
	for !stm32.RCC.EXTCFGR.HasBits(stm32.RCC_EXTCFGR_SHDHPREF) {
	}

	// PCLK1 Configuration (DIV1)
	stm32.RCC.CFGR.ReplaceBits(0x000, 0b111, stm32.RCC_CFGR_PPRE1_Pos)
	for !stm32.RCC.CFGR.HasBits(stm32.RCC_CFGR_PPRE1F) {
	}

	// PCLK2 Configuration (DIV1)
	stm32.RCC.CFGR.ReplaceBits(0x000, 0b111, stm32.RCC_CFGR_PPRE2_Pos)
	for !stm32.RCC.CFGR.HasBits(stm32.RCC_CFGR_PPRE2F) {
	}

	// Switch Clock source
	if machine.OSC_PLLHSE == true { // HSE
		// Set clock source to PLL (0x3)
		stm32.RCC.CFGR.ReplaceBits(0b11, 0b11, stm32.RCC_CFGR_SW_Pos)
		for (stm32.RCC.CFGR.Get() & stm32.RCC_CFGR_SWS_Msk) != 0xc {
		}
	} else {
		// Set clock source to MSI (0x00)
		stm32.RCC.CFGR.ReplaceBits(0b00, 0b11, stm32.RCC_CFGR_SW_Pos)
		for (stm32.RCC.CFGR.Get() & stm32.RCC_CFGR_SWS_Msk) != 0x00 {
		}

	}

}
