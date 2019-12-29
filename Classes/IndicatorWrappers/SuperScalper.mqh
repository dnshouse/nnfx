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
      double bulls = iCustom(NULL, this._timeframe, "Super Scalper", 0, this._offset);
      double bears = iCustom(NULL, this._timeframe, "Super Scalper", 2, this._offset);

      if(bulls != EMPTY_VALUE && bulls > 0)
        {
         return _BUY;
        }

      if(bears != EMPTY_VALUE && bears > 0)
        {
         return _SELL;
        }

      return 0;
     }
  }
//+------------------------------------------------------------------+
