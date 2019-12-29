//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
class SuperScalper
  {
private:
   int               _timeframe;
   int               _offset;

public:
   void              SuperScalper(int timeframe = 0, int offset = 1)
     {
      this._timeframe = timeframe;
      this._offset = offset;
     }

   void             ~SuperScalper()
     {

     }

   int               GetSignal()
     {
      double bull = iCustom(NULL, this._timeframe, "Super Scalper", 0, this._offset);
      double bear = iCustom(NULL, this._timeframe, "Super Scalper", 2, this._offset);

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
