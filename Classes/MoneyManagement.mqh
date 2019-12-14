//+------------------------------------------------------------------+
//|                                                   NNFX V1.30.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#include "Settings.mqh";

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MoneyManagement
  {
private:
   double            _Risk;
   bool              _RiskManagement;
   double            _MinimumLotSize;

   double            _TPMultiplier;
   double            _SLMultiplier;
   int               _ATRTimeframe;
   int               _ATRPeriod;
   int               _ATROffset;

public:
   void              MoneyManagement()
     {
      Settings* settings = new Settings();

      this._Risk = settings._Risk;
      this._RiskManagement = settings._RiskManagement;
      this._MinimumLotSize = settings._MinimumLotSize;

      this._TPMultiplier = settings._TP_Multiplier;
      this._SLMultiplier = settings._SL_Multiplier;

      this._ATRTimeframe = settings._IndicatorsTimeframe;
      this._ATRPeriod = 14;
      this._ATROffset = settings._IndicatorsOffset;

      delete(settings);
     };

   void             ~MoneyManagement()
     {

     };

   double            LotSize()
     {
      double riskAmountPerPip = (AccountFreeMargin() * this._Risk) / ((iATR(NULL, this._ATRTimeframe, this._ATRPeriod, this._ATROffset) * this._SLMultiplier) / Point);
      double lot = NormalizeDouble((riskAmountPerPip * (100000 / MarketInfo(Symbol(), MODE_TICKVALUE))) / 100000, 2);

      if(lot < this._MinimumLotSize)
        {
         lot = this._MinimumLotSize;
        }

      if(this._RiskManagement == true)
        {
         return lot;
        }

      return this._MinimumLotSize;
     };

   double            LongTP()
     {
      double tp = (Ask + (iATR(NULL,this._ATRTimeframe,this._ATRPeriod,this._ATROffset) * this._TPMultiplier));
      return tp;
     };

   double            LongSL()
     {
      double sl = (Ask - (iATR(NULL,this._ATRTimeframe,this._ATRPeriod,this._ATROffset) * this._SLMultiplier));
      return sl;
     };

   double            ShortTP()
     {
      double tp = (Bid - (iATR(NULL,this._ATRTimeframe,this._ATRPeriod,this._ATROffset) * this._TPMultiplier));
      return tp;
     };

   double            ShortSL()
     {
      double sl = (Bid + (iATR(NULL,this._ATRTimeframe,this._ATRPeriod,this._ATROffset) * this._SLMultiplier));
      return sl;
     };

   void              Sell()
     {
      double lot = LotSize();
      double tp = NormalizeDouble(ShortTP(), Digits);
      double sl = NormalizeDouble(ShortSL(), Digits);

      int order = OrderSend(Symbol(), OP_SELL, lot, Bid, 3, sl, tp, "Tester", MAGICMA, 0, Red);
      return;
     };

   void              Buy()
     {
      double lot = LotSize();
      double tp = NormalizeDouble(LongTP(), Digits);
      double sl = NormalizeDouble(LongSL(), Digits);

      int order = OrderSend(Symbol(), OP_BUY, lot, Ask, 3, sl, tp, "Tester", MAGICMA, 0, Blue);
      return;
     };

   void              CloseAll()
     {
      int Cnt, Mode;

      for(Cnt = OrdersTotal(); Cnt > 0; Cnt--)
        {
         if(OrderSelect(Cnt-1, SELECT_BY_POS, MODE_TRADES))
           {
            Mode = OrderType();
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == MAGICMA)
              {
               while(true)
                 {
                  if(Mode == OP_BUY)
                    {
                     if(!OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 3, Blue))
                        Print("OrderClose error ",GetLastError());
                    }
                  if(Mode == OP_SELL)
                    {
                     if(!OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 3, Red))
                        Print("OrderClose error ",GetLastError());
                    }

                  if(GetLastError() == 135)
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
     };
  };
//+------------------------------------------------------------------+
