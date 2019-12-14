//+------------------------------------------------------------------+
//|                                                   NNFX V1.30.mq4 |
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
     };

   void             ~SuperScalper()
     {

     };

   int               GetSignal()
     {
      double buffer_0 = iCustom(NULL, this._timeframe, "Super Scalper", 0, this._offset);
      double buffer_2 = iCustom(NULL, this._timeframe, "Super Scalper", 2, this._offset);
      
      if(buffer_0 != EMPTY_VALUE && buffer_0 > 0)
        {
         return _BUY;
        }
      if(buffer_2 != EMPTY_VALUE && buffer_2 > 0)
        {
         return _SELL;
        }
      return 0;
     };
  };
//+------------------------------------------------------------------+
