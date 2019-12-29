//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
class AroonUpAndDown
  {
private:
   int               _timeframe;
   int               _offset;
   int               _period;

public:
   void              AroonUpAndDown(int timeframe = 0, int offset = 1, int period = 14)
     {
      this._timeframe = timeframe;
      this._offset = offset;
      this._period = period;
     }

   void             ~AroonUpAndDown()
     {

     }

   int               GetSignal()
     {
      double bulls = iCustom(NULL, this._timeframe, "Aroon Up And Down", this._period, 0, this._offset);
      double bears = iCustom(NULL, this._timeframe, "Aroon Up And Down", this._period, 1, this._offset);

      if(bulls > bears)
        {
         return _BUY;
        }

      if(bears > bulls)
        {
         return _SELL;
        }

      return 0;
     }
  };
//+------------------------------------------------------------------+
