//+------------------------------------------------------------------+
//|                                                   NNFX V1.30.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
class TmaExtreme
  {
private:
   int               _timeframe;
   int               _offset;

public:
   void              TmaExtreme(int timeframe = 0, int offset = 0)
     {
      this._timeframe = timeframe;
      this._offset = offset;
     };

   void             ~TmaExtreme()
     {

     };

   int               GetSignal()
     {
      double upperBand = iCustom(NULL, this._timeframe, "tma-extreme", 1, this._offset);
      double lowerBand = iCustom(NULL, this._timeframe, "tma-extreme", 2, this._offset);
      
      double bull = iCustom(NULL, this._timeframe, "tma-extreme", 3, this._offset);
      double bear = iCustom(NULL, this._timeframe, "tma-extreme", 4, this._offset);
      double flat = iCustom(NULL, this._timeframe, "tma-extreme", 5, this._offset);
      
      if(Close[this._offset] < lowerBand)
        {
         return _SELL;
        }
   
      if(Close[this._offset] > upperBand)
        {
         return _BUY;
        }
   
      return 0;
     };
  };
//+------------------------------------------------------------------+
