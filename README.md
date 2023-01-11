# Apex Field Tooling

Classes with metadata tooling in Apex

## Classes

### MetadataPicklist

Create picklist field via Apex - for example:

```java
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
```

---

written w/ <3 by [Jamie](me@jsmith.dev)
