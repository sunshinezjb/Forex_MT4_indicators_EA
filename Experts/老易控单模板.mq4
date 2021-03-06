//+------------------------------------------------------------------+
//|                                                       老易控单模板.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| 初始化功能                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   iMain();
   return(0)
  }
//+------------------------------------------------------------------+
//| 卸载功能                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| 价格跳动时的执行函数                                       |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }

//+------------------------------------------------------------------+
//| 主控程序                                                |
//+------------------------------------------------------------------+
void iMain()
{
  iShowInfo();
}


//+------------------------------------------------------------------+
//| 显示交易信息                                            |
//+------------------------------------------------------------------+
void iShowInfo()
  {
    //初始化变量
    BuyGroupOrders=0; SellGroupOrders=0; //买入卖出组成交持仓单数量总计
    BuyGroupFirstTicket=0; SellGroupFirstTicket=0; //买入卖出组第一张订单单号
    BuyGroupLastTicket=0; SellGroupLastTicket=0;  //买入卖出组最后一张订单
    BuyGroupMaxProfitTicket=0; SellGroupMaxProfitTicket=0; //买入卖出组最大盈利单单号
    BuyGroupMinProfitTicket=0; SellGroupMinProfitTicket=0; //买入卖出组最小盈利单单号
    BuyGroupMaxLossTicket=0; SellGroupMaxLossTicket=0; //买入卖出组最大亏损单单号
    BuyGroupMinLossTicket=0; SellGroupMinLossTicket=0; //买入卖出组最小亏损单单号
    BuyGroupLots=0; SellGroupLots=0; //买入卖出组成交单持仓量
    BuyGroupProfit=0; SellGroupProfit=0; //买入卖出组成交单利润
    BuyLimitOrders=0; SellLimitOrders=0; //买入限价挂单、卖出限价挂单数量总计
    BuyStopOrders=0; SellStopOrders=0; //买入突破挂单、卖出突破挂单数量总计
    //初始化订单数组
    MyArrayRange=OrdersTotal()+1;
    //重新界定数组
    ArrayResize(OrdersArray, MyArrayRange);
    //初始化数组
    ArrayInitialize(OrdersArray,0.00);
    
    if(OrdersTotal()>0)
       {
         //遍历持仓单
         for(cnt=0; cnt<=MyArrayRange; cnt++)
             {
               //选中当前货币对相关持仓单
               if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()==MyMagicNum)
                  {
                    OrdersArray[cnt][0]=OrderTicket(); //0 订单号
                    OrdersArray[cnt][1]=OrderOpenTime(); //1 开仓时间
                    OrdersArray[cnt][2]=OrderProfit(); //2 订单利润
                    OrdersArray[cnt][3]=OrderType(); //3 订单类型
                    OrdersArray[cnt][4]=OrderLots(); //4 开仓量
                    OrdersArray[cnt][5]=OrderOpenPrice(); //5 开仓价
                    OrdersArray[cnt][6]=OrderStopLoss(); //6 止损价
                    OrdersArray[cnt][7]=OrderTakeProfit(); //7 止盈价
                    OrdersArray[cnt][8]=OrderMagicNumber(); //8 订单特征码
                    OrdersArray[cnt][9]=OrderCommission(); //9 订单佣金
                    OrdersArray[cnt][10]=OrderSwap(); //10 掉期
                    OrdersArray[cnt][11]=OrderExpiration(); //11 挂单有效日期
                  }
             }
             
          //统计基本信息
          for(cnt=0; cnt<=MyArrayRange; cnt++)
             {
               //买入持仓单
               if(OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUY)
                   {
                     BuyGroupOrders=BuyGroupOrders + 1; //买入组订单数量
                     BuyGroupLots=BuyGroupLots + OrdersArray[cnt][4]; //买入组开仓量
                     BuyGroupProfit=BuyGroupProfit + OrdersArray[cnt][2]; //买入组利润
                   }
               //卖出持仓单
               if(OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELL)
                   {
                     SellGroupOrders=SellGroupOrders + 1; //卖出组订单数量
                     SellGroupLots=SellGroupLots + OrdersArray[cnt][4]; //卖出组开仓量
                     SellGroupProfit=SellGroupProfit + OrdersArray[cnt][2]; //卖出组利润
                   }
               //买入组限制挂单总计
               if(OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYLIMIT) BuyLimitOrders=BuyLimitOrders + 1;
               //卖出组限制挂单总计
               if(OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLLIMIT) SellLimitOrders=SellLimitOrders + 1;
               //买入突破挂单总计
               if(OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYSTOP) BuyStopOrders=BuyStopOrders + 1;
               //卖出突破挂单总计
               if(OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLSTOP) SellStopOrders=SellStopOrders + 1;
             }
          //计算买入卖出组首尾单号
          BuyGroupFirstTicket=iOrderSortTicket(0,0,1); //买入组第1单单号
          SellGroupFirstTicket=iOrderSortTicket(1,0,1); //卖出组第1单单号
          BuyGroupLastTicket=iOrderSortTicket(0,0,0); //买入组最后1单单号
          SellGroupLastTicket=iOrderSortTicket(1,0,0); //卖出组最后1单单号
          
          BuyGroupMinProfitTicket=iOrderSortTicket(0,1,1); //买入组最小盈利单单号
          SellGroupMinProfitTicket=iOrderSortTicket(1,1,1); //卖出组最小盈利单单号
          BuyGroupMaxProfitTicket=iOrderSortTicket(0,1,0); //买入组最大盈利单单号
          SellGroupMaxProfitTicket=iOrderSortTicket(1,1,0); //卖出组最大盈利单单号
          BuyGroupMaxLossTicket=iOrderSortTicket(0,2,0); //买入组最大亏损单单号
          SellGroupMaxLossTicket=iOrderSortTicket(1,2,0); //卖出组最大亏损单单号
          BuyGroupMinLossTicket=iOrderSortTicket(0,2,1); //买入组最小亏损单单号
          SellGroupMinLossTicket=iOrderSortTicket(1,2,1); //卖出组最小亏损单单号
       }
     
     return(0);
  }

//+------------------------------------------------------------------+
//| 计算特定条件的订单
//| 入参 myOrderType:订单类型，0-Buy,1-Sell,2-BuyLimit,3-SellLimit,4-BuyStop,5-SellStop
//|      myOrderSort:排序类型，0-按时间，1-按盈利，2-按亏损
//|      myMaxMin:最值，0-最大，1-最小
//| 出参 返回订单号
//+------------------------------------------------------------------+
int iOrderSortTicket(int myOrderType, int myOrderSort, int myMaxMin)
    {
      int myTicket=0;
      int myArraycnt=0;
      int myArraycnt1=0;
      int myType;
      //创建临时数组
      double myTempArray[][12]; //定义临时数组
      ArrayResize(myTempArray, MyArrayRange); //重新界定临时数组
      ArrayInitialize(myTempArray, 0.00); //初始化临时数组
      double myTempOrdersArray[][12]; //定义临时数组
      myArraycnt=BuyGroupOrders + SellGroupOrders;
      if(myArraycnt==0)return(0);
      myArraycnt1=myArraycnt;
      myArraycnt=myArraycnt - 1;
      ArrayResize(myTempOrdersArray, myArraycnt1); //重新界定临时数组
      ArrayInitialize(myTempOrdersArray, 0.00); //初始化临时数组
      for(cnt=0;cnt<=MyArrayRange;cnt++)
         {
           if((OrdersArray[cnt][3]==0 || OrdersArray[cnt][3]==1) && OrdersArray[cnt][0]!=0)
               {
                 myTempOrdersArray[myArraycnt][0]=OrdersArray[cnt][0];
                 myTempOrdersArray[myArraycnt][1]=OrdersArray[cnt][1];
                 myTempOrdersArray[myArraycnt][2]=OrdersArray[cnt][2];
                 myTempOrdersArray[myArraycnt][3]=OrdersArray[cnt][3];
                 myTempOrdersArray[myArraycnt][4]=OrdersArray[cnt][4];
                 myTempOrdersArray[myArraycnt][5]=OrdersArray[cnt][5];
                 myTempOrdersArray[myArraycnt][6]=OrdersArray[cnt][6];
                 myTempOrdersArray[myArraycnt][7]=OrdersArray[cnt][7];
                 myTempOrdersArray[myArraycnt][8]=OrdersArray[cnt][8];
                 myTempOrdersArray[myArraycnt][9]=OrdersArray[cnt][9];
                 myTempOrdersArray[myArraycnt][10]=OrdersArray[cnt][10];
                 myTempOrdersArray[myArraycnt][11]=OrdersArray[cnt][11];
                 myArraycnt=myArraycnt - 1;
               }
         }
      //按时间降序排列数组
      if(myOrderSort==0)
          {
            for(i=0; i<MyArrayRange; i++)
                {
                  for(j=MyArrayRange; j>i; j--)
                      {
                        if(OrdersArray[j][1]>OrdersArray[j-1][1])
                            {
                              myTempArray[0][0]=OrdersArray[j-1][0];
                              myTempArray[0][1]=OrdersArray[j-1][1];
                              myTempArray[0][2]=OrdersArray[j-1][2];
                              myTempArray[0][3]=OrdersArray[j-1][3];
                              myTempArray[0][4]=OrdersArray[j-1][4];
                              myTempArray[0][5]=OrdersArray[j-1][5];
                              myTempArray[0][6]=OrdersArray[j-1][6];
                              myTempArray[0][7]=OrdersArray[j-1][7];
                              myTempArray[0][8]=OrdersArray[j-1][8];
                              myTempArray[0][9]=OrdersArray[j-1][9];
                              myTempArray[0][10]=OrdersArray[j-1][10];
                              myTempArray[0][11]=OrdersArray[j-1][11];
                              
                              OrdersArray[j-1][0]=OrdersArray[j][0];
                              OrdersArray[j-1][1]=OrdersArray[j][1];
                              OrdersArray[j-1][2]=OrdersArray[j][2];
                              OrdersArray[j-1][3]=OrdersArray[j][3];
                              OrdersArray[j-1][4]=OrdersArray[j][4];
                              OrdersArray[j-1][5]=OrdersArray[j][5];
                              OrdersArray[j-1][6]=OrdersArray[j][6];
                              OrdersArray[j-1][7]=OrdersArray[j][7];
                              OrdersArray[j-1][8]=OrdersArray[j][8];
                              OrdersArray[j-1][9]=OrdersArray[j][9];
                              OrdersArray[j-1][10]=OrdersArray[j][10];
                              OrdersArray[j-1][11]=OrdersArray[j][11];
                              
                              OrdersArray[j][0]=myTempArray[0][0];
                              OrdersArray[j][1]=myTempArray[0][1];
                              OrdersArray[j][2]=myTempArray[0][2];
                              OrdersArray[j][3]=myTempArray[0][3];
                              OrdersArray[j][4]=myTempArray[0][4];
                              OrdersArray[j][5]=myTempArray[0][5];
                              OrdersArray[j][6]=myTempArray[0][6];
                              OrdersArray[j][7]=myTempArray[0][7];
                              OrdersArray[j][8]=myTempArray[0][8];
                              OrdersArray[j][9]=myTempArray[0][9];
                              OrdersArray[j][10]=myTempArray[0][10];
                              OrdersArray[j][11]=myTempArray[0][11];
                            }
                      }
                }
          }
       //按利润降序排列数组
       double myTempArray1[][12]; //定义临时数组
       ArrayResize(myTempArray1, myArraycnt1); //重新界定临时数组
       ArrayInitialize(myTempArray1, 0.00); //初始化临时数组
       if(myOrderSort==1 || myOrderSort==2)
           {
             for(i=0; i<=myArraycnt1; i++)
                 {
                   for(j=myArraycnt1-1; j>i; j--)
                       { 
                         if(myTempOrdersArray[j][2]>myTempOrdersArray[j-1][2])
                             {
                               myTempArray1[0][0]=myTempOrdersArray[j-1][0];
                               myTempArray1[0][1]=myTempOrdersArray[j-1][1];
                               myTempArray1[0][2]=myTempOrdersArray[j-1][2];
                               myTempArray1[0][3]=myTempOrdersArray[j-1][3];
                               myTempArray1[0][4]=myTempOrdersArray[j-1][4];
                               myTempArray1[0][5]=myTempOrdersArray[j-1][5];
                               myTempArray1[0][6]=myTempOrdersArray[j-1][6];
                               myTempArray1[0][7]=myTempOrdersArray[j-1][7];
                               myTempArray1[0][8]=myTempOrdersArray[j-1][8];
                               myTempArray1[0][9]=myTempOrdersArray[j-1][9];
                               myTempArray1[0][10]=myTempOrdersArray[j-1][10];
                               myTempArray1[0][11]=myTempOrdersArray[j-1][11];
                               
                               myTempOrdersArray[j-1][0]=myTempOrdersArray[j][0];
                               myTempOrdersArray[j-1][1]=myTempOrdersArray[j][1];
                               myTempOrdersArray[j-1][2]=myTempOrdersArray[j][2];
                               myTempOrdersArray[j-1][3]=myTempOrdersArray[j][3];
                               myTempOrdersArray[j-1][4]=myTempOrdersArray[j][4];
                               myTempOrdersArray[j-1][5]=myTempOrdersArray[j][5];
                               myTempOrdersArray[j-1][6]=myTempOrdersArray[j][6];
                               myTempOrdersArray[j-1][7]=myTempOrdersArray[j][7];
                               myTempOrdersArray[j-1][8]=myTempOrdersArray[j][8];
                               myTempOrdersArray[j-1][9]=myTempOrdersArray[j][9];
                               myTempOrdersArray[j-1][10]=myTempOrdersArray[j][10];
                               myTempOrdersArray[j-1][11]=myTempOrdersArray[j][11];
                               
                               myTempOrdersArray[j][0]=myTempArray[0][0];
                               myTempOrdersArray[j][1]=myTempArray[0][1];
                               myTempOrdersArray[j][2]=myTempArray[0][2];
                               myTempOrdersArray[j][3]=myTempArray[0][3];
                               myTempOrdersArray[j][4]=myTempArray[0][4];
                               myTempOrdersArray[j][5]=myTempArray[0][5];
                               myTempOrdersArray[j][6]=myTempArray[0][6];
                               myTempOrdersArray[j][7]=myTempArray[0][7];
                               myTempOrdersArray[j][8]=myTempArray[0][8];
                               myTempOrdersArray[j][9]=myTempArray[0][9];
                               myTempOrdersArray[j][10]=myTempArray[0][10];
                               myTempOrdersArray[j][11]=myTempArray[0][11];                             
                             }
                       }
                 }
           }
        //订单类型最小亏损单
        if (myOrderSort==2 && myMaxMin==1)
            {
              for (cnt=0; cnt<=myArraycnt1; cnt++)
                  {
                    myType=NormalizeDouble(myTempOrdersArray[cnt][3],0);
                    if (myTempOrdersArray[cnt][2]<0 && myType==myOrderType)
                        {
                          myTicket=NormalizeDouble(myTempOrdersArray[cnt][0],0); break;
                        }
                  }
            }
        //X 订单类型最大亏损单
        if (myOrderSort==2 && myMaxMin==0)
            {
              for (cnt=myArraycnt1; cnt>=0; cnt--)
                  {
                    myType=NormalizeDouble(myTempOrdersArray[cnt][3],0);
                    if (myTempOrdersArray[cnt][2]<0 && myType==myOrderType)
                        {
                          myTicket=NormalizeDouble(myTempOrdersArray[cnt][0],0); break;
                        }
                  }
            }
        //X 订单类型最大盈利单
        if (myOrderSort==1 && myMaxMin==0)
            {
              for (cnt=0; cnt<=myArraycnt1; cnt++)
                  {
                    myType=NormalizeDouble(myTempOrdersArray[cnt][3],0);
                    if (myTempOrdersArray[cnt][2]>0 && myType==myOrderType)
                        {
                          myTicket=NormalizeDouble(myTempOrdersArray[cnt][0],0); break;
                        }
                  }
            }
         //X 订单类型最小盈利单
         if (myOrderSort==1 && myMaxMin==1)
             {
               for (cnt=myArraycnt1; cnt>=0; cnt--)
                   {
                     myType=NormalizeDouble(myTempOrdersArray[cnt][3],0);
                     if (myTempOrdersArray[cnt][2]>0 && myType==myOrderType)
                         {
                           myTicket=NormalizeDouble(myTempOrdersArray[cnt][0],0); break;
                         }
                   }
             }
         //X 订单类型第 1 开仓单
         if (myOrderSort==0 && myMaxMin==1)
             {
               for (cnt=MyArrayRange; cnt>=0; cnt--)
                   {
                     myType=NormalizeDouble(OrdersArray[cnt][3],0);
                     if (OrdersArray[cnt][0]!=0 && myType==myOrderType)
                         {
                           myTicket=NormalizeDouble(OrdersArray[cnt][0],0); break;
                         }
                   }
             }
         //X 类型最后开仓单
         if (myOrderSort==0 && myMaxMin==0)
             {
               for (cnt=0; cnt<=MyArrayRange; cnt++)
                   {
                     myType=NormalizeDouble(OrdersArray[cnt][3],0);
                     if (OrdersArray[cnt][0]!=0 && myType==myOrderType)
                         {
                           myTicket=NormalizeDouble(OrdersArray[cnt][0],0); break;
                         }
                   }
             }
         return(myTicket);
    }
//+------------------------------------------------------------------+
//| init函数                                            |
//+------------------------------------------------------------------+
int init()
    {
      iShowInfo();
      //初始化预设变量Lots=预设开仓量;
      MyOrderComment=订单注释; 
      MyMagicNum=订单特征码; 
      return(0);
    }








//+------------------------------------------------------------------+
//| deinit函数                                            |
//+------------------------------------------------------------------+
int deinit()
    {
      return(0);
    }




//+------------------------------------------------------------------+
//| ChartEvent函数                                            |
//+------------------------------------------------------------------+












//+------------------------------------------------------------------+
