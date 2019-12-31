//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
extern bool             PrefSettings = true;

sinput string           Risk_Label = ""; //Risk ------------------------------------------------------------------------------------
extern bool             RiskManagement = true;
extern double           MinimumLotSize = 0.1;
extern double           Risk = 0.01;

sinput string           ATR_Label = ""; //ATR ------------------------------------------------------------------------------------
extern int              ATR_Period = 14;
extern double           SL_Multiplier = 0.5;
extern double           TP_Multiplier = 0.5;

sinput string           Baseline_Label = ""; //Baseline ------------------------------------------------------------------------------------
extern int              Baseline_Period = 21;
extern double           Baseline_Levels = 0.00400;

sinput string           ConfirmationIndicator_Label = ""; //Confirmation ------------------------------------------------------------------------------------
extern int              ConfirmationIndicator_Period = 21;

sinput string           SecondConfirmationIndicator_Label = ""; //2nd Confirmation ------------------------------------------------------------------------------------
extern int              SecondConfirmationIndicator_Period = 21;

sinput string           VolumeIndicator_Label = ""; //Volume ------------------------------------------------------------------------------------
extern double           VolumeIndicator_MinimumVolume = 0.03;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Settings
  {
public:
   bool              _RiskManagement;
   double            _MinimumLotSize;
   double            _Risk;

   int               _ATR_Period;
   double            _SL_Multiplier;
   double            _TP_Multiplier;

   int               _Baseline_Period;
   double            _Baseline_Levels;

   int               _ConfirmationIndicator_Period;
   int               _SecondConfirmationIndicator_Period;
   double            _VolumeIndicator_MinimumVolume;

   int               _IndicatorsOffset;
   int               _IndicatorsTimeframe;

   void              Settings()
     {
      this._Risk = Risk;
      this._RiskManagement = RiskManagement;
      this._MinimumLotSize = MinimumLotSize;

      this._ATR_Period = ATR_Period;
      this._TP_Multiplier = TP_Multiplier;
      this._SL_Multiplier = SL_Multiplier;

      this._Baseline_Period = Baseline_Period;
      this._Baseline_Levels = Baseline_Levels;

      this._ConfirmationIndicator_Period = ConfirmationIndicator_Period;
      this._SecondConfirmationIndicator_Period = SecondConfirmationIndicator_Period;
      this._VolumeIndicator_MinimumVolume = VolumeIndicator_MinimumVolume;

      this._IndicatorsTimeframe = PERIOD_CURRENT;
      this._IndicatorsOffset = 1;

      if(PrefSettings == true)
        {
         if((Symbol() == "AUDCAD") || (Symbol() == "AUDCADmicro"))
           {
           }

         if((Symbol() == "AUDCHF") || (Symbol() == "AUDCHFmicro"))
           {
           }

         if((Symbol() == "AUDJPY") || (Symbol() == "AUDJPYmicro"))
           {
           }

         if((Symbol() == "AUDNZD") || (Symbol() == "AUDNZDmicro"))
           {
           }

         if((Symbol() == "AUDUSD") || (Symbol() == "AUDUSDmicro"))
           {
           }

         if((Symbol() == "CADCHF") || (Symbol() == "CADCHFmicro"))
           {
           }

         if((Symbol() == "CADJPY") || (Symbol() == "CADJPYmicro"))
           {
           }

         if((Symbol() == "CHFJPY") || (Symbol() == "CHFJPYmicro"))
           {
           }

         if((Symbol() == "EURAUD") || (Symbol() == "EURAUDmicro"))
           {
           }

         if((Symbol() == "EURCAD") || (Symbol() == "EURCADmicro"))
           {
           }

         if((Symbol() == "EURCHF") || (Symbol() == "EURCHFmicro"))
           {
           }

         if((Symbol() == "EURGBP") || (Symbol() == "EURGBPmicro"))
           {
           }

         if((Symbol() == "EURJPY") || (Symbol() == "EURJPYmicro"))
           {
           }

         if((Symbol() == "EURNZD") || (Symbol() == "EURNZDmicro"))
           {
           }

         if((Symbol() == "EURUSD") || (Symbol() == "EURUSDmicro"))
           {
           }

         if((Symbol() == "GBPAUD") || (Symbol() == "GBPAUDmicro"))
           {
           }

         if((Symbol() == "GBPCAD") || (Symbol() == "GBPCADmicro"))
           {
           }

         if((Symbol() == "GBPCHF") || (Symbol() == "GBPCHFmicro"))
           {
           }

         if((Symbol() == "GBPJPY") || (Symbol() == "GBPJPYmicro"))
           {
           }

         if((Symbol() == "GBPNZD") || (Symbol() == "GBPNZDmicro"))
           {
           }

         if((Symbol() == "GBPUSD") || (Symbol() == "GBPUSDmicro"))
           {
           }

         if((Symbol() == "NZDCAD") || (Symbol() == "NZDCADmicro"))
           {
           }

         if((Symbol() == "NZDCHF") || (Symbol() == "NZDCHFmicro"))
           {
           }

         if((Symbol() == "NZDJPY") || (Symbol() == "NZDJPYmicro"))
           {
           }

         if((Symbol() == "NZDUSD") || (Symbol() == "NZDUSDmicro"))
           {
           }

         if((Symbol() == "USDCAD") || (Symbol() == "USDCADmicro"))
           {
           }

         if((Symbol() == "USDCHF") || (Symbol() == "USDCHFmicro"))
           {
           }

         if((Symbol() == "USDJPY") || (Symbol() == "USDJPYmicro"))
           {
           }
        }
      else
        {
        }
     }
  };
//+------------------------------------------------------------------+
