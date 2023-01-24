@SuppressWarnings('PMD.ApexSuggestUsingNamedCred')

public with sharing class MetadataPicklist {

    // Consuming example
    public static void testRun(){

        MetadataPicklist.PicklistField field = new MetadataPicklist.PicklistField();

        field.objectAPIName = 'Opportunity';
        field.fieldAPIName = 'Mages__c';
        field.fieldLabel = 'Mages';
        field.picklistValues = new List<MetadataPicklist.PickListValue>{
            new MetadataPicklist.PicklistValue('TestFullName1', 'TestLabel1'),
            new MetadataPicklist.PicklistValue('TestFullName5', 'TestLabel5'),
            new MetadataPicklist.PicklistValue('TestFullName2', 'TestLabel2')
        };

        Boolean exists = field.doesFieldExist();
        Boolean hasNonExistentValues = field.hasNonExistentValues();

        if(exists && hasNonExistentValues){
            System.debug('Creating new values');
            String fieldId = MetadataPicklist.getFieldId(field);
            MetadataPicklist.upsertField(field, fieldId);
        }
        else if(!exists){
            System.debug('Creating new field');
            MetadataPicklist.upsertField(field, '');
        }
        else{
            System.debug('Field already exists and is up to date');
        }
    }


    public class PicklistField {
        public String objectAPIName;
        public String fieldAPIName;
        public String fieldLabel;
        public String fieldDescription;
        public String fieldType = 'Picklist';
        public List<PicklistValue> picklistValues;
        public Boolean doesFieldExist (){
            return MetadataPicklist.check(this);
        }
        public Boolean hasNonExistentValues (){
            return MetadataPicklist.hasNonExistentValues(this);
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
        public PicklistValue(String fullName, String label){
            this.fullName = fullName;
            this.isDefault = false;
            this.label = label;
        }
        public PicklistValue(String fullName){
            this.fullName = fullName;
            this.isDefault = false;
            this.label = fullName;
        }
    }

    public static Boolean check(PicklistField plf){//, Boolean deleteField
        
        Schema.SobjectField theField = Schema.getGlobalDescribe().get(plf.objectAPIName).getDescribe().fields.getMap().get(plf.fieldAPIName);

        // if not null, field exists
        return theField != null;
    }
    
    public static String upsertField(PicklistField plf, String fieldId){

        String objectAPIName = plf.objectAPIName;
        String fieldAPIName = plf.fieldAPIName;
        String fieldLabel = plf.fieldLabel;
        String fieldDescription = plf.fieldDescription;
        List<PicklistValue> picklistValues = plf.picklistValues;

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

        return callout(md, fieldId);
    }


    public static Boolean hasNonExistentValues(PicklistField plf){
        List<PicklistValue> nonExistentValues = MetadataPicklist.getNonExistentValues(plf);
        return nonExistentValues.size() > 0;
    }

    public static List<PicklistValue> getNonExistentValues(PicklistField plf){

        List<PicklistValue> potentialValues = plf.picklistValues;
        List<PicklistValue> newValues = new List<PicklistValue>();

        List<Schema.PicklistEntry> entries = Schema.getGlobalDescribe()
            .get(plf.objectAPIName).getDescribe()
            .fields.getMap().get(plf.fieldAPIName).getDescribe()
            .getPickListValues();
        
        for(PicklistValue pot : potentialValues){
            
            Boolean exists = false;

            for( Schema.PicklistEntry entry : entries){
                if(entry.getValue().equalsIgnoreCase(pot.fullName)){
                    exists = true;
                    break;
                }
            }

            if(!exists){
                newValues.add(pot);
            }
        }

        return newValues;
    }
    
    public static String getFieldId(MetadataPicklist.PicklistField field){

        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();

        String body = MetadataPicklist.callEndpoint( baseURL + '/services/data/v38.0/tooling/query?q=select+id,+DataType,NamespacePrefix,+DeveloperName,+Metadata+from+FieldDefinition+where+EntityDefinition.QualifiedApiName+=+\''+field.objectAPIName+'\'+AND+QualifiedApiName+=\''+field.fieldAPIName+'\'' );
        
        String pre = 'sobjects/FieldDefinition/Opportunity.';
        Integer marker = body.indexOf(pre);
        Integer mark = marker+pre.length();
        String uid = body.substring(mark, mark+15);

        return uid;
    }

    public static String callEndpoint(String endPoint) {

        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setTimeout(60000);   
        request.setEndpoint(endPoint);   
        request.setMethod('GET');

        Http http = new Http();
        HTTPResponse res = Test.isRunningTest() ? new HTTPResponse() : http.send(request);
        return res.getBody();
    }

    public static String callout(String body, String fieldId){

        String method = fieldId == null || fieldId == '' ? 'POST' : 'PATCH';

        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v41.0/tooling/sobjects/CustomField/'+fieldId);
        request.setMethod(method);
        
        request.setBody(body);
        
        Http http = new Http();
        HTTPResponse res = Test.isRunningTest() ? new HTTPResponse() : http.send(request);
        return res.getBody();
    }
}