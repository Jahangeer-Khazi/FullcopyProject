public class WHJ_Utils {
    
    //return sales region based on billing country
    public static String getSalesRegion(String billingCountry) {
        List<Country_Mapping__mdt> salesRegionMappingList = [SELECT Id, Name__c,Value__c FROM Country_Mapping__mdt WHERE Name__c = :billingCountry];
        return salesRegionMappingList.size() >0 ? salesRegionMappingList[0].value__c : System.Label.DefaultSalesRegion;
    }
    
    //return default manager based on sales region
    public static String getDefaultManagerId (String countryName, String leadType) {
        String country = System.Label.DefaultSalesRegion ;
        Set<String> countrySet = new Set<String>();
       // Map<String, Country_Mapping__mdt> salesRegionMappingListMap = new Map<String, Country_Mapping__mdt>();
        List<Country_Mapping__mdt> salesRegionMappingListData = [SELECT Id,Label, Name__c,Value__c,DefaultSMId__c,DefaultRMId__c,DefaultRenewalManagerId__c,DefaultReferralManagerId__c FROM Country_Mapping__mdt];  
        for(Country_Mapping__mdt countryMappingData: salesRegionMappingListData) {
            //salesRegionMappingListMap.put(countryMappingData.value__c, countryMappingData);
            countrySet.add(countryMappingData.value__c);
        }
        
        if (countrySet.contains(countryName)) {
            country = countryName;
        }
        
        List<Country_Mapping__mdt> salesRegionMappingList = [SELECT Id,Name__c,Value__c,DefaultSMId__c,DefaultRMId__c,DefaultRenewalManagerId__c,DefaultReferralManagerId__c FROM Country_Mapping__mdt WHERE Name__c = :country];  
        system.debug('list size-- ' + salesRegionMappingList);
        
        return leadType == 'New' ? salesRegionMappingList[0].DefaultSMId__c : leadType == 'Renewal' ? salesRegionMappingList[0].DefaultRenewalManagerId__c : leadType == 'Referral' ? salesRegionMappingList[0].DefaultReferralManagerId__c : leadType == 'Ops' ? salesRegionMappingList[0].DefaultRMId__c : System.Label.Default_US_Manager;
        
    }
	
    //return Salesref Id from Salesref Email
    public static Id getSalesRefEmail (String salesRefEmail) {
        List<User> lstUser = [SELECT Id,Email FROM User WHERE Email = :salesRefEmail limit 5];
        return lstUser.size() >0 ? lstUser[0].Id : null;
    }
    
    //delay function
   /* public static void addDelay() {
        Integer tmp = Integer.valueof((Math.random() * 50));
        
        integer count = 0;
        Integer start = System.Now().millisecond();
        while(System.Now().millisecond()< start + tmp ) {
            system.debug('count--- ' + count);
            count = count + 1;
        }
    }*/
    //Getting Random Number
    public static Integer generateRandomNumber(Integer num)
    {
        Integer tmp = Integer.valueof((Math.random() * num));
		
        return tmp;
    }
    
}