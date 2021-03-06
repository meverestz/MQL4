//+------------------------------------------------------------------+
//|                                                       Matrix.mq4 |Martingale Arbitrage Strategy
//|                                         Copyright 2019, MZ Corp. |
//|                                             https://www.mql5.com |Open order position by previous high/low candle
//+------------------------------------------------------------------+
//2020.10.14 create new EA with Fibo 25% level buy/sell stop order
//2020.10.14 create new EA with Fibo 25% level buy/sell stop order

#property copyright "Copyright 2020, Horse Technology Corp. MZ"
#property link      "https://www.horsegroup.net/en/"
#property version   "2.00"
#property strict
#property description "Make sure have Allow live trading mode on !" 
#property description "We recommond use this Expert based on H1 Timeframe or H4!" 
#property description "This EA can be applied to a variety of Symbols."
#property description "Contact us to set the correct parameters:"  
#property description "OSV2 EA. Copyright@Horseforex" 
#property description "Open Account: https://secure.horsegroup.net/register/" 
#property description "--" 
//#property description "Author: Derek Mu" 
//#property description "Email: derek@horseforex.om" 
//#property description "Link: https://www.horsegroup.net/en/" 
#property strict
#include <stderror.mqh> 
#include <stdlib.mqh> 
int MAGIC=1000;
int MAGIC2=2000;
int MAGIC3=3000;
int MAGIC4=4000;
int MAGIC5=5000;
int MAGIC6=6000;
int MAGIC7=7000;
int MAGIC8=8000;
int MAGIC9=9000;
int MAGIC10=10000;

int account_code=825746;
//input
extern string code="8888"; //InputValidationCODE
//input bool fanxiang=false;    //ReverseDirection
input int    countcandle=1;  //CountCandleBarNum
//int     TP_Level=2;  //25=4/50=2
input double  morethanprecentage=0.2;    //MoreThan_Precentage_%
input double  lessthanprecentage=1.5;      //LessThan_Precentage_%
input bool  TP_25=true;          //SendOrder_At_25%
input bool  TP_50=false;         //SendOrder_At_50%  
//input double  TP_Prectage=1.98;      //TakeProfit_Precentage
 int     WavePoint=15;    //WavePoint
int     TakeProfit1=200;  //TakeProfitPoint
int     StopLoss1=150;  //StopLossPoint
//input bool  autoatr=true;    //SetAuto_TP_SL
//extern int  atrbar=7;       //AveragingPeriod 
 int     SpreadPoint=20;    //SpreadPoint
input int   MaxOrder=9;        //MaxOrder
input double  tradelots=0.01;   //OrderLots_1
input double  tradelots_2=0.02;   //OrderLots_2
input double  tradelots_3=0.04;   //OrderLots_3
input double  tradelots_4=0.08;   //OrderLots_4
input double  tradelots_5=0.16;   //OrderLots_5
input double  tradelots_6=0.32;   //OrderLots_6
input double  tradelots_7=0.64;   //OrderLots_7
input double  tradelots_8=1.28;   //OrderLots_8
input double  tradelots_9=2.56;   //OrderLots_9
input double  tradelots_10=5.2;   //OrderLots_9
input string  TimeSet="-----!SeverTime!-----";//TimeParameter_Set
extern bool   SetTradingTime=true; //SetTradingTime
extern int    BeginH1=6;     //StartTradingHour
extern int    EndH1=21;       //CloseTradingHour
extern int    countday=3;  //MaxDayCloseAllLimit
//fibo candle count

 bool   drawfibo=false;   //DrawFiboLine
int checkbar=1;
color  LC = DodgerBlue; // FiboLineColor 
  ENUM_LINE_STYLE LS = 0; // FiboLineStyle 
                               // Solid = 0, Dot = 2
  int    LW = 1;          // FiboLineWidth
/*
extern int    countday=3;  //MaxDayCloseAllLimit
extern bool   StaticState=false; //SetStaticState
extern bool   SetWeekClose=false; //SetEveryWeekClose
extern bool   SetTradingTime=false; //SetTradingTime
input string  TimeSet="--GMT--Sunday-for-0--";//TimeParameter_Set
extern int    StartTradingTime=0; //SetStartTradingTime(GMT)
extern bool   SetTimeClose=false; //Set_23H_CloseAllPosition
extern int    BanTradingDay1=0; //BanTradingDay1
extern int    BanTradingDay2=6; //BanTradingDay2
*/
//trading parameter
double Precentage;  //CheckRangePrecentage
string pairs;          //Symbol
double maxlots=100;    
double sl_point,sl_price,tp_point,tp_price;
int    ticket,slippage;     //order_ticket
bool   turn_alert=false;

bool   FiboUptrend,FiboDowntrend;
datetime buytime=0;
datetime selltime=0;
datetime TimeTrigger;
double BuyPriceHigh,SellPriceLow;
double avgbuyprice,avgsellprice;
datetime   checktime;
datetime Todaytime;
//common parameter
int    T;
int    buyordercounts,sellordercounts,pending;
bool   flag,flag_buy,flag_sell;
double pips;
string    MACD_Settings         = "=== MACD Settings ===";
int       MACDFast              =           12;  // MACD fast EMA period
int       MACDSlow              =           26;  // MACD slow EMA period
int       MACDSignal            =            9;  // MACD signal SMA period

int fiboPoint;
double fiboValue50,fiboValue25;
//history order check variable
int LastCloseOrderTicket,LastOrderTicket,LastOrderType,LastCloseOrderType;
int HoldingTotalOrder,LastCloseOrderMagic;
double LastCloseOrderTicketProfit,LastOrderTicketProfit;
string LastOrderSymbol,LastCloseOrderSymbol,Last2CloseOrderSymbol;
int Last2CloseOrderTicket,Last2CloseOrderType,Last3CloseOrderTicket,Last4CloseOrderTicket,Last5CloseOrderTicket,Last6CloseOrderTicket,Last7CloseOrderTicket,Last8CloseOrderTicket,Last9CloseOrderTicket;
double Last2CloseOrderTicketProfit,Last3CloseOrderTicketProfit,Last4CloseOrderTicketProfit,Last5CloseOrderTicketProfit,Last6CloseOrderTicketProfit,Last7CloseOrderTicketProfit,Last8CloseOrderTicketProfit,Last9CloseOrderTicketProfit;
bool Lostflag,Lostflag2,Lostflag3,Lostflag4,Lostflag5,Lostflag6,Lostflag7,Lostflag8,Lostflag9;
datetime LastOrderOpenTime,LastCloseOrderOpenTime,LastCloseOrderColseTime,Last2CloseOrderOpenTime,Last2CloseOrderColseTime;
datetime testtime,testbuyorder,testsellorder,sellorder2,buyorder2,sellorder3,buyorder3,sellorder4,buyorder4,sellorder5,buyorder5,sellorder6,buyorder6,sellorder7,buyorder7,sellorder8,buyorder8,sellorder9,buyorder9,sellorder10,buyorder10;
//trading variable
double buystopprice,sellstopprice;
int checkpoint_up,checkpoint_down;
double buystopprice_tp,buystopprice_sl,sellstopprice_tp,sellstopprice_sl;
double AskPrice,BidPrice;
int  TP_Point,RangePoint,TakeProfit,StopLoss;
bool staticflag,Uptrend,Downtrend,TradingTime;
double PrevHigh,PrevLow,CheckPrecentage;
int checkloss;
datetime tbtime,tstime;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  //check trading time
  if(SetTradingTime)
  {
      if(TimeHour(TimeCurrent())<=EndH1 && TimeHour(TimeCurrent())>=BeginH1 )
         {
         TradingTime=true;
         //Print("Trading Time"+"!!!");
         }
      else {TradingTime=false;}
  }
  else {TradingTime=true;}
   //CreateFibo();
   //if(drawfibo)DrawFibo();
   //double orderprice,orderlots;

   pairs=Symbol();
   Todaytime=TimeCurrent();
   HoldingTotalOrder=OrdersTotal();
   //printf(HoldingTotalOrder);
   AskPrice=MarketInfo(pairs,MODE_ASK);
   BidPrice=MarketInfo(pairs,MODE_BID);
   int Spread=(int)MarketInfo(pairs,MODE_SPREAD);
   int    vdigits = (int)MarketInfo(pairs,MODE_DIGITS); 
   double MoreP=morethanprecentage/100;
   double LessP=lessthanprecentage/100;
   
///+---------------------OverAll----------------------------------------------+     
///+-------------------StartTrading-------------------------------------------+     
if(TradingTime)
{
//---check previous High&Low 
     int Highbar = iHighest(Symbol(),Period(),MODE_HIGH,countcandle,1);   //return bar count number
     int Lowbar  = iLowest(Symbol(),Period(),MODE_LOW,countcandle,1);     //!Check bar from -1!
     PrevHigh=High[Highbar];
     PrevLow=Low[Lowbar];
     
     CheckPrecentage=(PrevHigh-PrevLow)/PrevLow;
     RangePoint=(int)((High[1]-Low[1])/Point);
//---check previous 25% 50% level
     if(Close[1]>Open[1])
     {//阳线
        fiboValue25=PrevHigh-(PrevHigh-PrevLow)*0.25;
        fiboValue50=PrevHigh-(PrevHigh-PrevLow)*0.5;                 
        if(TP_25)sellstopprice=PrevHigh-RangePoint*Point*0.25;
        if(TP_50)sellstopprice=PrevHigh-RangePoint*Point*0.5;      
        Uptrend=true;
     }
     if(Close[1]<Open[1])
     {//阴线
        fiboValue25=PrevLow+(PrevHigh-PrevLow)*0.25;
        fiboValue50=PrevLow+(PrevHigh-PrevLow)*0.5; 
        if(TP_25)buystopprice=PrevLow+RangePoint*Point*0.25;  
        if(TP_50)buystopprice=PrevLow+RangePoint*Point*0.5; 
        Downtrend=true;   
     }

     Print("Checkloss=",IntegerToString(checkloss));
     Print("CandlePrecentage=",DoubleToStr(CheckPrecentage*100,vdigits),"%");
     Print("CandlePoint=",IntegerToString(RangePoint));
     Print("25%=",DoubleToStr(fiboValue25,vdigits),"  50%=",DoubleToStr(fiboValue50,vdigits));
//     Print("25%=",DoubleToStr(PrevHigh-RangePoint*Point*0.25,vdigits),"  50%=",DoubleToStr(PrevHigh-RangePoint*Point*0.5,vdigits));



///+----------------OrdersCheck-------------------------------------------+  
    
//---Trading order holding&close takeprofit condition   24hours check BuyCheck
   CheckHoldingOrder(MAGIC);
   CheckHistroyOrder();  

   //检测空单
   if(testtime!=Time[0])
   {  
      flag_buy=false;flag_sell=false;
      Uptrend=false;Downtrend=false;
      buystopprice=0;sellstopprice=0;
      
      if(LastCloseOrderTicketProfit>=0)
      {
         //if(LastCloseOrderType != LastOrderType)
         DeleteOrderPosition();
         //盈利后清零
         LastCloseOrderMagic=1;checkloss=0;
         fiboPoint=0;TP_Point=0;
         staticflag=false;
         flag=false;
      }
      
      testtime=Time[0]; 
   }
//if bugs occur
   if(OrdersTotal()>=2)
      {  
      checktime=TimeCurrent()+2;
      flag_buy=false;flag_sell=false;
      Uptrend=false;Downtrend=false;
      //buystopprice=0;sellstopprice=0;
      LastCloseOrderTicketProfit=0;
         //if(LastCloseOrderType != LastOrderType)
         DeleteOrderPosition();
         //盈利后清零
         fiboPoint=0;TP_Point=0;checkloss=0;
         flag=false;Lostflag=false;
      }
 /*     
//Countday Close and reset "" checkloss
   if(countday!=0)
   if(tbtime!=Time[0])
   if(CheckDurationFromStart(buytime,TimeCurrent())>=countday)
      {
         if(OrdersTotal()==0)
         { printf("CountDay Close");DeleteOrderPosition();checkloss=0;checktime=TimeCurrent()+10;
         flag_buy=false;buytime=0;Sleep(1000);RefreshRates();tbtime=Time[0];}     
      }   
      
   if(countday!=0)
   if(tstime!=Time[0])
   if(CheckDurationFromStart(selltime,TimeCurrent())>=countday)
      {
         if(OrdersTotal()==0)
         {printf("CountDay Close");DeleteOrderPosition();checkloss=0;checktime=TimeCurrent()+10;
         flag_sell=false;selltime=0;Sleep(1000);RefreshRates();tstime=Time[0];}     
      }  
      */   
   //检测连续止盈损单
   if(LastCloseOrderTicketProfit>=0){Lostflag=false;}
   else {Lostflag=true;}
   if(Last2CloseOrderTicketProfit>=0)Lostflag2=false;
   else {Lostflag2=true;}
   if(Last3CloseOrderTicketProfit>=0)Lostflag3=false;
   else {Lostflag3=true;}
   if(Last4CloseOrderTicketProfit>=0)Lostflag4=false;
   else {Lostflag4=true;}
   if(Last5CloseOrderTicketProfit>=0)Lostflag5=false;
   else {Lostflag5=true;}
   if(Last6CloseOrderTicketProfit>=0)Lostflag6=false;
   else {Lostflag6=true;}
   if(Last7CloseOrderTicketProfit>=0)Lostflag7=false;
   else {Lostflag7=true;}
   if(Last8CloseOrderTicketProfit>=0)Lostflag8=false;
   else {Lostflag8=true;}
   if(Last9CloseOrderTicketProfit>=0){Lostflag9=false;}
   else {Lostflag9=true;}   
//---check first condition   && flag==false
      
      //checkpoint_up=int((AskPrice-Open[0])/Point);
      //checkpoint_down=int(-(BidPrice-Open[0])/Point);   
         
      if((MoreP<=CheckPrecentage)&&(CheckPrecentage<LessP))
         {  
            //PrintFormat("PrevLow= %.2f   PrevHigh= %.2f ",PrevLow,PrevHigh);
            fiboPoint=RangePoint;
            if(!staticflag)
            {
               if(TP_25)TP_Point=fiboPoint/4;
               if(TP_50)TP_Point=fiboPoint/2;
            }
            Print("TP_Point=",IntegerToString(TP_Point));
            staticflag=true;
            flag=true;    
         }
         
       //if(AskPrice>=buystopprice)Uptrend=true;
       //if(BidPrice<=sellstopprice)Downtrend=true;  
//+----------------Uptrend------------Buy-----------------------------+    
      if(Uptrend&&flag)
         {  
           sellstopprice_tp=AskPrice-TP_Point*Point;
           sellstopprice_sl=High[1]; 
                   
           if(BidPrice>=sellstopprice)flag_buy=true; 
         }     
    
      if(flag_buy)//阳线sellstop开启
      {  
         if(testbuyorder!=Time[0])
         { 
               //if(MaxOrder>HoldingTotalOrder)
               //{
               //if(AskPrice<=buystopprice)
               //{
               if(!CheckHoldingOrder(MAGIC))
               {
                     if(checkloss<1)
                        {
                        if(SellStop(FormatPrice(sellstopprice),FormatLots(tradelots),FormatTPSL(sellstopprice_sl),FormatTPSL(sellstopprice_tp),"Sell"+"Order_1",MAGIC)>0)
                           {selltime=Time[0]; checkloss=0;}
                        }
                   
               } 
               //} 
             /*  else if(AskPrice>buystopprice) 
               {
               if(!CheckHoldingOrder(MAGIC))
               if(BuyLimit(FormatPrice(buystopprice),FormatLots(tradelots),FormatTPSL(buystopprice_sl),FormatTPSL(buystopprice_tp),"Buy"+"Order_1",MAGIC)>0)              
               {buytime=Time[0]; printf(HoldingTotalOrder);printf(checkpoint_up);} 
               }   */
               
         testbuyorder=Time[0]; 
         }                                 
      }
                                          
//+----------------Downtrend------------Sell-----------------------------+         
      if(Downtrend&&flag)
      {
            buystopprice_tp=BidPrice+TP_Point*Point;
            buystopprice_sl=Low[1];            
            if(AskPrice<=buystopprice)flag_sell=true;
      }
      
      if(flag_sell)//阴线buystop开启
      {  
         if(testsellorder!=Time[0])
         {       
               //if(MaxOrder>HoldingTotalOrder)
               //{
               //if(BidPrice>=sellstopprice)
               //{
               if(!CheckHoldingOrder(MAGIC))
               {

                    if(checkloss<1)
                    {
                    if(BuyStop(FormatPrice(buystopprice),FormatLots(tradelots),FormatTPSL(buystopprice_sl),FormatTPSL(buystopprice_tp),"Buy"+"Order_1",MAGIC)>0)              
                        {buytime=Time[0];checkloss=0;}
                    } 
                  
               }      
               //} 

               
         testsellorder=Time[0]; 
         }                     
      }

///+-----------------------------------------------------------+     
   //反向第二单
   if(LastCloseOrderTicketProfit<0)
   
   if(Lostflag)
   {
      if(LastCloseOrderType==OP_BUY)
      {
         if(sellorder2 !=(Time[0]-5))//1sec
         if(checkloss<1)
         { if(!CheckHoldingOrder(MAGIC2))
         Sell(FormatPrice(sellstopprice),FormatLots(tradelots_2),FormatTPSL(BidPrice+TP_Point*Point),FormatTPSL(BidPrice-TP_Point*Point),"Sell"+"Order_2",MAGIC2);checkloss=1;sellorder2=(Time[0]-5);
         }
      }
      
      if(LastCloseOrderType==OP_SELL)
      {
         if(buyorder2 !=(Time[0]-5))
         if(checkloss<1)
         {if(!CheckHoldingOrder(MAGIC2))
         Buy(FormatPrice(buystopprice),FormatLots(tradelots_2),FormatTPSL(AskPrice-TP_Point*Point),FormatTPSL(AskPrice+TP_Point*Point),"Buy"+"Order_2",MAGIC2);checkloss=1;buyorder2=(Time[0]-5);
         }
      }
   }
   //反向第三单
   if(LastCloseOrderTicketProfit<0)
   
   if(Lostflag && Lostflag2)
   {
      if(LastCloseOrderType==OP_BUY)
      {
         if(sellorder3 !=(Time[0]-10))
         if(checkloss<2)
         {if(!CheckHoldingOrder(MAGIC3))
         Sell(FormatPrice(sellstopprice),FormatLots(tradelots_3),FormatTPSL(BidPrice+TP_Point*Point),FormatTPSL(BidPrice-TP_Point*Point),"Sell"+"Order_3",MAGIC3);checkloss=2;sellorder3=(Time[0]-10);
         }
      }
      
      if(LastCloseOrderType==OP_SELL)
      {
         if(buyorder3 !=(Time[0]-10))
         if(checkloss<2)
         {if(!CheckHoldingOrder(MAGIC3))
         Buy(FormatPrice(buystopprice),FormatLots(tradelots_3),FormatTPSL(AskPrice-TP_Point*Point),FormatTPSL(AskPrice+TP_Point*Point),"Buy"+"Order_3",MAGIC3);checkloss=2;buyorder3=(Time[0]-10);
         }
      }
   }   
      //反向第四单
   if(LastCloseOrderTicketProfit<0)
   
   if(Lostflag && Lostflag2 && Lostflag3)
   {
      if(LastCloseOrderType==OP_BUY)
      {
         if(sellorder4 !=(Time[0]-15))
         if(checkloss<3)
         { if(!CheckHoldingOrder(MAGIC4))
         Sell(FormatPrice(sellstopprice),FormatLots(tradelots_4),FormatTPSL(BidPrice+TP_Point*Point),FormatTPSL(BidPrice-TP_Point*Point),"Sell"+"Order_4",MAGIC4);checkloss=3;sellorder4=(Time[0]-15);
         }
      }
      
      if(LastCloseOrderType==OP_SELL)
      {
         if(buyorder4 !=(Time[0]-15))
         if(checkloss<3)
         {if(!CheckHoldingOrder(MAGIC4))
         Buy(FormatPrice(buystopprice),FormatLots(tradelots_4),FormatTPSL(AskPrice-TP_Point*Point),FormatTPSL(AskPrice+TP_Point*Point),"Buy"+"Order_4",MAGIC4);checkloss=3;buyorder4=(Time[0]-15);
         }
      }
   }
   //反向第五单
   if(LastCloseOrderTicketProfit<0)
   
   if(Lostflag && Lostflag2 && Lostflag3 && Lostflag4)
   {
      if(LastCloseOrderType==OP_BUY)
      {
         if(sellorder5 !=(Time[0]-20))
         if(checkloss<4)
         {if(!CheckHoldingOrder(MAGIC5))
          Sell(FormatPrice(sellstopprice),FormatLots(tradelots_5),FormatTPSL(BidPrice+TP_Point*Point),FormatTPSL(BidPrice-TP_Point*Point),"Sell"+"Order_5",MAGIC5);checkloss=4;sellorder5=(Time[0]-20);
         }
      }
      
      if(LastCloseOrderType==OP_SELL)
      {
         if(buyorder5 !=(Time[0]-20))
         if(checkloss<4)
         {if(!CheckHoldingOrder(MAGIC5))
         Buy(FormatPrice(buystopprice),FormatLots(tradelots_5),FormatTPSL(AskPrice-TP_Point*Point),FormatTPSL(AskPrice+TP_Point*Point),"Buy"+"Order_5",MAGIC5);checkloss=4;buyorder5=(Time[0]-20);
         }
      }
   }   
   //反向第六单
   if(LastCloseOrderTicketProfit<0)
   
   if(Lostflag && Lostflag2 && Lostflag3 && Lostflag4 && Lostflag5)
   {
      if(LastCloseOrderType==OP_BUY)
      {
         if(sellorder6 !=(Time[0]-25))
         if(checkloss<5)
         {if(!CheckHoldingOrder(MAGIC6))
          Sell(FormatPrice(sellstopprice),FormatLots(tradelots_6),FormatTPSL(BidPrice+TP_Point*Point*2),FormatTPSL(BidPrice-TP_Point*Point*2),"Sell"+"Order_6",MAGIC6);checkloss=5;sellorder6=(Time[0]-25);
         }
      }
      
      if(LastCloseOrderType==OP_SELL)
      {
         if(buyorder6 !=(Time[0]-25))
         if(checkloss<5)
         {if(!CheckHoldingOrder(MAGIC6))
         Buy(FormatPrice(buystopprice),FormatLots(tradelots_6),FormatTPSL(AskPrice-TP_Point*Point*2),FormatTPSL(AskPrice+TP_Point*Point*2),"Buy"+"Order_6",MAGIC6);checkloss=5;buyorder6=(Time[0]-25);
         }
      }
   } 
   //反向第七单
   if(LastCloseOrderTicketProfit<0)
   
   if(Lostflag && Lostflag2 && Lostflag3 && Lostflag4 && Lostflag5 && Lostflag6)
   {
      if(LastCloseOrderType==OP_BUY)
      {
         if(sellorder7 !=(Time[0]-30))
         if(checkloss<6)
         {if(!CheckHoldingOrder(MAGIC7))
          Sell(FormatPrice(sellstopprice),FormatLots(tradelots_7),FormatTPSL(BidPrice+TP_Point*Point*2),FormatTPSL(BidPrice-TP_Point*Point*2),"Sell"+"Order_7",MAGIC7);checkloss=6;sellorder7=(Time[0]-30);
         }
      }
      
      if(LastCloseOrderType==OP_SELL)
      {
         if(buyorder7 !=(Time[0]-30))
         if(checkloss<6)
         {if(!CheckHoldingOrder(MAGIC7))
         Buy(FormatPrice(buystopprice),FormatLots(tradelots_7),FormatTPSL(AskPrice-TP_Point*Point*2),FormatTPSL(AskPrice+TP_Point*Point*2),"Buy"+"Order_7",MAGIC7);checkloss=6;buyorder7=(Time[0]-30);
         }
      }
   }   
   //反向第八单
   if(LastCloseOrderTicketProfit<0)
   
   if(Lostflag && Lostflag2 && Lostflag3 && Lostflag4 && Lostflag5 && Lostflag6 && Lostflag7)
   {
      if(LastCloseOrderType==OP_BUY)
      {
         if(sellorder8 !=(Time[0]-35))
         if(checkloss<7)
         {if(!CheckHoldingOrder(MAGIC8))
          Sell(FormatPrice(sellstopprice),FormatLots(tradelots_8),FormatTPSL(BidPrice+TP_Point*Point*3),FormatTPSL(BidPrice-TP_Point*Point*3),"Sell"+"Order_8",MAGIC8);checkloss=7;sellorder8=(Time[0]-35);
         }
      }
      
      if(LastCloseOrderType==OP_SELL)
      {
         if(buyorder8 !=(Time[0]-35))
         if(checkloss<7)
         {if(!CheckHoldingOrder(MAGIC8))
         Buy(FormatPrice(buystopprice),FormatLots(tradelots_8),FormatTPSL(AskPrice-TP_Point*Point*3),FormatTPSL(AskPrice+TP_Point*Point*3),"Buy"+"Order_8",MAGIC8);checkloss=7;buyorder8=(Time[0]-35);
         }
      }
   }        
   //反向第九单
   if(LastCloseOrderTicketProfit<0)
   
   if(Lostflag && Lostflag2 && Lostflag3 && Lostflag4 && Lostflag5 && Lostflag6 && Lostflag7 && Lostflag8)
   {
      if(LastCloseOrderType==OP_BUY)
      {
         if(sellorder9 !=(Time[0]-40))
         if(checkloss<8)
         {if(!CheckHoldingOrder(MAGIC9))
          Sell(FormatPrice(sellstopprice),FormatLots(tradelots_9),FormatTPSL(BidPrice+TP_Point*Point*3),FormatTPSL(BidPrice-TP_Point*Point*3),"Sell"+"Order_9",MAGIC8);checkloss=8;sellorder9=(Time[0]-40);
         }
      }
      
      if(LastCloseOrderType==OP_SELL)
      {
         if(buyorder9 !=(Time[0]-40))
         if(checkloss<8)
         {if(!CheckHoldingOrder(MAGIC9))
         Buy(FormatPrice(buystopprice),FormatLots(tradelots_9),FormatTPSL(AskPrice-TP_Point*Point*3),FormatTPSL(AskPrice+TP_Point*Point*3),"Buy"+"Order_9",MAGIC8);checkloss=8;buyorder9=(Time[0]-40);
         }
      }
   } 
   //反向第十单
   if(LastCloseOrderTicketProfit<0)
   
   if(Lostflag && Lostflag2 && Lostflag3 && Lostflag4 && Lostflag5 && Lostflag6 && Lostflag7 && Lostflag8 && Lostflag9)
   {
      if(LastCloseOrderType==OP_BUY)
      {
         if(sellorder10 !=(Time[0]-45))
         if(checkloss<9)
         {if(!CheckHoldingOrder(MAGIC10)) 
         Sell(FormatPrice(sellstopprice),FormatLots(tradelots_10),FormatTPSL(BidPrice+TP_Point*Point*3),FormatTPSL(BidPrice-TP_Point*Point*3),"Sell"+"Order_10",MAGIC8);checkloss=9;sellorder10=(Time[0]-45);
         }
      }
      
      if(LastCloseOrderType==OP_SELL)
      {
         if(buyorder10 !=(Time[0]-45))
         if(checkloss<9)
         {if(!CheckHoldingOrder(MAGIC10))
         Buy(FormatPrice(buystopprice),FormatLots(tradelots_10),FormatTPSL(AskPrice-TP_Point*Point*3),FormatTPSL(AskPrice+TP_Point*Point*3),"Buy"+"Order_10",MAGIC8);checkloss=9;buyorder10=(Time[0]-45);
         }
      }
   }      
            
}
//finish      
}


void CheckForMACD()
   {
      bool res_macd_gold=false;
      bool res_macd_kill=false;
      double MACD_m_240=iMACD(NULL,PERIOD_H4,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,0);
      double MACD_s_240=iMACD(NULL,PERIOD_H4,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,0);
   
    //  if ((MACD_m_240 > MACD_s_240)) { MACD_Trend = "UP"; x = 250; UP_38 = 1; DOWN_38 = 0; }
    //  if ((MACD_m_240 < MACD_s_240)) { MACD_Trend = "DOWN"; x = 240;  UP_38 = 0; DOWN_38 = 1; }

   }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

//--- create timer
   //EventSetTimer(1);
   T=Period();
   checktime=TimeCurrent()+1;
//---check ticksize   
   double ticksize=MarketInfo(Symbol(),MODE_TICKSIZE);
   if(ticksize==0.00001 || ticksize==0.001)
      pips=ticksize*10;
   else
      pips=ticksize;
//---check Account Code Fit
   //if(AccountNumber()!=account_code){MessageBox("Invaild Account Number!","Check it again!",0x00000000);ExpertRemove();}
     if(AccountInfoString(ACCOUNT_COMPANY)=="Horse Forex Ltd")
         {           
               // TextCreate("PASS","Horse Technology @copyright",15,15,10,Red);
               // flag=1;
         }
    else {
            Alert("Invaild Broker !");
            Alert("Please Change Account !");
            Alert("Failed Authorization !");
            ExpertRemove();
            return(INIT_FAILED);
         }  
      if(code=="88888888")
         {
       if(TimeLocal()<D'2021.01.31 00:00')
              {
                TextCreate("PASS","                 Passed Certification // Expiry Date 2021.01.31",15,15,10,Red);
                //flag=false;
              }
         }
    else {
            MessageBox("Invaild Account Number! Please Contact Author!","Failed Authorization!",0x00000000);
            ExpertRemove();
         }     
   Comment("Horse Technology @copyright\nhttps://www.horsegroup.net/\nOpen Account: https://secure.horsegroup.net/register/");
//---check symbol min lots       
   double    lotcheck = MarketInfo(pairs,MODE_MINLOT); 
   printf("Min Lots = %s ",DoubleToString(lotcheck,Digits()));
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

//--- destroy timer
   //EventKillTimer();
   ObjectDelete(0,"PASS");
   ObjectDelete(0,"FIBO");
   
  }



void ModifySpecificOrder(string com,double openprice,double sl,double tp)
  {
     bool res=false;
     //double modprice=FormatPrice(openprice);
     double BaseTemp=NormalizeDouble(openprice,Digits);
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderComment()==com)
              {                        //check 如果当前的止损价没有被修改时，那么就进行修改。否则如果当前的止损价已经被修改了，那么就不往下执行了
                  if (NormalizeDouble(OrderOpenPrice(),Digits)!=NormalizeDouble(BaseTemp,Digits))    
                       {
                        if(sl==0 && tp!=0)res=OrderModify(OrderTicket(),openprice,OrderStopLoss(),tp,0,Green);   
                        if(sl!=0 && tp==0)res=OrderModify(OrderTicket(),openprice,sl,OrderTakeProfit(),0,Green);  
                        if(sl==0 && tp==0)res=OrderModify(OrderTicket(),openprice,sl,tp,0,Green);                               
                        if(!res) 
                           //printf("Error in OrderModify. %s  Error code= %s ",com,GetLastError()); 
                           Print("Error in TrackingPriceModify. Error: ",ErrorDescription(GetLastError())); 
                      // else 
                           printf("Order TrackingPriceModify %s modified successfully.",com); 
                       }     
                 
              }
          }
      }
  }



double FormatLots(double llots)  //transform Format Lots
  {

    
   double lots=llots;
//--- minimal allowed volume for trade operations
   double minlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(lots<minlot)
     {
      lots=minlot;
      Print("Volume is less than the minimal allowed ,we use",minlot);
     }
//--- maximal allowed volume of trade operations
   double maxlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(lots>maxlot)
     {
      lots=maxlot;
      Print("Volume is greater than the maximal allowed,we use",maxlot);
     }
//--- get minimal step of volume changing
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);
   int ratio=(int)MathRound(lots/volume_step);
   if(MathAbs(ratio*volume_step-lots)>0.0000001)
     {
      lots=ratio*volume_step;

      Print("Volume is not a multiple of the minimal step ,we use the closest correct volume ",ratio*volume_step);
     }

   return(lots); 
  }  
    
double FormatTPSL(double val)
  {
   RefreshRates();
   double SPREAD=MarketInfo(Symbol(),MODE_SPREAD);
   double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   if(val<StopLevel*pips+SPREAD*pips)
      val=StopLevel*pips+SPREAD*pips;
   return(NormalizeDouble(val, Digits));
// return(val);
  } 
  
double FormatPrice(double val)
  {
   return(NormalizeDouble(val, Digits));
  } 
/*  
int BuyOrderCount(double &openprice,double &lots)  //最近一次开多单的开仓价格【传引用值！The Last order openprice and lots】 Also return buy total order counts
  {
     int a=0;
     openprice=0;
     lots=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==MAGIC)
              {
                a++;
                openprice=OrderOpenPrice();
                lots=OrderLots();
              }
          }
      }
    return(a);
  }
 int SellOrderCount(double &openprice,double &lots)     //最近一次开多单的开仓价格【传引用值！】
  {
     int a=0;
     openprice=0;
     lots=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==MAGIC)
              {
                a++;
                openprice=OrderOpenPrice();
                lots=OrderLots();
              }
          }
      }
    return(a);
  }
  

//+------------------------------------------------------------------+
//|   DRAW FIBONACCI ON CHART                                        |
//+------------------------------------------------------------------+
int DrawFibo()
{
     int fibHigh = iHighest(Symbol(),Period(),MODE_HIGH,countcandle,checkbar);   //return bar count number
     int fibLow  = iLowest(Symbol(),Period(),MODE_LOW,countcandle,checkbar);
     double fiboPriceHigh=High[fibHigh];
     double fiboPriceLow =Low[fibLow];
     datetime highTime = iTime(Symbol(),0,fibHigh);
     datetime lowTime  = iTime(Symbol(),0,fibLow);
     
     datetime T2=0;                     // Second time coordinate
     double t2=0;
     int Error;                          // Error code

     t2=ObjectGet("FIBO",OBJPROP_TIME2);  // Requesting t2 coord.
//T2=t2;
     Error=GetLastError();                // Getting an error code
     if(Error==4202)                      // If no object :(
     {
      // Check for New Bar (Compatible with both MQL4 and MQL5)
      static datetime dtBarCurrent=WRONG_VALUE;
      datetime dtBarPrevious=dtBarCurrent;
      dtBarCurrent=(datetime) SeriesInfoInteger(_Symbol,_Period,SERIES_LASTBAR_DATE);
      bool NewBarFlag=(dtBarCurrent!=dtBarPrevious);
      if(NewBarFlag)  CreateFibo();
     // T2=Time[price2];                  // Current value of t2 coordinate
      T2=iTime(NULL,Period(),fibLow);
     }
//--------------------------------------------------------------- 4 --
  // if(T2!=Time[price2])                 // If object is not in its place
     if(T2!=iTime(NULL,Period(),fibLow))                 // If object is not in its place
     {
      //Create coord.
           if(fibHigh>fibLow)
              {
                ObjectMove("FIBO",0,highTime,fiboPriceHigh);   // Anchor point number.
                ObjectMove("FIBO",1,lowTime,fiboPriceLow);     // 0 to high, 1 to low //Up trend                   
              }
               else
              {
                ObjectMove("FIBO",0,lowTime,fiboPriceLow);     // Fibo point_index
                ObjectMove("FIBO",1,highTime,fiboPriceHigh);   // 0 to low, 1 to high //Down trend
              }
      WindowRedraw();                  // Redrawing the image
     }
   return (0);
}
//----------------------------------------------------------------
int CreateFibo()                        // User-defined function..
{
// ..of object creation  
     int fibHigh = iHighest(Symbol(),Period(),MODE_HIGH,countcandle,checkbar);   //return bar count number
     int fibLow  = iLowest(Symbol(),Period(),MODE_LOW,countcandle,checkbar);     //!Check bar from -1!
     //printff("fibHigh=  %d  fibLow=  %d",fibHigh,fibLow); 

     double fiboPriceHigh=High[fibHigh];
     double fiboPriceLow =Low[fibLow];
     //printff("fiboPrice1=  %-.4f  fiboPrice2=  %-.4f",fiboPriceHigh,fiboPriceLow); 
     

    
     datetime highTime = iTime(Symbol(),0,fibHigh);
     datetime lowTime  = iTime(Symbol(),0,fibLow);
     MqlDateTime str1,str2;
     TimeToStruct(highTime,str1);TimeToStruct(lowTime,str2);
     //printff("%4d.%02d.%02d, %d:%d",str1.year,str1.mon,str1.day,str1.hour,str1.min); 
     //printff("%4d.%02d.%02d, %d:%d",str2.year,str2.mon,str2.day,str2.hour,str2.min); 

 //Fibo from 0% to 100%  Creation
     if(fibHigh>fibLow)
     {
       if(drawfibo)
       {
          WindowRedraw();
          ObjectCreate("FIBO",OBJ_FIBO,0,highTime,fiboPriceHigh,lowTime,fiboPriceLow);   //Down trend
       }
        fiboPrice1=fiboPriceHigh;
        fiboPrice0=fiboPriceLow;
        FiboDowntrend=true;
        //--- Cal Fibo Down Precentage 
        fiboPrecentage=(fiboPrice1-fiboPrice0)/fiboPrice1;
        //printff("Down Trend!   Fibo_Precentage = %.3f    ",fiboPrecentage);
     }
      else
     {
       if(drawfibo)
       {
       WindowRedraw();
       ObjectCreate("FIBO",OBJ_FIBO,0,lowTime,fiboPriceLow,highTime,fiboPriceHigh);   //Up trend   
       }   
        fiboPrice1=fiboPriceLow;
        fiboPrice0=fiboPriceHigh;
        FiboUptrend=true; 
        //--- Cal Fibo Up Precentage
        fiboPrecentage=(fiboPrice0-fiboPrice1)/fiboPrice1;
        //printff("Up Trend!   Fibo_Precentage = %.3f    ",fiboPrecentage);        
     }
     
//--- Check FiboDiff Price     
     //double fiboPrice0=ObjectGet("XIT_FIBO",OBJPROP_PRICE1);
     //double fiboPrice1=ObjectGet("XIT_FIBO",OBJPROP_PRICE2);
        fiboPriceDiff = fiboPrice0-fiboPrice1;
        fiboValue0 = fiboPrice0-fiboPriceDiff*0.0;
        fiboValue50 = fiboPrice0-fiboPriceDiff*FiboLevel_1;
        fiboValue150 = fiboPrice0-fiboPriceDiff*FiboLevel_2;
        fiboValue200 = fiboPrice0-fiboPriceDiff*FiboLevel_3;
        fiboValue300 = fiboPrice0-fiboPriceDiff*FiboLevel_4;
        fiboValue400 = fiboPrice0-fiboPriceDiff*FiboLevel_5;
        fiboValue100 = fiboPrice0-fiboPriceDiff*FiboLevel_6;
        //printff("Fibo_0 = %.2f    Fibo_100 = %.2f    Fibo_PriceDiff = %.2f    ",fiboPrice0,fiboPrice1,fiboPriceDiff);
        //printff("Fibo_0 = %.2f    Fibo_382 = %.2f    Fibo_100 = %.2f    Fibo_168 = %.2f",fiboValue0,fiboValue38,fiboValue100,fiboValue168);

//--- set line color/description and width/sytle
     if(drawfibo)
     {
        ObjectSet("FIBO",OBJPROP_COLOR,LC);      //FIBO Color
        ObjectSet("FIBO",OBJPROP_FIBOLEVELS,7);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+0,0.0);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+1,0.5);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+2,1.0);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+3,1.5);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+4,2.0);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+5,3.0);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+6,4.0);
        ObjectSet("FIBO",OBJPROP_LEVELCOLOR,LC);
        ObjectSet("FIBO",OBJPROP_LEVELWIDTH,LW);
        ObjectSet("FIBO",OBJPROP_LEVELSTYLE,LS);
   
        ObjectSetFiboDescription( "FIBO",0, "0,0%"); 
        ObjectSetFiboDescription( "FIBO",1, "50%"); 
        ObjectSetFiboDescription( "FIBO",2, "100%"); 
        ObjectSetFiboDescription( "FIBO",3, "150%");
        ObjectSetFiboDescription( "FIBO",4, "200%");
        ObjectSetFiboDescription( "FIBO",5, "300%");
        ObjectSetFiboDescription( "FIBO",6, "400%");
   //--- enable (true) or disable (false) the mode of continuation of the FIBO's display to the right
        //ObjectSet("FIBO",OBJPROP_RAY,true);         // Ray
        //ObjectSet("FIBO",OBJPROP_BACK,true);
        RefreshRates();
        ChartRedraw();                             // Image redrawing
     }
     return(0);
}
*/  
  
  
int BuyOrderCount()  // return buy total order counts
  {
     int a=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY )
              {
                a++;
              }
          }
      }
    return(a);
  }
 int SellOrderCount()     
  {
     int a=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL )
              {
                a++;
              }
          }
      }
    return(a);
  }  
int PendingBuyOrderCount()  // return buy total order counts
  {
     int a=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol())
            {
              if(OrderType()==OP_BUYLIMIT)
              {
                a++;
              }
            }  
          }
      }
    return(a);
  }  
int PendingSellOrderCount()  // return buy total order counts
  {
     int a=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol())
            {
              if(OrderType()==OP_SELLLIMIT)
              {
                a++;
              }
            }  
          }
      }
    return(a);
  }    
int BuyOrder(double lots,double sl,double tp,string com,int buymagic)  //check whether same order firstly and if not send buy order later 
  {
     RefreshRates();  
     int a=0;
     bool zhaodan=false;
     //double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL); 
     //Print("Minimum Stop Level=",minstoplevel," points"); 
     double price=MarketInfo(pairs,MODE_ASK); 
   //--- calculated SL and TP prices must be normalized 
     double stoploss=FormatTPSL(sl); 
     double takeprofit=FormatTPSL(tp); 
   //printf("minstoplevel= %f   takeprofit= %f",minstoplevel,takeprofit);
      for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && zhushi==com && ma==buymagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
      //  if(sl!=0 && tp==0)
      //   {
      //    a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,White);
      //   }
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_BUY,lots,price,500,NULL,takeprofit,com,buymagic,0,White);
             if(!a)
             {printf("Error BuyOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits())); Print("Error: ",ErrorDescription(GetLastError())); }
             else {printf("BuyOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_BUY,lots,price,500,NULL,NULL,com,buymagic,0,White);
             if(!a)
             {printf("Error BuyOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits())); Print("Error: ",ErrorDescription(GetLastError())); }
             else {printf("BuyOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl!=0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_BUY,lots,price,500,stoploss,takeprofit,com,buymagic,0,White);
             if(!a)
             {printf("Error BuyOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits())); Print("Error: ",ErrorDescription(GetLastError())); }
             else {printf("BuyOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
        } 
      }
    return(a);
  }

int SellOrder(double lots,double sl,double tp,string com,int sellmagic)
  {
      RefreshRates();
      int a=0;
      bool zhaodan=false;
     // double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL); 
     //Print("Minimum Stop Level=",minstoplevel," points"); 
      double price=MarketInfo(pairs,MODE_BID); 
   //--- calculated SL and TP prices must be normalized 
      double stoploss=FormatTPSL(sl); 
      double takeprofit=FormatTPSL(tp); 
      for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && zhushi==com && ma==sellmagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_SELL,lots,price,500,NULL,takeprofit,com,sellmagic,0,Red);
             if(!a)
             {printf("Error SellOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));Print("Error: ",ErrorDescription(GetLastError())); }
             else   {printf("SellOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
     //   if(sl!=0 && tp==0)
     //    {
     //      a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,0,com,sellmagic,0,Red);
     //    }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_SELL,lots,MarketInfo(pairs,MODE_BID),500,NULL,NULL,com,sellmagic,0,Red);
             if(!a)
             {printf("Error SellOrder! %s  %s  Lots= %s  TP_Level= %s  ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));Print("Error: ",ErrorDescription(GetLastError())); }
             else   {printf("SellOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl!=0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_SELL,lots,price,500,stoploss,takeprofit,com,sellmagic,0,Red);
             if(!a)
             {printf("Error SellOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));Print("Error: ",ErrorDescription(GetLastError())); }
             else   {printf("SellOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
      }
    return(a);
  }  

int BuyLimit(double price,double lots,double sl,double tp,string com,int buymagic)  //check whether same order firstly and if not send buy order later 
  {
      RefreshRates(); 
      int a=0;
      bool zhaodan=false;
      for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)     //MODE_TRADES can be selected trading and pending orders
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUYLIMIT && zhushi==com && ma==buymagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
      //  if(sl!=0 && tp==0)
      //   {
      //    a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,White);
      //   }
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_BUYLIMIT,lots,price,500,NULL,tp,com,buymagic,0,White);
             if(!a)
             {printf("Error BuyLimitOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));Print("Error: ",ErrorDescription(GetLastError())); }
             else  {printf("BuyLimitOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_BUYLIMIT,lots,price,500,NULL,NULL,com,buymagic,0,White);
             if(!a)
             {printf("Error BuyLimitOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("BuyLimitOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
      //  if(sl!=0 && tp!=0)
      //   {
      //    a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,Ask+tp*Point,com,buymagic,0,White);
      //  } 
      }
    return(a);
  }
  
int SellLimit(double price,double lots,double sl,double tp,string com,int sellmagic)
  {
      RefreshRates();
      int a=0;
      bool zhaodan=false;
      for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELLLIMIT && zhushi==com && ma==sellmagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_SELLLIMIT,lots,price,500,NULL,tp,com,sellmagic,0,Red);
             if(!a)
             {printf("Error SellLimitOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) );Print("Error: ",ErrorDescription(GetLastError())); }
             else {printf("SellLimitOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
     //   if(sl!=0 && tp==0)
     //    {
     //      a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,0,com,sellmagic,0,Red);
     //    }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_SELLLIMIT,lots,price,500,NULL,NULL,com,sellmagic,0,Red);
             if(!a)
             {printf("Error SellLimitOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("SellLimitOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
     //   if(sl!=0 && tp!=0)
     //    {
     //      a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,Bid-tp*Point,com,sellmagic,0,Red);
     //    }
      }
    return(a);
  }  
int BuyStop(double price,double lots,double sl,double tp,string com,int buymagic)  //check whether same order firstly and if not send buy order later 
  {
      
      int a=0;
      bool zhaodan=false;
      //for(int i=0;i<OrdersTotal();i++)
      for(int i=OrdersTotal()-1; i>=0; i--)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)     //MODE_TRADES can be selected trading and pending orders
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP && zhushi==com )
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
      //  if(sl!=0 && tp==0)
      //   {
      //    a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,White);
      //   }
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_BUYSTOP,lots,price,500,NULL,tp,com,buymagic,0,White);
             if(!a)
             {printf("Error OP_BUYSTOP Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));Print("Error: ",ErrorDescription(GetLastError())); }
             else  {printf("OP_BUYSTOP Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_BUYSTOP,lots,price,500,NULL,NULL,com,buymagic,0,White);
             if(!a)
             {printf("Error OP_BUYSTOP Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("OP_BUYSTOP Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl!=0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_BUYSTOP,lots,price,500,sl,tp,com,buymagic,TimeCurrent()+3600,White);
             if(!a)
             {printf("Error OP_BUYSTOP Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("OP_BUYSTOP Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
        } 
      }
    return(a);
  }
  
int SellStop(double price,double lots,double sl,double tp,string com,int sellmagic)
  {
      
      int a=0;
      bool zhaodan=false;
      //for(int i=0;i<OrdersTotal();i++)
      for(int i=OrdersTotal()-1; i>=0; i--)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP && zhushi==com)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_SELLSTOP,lots,price,500,NULL,tp,com,sellmagic,0,Red);
             if(!a)
             {printf("Error OP_SELLSTOP Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) );Print("Error: ",ErrorDescription(GetLastError())); }
             else {printf("OP_SELLSTOP Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
     //   if(sl!=0 && tp==0)
     //    {
     //      a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,0,com,sellmagic,0,Red);
     //    }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_SELLSTOP,lots,price,500,NULL,NULL,com,sellmagic,0,Red);
             if(!a)
             {printf("Error OP_SELLSTOP Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("OP_SELLSTOP Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl!=0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_SELLSTOP,lots,price,500,sl,tp,com,sellmagic,TimeCurrent()+3600,Red);
             if(!a)
             {printf("Error OP_SELLSTOP Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("OP_SELLSTOP Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
      }
    return(a);
  }    
  
  
int Buy(double price,double lots,double sl,double tp,string com,int buymagic)  //check whether same order firstly and if not send buy order later 
  {
      
      int a=0;
      bool zhaodan=false;
      //for(int i=0;i<OrdersTotal();i++)
      for(int i=OrdersTotal()-1; i>=0; i--)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)     //MODE_TRADES can be selected trading and pending orders
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && zhushi==com )
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
      //  if(sl!=0 && tp==0)
      //   {
      //    a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,White);
      //   }
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_BUY,lots,AskPrice,500,NULL,tp,com,buymagic,0,White);
             if(!a)
             {printf("Error OP_BUY Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));Print("Error: ",ErrorDescription(GetLastError())); }
             else  {printf("OP_BUY Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_BUY,lots,AskPrice,500,NULL,NULL,com,buymagic,0,White);
             if(!a)
             {printf("Error OP_BUY Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("OP_BUY Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl!=0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_BUY,lots,AskPrice,500,sl,tp,com,buymagic,0,White);
             if(!a)
             {printf("Error OP_BUY Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("OP_BUY Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
        } 
      }
    return(a);
  }
  
int Sell(double price,double lots,double sl,double tp,string com,int sellmagic)
  {
      
      int a=0;
      bool zhaodan=false;
      //for(int i=0;i<OrdersTotal();i++)
      for(int i=OrdersTotal()-1; i>=0; i--)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && zhushi==com)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_SELL,lots,BidPrice,500,NULL,tp,com,sellmagic,0,Red);
             if(!a)
             {printf("Error OP_SELL Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) );Print("Error: ",ErrorDescription(GetLastError())); }
             else {printf("OP_SELL Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
     //   if(sl!=0 && tp==0)
     //    {
     //      a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,0,com,sellmagic,0,Red);
     //    }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_SELL,lots,BidPrice,500,NULL,NULL,com,sellmagic,0,Red);
             if(!a)
             {printf("Error OP_SELL Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("OP_SELL Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl!=0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_SELL,lots,BidPrice,500,sl,tp,com,sellmagic,0,Red);
             if(!a)
             {printf("Error OP_SELL Order! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("OP_SELL Order successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
      }
    return(a);
  }      
void CloseBuyOrderPosition()
  {
     double myBid,myLot;
     int myType,i,problem;
     bool result = false;
     int myTicket=0;

     for(i=OrdersTotal()-1;i>=0;i--)
         {
                if(OrderSelect(i,SELECT_BY_POS))
                {
                       if(OrdersTotal()>0)                        // &&OrderSymbol()==SetYourSymbol
                              {                            
                              myTicket=OrderTicket();
                              myLot=OrderLots();
                              myType=OrderType();
                            // if(OrderMagicNumber == MAGIC1)
                              if(OrderType()==OP_BUYLIMIT  || OrderType()==OP_BUYSTOP )
                                {
                                    result=OrderDelete(myTicket);
                                }
                              if(OrderType()==OP_BUY)
                                {
                                    myBid=MarketInfo(OrderSymbol(),MODE_ASK);
                                    result=OrderClose(myTicket,myLot,myBid,500,Yellow);
                                }
                                                         
                              if (result != 1) 
                              {
                              problem = GetLastError();
                              printf("LastError = ", problem);
                              } else problem = 0;
                        }
                }
         }         
  } 
void CloseSellOrderPosition()
  {
     double myBid,myLot;
     int myType,i,problem;
     bool result = false;
     int myTicket=0;

     for(i=OrdersTotal()-1;i>=0;i--)
         {
                if(OrderSelect(i,SELECT_BY_POS))
                {
                       if(OrdersTotal()>0)                        // &&OrderSymbol()==SetYourSymbol
                              {                            
                              myTicket=OrderTicket();
                              myLot=OrderLots();
                              myType=OrderType();
                              if(OrderType()==OP_BUYLIMIT  || OrderType()==OP_BUYSTOP )
                                {
                                    result=OrderDelete(myTicket);
                                }
                              if(OrderType()==OP_SELL)
                                {
                                    myBid=MarketInfo(OrderSymbol(),MODE_ASK);
                                    result=OrderClose(myTicket,myLot,myBid,500,Yellow);
                                }
                                                        
                              if (result != 1) 
                              {
                              problem = GetLastError();
                              printf("LastError = ", problem);
                              } else problem = 0;
                        }
                }
         }         
  } 
void DeleteOrderPosition()
  {
     //double myBid,myLot;
     int i,problem;
     bool result = false;
     int myTicket=0,num=0;
     for(i=OrdersTotal()-1;i>=0;i--)
         {
                if(OrderSelect(i,SELECT_BY_POS))
                {
                       if(OrderSymbol()==Symbol())                        // &&OrderSymbol()==SetYourSymbol
                       {                            
                              myTicket=OrderTicket();
                              num=OrderMagicNumber();
                              if(num>=MAGIC)
                              if(OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP)
                                {
                                    result=OrderDelete(myTicket);
                                }
                         
                              if (result != 1) 
                              {
                              problem = GetLastError();
                              printf("LastError = ", problem);
                              } else problem = 0;
                        }
                }
         }  
                
                 
  } 
void TextCreate(string name,string neirong,int x,int y,int daxiao,color yanse)
  {
    if(ObjectFind(name)<0)
     {
        ObjectCreate(name,OBJ_LABEL,0,0,0);
        ObjectSetText(name,neirong,daxiao,"宋体",yanse);
        ObjectSet(name,OBJPROP_XDISTANCE,x);
        ObjectSet(name,OBJPROP_YDISTANCE,y);
        ObjectSet(name,OBJPROP_CORNER,0);
     }
    else
     {
        ObjectSetText(name,neirong,daxiao,"宋体",yanse);
        WindowRedraw();
     }
  }
  
  
bool TradeTime(int starthour,int endhour)
  {
    bool a=false;
    if(starthour<=endhour)
     {
       if(TimeHour(TimeLocal())>=starthour && TimeHour(TimeLocal())<endhour)
         {
           a=true;
         }
     }
    else
     {
        if(TimeHour(TimeLocal())>=starthour || TimeHour(TimeLocal())<endhour)
         {
           a=true;
         }
     }
    return(a);
  }
/*
void CheckTradeTime()
{
     Todaytime=TimeCurrent();
     //printff(TimeToString(Todaytime,TIME_DATE));
     checktime=true;
     MqlDateTime tm;
     if(SetTradingTime)
         {  
            if(TimeToStruct(Todaytime,tm))
                  {
                        if((tm.day_of_week!=BanTradingDay1)||(tm.day_of_week!=BanTradingDay2))   //周末不交易 (0-Sunday, 1-Monday, ... ,6-Saturday) 
                            {
                              checktime=false;
                            }//else{checktime=true;}
                        
                        if(tm.hour>=StartTradingTime){checktime=true;}else{checktime=false;}
                        
                        if(tm.hour==20)
                              {
                                if(SetTimeClose && (OrdersTotal()!=0))
                                       {
                                                 printf("It's time(23H tradingtime) to close all position!");
                                                 CloseBuyOrderPosition();CloseSellOrderPosition();   
                                       }
                              }
                  }
                      
          }         
}
*/
//+------------------------------------------------------------------+
//| History Check Function          FiboTPCount                      |check history close orders and counts then start new trading section
//+------------------------------------------------------------------+
int HistoryCheckOrder_Buy(datetime startopen)
{
   buyordercounts=0;
   for(int r=0;r<OrdersHistoryTotal();r++)
      {
         if(OrderSelect(r,SELECT_BY_POS,MODE_HISTORY))
            {
               if(OrderType()==OP_BUY)
                  {
                     if(OrderOpenTime()>startopen && (OrderCloseTime()<TimeCurrent()))buyordercounts++;
                  } 
            }
      }
     return(buyordercounts);
}

int HistoryCheckOrder_Sell(datetime startopen)
{
   sellordercounts=0;
   for(int r=0;r<OrdersHistoryTotal();r++)
      {
         if(OrderSelect(r,SELECT_BY_POS,MODE_HISTORY))
            {
     
               if(OrderType()==OP_SELL)
                  {
                     if(OrderOpenTime()>startopen && (OrderCloseTime()<TimeCurrent()))sellordercounts++;
                  }   
            }
      }
     return(sellordercounts);
}

int HistoryCheckOrder_Pending(datetime startopen)
{
   pending=0;
   for(int r=0;r<OrdersHistoryTotal();r++)
      {
         if(OrderSelect(r,SELECT_BY_POS,MODE_HISTORY))
            {
     
               if(OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYLIMIT)
                  {
                     if(OrderOpenTime()>startopen && (OrderCloseTime()<TimeCurrent()))pending++;
                  }   
            }
      }
     return(pending);
}



bool CheckHoldingOrder(int number)
{
   int magic;
   bool check=false;
   
      if(OrdersTotal()>=0)
        {
         int j=OrdersTotal()-1;
         for(int i=OrdersTotal()-1; i>=0; i--) //和历史统计一样，从0表示First首单。 for(int i=0;i<orderstotals;i++)  //从First首单开始扫描。
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
              {
               RefreshRates();
               string ordersymbol_1=OrderSymbol(),ordercomment_1=OrderComment();
               double orderask_1=MarketInfo(OrderSymbol(),MODE_ASK),orderbid_1=MarketInfo(OrderSymbol(),MODE_BID),ordertickvalue_1=MarketInfo(OrderSymbol(),MODE_TICKVALUE);
               magic=OrderMagicNumber();
               //printf(magic);
               //Get Last order ticket info
               LastOrderTicket=OrderTicket();LastOrderTicketProfit=OrderProfit();
               LastOrderSymbol=OrderSymbol();LastOrderType=OrderType();
               LastOrderOpenTime=OrderOpenTime();
               //datetime testordertime;testordertime=LastOrderOpenTime;
               if(j==i)
               {//Print(__FUNCTION__);
               //printf("LastOrderTicket=%d  Symobl=%s  Profit=%.2f   OpenTime=%s  ",LastOrderTicket,LastOrderSymbol,LastOrderTicketProfit,TimeToString(OrderOpenTime(),TIME_MINUTES));}
              }
               if(magic==number)
               {check=true;break;}
              
              }
            }
         }
  return(check) ;            
}


void CheckHistroyOrder()
{
      if(OrdersHistoryTotal()>0)
        {
         int j=OrdersHistoryTotal()-1;
         for(int i=OrdersHistoryTotal()-1; i>=0; i--) //建仓晚至早_非平仓时间
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
              { 
              if(OrderOpenTime()>checktime)
              {             
                  if(j==i)
                  {                       
                     //Get first Last Close Order ticket info
                     LastCloseOrderTicket=OrderTicket();LastCloseOrderTicketProfit=OrderProfit();
                     LastCloseOrderSymbol=OrderSymbol();LastCloseOrderType=OrderType();
                     LastCloseOrderOpenTime=OrderOpenTime();LastCloseOrderColseTime=OrderCloseTime();
                     LastCloseOrderMagic=OrderMagicNumber();
                     //datetime testordertime;testordertime=LastCloseOrderColseTime;
                     //Print(__FUNCTION__);
                     //printf("Last111CloseOrderTicket=%d  Symobl=%s   Profit=%.2f   OpenTime=%s    CloseTime=%s",LastCloseOrderTicket,LastCloseOrderSymbol,LastCloseOrderTicketProfit,TimeToString(LastCloseOrderOpenTime,TIME_MINUTES),TimeToString(LastCloseOrderColseTime,TIME_MINUTES));
                  }
                  if((j-1)==i)
                  {
                     //Get second last Close Order ticket info
                     Last2CloseOrderTicket=OrderTicket();Last2CloseOrderTicketProfit=OrderProfit();
                     Last2CloseOrderSymbol=OrderSymbol();Last2CloseOrderType=OrderType();
                     Last2CloseOrderOpenTime=OrderOpenTime();Last2CloseOrderColseTime=OrderCloseTime();
                     //Print(__FUNCTION__);
                     //printf("Last222CloseOrderTicket=%d  Symobl=%s   Profit=%.2f   OpenTime=%s    CloseTime=%s",Last2CloseOrderTicket,Last2CloseOrderSymbol,Last2CloseOrderTicketProfit,TimeToString(Last2CloseOrderOpenTime,TIME_MINUTES),TimeToString(Last2CloseOrderColseTime,TIME_MINUTES));
                  }
                  if((j-2)==i)
                  {
                     //Get third last Close Order ticket info
                     Last3CloseOrderTicket=OrderTicket();Last3CloseOrderTicketProfit=OrderProfit();
                     //Last3CloseOrderSymbol=OrderSymbol();Last3CloseOrderType=OrderType();
                     //Last3CloseOrderOpenTime=OrderOpenTime();Last3CloseOrderColseTime=OrderCloseTime();
                     //Print(__FUNCTION__);
                     //printf("Last222CloseOrderTicket=%d  Symobl=%s   Profit=%.2f   OpenTime=%s    CloseTime=%s",Last2CloseOrderTicket,Last2CloseOrderSymbol,Last2CloseOrderTicketProfit,TimeToString(Last2CloseOrderOpenTime,TIME_MINUTES),TimeToString(Last2CloseOrderColseTime,TIME_MINUTES));
                  }
                  if((j-3)==i)
                  {
                     //Get forth last Close Order ticket info
                     Last4CloseOrderTicket=OrderTicket();Last4CloseOrderTicketProfit=OrderProfit();
                     //Last4CloseOrderSymbol=OrderSymbol();Last4CloseOrderType=OrderType();
                     //Last4CloseOrderOpenTime=OrderOpenTime();Last4CloseOrderColseTime=OrderCloseTime();
                     //Print(__FUNCTION__);
                     //printf("Last222CloseOrderTicket=%d  Symobl=%s   Profit=%.2f   OpenTime=%s    CloseTime=%s",Last2CloseOrderTicket,Last2CloseOrderSymbol,Last2CloseOrderTicketProfit,TimeToString(Last2CloseOrderOpenTime,TIME_MINUTES),TimeToString(Last2CloseOrderColseTime,TIME_MINUTES));
                  }  
                  if((j-4)==i)
                  {
                     //Get fifth last Close Order ticket info
                     Last5CloseOrderTicket=OrderTicket();Last5CloseOrderTicketProfit=OrderProfit();
                     //Last4CloseOrderSymbol=OrderSymbol();Last4CloseOrderType=OrderType();
                     //Last4CloseOrderOpenTime=OrderOpenTime();Last4CloseOrderColseTime=OrderCloseTime();
                     //Print(__FUNCTION__);
                     //printf("Last222CloseOrderTicket=%d  Symobl=%s   Profit=%.2f   OpenTime=%s    CloseTime=%s",Last2CloseOrderTicket,Last2CloseOrderSymbol,Last2CloseOrderTicketProfit,TimeToString(Last2CloseOrderOpenTime,TIME_MINUTES),TimeToString(Last2CloseOrderColseTime,TIME_MINUTES));
                  }   
                  if((j-5)==i)
                  {
                     //Get sixth last Close Order ticket info
                     Last6CloseOrderTicket=OrderTicket();Last6CloseOrderTicketProfit=OrderProfit();
                     //Last4CloseOrderSymbol=OrderSymbol();Last4CloseOrderType=OrderType();
                     //Last4CloseOrderOpenTime=OrderOpenTime();Last4CloseOrderColseTime=OrderCloseTime();
                     //Print(__FUNCTION__);
                     //printf("Last222CloseOrderTicket=%d  Symobl=%s   Profit=%.2f   OpenTime=%s    CloseTime=%s",Last2CloseOrderTicket,Last2CloseOrderSymbol,Last2CloseOrderTicketProfit,TimeToString(Last2CloseOrderOpenTime,TIME_MINUTES),TimeToString(Last2CloseOrderColseTime,TIME_MINUTES));
                  }  
                  if((j-6)==i)
                  {
                     //Get seventh last Close Order ticket info
                     Last7CloseOrderTicket=OrderTicket();Last7CloseOrderTicketProfit=OrderProfit();
                     //Last4CloseOrderSymbol=OrderSymbol();Last4CloseOrderType=OrderType();
                     //Last4CloseOrderOpenTime=OrderOpenTime();Last4CloseOrderColseTime=OrderCloseTime();
                     //Print(__FUNCTION__);
                     //printf("Last222CloseOrderTicket=%d  Symobl=%s   Profit=%.2f   OpenTime=%s    CloseTime=%s",Last2CloseOrderTicket,Last2CloseOrderSymbol,Last2CloseOrderTicketProfit,TimeToString(Last2CloseOrderOpenTime,TIME_MINUTES),TimeToString(Last2CloseOrderColseTime,TIME_MINUTES));
                  }     
                  if((j-7)==i)
                  {
                     //Get eighth last Close Order ticket info
                     Last8CloseOrderTicket=OrderTicket();Last8CloseOrderTicketProfit=OrderProfit();
                     //Last4CloseOrderSymbol=OrderSymbol();Last4CloseOrderType=OrderType();
                     //Last4CloseOrderOpenTime=OrderOpenTime();Last4CloseOrderColseTime=OrderCloseTime();
                     //Print(__FUNCTION__);
                     //printf("Last222CloseOrderTicket=%d  Symobl=%s   Profit=%.2f   OpenTime=%s    CloseTime=%s",Last2CloseOrderTicket,Last2CloseOrderSymbol,Last2CloseOrderTicketProfit,TimeToString(Last2CloseOrderOpenTime,TIME_MINUTES),TimeToString(Last2CloseOrderColseTime,TIME_MINUTES));
                  } 
                  if((j-8)==i)
                  {
                     //Get ninth last Close Order ticket info
                     Last9CloseOrderTicket=OrderTicket();Last9CloseOrderTicketProfit=OrderProfit();
                     //Last4CloseOrderSymbol=OrderSymbol();Last4CloseOrderType=OrderType();
                     //Last4CloseOrderOpenTime=OrderOpenTime();Last4CloseOrderColseTime=OrderCloseTime();
                     //Print(__FUNCTION__);
                     //printf("Last222CloseOrderTicket=%d  Symobl=%s   Profit=%.2f   OpenTime=%s    CloseTime=%s",Last2CloseOrderTicket,Last2CloseOrderSymbol,Last2CloseOrderTicketProfit,TimeToString(Last2CloseOrderOpenTime,TIME_MINUTES),TimeToString(Last2CloseOrderColseTime,TIME_MINUTES));
                  }                             
               }
               }
            }
         }

                 
}
int CheckDurationFromStart(datetime startopen,datetime closetime)
{
     int CalDay=0;
     datetime TodayTime=closetime;
     datetime CalTime=startopen;
     //printff(TimeToString(Todaytime,TIME_DATE));
     MqlDateTime tm,tm2;
     TimeToStruct(TodayTime,tm);
     TimeToStruct(CalTime,tm2);
       
     CalDay=tm.day_of_year - tm2.day_of_year;
     
      return(CalDay);              
}