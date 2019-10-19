//+------------------------------------------------------------------+
//|                                                   NNFX V1.20.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
class Baseline {
 private:
   int               _period;
   int               _shift;
   int               _method;
   int               _appliedPrice;
   int               _offset;

 public:
   void              Baseline(int period, int shift, int offset = 1) {
      this._period = period;
      this._shift = shift;
      this._method = MODE_SMA;
      this._appliedPrice = PRICE_CLOSE;
      this._offset = offset;
   };

   int               GetSignal() {
      double baseline = iMA(NULL, 0, this._period, this._shift, this._method, this._appliedPrice, this._offset);

      if(Bid < baseline) {
         return _SELL;
      }
      if(Ask > baseline) {
         return _BUY;
      }

      return 0;
   };
};
//+------------------------------------------------------------------+
