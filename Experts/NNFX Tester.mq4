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
extern bool    RiskManagement = false;
extern double  Risk = 0.02;

extern double  ATR_TP_Multiplier = 1.3;
extern double  ATR_SL_Multiplier = 0.9;
extern int     ATR_Period = 6;
int            ATR_Offset = 1;

extern int     Aroon_Period = 6;
int            Aroon_Offset = 1;

extern int     CMF_Period = 4;
extern double  CMF_Min = 0.04;
int            CMF_Offset = 1;

extern int     ADX_Period = 4;
extern int     Volume_Min = 11;
int            ADX_AppliedPrice = PRICE_CLOSE; // ADX PRICE_CLOSE - can be between 0 - 6
int            ADX_Offset = 1;

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
   if(
      confirmationSignal() == _SELL
      && secondConfirmationSignal() == _SELL
      && checkVolume()
   )
     {
      return _SELL;
     }

   if(
      confirmationSignal() == _BUY
      && secondConfirmationSignal() == _BUY
      && checkVolume()
   )
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

   double tp = NormalizeDouble((Bid - (iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_TP_Multiplier)), Digits);
   double sl = NormalizeDouble((Bid + (iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_SL_Multiplier)), Digits);

   OrderSend(Symbol(), OP_SELL, lot, Bid, 3, sl, tp, "Tester", MAGICMA, 0, Red);
   return;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void buy()
  {
   double lot = lotSize();

   double tp = NormalizeDouble((Ask + (iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_TP_Multiplier)), Digits);
   double sl = NormalizeDouble((Ask - (iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_SL_Multiplier)), Digits);

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
void preferredSettings()
  {
   if(PrefSettings == true)
     {
      if((Symbol() == "AUDCAD") || (Symbol() == "AUDCADmicro"))
        {
         ATR_TP_Multiplier = 2.9;
         ATR_SL_Multiplier = 1.7;
         ATR_Period = 6;

         Aroon_Period = 20;

         CMF_Period = 13;
         CMF_Min = 0.06;

         ADX_Period = 19;
         Volume_Min = 12;
        }

     }
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
