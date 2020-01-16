//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
extern bool             LiveMode = true;
extern bool             PrefSettings = true;
extern bool             RiskManagement = true; //Risk Management
extern double           Risk = 0.005; // Risk

extern int              StopLoss = 200;
extern int              TargetProfit = 300;

sinput string           ATR_Label = ""; //ATR ------------------------------------------------------------------------------------
extern bool             ATR_Enabled = false;
extern int              ATR_Period = 14; //Period
extern double           SL_Multiplier = 0.5; //SL Multiplier
extern double           TP_Multiplier = 0.5; // TP Multiplier

sinput string           Baseline_Label = ""; //Baseline ------------------------------------------------------------------------------------
extern int              Baseline_Period = 21; //Period
extern double           Baseline_Levels = 0.00400; //Levels

sinput string           ConfirmationIndicator_Label = ""; //Confirmation ------------------------------------------------------------------------------------
extern int              ConfirmationIndicator_Period = 21; //Period

sinput string           SecondConfirmationIndicator_Label = ""; //2nd Confirmation ------------------------------------------------------------------------------------
extern int              SecondConfirmationIndicator_Period = 21; //Period

sinput string           VolumeIndicator_Label = ""; //Volume ------------------------------------------------------------------------------------
extern double           VolumeIndicator_MinimumVolume = 0.03; //Minimum Volume

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Settings
  {
public:
   bool              _LiveMode;
   bool              _RiskManagement;
   double            _Risk;

   int               _StopLoss;
   int               _TargetProfit;

   bool              _ATR_Enabled;
   int               _ATR_Period;
   double            _SL_Multiplier;
   double            _TP_Multiplier;

   int               _Baseline_Period;
   double            _Baseline_Levels;

   int               _ConfirmationIndicator_Period;
   int               _SecondConfirmationIndicator_Period;
   double            _VolumeIndicator_MinimumVolume;

   int               _IndicatorsTimeframe;
   int               _IndicatorsOffset;

   void              Settings()
     {
      this._LiveMode = LiveMode;
      this._Risk = Risk;
      this._RiskManagement = RiskManagement;

      this._StopLoss = StopLoss;
      this._TargetProfit = TargetProfit;

      this._ATR_Enabled = ATR_Enabled;
      this._ATR_Period = ATR_Period;
      this._SL_Multiplier = SL_Multiplier;
      this._TP_Multiplier = TP_Multiplier;

      this._Baseline_Period = Baseline_Period;
      this._Baseline_Levels = Baseline_Levels;

      this._ConfirmationIndicator_Period = ConfirmationIndicator_Period;
      this._SecondConfirmationIndicator_Period = SecondConfirmationIndicator_Period;
      this._VolumeIndicator_MinimumVolume = VolumeIndicator_MinimumVolume;

      if(this._LiveMode == true)
        {
         this._IndicatorsTimeframe = PERIOD_D1;
         this._IndicatorsOffset = 0;
        }
      else
        {
         this._IndicatorsTimeframe = PERIOD_CURRENT;
         this._IndicatorsOffset = 1;
        }

      if(PrefSettings == false)
        {
        }
      else
        {
         if((Symbol() == "AUDCAD") || (Symbol() == "AUDCADmicro"))
           {
            this._StopLoss = 250;
            this._TargetProfit = 750;

            this._ATR_Enabled = false;

            this._Baseline_Period = 21;
            this._Baseline_Levels = 0.005;

            this._ConfirmationIndicator_Period = 16;
            this._SecondConfirmationIndicator_Period = 8;
            this._VolumeIndicator_MinimumVolume = 0.02;
           }

         if((Symbol() == "AUDCHF") || (Symbol() == "AUDCHFmicro"))
           {
            this._StopLoss = 300;
            this._TargetProfit = 700;

            this._ATR_Enabled = false;

            this._Baseline_Period = 18;
            this._Baseline_Levels = 0.005;

            this._ConfirmationIndicator_Period = 13;
            this._SecondConfirmationIndicator_Period = 12;
            this._VolumeIndicator_MinimumVolume = 0.06;
           }

         if((Symbol() == "AUDJPY") || (Symbol() == "AUDJPYmicro"))
           {
            this._StopLoss = 900;
            this._TargetProfit = 450;

            this._ATR_Enabled = false;

            this._Baseline_Period = 12;
            this._Baseline_Levels = 0.006;

            this._ConfirmationIndicator_Period = 9;
            this._SecondConfirmationIndicator_Period = 18;
            this._VolumeIndicator_MinimumVolume = 0.01;
           }

         if((Symbol() == "AUDNZD") || (Symbol() == "AUDNZDmicro"))
           {
            this._StopLoss = 200;
            this._TargetProfit = 950;

            this._ATR_Enabled = false;

            this._Baseline_Period = 8;
            this._Baseline_Levels = 0.005;

            this._ConfirmationIndicator_Period = 11;
            this._SecondConfirmationIndicator_Period = 9;
            this._VolumeIndicator_MinimumVolume = 0.01;
           }

         if((Symbol() == "AUDUSD") || (Symbol() == "AUDUSDmicro"))
           {
            this._StopLoss = 200;
            this._TargetProfit = 1000;

            this._ATR_Enabled = false;

            this._Baseline_Period = 21;
            this._Baseline_Levels = 0.003;

            this._ConfirmationIndicator_Period = 9;
            this._SecondConfirmationIndicator_Period = 21;
            this._VolumeIndicator_MinimumVolume = 0.03;
           }

         if((Symbol() == "CADCHF") || (Symbol() == "CADCHFmicro"))
           {
            this._StopLoss = 500;
            this._TargetProfit = 1000;

            this._ATR_Enabled = false;

            this._Baseline_Period = 10;
            this._Baseline_Levels = 0.002;

            this._ConfirmationIndicator_Period = 16;
            this._SecondConfirmationIndicator_Period = 14;
            this._VolumeIndicator_MinimumVolume = 0.05;
           }

         if((Symbol() == "CADJPY") || (Symbol() == "CADJPYmicro"))
           {
            this._StopLoss = 250;
            this._TargetProfit = 800;

            this._ATR_Enabled = false;

            this._Baseline_Period = 20;
            this._Baseline_Levels = 0.003;

            this._ConfirmationIndicator_Period = 18;
            this._SecondConfirmationIndicator_Period = 20;
            this._VolumeIndicator_MinimumVolume = 0.05;
           }

         if((Symbol() == "CHFJPY") || (Symbol() == "CHFJPYmicro"))
           {
            this._StopLoss = 350;
            this._TargetProfit = 700;

            this._ATR_Enabled = false;

            this._Baseline_Period = 8;
            this._Baseline_Levels = 0.007;

            this._ConfirmationIndicator_Period = 18;
            this._SecondConfirmationIndicator_Period = 9;
            this._VolumeIndicator_MinimumVolume = 0.07;
           }

         if((Symbol() == "EURAUD") || (Symbol() == "EURAUDmicro"))
           {
            this._StopLoss = 300;
            this._TargetProfit = 950;

            this._ATR_Enabled = false;

            this._Baseline_Period = 16;
            this._Baseline_Levels = 0.006;

            this._ConfirmationIndicator_Period = 15;
            this._SecondConfirmationIndicator_Period = 21;
            this._VolumeIndicator_MinimumVolume = 0.08;
           }

         if((Symbol() == "EURCAD") || (Symbol() == "EURCADmicro"))
           {
            this._StopLoss = 300;
            this._TargetProfit = 800;

            this._ATR_Enabled = false;

            this._Baseline_Period = 20;
            this._Baseline_Levels = 0.007;

            this._ConfirmationIndicator_Period = 8;
            this._SecondConfirmationIndicator_Period = 15;
            this._VolumeIndicator_MinimumVolume = 0.01;
           }

         if((Symbol() == "EURCHF") || (Symbol() == "EURCHFmicro"))
           {
            this._StopLoss = 400;
            this._TargetProfit = 1000;

            this._ATR_Enabled = false;

            this._Baseline_Period = 21;
            this._Baseline_Levels = 0.002;

            this._ConfirmationIndicator_Period = 14;
            this._SecondConfirmationIndicator_Period = 14;
            this._VolumeIndicator_MinimumVolume = 0.04;
           }

         if((Symbol() == "EURGBP") || (Symbol() == "EURGBPmicro"))
           {
            this._StopLoss = 500;
            this._TargetProfit = 950;

            this._ATR_Enabled = false;

            this._Baseline_Period = 21;
            this._Baseline_Levels = 0.004;

            this._ConfirmationIndicator_Period = 18;
            this._SecondConfirmationIndicator_Period = 10;
            this._VolumeIndicator_MinimumVolume = 0.02;
           }

         if((Symbol() == "EURJPY") || (Symbol() == "EURJPYmicro"))
           {
            this._StopLoss = 450;
            this._TargetProfit = 850;

            this._ATR_Enabled = false;

            this._Baseline_Period = 20;
            this._Baseline_Levels = 0.007;

            this._ConfirmationIndicator_Period = 20;
            this._SecondConfirmationIndicator_Period = 20;
            this._VolumeIndicator_MinimumVolume = 0.05;
           }

         if((Symbol() == "EURNZD") || (Symbol() == "EURNZDmicro"))
           {
            this._StopLoss = 600;
            this._TargetProfit = 950;

            this._ATR_Enabled = false;

            this._Baseline_Period = 11;
            this._Baseline_Levels = 0.006;

            this._ConfirmationIndicator_Period = 9;
            this._SecondConfirmationIndicator_Period = 8;
            this._VolumeIndicator_MinimumVolume = 0.03;
           }

         if((Symbol() == "EURUSD") || (Symbol() == "EURUSDmicro"))
           {
            this._StopLoss = 300;
            this._TargetProfit = 600;

            this._ATR_Enabled = false;

            this._Baseline_Period = 19;
            this._Baseline_Levels = 0.002;

            this._ConfirmationIndicator_Period = 9;
            this._SecondConfirmationIndicator_Period = 9;
            this._VolumeIndicator_MinimumVolume = 0.03;
           }

         if((Symbol() == "GBPAUD") || (Symbol() == "GBPAUDmicro"))
           {
           }

         if((Symbol() == "GBPCAD") || (Symbol() == "GBPCADmicro"))
           {
           }

         if((Symbol() == "GBPCHF") || (Symbol() == "GBPCHFmicro"))
           {
            this._StopLoss = 250;
            this._TargetProfit = 950;

            this._ATR_Enabled = false;

            this._Baseline_Period = 21;
            this._Baseline_Levels = 0.006;

            this._ConfirmationIndicator_Period = 8;
            this._SecondConfirmationIndicator_Period = 12;
            this._VolumeIndicator_MinimumVolume = 0.08;
           }

         if((Symbol() == "GBPJPY") || (Symbol() == "GBPJPYmicro"))
           {
            this._StopLoss = 850;
            this._TargetProfit = 1000;

            this._ATR_Enabled = false;

            this._Baseline_Period = 21;
            this._Baseline_Levels = 0.006;

            this._ConfirmationIndicator_Period = 8;
            this._SecondConfirmationIndicator_Period = 19;
            this._VolumeIndicator_MinimumVolume = 0.06;
           }

         if((Symbol() == "GBPNZD") || (Symbol() == "GBPNZDmicro"))
           {
           }

         if((Symbol() == "GBPUSD") || (Symbol() == "GBPUSDmicro"))
           {
            this._StopLoss = 300;
            this._TargetProfit = 950;

            this._ATR_Enabled = false;

            this._Baseline_Period = 21;
            this._Baseline_Levels = 0.007;

            this._ConfirmationIndicator_Period = 9;
            this._SecondConfirmationIndicator_Period = 14;
            this._VolumeIndicator_MinimumVolume = 0.07;
           }

         if((Symbol() == "NZDCAD") || (Symbol() == "NZDCADmicro"))
           {
           }

         if((Symbol() == "NZDCHF") || (Symbol() == "NZDCHFmicro"))
           {
           }

         if((Symbol() == "NZDJPY") || (Symbol() == "NZDJPYmicro"))
           {
            this._StopLoss = 350;
            this._TargetProfit = 1000;

            this._ATR_Enabled = false;

            this._Baseline_Period = 21;
            this._Baseline_Levels = 0.003;

            this._ConfirmationIndicator_Period = 18;
            this._SecondConfirmationIndicator_Period = 19;
            this._VolumeIndicator_MinimumVolume = 0.07;
           }

         if((Symbol() == "NZDUSD") || (Symbol() == "NZDUSDmicro"))
           {
            this._StopLoss = 200;
            this._TargetProfit = 800;

            this._ATR_Enabled = false;

            this._Baseline_Period = 15;
            this._Baseline_Levels = 0.005;

            this._ConfirmationIndicator_Period = 10;
            this._SecondConfirmationIndicator_Period = 8;
            this._VolumeIndicator_MinimumVolume = 0.06;
           }

         if((Symbol() == "USDCAD") || (Symbol() == "USDCADmicro"))
           {
            this._StopLoss = 500;
            this._TargetProfit = 350;

            this._ATR_Enabled = false;

            this._Baseline_Period = 9;
            this._Baseline_Levels = 0.005;

            this._ConfirmationIndicator_Period = 14;
            this._SecondConfirmationIndicator_Period = 11;
            this._VolumeIndicator_MinimumVolume = 0.06;
           }

         if((Symbol() == "USDCHF") || (Symbol() == "USDCHFmicro"))
           {
            this._StopLoss = 200;
            this._TargetProfit = 950;

            this._ATR_Enabled = false;

            this._Baseline_Period = 9;
            this._Baseline_Levels = 0.003;

            this._ConfirmationIndicator_Period = 8;
            this._SecondConfirmationIndicator_Period = 9;
            this._VolumeIndicator_MinimumVolume = 0.03;
           }

         if((Symbol() == "USDJPY") || (Symbol() == "USDJPYmicro"))
           {
            this._StopLoss = 200;
            this._TargetProfit = 1000;

            this._ATR_Enabled = false;

            this._Baseline_Period = 9;
            this._Baseline_Levels = 0.005;

            this._ConfirmationIndicator_Period = 20;
            this._SecondConfirmationIndicator_Period = 15;
            this._VolumeIndicator_MinimumVolume = 0.07;
           }
        }
     }
  };
//+------------------------------------------------------------------+
