//+------------------------------------------------------------------+
//|                                                             NNFX |
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
   bool              _RiskManagement;
   double            _Risk;

   int               _StopLoss;
   int               _TargetProfit;

   bool              _ATREnabled;
   int               _ATRTimeframe;
   int               _ATROffset;
   int               _ATRPeriod;

   double            _SLMultiplier;
   double            _TPMultiplier;

public:
   void              MoneyManagement()
     {
      Settings* settings = new Settings();

      this._RiskManagement = settings._RiskManagement;
      this._Risk = settings._Risk;

      this._StopLoss = settings._StopLoss;
      this._TargetProfit = settings._TargetProfit;

      this._ATREnabled = settings._ATR_Enabled;
      this._ATRTimeframe = settings._IndicatorsTimeframe;
      this._ATROffset = settings._IndicatorsOffset;
      this._ATRPeriod = settings._ATR_Period;

      this._SLMultiplier = settings._SL_Multiplier;
      this._TPMultiplier = settings._TP_Multiplier;

      delete(settings);
     }

   void             ~MoneyManagement()
     {

     }

   double            LongSL()
     {
      double sl;
      double atr;

      if(this._ATREnabled == true)
        {
         atr = (iATR(NULL,this._ATRTimeframe,this._ATRPeriod,this._ATROffset) * this._SLMultiplier) / Point / 10;
        }
      else
        {
         atr = this._StopLoss;
        }

      if(atr > (MarketInfo(Symbol(), MODE_STOPLEVEL) + MarketInfo(Symbol(), MODE_SPREAD)))
        {
         sl = (Bid - (atr * Point));
        }
      else
        {
         sl = (Bid - (MarketInfo(Symbol(), MODE_STOPLEVEL)) * Point);
        }

      return sl;
     }

   double            ShortSL()
     {
      double sl;
      double atr;

      if(this._ATREnabled == true)
        {
         atr = (iATR(NULL,this._ATRTimeframe,this._ATRPeriod,this._ATROffset) * this._SLMultiplier) / Point / 10;
        }
      else
        {
         atr = this._StopLoss;
        }

      if(atr > (MarketInfo(Symbol(), MODE_STOPLEVEL)))
        {
         sl = (Ask + (atr * Point));
        }
      else
        {
         sl = (Ask + (MarketInfo(Symbol(), MODE_STOPLEVEL)) * Point);
        }

      return sl;
     }

   double            LongTP()
     {
      double tp;
      double atr;

      if(this._ATREnabled == true)
        {
         atr = (iATR(NULL,this._ATRTimeframe,this._ATRPeriod,this._ATROffset) * this._TPMultiplier) / Point / 10;
        }
      else
        {
         atr = this._TargetProfit;
        }

      tp = (Ask + (atr * Point));
      return tp;
     }

   double            ShortTP()
     {
      double tp;
      double atr;

      if(this._ATREnabled == true)
        {
         atr = (iATR(NULL,this._ATRTimeframe,this._ATRPeriod,this._ATROffset) * this._TPMultiplier) / Point / 10;
        }
      else
        {
         atr = this._TargetProfit;
        }

      tp = (Bid - (atr * Point));
      return tp;
     }

   double            LotSize()
     {
      double atr;

      if(this._ATREnabled == true)
        {
         atr = (iATR(NULL,this._ATRTimeframe,this._ATRPeriod,this._ATROffset) * this._SLMultiplier) / Point / 10;
        }
      else
        {
         atr = this._StopLoss + MarketInfo(Symbol(), MODE_SPREAD);
        }

      double riskAmountPerPip = (AccountFreeMargin() * this._Risk) / atr;
      double lot = (riskAmountPerPip * (MarketInfo(Symbol(), MODE_LOTSIZE) / MarketInfo(Symbol(), MODE_TICKVALUE))) / MarketInfo(Symbol(), MODE_LOTSIZE);
      double minlot = MarketInfo(Symbol(), MODE_MINLOT);
      double maxlot = MarketInfo(Symbol(), MODE_MAXLOT);

      if(lot < minlot)
         lot = minlot;

      if(lot > maxlot)
         lot = maxlot;

      int lotDigits = 0;
      if(MarketInfo(Symbol(), MODE_LOTSTEP) == 0.1)
         lotDigits = 1;
      if(MarketInfo(Symbol(), MODE_LOTSTEP) == 0.01)
         lotDigits = 2;

      return NormalizeDouble(lot, lotDigits);
     }

   void              Buy()
     {
      double tp = NormalizeDouble(LongTP(), Digits);
      double sl = NormalizeDouble(LongSL(), Digits);

      int order = OrderSend(Symbol(), OP_BUY, LotSize(), Ask, 3, sl, tp, "Tester", MAGICMA, 0, Blue);
      return;
     }

   void              Sell()
     {
      double tp = NormalizeDouble(ShortTP(), Digits);
      double sl = NormalizeDouble(ShortSL(), Digits);

      int order = OrderSend(Symbol(), OP_SELL, LotSize(), Bid, 3, sl, tp, "Tester", MAGICMA, 0, Red);
      return;
     }

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
     }
  };
//+------------------------------------------------------------------+
