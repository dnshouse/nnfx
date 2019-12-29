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

public:
   void              CMF(int timeframe = 0, int offset = 1)
     {
      this._timeframe = timeframe;
      this._offset = offset;
     }

   void             ~CMF()
     {

     }

   int               GetSignal()
     {
      double level = iCustom(NULL, this._timeframe, "CMF", 0, this._offset);

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
  };
//+------------------------------------------------------------------+
