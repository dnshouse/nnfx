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
      double aroon_up_current = iCustom(NULL, this._timeframe, "Aroon Up And Down", this._period, 0, this._offset);
      double aroon_down_current = iCustom(NULL, this._timeframe, "Aroon Up And Down", this._period, 1, this._offset);

      if(aroon_down_current > aroon_up_current)
        {
         return _SELL;
        }

      if(aroon_up_current > aroon_down_current)
        {
         return _BUY;
        }

      return 0;
     }
  };
//+------------------------------------------------------------------+
