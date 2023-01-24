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

if( !field.doesFieldExist() ){
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
field.fieldDescription = 'It\'s a picklist field description';
field.picklistValues = new List<MetadataPicklist.PickListValue>{
    new MetadataPicklist.PicklistValue('TestFullName1', 'TestLabel1'),
    new MetadataPicklist.PicklistValue('TestFullName2', 'TestLabel2')
};

if( field.doesFieldExist() ){

    if( field.hasNonExistentValues() ){
        String fieldId = MetadataPicklist.getFieldId(field);
        System.debug('Updating '+fieldId+' with new options');
        MetadataPicklist.upsertField(field, fieldId);
    }
    else {
        System.debug('Field already exists and is up to date');
    }
}
else {
    System.debug('Creating new field');
    MetadataPicklist.createField(field);
}
```

> If a picklist has options and they are omitted in an update call, the Metadata API will set those as inactive options

---

written with a 🐕 at my feet by [Jamie Smith](https://jsmith.dev)
