//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
class CMF
  {
private:
   int               _timeframe;
   int               _offset;
   int               _period;

public:
   void              CMF(int timeframe = 0, int offset = 1, int period = 8)
     {
      this._timeframe = timeframe;
      this._offset = offset;
      this._period = period;
     }

   void             ~CMF()
     {

     }

   int               GetState(int offset = -1)
     {
      if(offset < 0)
         offset = this._offset;

      double level = iCustom(NULL, this._timeframe, "CMF", this._period, 0, offset);

      if(level > 0)
        {
         return _BUY;
        }

      if(level < 0)
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
