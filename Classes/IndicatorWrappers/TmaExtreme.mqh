//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
class TmaExtreme
  {
private:
   int               _timeframe;
   int               _offset;

public:
   void              TmaExtreme(int timeframe = 0, int offset = 1)
     {
      this._timeframe = timeframe;
      this._offset = offset;
     }

   void             ~TmaExtreme()
     {

     }

   double            GetTMA()
     {
      return iCustom(NULL, this._timeframe, "Tma Extreme", 0, this._offset);
     }

   double            GetUpperBand()
     {
      return iCustom(NULL, this._timeframe, "Tma Extreme", 1, this._offset);
     }

   double            GetLowerBand()
     {
      return iCustom(NULL, this._timeframe, "Tma Extreme", 2, this._offset);
     }

   int               GetSignal()
     {
      double bull = iCustom(NULL, this._timeframe, "Tma Extreme", 3, this._offset);
      double bear = iCustom(NULL, this._timeframe, "Tma Extreme", 4, this._offset);

      if(bull != EMPTY_VALUE && bull > 0)
        {
         return _BUY;
        }

      if(bear != EMPTY_VALUE && bear > 0)
        {
         return _SELL;
        }

      return 0;
     }
  }
//+------------------------------------------------------------------+
