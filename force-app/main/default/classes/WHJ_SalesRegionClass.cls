public class WHJ_SalesRegionClass {
    public static String getthesalesregion(String BillingCountry){
        String region;
        region = (BillingCountry == system.Label.SalesRegionIndia) ? 'India' : 'International';
        region = (BillingCountry == system.Label.SalesRegionIndiaV2) ? 'IndiaV2' : 'International';
        region = (BillingCountry == system.Label.SalesRegionNZ) ? 'NZ' : 'International';
        region = (BillingCountry == system.Label.SalesRegionUK) ? 'UK' : 'International';
        region = (BillingCountry == system.Label.SalesRegionAus) ? 'AUS' : 'International';
        region = (BillingCountry == system.Label.SalesRegionCanada) ? 'Canada' : 'International';
        region = (BillingCountry == system.Label.SalesRegionUS) ? 'US' : 'International';
        return region;
    }
}