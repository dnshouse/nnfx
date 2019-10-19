//+------------------------------------------------------------------+
//|                                                   NNFX V1.20.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#property strict

#define MAGICMA   1234567890
#define _SELL     1
#define _BUY      2

//--- input parameters
extern double  Risk = 0.01;
extern double  MinimumLotSize = 0.1;
extern bool    RiskManagement = true;

extern int     OptimizationStage = 1;

extern double  TP_Multiplier = 0.5;
extern double  SL_Multiplier = 0.5;

extern int     Baseline_Period = 6;
extern int     Baseline_Shift = 4;

extern int     Confirmation_Period = 4;

#include "Classes/Baseline.mqh"
#include "Classes/Confirmation.mqh"
#include "Classes/MoneyManagement.mqh"

Baseline* BaselineInstance;
Confirmation* ConfirmationInstance;
MoneyManagement* MoneyManagementInstance;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   BaselineInstance = new Baseline(Baseline_Period, Baseline_Shift);
   ConfirmationInstance = new Confirmation(Confirmation_Period);
   MoneyManagementInstance = new MoneyManagement(TP_Multiplier, SL_Multiplier, Risk, MinimumLotSize, RiskManagement);
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int LastSignal = 0, CurrentSignal = 0;
void OnTick() {
   if(Bars < 100 || IsTradeAllowed() == false)
      return;

   if(Volume[0] > 1)
      return;

   CurrentSignal = getSignal();
   if(CurrentSignal == LastSignal) {
      return;
   }

   CheckForExit();

   if(CurrentSignal == _SELL) {
      MoneyManagementInstance.Sell();
   }
   if(CurrentSignal == _BUY) {
      MoneyManagementInstance.Buy();
   }

   LastSignal = CurrentSignal;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getSignal() {
   if(OptimizationStage == 1 && BaselineInstance.GetSignal() == _SELL && ConfirmationInstance.GetSignal() == _SELL) {
      return _SELL;
   }

   if(OptimizationStage == 1 && BaselineInstance.GetSignal() == _BUY && ConfirmationInstance.GetSignal() == _BUY) {
      return _BUY;
   }

   return 0;
}

void CheckForExit() {
   CheckForConfirmationSignalExit();
}

int LastConfirmationSignal = 0, CurrentConfirmationSignal = 0;
void CheckForConfirmationSignalExit() {

   CurrentConfirmationSignal = ConfirmationInstance.GetSignal();

   if(CurrentConfirmationSignal > 0 && CurrentConfirmationSignal != LastConfirmationSignal) {
      MoneyManagementInstance.CloseAll();
   }

   if(CurrentConfirmationSignal > 0) {
      LastConfirmationSignal = CurrentConfirmationSignal;
   }
}