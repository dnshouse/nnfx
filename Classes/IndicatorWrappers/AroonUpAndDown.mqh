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
   void              AroonUpAndDown(int timeframe = 0, int offset = 1, int period = 8)
     {
      this._timeframe = timeframe;
      this._offset = offset;
      this._period = period;
     }

   void             ~AroonUpAndDown()
     {

     }

   int               GetState(int offset = -1)
     {
      if(offset < 0)
         offset = this._offset;

      double bulls = iCustom(NULL, this._timeframe, "Aroon Up And Down", this._period, 0, offset);
      double bears = iCustom(NULL, this._timeframe, "Aroon Up And Down", this._period, 1, offset);

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
