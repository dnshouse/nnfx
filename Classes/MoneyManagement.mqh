//+------------------------------------------------------------------+
//|                                                   NNFX V1.20.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
class MoneyManagement
{
private:
   double            _Risk;
   double            _MinimumLotSize;
   bool              _RiskManagement;
   double            _TPMultiplier;
   double            _SLMultiplier;
   int               _ATRPeriod;
   int               _ATROffset;

public:
   void              MoneyManagement(double iTP_Multiplier, double iSL_Multiplier, double iRisk = 0.01, double iMinimumLotSize = 0.1, bool iRiskManagement = true, int iATROffset = 1)
   {
      this._Risk = iRisk;
      this._MinimumLotSize = iMinimumLotSize;
      this._RiskManagement = iRiskManagement;
      this._TPMultiplier = iTP_Multiplier;
      this._SLMultiplier = iTP_Multiplier * iSL_Multiplier;
      this._ATRPeriod = 14;
      this._ATROffset = iATROffset;
   };

   double            LotSize()
   {
      double riskAmountPerPip = (AccountFreeMargin() * this._Risk) / ((iATR(NULL, 0, this._ATRPeriod, this._ATROffset) * this._SLMultiplier) / Point);
      double lot = NormalizeDouble((riskAmountPerPip * (100000 / MarketInfo(Symbol(), MODE_TICKVALUE))) / 100000, 1);

      if(lot < this._MinimumLotSize) {
         lot = this._MinimumLotSize;
      }

      if(this._RiskManagement == true) {
         return lot;
      }

      return this._MinimumLotSize;
   };

   void              Sell()
   {
      double lot = LotSize();
      double tp = NormalizeDouble(ShortTP(), Digits);
      double sl = NormalizeDouble(ShortSL(), Digits);

      OrderSend(Symbol(), OP_SELL, lot, Bid, 3, sl, tp, "Tester", MAGICMA, 0, Red);
      return;
   };

   void              Buy()
   {
      double lot = LotSize();
      double tp = NormalizeDouble(LongTP(), Digits);
      double sl = NormalizeDouble(LongSL(), Digits);

      OrderSend(Symbol(), OP_BUY, lot, Ask, 3, sl, tp, "Tester", MAGICMA, 0, Blue);
      return;
   };

   void              CloseAll()
   {
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
   };

   double            LongTP()
   {
      double tp = (Ask + (iATR(NULL,0,this._ATRPeriod,this._ATROffset) * this._TPMultiplier));
      return tp;
   };

   double            LongSL()
   {
      double sl = (Ask - (iATR(NULL,0,this._ATRPeriod,this._ATROffset) * this._SLMultiplier));
      return sl;
   };

   double            ShortTP()
   {
      double tp = (Bid - (iATR(NULL,0,this._ATRPeriod,this._ATROffset) * this._TPMultiplier));
      return tp;
   };

   double            ShortSL()
   {
      double sl = (Bid + (iATR(NULL,0,this._ATRPeriod,this._ATROffset) * this._SLMultiplier));
      return sl;
   };
};
//+------------------------------------------------------------------+
