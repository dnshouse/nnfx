//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
class ChaikinMoneyFlow
  {
private:
   int               _timeframe;
   int               _offset;
   int               _period;
   double            _levels;

public:
   void              ChaikinMoneyFlow(int timeframe = 0, int offset = 1, int period = 8, double levels = 0.03)
     {
      this._timeframe = timeframe;
      this._offset = offset;
      this._period = period;
      this._levels = levels;
     }

   void             ~ChaikinMoneyFlow()
     {

     }

   int               GetState(int offset = -1)
     {
      if(offset < 0)
         offset = this._offset;

      double level = iCustom(NULL, this._timeframe, "CMF", this._period, 0, offset);

      if(Ask > level + this._levels)
        {
         return _BUY;
        }

      if(Bid < level - this._levels)
        {
         return _SELL;
        }

      return 0;
     }

   int               GetSignal()
     {
      int currentSignal = this.GetState(this._offset);
      int lastSignal = this.GetState(this._offset + 1);

      if(currentSignal != lastSignal)
        {
         return currentSignal;
        }

      return 0;
     }
  };
//+------------------------------------------------------------------+
