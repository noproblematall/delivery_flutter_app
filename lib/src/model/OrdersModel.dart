class OrdersModel {

  dynamic Order_ID;

  dynamic Order_Name;

  dynamic Order_Number;

  dynamic Order_Status;
  dynamic Order_External_Status;
  dynamic Order_Location;
  dynamic Order_Notes_Public;

  dynamic Order_Notes_Private;
  dynamic Order_Customer_Notes;
  dynamic Order_Email;

  dynamic Sales_Rep_ID;
  dynamic Customer_ID;

  dynamic WooCommerce_ID;
  dynamic Zendesk_ID;
  dynamic Order_Status_Updated;

  dynamic Order_Display;
  dynamic Order_Payment_Price;

  dynamic Order_Payment_Completed;

  dynamic Order_PayPal_Receipt_Number;
  dynamic Order_View_Count;

  dynamic Order_Tracking_Link_Clicked;
  dynamic Order_Tracking_Link_Code;

  dynamic Customer_Name;

  dynamic Customer_WP_ID;

  dynamic Customer_FEUP_ID;

  dynamic Customer_Email;

  dynamic Customer_Created;

  dynamic Sales_Rep_First_Name;
  dynamic Sales_Rep_Last_Name;

  dynamic Sales_Rep_Email;
  dynamic Sales_Rep_WP_ID;
  dynamic Sales_Rep_Created;
  dynamic Note;
  dynamic Phone;
  dynamic Final_Price;
  dynamic Driver_Price;
  dynamic Customer_Price;


  OrdersModel({
    this.Order_ID,
    this.Order_Name ,
    this.Order_Number ,
    this.Order_Status,
    this.Order_External_Status,
    this.Order_Location,
    this.Order_Notes_Public ,
    this.Order_Notes_Private,
    this.Order_Customer_Notes,
    this.Order_Email ,
    this.Sales_Rep_ID,
    this.Customer_ID ,
    this.WooCommerce_ID,
    this.Zendesk_ID,
    this.Order_Status_Updated ,
    this.Order_Display,
    this.Order_Payment_Price ,
    this.Order_Payment_Completed ,
    this.Order_PayPal_Receipt_Number,
    this.Order_View_Count ,
    this.Order_Tracking_Link_Clicked,
    this.Order_Tracking_Link_Code ,
    this.Customer_Name ,
    this.Customer_WP_ID ,
    this.Customer_FEUP_ID ,
    this.Customer_Email ,
    this.Customer_Created ,
    this.Sales_Rep_First_Name,
    this.Sales_Rep_Last_Name ,
    this.Sales_Rep_Email,
    this.Sales_Rep_WP_ID,
    this.Sales_Rep_Created,
    this.Note,
    this.Phone,
    this.Final_Price,
    this.Driver_Price,
    this.Customer_Price

  });
}