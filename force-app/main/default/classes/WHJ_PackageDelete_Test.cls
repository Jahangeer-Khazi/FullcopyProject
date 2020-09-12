/*White Hat Junior Package Delete TEST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 25/09/2019
 *Purpose: This Test class is to test Data for WHJ_PackageDelete trigger.
 */ 


@isTest
public class WHJ_PackageDelete_Test {
    @isTest
   static void testData() {
       Account acc = new Account();
       acc.LastName = 'test';
       insert acc;
       
       Opportunity oppo = new Opportunity();
       oppo.AccountId = acc.Id;
       oppo.Name = 'whj';
       oppo.StageName = 'WON-PART PAYMENT';
       oppo.CloseDate = Date.newInstance(1960, 2, 17);
       insert oppo;
       
       Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        // 2. Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
       OpportunityLineItem ol = new OpportunityLineItem();
       ol.OpportunityId = oppo.Id;
       ol.Available_Discount__c = 10;
//       ol.Discount = 25;
       ol.UnitPrice = 200;
       ol.Quantity = 1 ;
       ol.PricebookEntryId = customPrice.Id;
   //    ol.Product2Id = '01t6D000000qpkxQAA';
       insert ol;
       try
            {
                Delete  ol;
            }
            catch(Exception ee)
            {
                
            }

       
   }
}