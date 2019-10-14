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

extern bool    PrefSettings = true;

//--- input parameters
extern double  MinimumLotSize = 0.1;
extern bool    RiskManagement = true;
extern double  Risk = 0.01;

extern int     OptimizationStage = 3;

int            ATR_Period = 14;
int            ATR_Offset = 1;
extern double  ATR_TP_Multiplier = 0.5;
extern double  ATR_SL_Multiplier = 0.5;

extern int     Aroon_Period = 4;
int            Aroon_Offset = 1;

extern int     CMF_Period = 14;
int            CMF_Offset = 1;
extern double  CMF_Min = 0.04;

int            ADX_AppliedPrice = PRICE_CLOSE; // ADX PRICE_CLOSE - can be between 0 - 6
int            ADX_Period = 14;
int            ADX_Offset = 1;
extern int     Volume_Min = 5;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   preferredSettings();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int LastSignal = 0, CurrentSignal = 0;
void OnTick()
  {
   if(Bars < 100 || IsTradeAllowed() == false)
      return;

   if(Volume[0] > 1)
      return;

   PrintComment();

   CurrentSignal = getSignal();
   if(CurrentSignal == LastSignal)
     {
      return;
     }

   CheckForExit();

   if(CurrentSignal == _SELL)
     {
      sell();
     }
   if(CurrentSignal == _BUY)
     {
      buy();
     }

   LastSignal = CurrentSignal;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getSignal()
  {
   if(OptimizationStage == 1 && confirmationSignal() == _SELL)
     {
      return _SELL;
     }

   if(OptimizationStage == 2 && confirmationSignal() == _SELL && secondConfirmationSignal() == _SELL)
     {
      return _SELL;
     }

   if(OptimizationStage == 3 && confirmationSignal() == _SELL && secondConfirmationSignal() == _SELL && checkVolume())
     {
      return _SELL;
     }

   if(OptimizationStage == 1 && confirmationSignal() == _BUY)
     {
      return _BUY;
     }

   if(OptimizationStage == 2 && confirmationSignal() == _BUY && secondConfirmationSignal() == _BUY)
     {
      return _BUY;
     }

   if(OptimizationStage == 3 && confirmationSignal() == _BUY && secondConfirmationSignal() == _BUY && checkVolume())
     {
      return _BUY;
     }

   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int confirmationSignal()
  {
   double aroon_up_current = iCustom(NULL, 0, "Aroon Up And Down", Aroon_Period, 0, Aroon_Offset);
   double aroon_down_current = iCustom(NULL, 0, "Aroon Up And Down", Aroon_Period, 1, Aroon_Offset);
   double aroon_up_last = iCustom(NULL, 0, "Aroon Up And Down", Aroon_Period, 0, Aroon_Offset + 1);
   double aroon_down_last = iCustom(NULL, 0, "Aroon Up And Down", Aroon_Period, 1, Aroon_Offset + 1);

   if(aroon_up_last > aroon_down_last && aroon_down_current > aroon_up_current)
     {
      return _SELL;
     }
   if(aroon_down_last > aroon_up_last && aroon_up_current > aroon_down_current)
     {
      return _BUY;
     }

   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int secondConfirmationSignal()
  {
   double cmf = iCustom(NULL, 0, "CMF", CMF_Period, 0, CMF_Offset);

   if(cmf < (0 - CMF_Min))
     {
      return _SELL;
     }
   if(cmf > (0 + CMF_Min))
     {
      return _BUY;
     }

   return 0;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkVolume()
  {
   double volume = iADX(NULL, 0, ADX_Period, ADX_AppliedPrice, MODE_MAIN, ADX_Offset);

   if(volume >= Volume_Min)
     {
      return true;
     }

   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForExit()
  {
   CheckForConfirmationSignalExit();
  }

int LastConfirmationSignal = 0, CurrentConfirmationSignal = 0;
void CheckForConfirmationSignalExit()
  {

   CurrentConfirmationSignal = confirmationSignal();

   if(CurrentConfirmationSignal > 0 && CurrentConfirmationSignal != LastConfirmationSignal)
     {
      CloseAll();
     }

   if(CurrentConfirmationSignal > 0)
     {
      LastConfirmationSignal = CurrentConfirmationSignal;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LongTP()
  {
   double tp = (Ask + (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_TP_Multiplier));
   return tp;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LongSL()
  {
   double sl = (Ask - (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_SL_Multiplier));
   return sl;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ShortTP()
  {
   double tp = (Bid - (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_TP_Multiplier));
   return tp;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ShortSL()
  {
   double sl = (Bid + (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_SL_Multiplier));
   return sl;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lotSize()
  {
   double riskAmountPerPip = (AccountFreeMargin() * Risk) / ((iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_SL_Multiplier) / Point);
   double lot = NormalizeDouble((riskAmountPerPip * (100000 / MarketInfo(Symbol(), MODE_TICKVALUE))) / 100000, 1);

   if(lot < MinimumLotSize)
     {
      lot = MinimumLotSize;
     }

   if(RiskManagement == true)
     {
      return lot;
     }

   return MinimumLotSize;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void sell()
  {
   double lot = lotSize();
   double tp = NormalizeDouble(ShortTP(), Digits);
   double sl = NormalizeDouble(ShortSL(), Digits);

   OrderSend(Symbol(), OP_SELL, lot, Bid, 3, sl, tp, "Tester", MAGICMA, 0, Red);
   return;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void buy()
  {
   double lot = lotSize();
   double tp = NormalizeDouble(LongTP(), Digits);
   double sl = NormalizeDouble(LongSL(), Digits);

   OrderSend(Symbol(), OP_BUY, lot, Ask, 3, sl, tp, "Tester", MAGICMA, 0, Blue);
   return;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAll()
  {
   int Cnt, Error, Mode;
   bool Result;

   for(Cnt = OrdersTotal(); Cnt >= 0; Cnt--)
     {
      if(OrderSelect(Cnt, SELECT_BY_POS, MODE_TRADES))
        {
         Mode = OrderType();
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MAGICMA)
           {
            while(true)
              {
               if(Mode == OP_BUY)
                 {
                  Result = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 3, Blue);
                 }
               if(Mode == OP_SELL)
                 {
                  Result = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 3, Red);
                 }

               if(Result != TRUE)
                 {
                  Error = GetLastError();
                  Print("LastError = ", Error);
                 }
               else
                 {
                  Error = 0;
                 }

               if(Error == 135)
                 {
                  RefreshRates();
                 }
               else
                 {
                  break;
                 }
              }
           }
        }
      else
        {
         Print("Error when order select ", GetLastError());
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrintComment()
  {
   double riskAmountPerPip = (1000*0.02) / ((iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_SL_Multiplier) / Point);
   double lot = NormalizeDouble((riskAmountPerPip * (100000 / MarketInfo(Symbol(), MODE_TICKVALUE))) / 100000, 2);

   Comment(
      "\nBid : ", DoubleToString(Bid,Digits),
      "\nAsk : ", DoubleToString(Ask,Digits),
      "\nSpread : ", DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD), 0),
      "\nPipValue : ", DoubleToStr(MarketInfo(Symbol(), MODE_TICKVALUE), Digits),

      "\nATR(",ATR_Period,"): ", DoubleToString(iATR(NULL,0,ATR_Period,ATR_Offset),Digits),

      "\nLongTP : ", DoubleToString(LongTP(),Digits),
      "\nLongSL : ", DoubleToString(LongSL(),Digits),
      "\nShortTP : ", DoubleToString(ShortTP(),Digits),
      "\nShortSL : ", DoubleToString(ShortSL(),Digits),
      "\nLot Size : ", DoubleToString(lot, 2)
   );
   /*
   int i;
   for(i=Bars; i>0; i--){
      double aroon_up_current = iCustom(NULL,0,"Aroon Up And Down", Aroon_Period, 0, i-1);
      double aroon_down_current = iCustom(NULL,0,"Aroon Up And Down", Aroon_Period, 1, i-1);

      double aroon_up_last = iCustom(NULL,0,"Aroon Up And Down", Aroon_Period, 0, i);
      double aroon_down_last = iCustom(NULL,0,"Aroon Up And Down", Aroon_Period, 1, i);

      if(aroon_up_last > aroon_down_last && aroon_down_current > aroon_up_current)
        {
         ObjectCreate(NULL,i,OBJ_ARROW_SELL,0,Time[i-2],Low[i]-20*Point);
         ObjectSetInteger(NULL,i,OBJPROP_COLOR,C'225,68,29');
        }

      if(aroon_down_last > aroon_up_last && aroon_up_current > aroon_down_current)
        {
         ObjectCreate(NULL,i,OBJ_ARROW_BUY,0,Time[i-2],High[i]+20*Point);
         ObjectSetInteger(NULL,i,OBJPROP_COLOR,C'3,95,172');
        }
   }
   */
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void preferredSettings()
  {
   if(PrefSettings == true)
     {
      if((Symbol() == "AUDCAD") || (Symbol() == "AUDCADmicro"))
        {
         ATR_TP_Multiplier = 2.6;
         ATR_SL_Multiplier = 0.8;
         Aroon_Period = 18;
         CMF_Period = 16;
         CMF_Min = 0.05;
         Volume_Min = 15;
        }

      if((Symbol() == "AUDCHF") || (Symbol() == "AUDCHFmicro"))
        {
         ATR_TP_Multiplier = 3.0;
         ATR_SL_Multiplier = 1.3;
         Aroon_Period = 16;
         CMF_Period = 10;
         CMF_Min = 0.02;
         Volume_Min = 18;
        }

      if((Symbol() == "AUDJPY") || (Symbol() == "AUDJPYmicro"))
        {
         ATR_TP_Multiplier = 1.8;
         ATR_SL_Multiplier = 1.0;
         Aroon_Period = 8;
         CMF_Period = 9;
         CMF_Min = 0.03;
         Volume_Min = 10;
        }

      if((Symbol() == "AUDNZD") || (Symbol() == "AUDNZDmicro"))
        {
         ATR_TP_Multiplier = 2.1;
         ATR_SL_Multiplier = 0.9;
         Aroon_Period = 12;
         CMF_Period = 6;
         CMF_Min = 0.07;
         Volume_Min = 10;
        }

      if((Symbol() == "AUDUSD") || (Symbol() == "AUDUSDmicro"))
        {
         ATR_TP_Multiplier = 1.3;
         ATR_SL_Multiplier = 0.5;
         Aroon_Period = 8;
         CMF_Period = 4;
         CMF_Min = 0.02;
         Volume_Min = 15;
        }

      if((Symbol() == "CADCHF") || (Symbol() == "CADCHFmicro"))
        {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 0.6;
         Aroon_Period = 20;
         CMF_Period = 12;
         CMF_Min = 0.02;
         Volume_Min = 16;
        }

      if((Symbol() == "CADJPY") || (Symbol() == "CADJPYmicro"))
        {
         ATR_TP_Multiplier = 2.1;
         ATR_SL_Multiplier = 0.9;
         Aroon_Period = 4;
         CMF_Period = 5;
         CMF_Min = 0.02;
         Volume_Min = 14;
        }

      if((Symbol() == "CHFJPY") || (Symbol() == "CHFJPYmicro"))
        {
         ATR_TP_Multiplier = 2.9;
         ATR_SL_Multiplier = 0.7;
         Aroon_Period = 21;
         CMF_Period = 10;
         CMF_Min = 0.05;
         Volume_Min = 17;
        }

      if((Symbol() == "EURAUD") || (Symbol() == "EURAUDmicro"))
        {
         ATR_TP_Multiplier = 2.1;
         ATR_SL_Multiplier = 0.5;
         Aroon_Period = 8;
         CMF_Period = 8;
         CMF_Min = 0.03;
         Volume_Min = 14;
        }

      if((Symbol() == "EURCAD") || (Symbol() == "EURCADmicro"))
        {
         ATR_TP_Multiplier = 2.1;
         ATR_SL_Multiplier = 0.9;
         Aroon_Period = 19;
         CMF_Period = 10;
         CMF_Min = 0.09;
         Volume_Min = 9;
        }

      if((Symbol() == "EURCHF") || (Symbol() == "EURCHFmicro"))
        {
         ATR_TP_Multiplier = 2.8;
         ATR_SL_Multiplier = 1.4;
         Aroon_Period = 19;
         CMF_Period = 5;
         CMF_Min = 0.01;
         Volume_Min = 17;
        }

      if((Symbol() == "EURGBP") || (Symbol() == "EURGBPmicro"))
        {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.8;
         Aroon_Period = 10;
         CMF_Period = 5;
         CMF_Min = 0.02;
         Volume_Min = 20;
        }


      if((Symbol() == "EURJPY") || (Symbol() == "EURJPYmicro"))
        {
         // hard to match all the brokers
        }

      if((Symbol() == "EURNZD") || (Symbol() == "EURNZDmicro"))
        {
         ATR_TP_Multiplier = 2.1;
         ATR_SL_Multiplier = 0.6;
         Aroon_Period = 4;
         CMF_Period = 4;
         CMF_Min = 0.01;
         Volume_Min = 16;
        }

      if((Symbol() == "EURUSD") || (Symbol() == "EURUSDmicro"))
        {
         // hard to match all the brokers
        }

      //if((Symbol() == "GBPAUD") || (Symbol() == "GBPAUDmicro"))
      //{

      //}

      //if((Symbol() == "GBPCAD") || (Symbol() == "GBPCADmicro"))
      //{

      //}

      if((Symbol() == "GBPCHF") || (Symbol() == "GBPCHFmicro"))
        {
         ATR_TP_Multiplier = 2.8;
         ATR_SL_Multiplier = 1.2;
         Aroon_Period = 13;
         CMF_Period = 7;
         CMF_Min = 0.02;
         Volume_Min = 13;
        }

      if((Symbol() == "GBPJPY") || (Symbol() == "GBPJPYmicro"))
        {
         ATR_TP_Multiplier = 2.7;
         ATR_SL_Multiplier = 1.5;
         Aroon_Period = 14;
         CMF_Period = 4;
         CMF_Min = 0.02;
         Volume_Min = 16;
        }

      //if((Symbol() == "GBPNZD") || (Symbol() == "GBPNZDmicro"))
      //{

      //}

      if((Symbol() == "GBPUSD") || (Symbol() == "GBPUSDmicro"))
        {
         ATR_TP_Multiplier = 2.2;
         ATR_SL_Multiplier = 0.6;
         Aroon_Period = 9;
         CMF_Period = 7;
         CMF_Min = 0.04;
         Volume_Min = 6;
        }

      //if((Symbol() == "NZDCAD") || (Symbol() == "NZDCADmicro"))
      //{

      //}

      //if((Symbol() == "NZDCHF") || (Symbol() == "NZDCHFmicro"))
      //{

      //}

      if((Symbol() == "NZDJPY") || (Symbol() == "NZDJPYmicro"))
        {
         ATR_TP_Multiplier = 2.9;
         ATR_SL_Multiplier = 1.0;
         Aroon_Period = 6;
         CMF_Period = 4;
         CMF_Min = 0.02;
         Volume_Min = 15;
        }

      if((Symbol() == "NZDUSD") || (Symbol() == "NZDUSDmicro"))
        {
         ATR_TP_Multiplier = 1.9;
         ATR_SL_Multiplier = 0.7;
         Aroon_Period = 4;
         CMF_Period = 4;
         CMF_Min = 0.01;
         Volume_Min = 4;
        }

      if((Symbol() == "USDCAD") || (Symbol() == "USDCADmicro"))
        {
         ATR_TP_Multiplier = 1.3;
         ATR_SL_Multiplier = 0.5;
         Aroon_Period = 5;
         CMF_Period = 6;
         CMF_Min = 0.03;
         Volume_Min = 9;
        }

      if((Symbol() == "USDCHF") || (Symbol() == "USDCHFmicro"))
        {
         ATR_TP_Multiplier = 1.9;
         ATR_SL_Multiplier = 0.5;
         Aroon_Period = 8;
         CMF_Period = 4;
         CMF_Min = 0.01;
         Volume_Min = 15;
        }

      if((Symbol() == "USDJPY") || (Symbol() == "USDJPYmicro"))
        {
         ATR_TP_Multiplier = 2.1;
         ATR_SL_Multiplier = 1.0;
         Aroon_Period = 21;
         CMF_Period = 14;
         CMF_Min = 0.01;
         Volume_Min = 5;
        }
     }
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
