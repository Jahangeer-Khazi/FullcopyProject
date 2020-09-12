/*White Hat Junior Lead API Parser Class 
*Created By: HGUGHANGE
*Release No: 1
*Created Date: 11/09/2019
*Purpose: This Apex Parser class is to Parse Data for WHJ_Lead_API class.
*/ 


public class WHJ_LeadParser {
    
    public String primaryemail;
    public String alternateemail;
    public String firstname;
    public String lastname;
    public String street;
    public String city;
    public String state;
    public String country;
    public String status;
    public String mobile;
    public Integer credit;
    
    public String testVar;
    public String gender;
    public String parentname;
    public Date registereddate;
    public Boolean isreferral;
    public String grade;
    public String timezone;
    public String id;
    public String studentid;
    public String campaignsource;
    public String campaignmedium;
    public String campaignname;
    public String campaigncontent;
    public String campaignterm;
    public String campaigncreative;
    public String language;
    public String page;
    public String campaignid;
    public String adsetid;
    public String adid;
    public String affiliatename;
    public String listname;
    public String location;
    public String matchtype;
    public String device;
    public String reftype;
    public String refdescription;
    public Integer totaldiscount;
    
    public String salesRef;
    public String course_short_name;
    public String additionalContactNo;
    
    public DateTime appointmentschedule;
    public String appointmentcomments;
    public Boolean subscriptionflag;
    public String additionalEmailId;
    
    public String ReferralCustomer;
    public String ReferralManager;
    public String LeadType;
    public String LeadId;
    public String RegistrationLink; 
    public String batchtype;
    public String batchid;
    public DateTime batchstartdate;
    Public DateTime trialbookingdate;
    public Boolean isdndactive;
    
    public static WHJ_LeadParser parse(String json) {
        return (WHJ_LeadParser) System.JSON.deserialize(json, WHJ_LeadParser.class);
    }
    
    
}