//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//|                      Copyright ?0213, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright " Copyright ?0213, MetaQuotes Software Corp."
#property  link      " http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 5
#property  indicator_color1  Silver
#property  indicator_color2  White
#property  indicator_color3  Red
#property  indicator_color4  Green
#property  indicator_color5  Purple
#property  indicator_width1  1
//---- indicator parameters
extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;
//---- indicator buffers
static double     MacdBuffer[];
static double     FastEMAbuffer[];
static double     SlowEMAbuffer[];
static double     MacdBufferUp[];
static double     MacdBufferDown[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3, DRAW_HISTOGRAM, EMPTY, 2, Red);
   SetIndexStyle(4, DRAW_HISTOGRAM, EMPTY, 2, Green);
//---- indicator buffers mapping
   SetIndexBuffer(0,MacdBuffer);
   SetIndexBuffer(1,FastEMAbuffer);
   SetIndexBuffer(2,SlowEMAbuffer);
   SetIndexBuffer(3,MacdBufferUp);
   SetIndexBuffer(4,MacdBufferDown);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MACD("+FastEMA+","+SlowEMA+","+SignalSMA+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st buffer
   for(int i=0; i<limit; i++)
      FastEMAbuffer[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
//---- signal line counted in the 2-nd buffer
   for(i=0; i<limit; i++)
      SlowEMAbuffer[i]=iMAOnArray(FastEMAbuffer,Bars,SignalSMA,0,MODE_SMA,i);
//---- signal line counted in the 2-nd buffer       
   for(i=0; i<limit; i++)
   {
     MacdBuffer[i]=FastEMAbuffer[i]-SlowEMAbuffer[i];
     Print ("MacdBuffer is ",MacdBuffer[i]);
   //Print ("MacdBufferUp is ",MacdBufferUp[i]);
     if(MacdBuffer[i]>=0)
     {
       MacdBufferUp[i]=MacdBuffer[i];
       MacdBufferDown[i]=0;
       Print ("MacdBufferUp is ",MacdBufferUp[i]);
      }
     else
     {
       MacdBufferDown[i]=MacdBuffer[i];
       MacdBufferUp[i]=0;
       Print ("MacdBufferDown is ",MacdBufferDown[i]);
     }
   }
     
//---- done
   return(0);
  }
