//+------------------------------------------------------------------+
//|                                                         NNFX.mq4 |
//|                                      Copyright 2019, DAsolutions |
//|                                           http://dasolutions.org |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, DAsolutions"
#property link      "http://dasolutions.org"
#property version   "1.10"
#property strict

#define MAGICMA   1234567890
#define _SELL     1
#define _BUY      2

extern bool PrefSettings = true;

//--- input parameters
extern double  MinimumLotSize = 0.1;
extern double  Risk = 0.02;

input double   ATR_TP_Multiplier = 1.3;
input double   ATR_SL_Multiplier = 0.9;
input int      ATR_Period = 6;
int            ATR_Offset = 1;

extern int     Baseline_Period = 6;
extern int     MA_Shift = 4;
extern int     MA_Method = MODE_SMA; // MA MODE_SMA - can be between 0 - 3;
extern int     MA_AppliedPrice = PRICE_CLOSE; // MA PRICE_CLOSE - can be between 0 - 6;
int            Baseline_Offset = 1;

extern int     Aroon_Period = 6;
int            Aroon_Offset = 1;

extern int     CMF_Period = 4;
extern double  CMF_Min = 0.04;
int            CMF_Offset = 1;

extern int     ADX_AppliedPrice = PRICE_CLOSE; // ADX PRICE_CLOSE - can be between 0 - 6
extern int     ADX_Period = 4;
int            ADX_Offset = 1;

extern int     Volume_Min = 11;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   preferredSettings();
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//---
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
      sell();
   }
   if(CurrentSignal == _BUY) {
      buy();
   }

   LastSignal = CurrentSignal;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getSignal() {
   if(
      baselineSignal() == _SELL
      && confirmationSignal() == _SELL
      && secondConfirmationSignal() == _SELL
      && checkVolume()
   ) {
      return _SELL;
   }
   if(
      baselineSignal() == _BUY
      && confirmationSignal() == _BUY
      && secondConfirmationSignal() == _BUY
      && checkVolume()
   ) {
      return _BUY;
   }

   return 0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int baselineSignal() {
   double baseline = iMA(NULL, 0, Baseline_Period, MA_Shift, MA_Method, MA_AppliedPrice, Baseline_Offset);

   if(Bid < baseline) {
      return _SELL;
   }
   if(Ask > baseline) {
      return _BUY;
   }

   return 0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int confirmationSignal() {
   double aroon_up_current = iCustom(NULL, 0, "Aroon Up And Down", Aroon_Period, 0, Aroon_Offset);
   double aroon_down_current = iCustom(NULL, 0, "Aroon Up And Down", Aroon_Period, 1, Aroon_Offset);
   double aroon_up_last = iCustom(NULL, 0, "Aroon Up And Down", Aroon_Period, 0, Aroon_Offset + 1);
   double aroon_down_last = iCustom(NULL, 0, "Aroon Up And Down", Aroon_Period, 1, Aroon_Offset + 1);

   if(aroon_up_last > aroon_down_last && aroon_down_current > aroon_up_current) {
      return _SELL;
   }
   if(aroon_down_last > aroon_up_last && aroon_up_current > aroon_down_current) {
      return _BUY;
   }

   return 0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int secondConfirmationSignal() {
   double cmf = iCustom(NULL, 0, "CMF", CMF_Period, 0, CMF_Offset);

   if(cmf < (0 - CMF_Min)) {
      return _SELL;
   }
   if(cmf > (0 + CMF_Min)) {
      return _BUY;
   }

   return 0;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkVolume() {
   double volume = iADX(NULL, 0, ADX_Period, ADX_AppliedPrice, MODE_MAIN, ADX_Offset);

   if(volume >= Volume_Min) {
      return true;
   }

   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForExit() {
   //CheckForBaselineSignalExit();
   CheckForConfirmationSignalExit();
}

int LastBaselineSignal = 0, CurrentBaselineSignal = 0;
void CheckForBaselineSignalExit() {

   CurrentBaselineSignal = baselineSignal();

   if(CurrentBaselineSignal > 0 && CurrentBaselineSignal != LastBaselineSignal) {
      CloseAll();
   }

   if(CurrentBaselineSignal > 0) {
      LastBaselineSignal = CurrentBaselineSignal;
   }
}

int LastConfirmationSignal = 0, CurrentConfirmationSignal = 0;
void CheckForConfirmationSignalExit() {

   CurrentConfirmationSignal = confirmationSignal();

   if(CurrentConfirmationSignal > 0 && CurrentConfirmationSignal != LastConfirmationSignal) {
      CloseAll();
   }

   if(CurrentConfirmationSignal > 0) {
      LastConfirmationSignal = CurrentConfirmationSignal;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lotSize() {
   double riskAmountPerPip = (AccountFreeMargin() * Risk) / ((iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_SL_Multiplier) / Point);
   double lot = NormalizeDouble((riskAmountPerPip * (100000 / MarketInfo(Symbol(), MODE_TICKVALUE))) / 100000, 1);

   if(lot < MinimumLotSize) {
      lot = MinimumLotSize;
   }
   return lot;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void sell() {
   double lot = lotSize();
   if(AccountFreeMargin() < (1000 * lot)) {
      Print("We have no money. Free Margin = ", AccountFreeMargin());
      return;
   }

   double tp = NormalizeDouble((Bid - (iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_TP_Multiplier)), Digits);
   double sl = NormalizeDouble((Bid + (iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_SL_Multiplier)), Digits);

   OrderSend(Symbol(), OP_SELL, lot, Bid, 3, sl, tp, "Tester", MAGICMA, 0, Red);
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void buy() {
   double lot = lotSize();
   if(AccountFreeMargin() < (1000 * lot)) {
      Print("We have no money. Free Margin = ", AccountFreeMargin());
      return;
   }

   double tp = NormalizeDouble((Ask + (iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_TP_Multiplier)), Digits);
   double sl = NormalizeDouble((Ask - (iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_SL_Multiplier)), Digits);

   OrderSend(Symbol(), OP_BUY, lot, Ask, 3, sl, tp, "Tester", MAGICMA, 0, Blue);
   return;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAll() {
   int Cnt, Error, Mode;
   bool Result;

   for(Cnt = OrdersTotal(); Cnt >= 0; Cnt--) {
      if(OrderSelect(Cnt, SELECT_BY_POS, MODE_TRADES)) {
         Mode = OrderType();
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MAGICMA) {
            while(true) {
               if(Mode == OP_BUY) {
                  Result = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 3, Blue);
               }
               if(Mode == OP_SELL) {
                  Result = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 3, Red);
               }

               if(Result != TRUE) {
                  Error = GetLastError();
                  Print("LastError = ", Error);
               } else {
                  Error = 0;
               }

               if(Error == 135) {
                  RefreshRates();
               } else {
                  break;
               }
            }
         }
      } else {
         Print("Error when order select ", GetLastError());
      }
   }
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void preferredSettings() {
   if(PrefSettings == true) {
      if((Symbol() == "AUDCAD") || (Symbol() == "AUDCADmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 0.9;
         ATR_Period = 4;
         Aroon_Period = 8;
         Baseline_Period = 19;
         CMF_Period = 18;
      }
      if((Symbol() == "AUDCHF") || (Symbol() == "AUDCHFmicro")) {
         ATR_TP_Multiplier = 1.8;
         ATR_SL_Multiplier = 2.0;
         ATR_Period = 3;
         Aroon_Period = 6;
         Baseline_Period = 29;
         CMF_Period = 17;
      }
      if((Symbol() == "AUDJPY") || (Symbol() == "AUDJPYmicro")) {
         ATR_TP_Multiplier = 0.9;
         ATR_SL_Multiplier = 1.0;
         ATR_Period = 10;
         Aroon_Period = 8;
         Baseline_Period = 17;
         CMF_Period = 4;
      }
      if((Symbol() == "AUDNZD") || (Symbol() == "AUDNZDmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 0.9;
         ATR_Period = 2;
         Aroon_Period = 12;
         Baseline_Period = 6;
         CMF_Period = 11;
      }
      if((Symbol() == "AUDUSD") || (Symbol() == "AUDUSDmicro")) {
         ATR_TP_Multiplier = 1.2;
         ATR_SL_Multiplier = 0.6;
         ATR_Period = 4;
         Aroon_Period = 8;
         Baseline_Period = 21;
         CMF_Period = 5;
      }
      if((Symbol() == "CADCHF") || (Symbol() == "CADCHFmicro")) {
         ATR_TP_Multiplier = 1.9;
         ATR_SL_Multiplier = 2.0;
         ATR_Period = 11;
         Aroon_Period = 4;
         Baseline_Period = 4;
         CMF_Period = 11;
      }
      if((Symbol() == "CADJPY") || (Symbol() == "CADJPYmicro")) {
         ATR_TP_Multiplier = 1.9;
         ATR_SL_Multiplier = 1.3;
         ATR_Period = 2;
         Aroon_Period = 9;
         Baseline_Period = 17;
         CMF_Period = 21;
      }
      if((Symbol() == "CHFJPY") || (Symbol() == "CHFJPYmicro")) {
         ATR_TP_Multiplier = 1.9;
         ATR_SL_Multiplier = 0.7;
         ATR_Period = 13;
         Aroon_Period = 14;
         Baseline_Period = 27;
         CMF_Period = 6;
      }
      if((Symbol() == "EURAUD") || (Symbol() == "EURAUDmicro")) {
         ATR_TP_Multiplier = 1.4;
         ATR_SL_Multiplier = 0.8;
         ATR_Period = 9;
         Aroon_Period = 5;
         Baseline_Period = 19;
         CMF_Period = 24;
      }
      if((Symbol() == "EURCAD") || (Symbol() == "EURCADmicro")) {
         ATR_TP_Multiplier = 0.6;
         ATR_SL_Multiplier = 1.8;
         ATR_Period = 10;
         Aroon_Period = 5;
         Baseline_Period = 13;
         CMF_Period = 3;
      }
      if((Symbol() == "EURCHF") || (Symbol() == "EURCHFmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.0;
         ATR_Period = 3;
         Aroon_Period = 2;
         Baseline_Period = 3;
         CMF_Period = 18;
      }
      if((Symbol() == "EURGBP") || (Symbol() == "EURGBPmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.9;
         ATR_Period = 10;
         Aroon_Period = 9;
         Baseline_Period = 27;
         CMF_Period = 16;
      }
      if((Symbol() == "EURJPY") || (Symbol() == "EURJPYmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.8;
         ATR_Period = 8;
         Aroon_Period = 2;
         Baseline_Period = 25;
         CMF_Period = 2;
      }
      if((Symbol() == "EURNZD") || (Symbol() == "EURNZDmicro")) {
         ATR_TP_Multiplier = 1.7;
         ATR_SL_Multiplier = 0.9;
         ATR_Period = 11;
         Aroon_Period = 9;
         Baseline_Period = 12;
         CMF_Period = 17;
      }
      if((Symbol() == "EURUSD") || (Symbol() == "EURUSDmicro")) {
         ATR_TP_Multiplier = 1.9;
         ATR_SL_Multiplier = 2.0;
         ATR_Period = 11;
         Aroon_Period = 5;
         Baseline_Period = 17;
         CMF_Period = 22;
      }
      if((Symbol() == "GBPCHF") || (Symbol() == "GBPCHFmicro")) {
         ATR_TP_Multiplier = 1.8;
         ATR_SL_Multiplier = 1.7;
         ATR_Period = 7;
         Aroon_Period = 11;
         Baseline_Period = 19;
         CMF_Period = 18;
      }
      if((Symbol() == "GBPJPY") || (Symbol() == "GBPJPYmicro")) {
         ATR_TP_Multiplier = 1.7;
         ATR_SL_Multiplier = 1.4;
         ATR_Period = 6;
         Aroon_Period = 14;
         Baseline_Period = 21;
         CMF_Period = 9;
      }
      if((Symbol() == "GBPUSD") || (Symbol() == "GBPUSDmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.0;
         ATR_Period = 6;
         Aroon_Period = 12;
         Baseline_Period = 5;
         CMF_Period = 6;
      }
      if((Symbol() == "NZDJPY") || (Symbol() == "NZDJPYmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 2.0;
         ATR_Period = 2;
         Aroon_Period = 6;
         Baseline_Period = 28;
         CMF_Period = 4;
      }
      if((Symbol() == "NZDUSD") || (Symbol() == "NZDUSDmicro")) {
         ATR_TP_Multiplier = 0.8;
         ATR_SL_Multiplier = 2.0;
         ATR_Period = 5;
         Aroon_Period = 7;
         Baseline_Period = 16;
         CMF_Period = 2;
      }
      if((Symbol() == "USDCAD") || (Symbol() == "USDCADmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.9;
         ATR_Period = 8;
         Aroon_Period = 2;
         Baseline_Period = 14;
         CMF_Period = 5;
      }
      if((Symbol() == "USDCHF") || (Symbol() == "USDCHFmicro")) {
         ATR_TP_Multiplier = 1.3;
         ATR_SL_Multiplier = 1.7;
         ATR_Period = 5;
         Aroon_Period = 6;
         Baseline_Period = 17;
         CMF_Period = 26;
      }
      if((Symbol() == "USDJPY") || (Symbol() == "USDJPYmicro")) {
         ATR_TP_Multiplier = 1.1;
         ATR_SL_Multiplier = 1.5;
         ATR_Period = 10;
         Aroon_Period = 2;
         Baseline_Period = 23;
         CMF_Period = 21;
      }
   }
}

//+------------------------------------------------------------------+