@SuppressWarnings('PMD.ApexSuggestUsingNamedCred')

public with sharing class MetadataPicklist {

    // Consuming example
    public static void testRun(){

        MetadataPicklist.Meta m = new MetadataPicklist.Meta();
        m.objectAPIName = 'Opportunity';
        m.fieldAPIName = 'Mages__c';
        m.fieldLabel = 'Mages';
        m.fieldDescription = 'This is a description';
        m.fieldType = 'Picklist';
        m.picklistValues = new List<PicklistValue>{
            new PicklistValue('TestFullName1', true, 'TestLabel1'),
            new PicklistValue('TestFullName2', false, 'TestLabel2')
        };
        Boolean exists = MetadataPicklist.check(m);

        if(exists == false){
            String result = MetadataPicklist.create(m);
            System.debug(result);
        }
        else {
            System.debug('Field already exists');
        }
    }

    public class PicklistValue {
        public String fullName;
        public Boolean isDefault;
        public String label;
        public PicklistValue(String fullName, Boolean isDefault, String label){
            this.fullName = fullName;
            this.isDefault = isDefault;
            this.label = label;
        }
    }
    
    public class Meta {
        public String objectAPIName;
        public String fieldAPIName;
        public String fieldLabel;
        public String fieldDescription;
        public String fieldType;
        public List<PicklistValue> picklistValues;
    }

    public static Boolean check(Meta m){//, Boolean deleteField

        Schema.SobjectField theField = Schema.getGlobalDescribe().get(m.objectAPIName).getDescribe().fields.getMap().get(m.fieldAPIName);

        // if not null, field exists
        return theField != null;
    }
    
    public static String create(Meta m){

        String objectAPIName = m.objectAPIName;
        String fieldAPIName = m.fieldAPIName;
        String fieldLabel = m.fieldLabel;
        String fieldDescription = m.fieldDescription;
        List<PicklistValue> picklistValues = m.picklistValues;

        String values = '';

        for(PicklistValue pl : picklistValues){
            
            String val = '{'+
                '"fullName": "'+pl.fullName+'",'+
                '"default": '+pl.isDefault+','+
                '"label": "'+pl.label+'"'+
            '}';

            if(picklistValues.indexOf(pl) != picklistValues.size() - 1){
                val += ',';
            }

            values += val;
        }

        String md = '{"Metadata": {'+
            '"type": "Picklist",'+
            '"required": false,'+
            '"label": "'+fieldLabel+'",'+
            '"description": "'+fieldDescription+'",'+

            '"valueSet": {'+
                '"restricted": true,'+
                '"valueSetDefinition": {'+
                    '"sorted": false,'+
                    '"value": [ '+values+' ]'+
                '}'+
            '}'+
        '}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';

        //System.debug(md);

        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v41.0/tooling/sobjects/CustomField/');
        request.setMethod('POST');
        
        request.setBody(md);
        
        Http http = new Http();
        HTTPResponse res = Test.isRunningTest() ? new HTTPResponse() : http.send(request);
        return res.getBody();
    }
}