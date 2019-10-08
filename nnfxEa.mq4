//+------------------------------------------------------------------+
//|                                                       nnfxEa.mq4 |
//|                                          Copyright © 2019, Deyan |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2019, Deyan."

#define MAGICMA  888

extern bool PrefSettings = true;

extern double Lots = 0.1;

extern double ATR_TP_Multiplier = 1;
extern double ATR_SL_Multiplier = 1.5;

extern int ATR_Offset = 1;
extern int ATR_Period = 14;

extern int Aroon_Offset = 1;
extern int Aroon_Period = 14;

extern int Ichimoku_Offset = 1;
extern int TenkanSen_Period = 9;
extern int KijunSen_Period = 26;

extern int CMF_Offset = 1;
extern int CMF_Period = 20;

extern double EnvelopePercent = 0.008;
extern int EnvelopePeriod = 2;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init() {
   preferredSettings();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getSignal() {
   double aroon_up_current = iCustom(NULL,0,"Aroon Up And Down", Aroon_Period, 0, Aroon_Offset);
   double aroon_down_current = iCustom(NULL,0,"Aroon Up And Down", Aroon_Period, 1, Aroon_Offset);
   double aroon_up_last = iCustom(NULL,0,"Aroon Up And Down", Aroon_Period, 0, Aroon_Offset + 1);
   double aroon_down_last = iCustom(NULL,0,"Aroon Up And Down", Aroon_Period, 1, Aroon_Offset + 1);
   double kijun_sen = iCustom(NULL,0,"Ichimoku", KijunSen_Period, 1, Ichimoku_Offset);
   double cmf = iCustom(NULL,0,"CMF", CMF_Period, 0, CMF_Offset);
   if(aroon_up_last > aroon_down_last && aroon_down_current > aroon_up_current && Bid < kijun_sen && cmf < 0) {
      return 1; // sell
   }
   if(aroon_down_last > aroon_up_last && aroon_up_current > aroon_down_current && Ask > kijun_sen && cmf > 0) {
      return 2; // buy
   }
   return 0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getEnvelopeSignal() {
   double HighEnvelope1 = iEnvelopes(NULL,0,EnvelopePeriod,MODE_SMA,0,PRICE_CLOSE,EnvelopePercent,MODE_UPPER,1);
   double LowEnvelope1  = iEnvelopes(NULL,0,EnvelopePeriod,MODE_SMA,0,PRICE_CLOSE,EnvelopePercent,MODE_LOWER,1);
   double CloseBar1     = iClose(NULL,0,1);
   if(CloseBar1> HighEnvelope1) {
      return 1; // sell
   }
   if(CloseBar1 < LowEnvelope1) {
      return 2; // buy
   }
   return 0;
}

int LastSignal=3,CurrentSignal=3;
int CurrentPosition=3;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start() {
   if(Bars<100 || IsTradeAllowed()==false)
      return;
   if(Volume[0]>1)
      return;
   // CheckForExit();
   // CurrentSignal=getEnvelopeSignal();
   CurrentSignal=getSignal();
   if(CurrentSignal==LastSignal) {
      return;
   }
   if(CurrentSignal==2) {
      CloseAll();
      buy();
   }
   if(CurrentSignal==1) {
      CloseAll();
      sell();
   }
   LastSignal=CurrentSignal;
}
//+------------------------------------------------------------------+
void CheckForExit() {
   double tenkan_sen = iCustom(NULL,0,"Ichimoku", TenkanSen_Period, 0, Ichimoku_Offset);
   if(CurrentPosition == 1 && Ask > tenkan_sen) { // short
      CloseAll();
   }
   if(CurrentPosition == 2 && Bid < tenkan_sen) { // long
      CloseAll();
   }
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lotSize() {
   double riskAmountPerPip = (AccountFreeMargin() * 0.01) / ((iATR(NULL, 0, ATR_Period, ATR_Offset) * ATR_SL_Multiplier) / Point);
   double lot = NormalizeDouble((riskAmountPerPip * (100000 / MarketInfo(Symbol(), MODE_TICKVALUE))) / 100000, 1);
   if(lot < 0.1) {
      lot = 0.1;
   }
   return lot;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void buy() {
   if(AccountFreeMargin()<(1000*Lots)) {
      Print("We have no money. Free Margin = ", AccountFreeMargin());
      return(0);
   }
   CurrentPosition = 2;
   double tp = NormalizeDouble((Ask + (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_TP_Multiplier)),Digits);
   double sl = NormalizeDouble((Ask - (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_SL_Multiplier)),Digits);
   OrderSend(Symbol(),OP_BUY,Lots,Ask,3,sl,tp,"Tester",MAGICMA,0,Blue);
   //OrderSend(Symbol(),OP_BUY,Lots,Ask,3,sl,0,"Tester",MAGICMA,0,Blue);
   return;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void sell() {
   if(AccountFreeMargin()<(1000*Lots)) {
      Print("We have no money. Free Margin = ", AccountFreeMargin());
      return(0);
   }
   CurrentPosition = 1;
   double tp = NormalizeDouble((Bid - (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_TP_Multiplier)),Digits);
   double sl = NormalizeDouble((Bid + (iATR(NULL,0,ATR_Period,ATR_Offset) * ATR_SL_Multiplier)),Digits);
   OrderSend(Symbol(),OP_SELL,Lots,Bid,3,sl,tp,"Tester",MAGICMA,0,Red);
   //OrderSend(Symbol(),OP_SELL,Lots,Bid,3,sl,0,"Tester",MAGICMA,0,Red);
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAll() {
   int Cnt,Error,Mode;
   bool Result;
   CurrentPosition = 3;
   for(Cnt=OrdersTotal(); Cnt>=0; Cnt--) {
      if(OrderSelect(Cnt,SELECT_BY_POS,MODE_TRADES)) {
         Mode=OrderType();
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA) {
            while(true) {
               if(Mode==OP_BUY) {
                  Result=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,Blue);
               }
               if(Mode==OP_SELL) {
                  Result=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,Red);
               }
               if(Result!=TRUE) {
                  Error=GetLastError();
                  Print("LastError = ",Error);
               } else {
                  Error=0;
               }
               if(Error==135) {
                  RefreshRates();
               } else {
                  break;
               }
            }
         }
      } else {
         Print("Error when order select ",GetLastError());
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
         KijunSen_Period = 19;
         CMF_Period = 18;
      }
      if((Symbol() == "AUDCHF") || (Symbol() == "AUDCHFmicro")) {
         ATR_TP_Multiplier = 1.8;
         ATR_SL_Multiplier = 2.0;
         ATR_Period = 3;
         Aroon_Period = 6;
         KijunSen_Period = 29;
         CMF_Period = 17;
      }
      if((Symbol() == "AUDJPY") || (Symbol() == "AUDJPYmicro")) {
         ATR_TP_Multiplier = 0.9;
         ATR_SL_Multiplier = 1.0;
         ATR_Period = 10;
         Aroon_Period = 8;
         KijunSen_Period = 17;
         CMF_Period = 4;
      }
      if((Symbol() == "AUDNZD") || (Symbol() == "AUDNZDmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 0.9;
         ATR_Period = 2;
         Aroon_Period = 12;
         KijunSen_Period = 6;
         CMF_Period = 11;
      }
      if((Symbol() == "AUDUSD") || (Symbol() == "AUDUSDmicro")) {
         ATR_TP_Multiplier = 1.2;
         ATR_SL_Multiplier = 0.6;
         ATR_Period = 4;
         Aroon_Period = 8;
         KijunSen_Period = 21;
         CMF_Period = 5;
      }
      if((Symbol() == "CADCHF") || (Symbol() == "CADCHFmicro")) {
         ATR_TP_Multiplier = 1.9;
         ATR_SL_Multiplier = 2.0;
         ATR_Period = 11;
         Aroon_Period = 4;
         KijunSen_Period = 4;
         CMF_Period = 11;
      }
      if((Symbol() == "CADJPY") || (Symbol() == "CADJPYmicro")) {
         ATR_TP_Multiplier = 1.9;
         ATR_SL_Multiplier = 1.3;
         ATR_Period = 2;
         Aroon_Period = 9;
         KijunSen_Period = 17;
         CMF_Period = 21;
      }
      if((Symbol() == "CHFJPY") || (Symbol() == "CHFJPYmicro")) {
         ATR_TP_Multiplier = 1.9;
         ATR_SL_Multiplier = 0.7;
         ATR_Period = 13;
         Aroon_Period = 14;
         KijunSen_Period = 27;
         CMF_Period = 6;
      }
      if((Symbol() == "EURAUD") || (Symbol() == "EURAUDmicro")) {
         ATR_TP_Multiplier = 1.4;
         ATR_SL_Multiplier = 0.8;
         ATR_Period = 9;
         Aroon_Period = 5;
         KijunSen_Period = 19;
         CMF_Period = 24;
      }
      if((Symbol() == "EURCAD") || (Symbol() == "EURCADmicro")) {
         ATR_TP_Multiplier = 0.6;
         ATR_SL_Multiplier = 1.8;
         ATR_Period = 10;
         Aroon_Period = 5;
         KijunSen_Period = 13;
         CMF_Period = 3;
      }
      if((Symbol() == "EURCHF") || (Symbol() == "EURCHFmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.0;
         ATR_Period = 3;
         Aroon_Period = 2;
         KijunSen_Period = 3;
         CMF_Period = 18;
      }
      if((Symbol() == "EURGBP") || (Symbol() == "EURGBPmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.9;
         ATR_Period = 10;
         Aroon_Period = 9;
         KijunSen_Period = 27;
         CMF_Period = 16;
      }
      if((Symbol() == "EURJPY") || (Symbol() == "EURJPYmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.8;
         ATR_Period = 8;
         Aroon_Period = 2;
         KijunSen_Period = 25;
         CMF_Period = 2;
      }
      if((Symbol() == "EURNZD") || (Symbol() == "EURNZDmicro")) {
         ATR_TP_Multiplier = 1.7;
         ATR_SL_Multiplier = 0.9;
         ATR_Period = 11;
         Aroon_Period = 9;
         KijunSen_Period = 12;
         CMF_Period = 17;
      }
      if((Symbol() == "EURUSD") || (Symbol() == "EURUSDmicro")) {
         ATR_TP_Multiplier = 1.9;
         ATR_SL_Multiplier = 2.0;
         ATR_Period = 11;
         Aroon_Period = 5;
         KijunSen_Period = 17;
         CMF_Period = 22;
      }
      if((Symbol() == "GBPCHF") || (Symbol() == "GBPCHFmicro")) {
         ATR_TP_Multiplier = 1.8;
         ATR_SL_Multiplier = 1.7;
         ATR_Period = 7;
         Aroon_Period = 11;
         KijunSen_Period = 19;
         CMF_Period = 18;
      }
      if((Symbol() == "GBPJPY") || (Symbol() == "GBPJPYmicro")) {
         ATR_TP_Multiplier = 1.7;
         ATR_SL_Multiplier = 1.4;
         ATR_Period = 6;
         Aroon_Period = 14;
         KijunSen_Period = 21;
         CMF_Period = 9;
      }
      if((Symbol() == "GBPUSD") || (Symbol() == "GBPUSDmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.0;
         ATR_Period = 6;
         Aroon_Period = 12;
         KijunSen_Period = 5;
         CMF_Period = 6;
      }
      if((Symbol() == "NZDJPY") || (Symbol() == "NZDJPYmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 2.0;
         ATR_Period = 2;
         Aroon_Period = 6;
         KijunSen_Period = 28;
         CMF_Period = 4;
      }
      if((Symbol() == "NZDUSD") || (Symbol() == "NZDUSDmicro")) {
         ATR_TP_Multiplier = 0.8;
         ATR_SL_Multiplier = 2.0;
         ATR_Period = 5;
         Aroon_Period = 7;
         KijunSen_Period = 16;
         CMF_Period = 2;
      }
      if((Symbol() == "USDCAD") || (Symbol() == "USDCADmicro")) {
         ATR_TP_Multiplier = 2.0;
         ATR_SL_Multiplier = 1.9;
         ATR_Period = 8;
         Aroon_Period = 2;
         KijunSen_Period = 14;
         CMF_Period = 5;
      }
      if((Symbol() == "USDCHF") || (Symbol() == "USDCHFmicro")) {
         ATR_TP_Multiplier = 1.3;
         ATR_SL_Multiplier = 1.7;
         ATR_Period = 5;
         Aroon_Period = 6;
         KijunSen_Period = 17;
         CMF_Period = 26;
      }
      if((Symbol() == "USDJPY") || (Symbol() == "USDJPYmicro")) {
         ATR_TP_Multiplier = 1.1;
         ATR_SL_Multiplier = 1.5;
         ATR_Period = 10;
         Aroon_Period = 2;
         KijunSen_Period = 23;
         CMF_Period = 21;
      }
   }
}

//+------------------------------------------------------------------+
