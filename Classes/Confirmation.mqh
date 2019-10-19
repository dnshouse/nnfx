//+------------------------------------------------------------------+
//|                                                   NNFX V1.20.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#resource "\\Indicators\\AroonUpAndDown.ex4"

class Confirmation {
 private:
   int               _period;
   int               _offset;

 public:
   void              Confirmation(int period, int offset = 1) {
      this._period = period;
      this._offset = offset;
   };

   int               GetSignal() {
      double aroon_up_current = iCustom(NULL, 0, "::Indicators\\AroonUpAndDown", this._period, 0, this._offset);
      double aroon_down_current = iCustom(NULL, 0, "::Indicators\\AroonUpAndDown", this._period, 1, this._offset);
      double aroon_up_last = iCustom(NULL, 0, "::Indicators\\AroonUpAndDown", this._period, 0, this._offset + 1);
      double aroon_down_last = iCustom(NULL, 0, "::Indicators\\AroonUpAndDown", this._period, 1, this._offset + 1);

      if(aroon_up_last > aroon_down_last && aroon_down_current > aroon_up_current) {
         return _SELL;
      }
      if(aroon_down_last > aroon_up_last && aroon_up_current > aroon_down_current) {
         return _BUY;
      }

      return 0;
   };
};
//+------------------------------------------------------------------+
