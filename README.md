# Apex Field Tooling

Classes with metadata tooling in Apex

## Classes

### MetadataPicklist

Create picklist field via Apex - for example:

```java


MetadataPicklist.PicklistField field = new MetadataPicklist.PicklistField();

field.objectAPIName = 'Opportunity';
field.fieldAPIName = 'Mages__c';
field.fieldLabel = 'Mages';
field.fieldDescription = 'This is a description';
field.picklistValues = new List<MetadataPicklist.PickListValue>{
    new MetadataPicklist.PicklistValue('TestFullName1', 'TestLabel1'),
    new MetadataPicklist.PicklistValue('TestFullName2', 'TestLabel2')
};

Boolean exists = field.doesFieldExist();

if(exists == false){
    MetadataPicklist.createField( field );
}
else {
    System.debug('Field already exists');
}
```

Update a picklist's options via Apex - for example:

```java
MetadataPicklist.PicklistField field = new MetadataPicklist.PicklistField();

field.objectAPIName = 'Opportunity';
field.fieldAPIName = 'Mages__c';
field.fieldLabel = 'Mages';
field.picklistValues = new List<MetadataPicklist.PickListValue>{
    new MetadataPicklist.PicklistValue('TestFullName1', 'TestLabel1'),
    new MetadataPicklist.PicklistValue('TestFullName2', 'TestLabel2'),
    new MetadataPicklist.PicklistValue('TestFullName3', 'TestLabel3')
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
    MetadataPicklist.createField(field);
}
else{
    System.debug('Field already exists and is up to date');
}
```

> If a picklist has options and they are omitted in an update call, the Metadata API will set those as inactive options

---

written with a 🐕 at my feet by [Jamie Smith](https://jsmith.dev)
