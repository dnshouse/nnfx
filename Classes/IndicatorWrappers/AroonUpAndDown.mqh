//+------------------------------------------------------------------+
//|                                                   NNFX V1.30.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
class AroonUpAndDown
  {
private:
   int               _timeframe;
   int               _offset;
   int               _aroon_period;

public:
   void              AroonUpAndDown(int timeframe = 0, int offset = 1, int aroon_period = 14)
     {
      this._timeframe = timeframe;
      this._offset = offset;
      this._aroon_period = aroon_period;
     };

   void             ~AroonUpAndDown()
     {

     };

   int               GetSignal()
     {
        double aroon_up_current = iCustom(NULL, this._timeframe, "Aroon Up And Down", this._aroon_period, 0, this._offset);
        double aroon_down_current = iCustom(NULL, this._timeframe, "Aroon Up And Down", this._aroon_period, 1, this._offset);

        double aroon_up_last = iCustom(NULL, this._timeframe, "Aroon Up And Down", this._aroon_period, 0, this._offset + 1);
        double aroon_down_last = iCustom(NULL, this._timeframe, "Aroon Up And Down", this._aroon_period, 1, this._offset + 1);

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
