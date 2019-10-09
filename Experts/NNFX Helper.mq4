//+------------------------------------------------------------------+
//|                                                   NNFX_V1.00.mq4 |
//|                                      Copyright 2019, DAsolutions |
//|                                           http://dasolutions.org |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, DAsolutions"
#property link      "http://dasolutions.org"
#property version   "1.00"
#property strict

int ATR_Offset = 1;
extern int ATR_Period = 14;
extern double ATR_TP_Multiplier = 1;
extern double ATR_SL_Multiplier = 1.5;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   PrintComment();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   PrintComment();
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
double LongTP()
  {
// Include the spread into the risk calculation
   double tp = (Ask + (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_TP_Multiplier));
   return tp;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LongSL()
  {
// Include the spread into the risk calculation
   double sl = (Ask - (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_SL_Multiplier));
   return sl;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ShortTP()
  {
// Include the spread into the risk calculation
   double tp = (Bid - (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_TP_Multiplier));
   return tp;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ShortSL()
  {
// Include the spread into the risk calculation
   double sl = (Bid + (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_SL_Multiplier));
   return sl;
  }
//+------------------------------------------------------------------+
