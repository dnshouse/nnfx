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

   int               GetSignal()
     {
      double bulls = iCustom(NULL, this._timeframe, "ASO", 0, this._offset);
      double bears = iCustom(NULL, this._timeframe, "ASO", 2, this._offset);

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
