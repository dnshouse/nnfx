//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
class AbsoluteStrengthOscillator
  {
private:
   int               _timeframe;
   int               _offset;

public:
   void              AbsoluteStrengthOscillator(int timeframe = 0, int offset = 1)
     {
      this._timeframe = timeframe;
      this._offset = offset;
     }

   void             ~AbsoluteStrengthOscillator()
     {

     }

   int               GetState(int offset = -1)
     {
      if(offset < 0)
         offset = this._offset;

      double bulls = iCustom(NULL, this._timeframe, "ASO", 0, this._offset);
      double bears = iCustom(NULL, this._timeframe, "ASO", 1, this._offset);

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
