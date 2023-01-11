@SuppressWarnings('PMD.NcssMethodCount, PMD.TooManyFields, PMD.ExcessivePublicCount, PMD.CognitiveComplexity') //todo would be nice to refactor this class

public class MetadataTooling {
	public Integer length;
	public Integer precision;
	public Integer relationshipOrder;
	public Integer scale;
	public Integer startingNumber;
	public Integer visibleLines;
    
	public String defaultValue;
    public String deleteConstraint;
	public String description;
	public String displayFormat;
	public String externalDeveloperName;
	public String formula;
	public String formulaTreatBlanksAs;
	public String inlineHelpText;
	public String label;
	public String maskChar;
	public String maskType;
	public String referenceTo;
	public String relationshipLabel;
	public String relationshipName;
    public String summarizedField;
	public String summaryForeignKey;
	public String summaryOperation;
	public String fieldType;
    
    public Boolean caseSensitive;
    public Boolean displayLocationInDecimal;
    public Boolean escapeMarkup;
	public Boolean externalId;
    public Boolean isFilteringDisabled;
    public Boolean isNameField;
    public Boolean isSortingDisabled;
    public Boolean populateExistingRows;
    public Boolean readOnlyProxy;
    public Boolean reparentableMasterDetail;
    public Boolean required;
    public Boolean restrictedAdminField;
    public Boolean stripMarkup;
    public Boolean trackFeedHistory;
    public Boolean trackHistory;
    public Boolean unique;
    public Boolean writeRequiresMasterRead;
    
	public MetadataService.FilterItem[] summaryFilterItems;
    
    private MetadataService.MetadataPort service = new MetadataService.MetadataPort();  
    
    public MetadataTooling() {
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
    }
    
    public MetadataService.SaveResult[] createField(String objectAPIName, String fieldAPIName) {
		String returnValue = '';
        
        List<MetadataService.Metadata> fields = new List<MetadataService.Metadata>();
        MetadataService.CustomField customField = new MetadataService.CustomField();
		customField.fullName = objectAPIName + '.' + fieldAPIName;

        // decimal fields.
        if (this.length != null) { customField.length = this.length; }
        if (this.precision != null) { customField.precision = this.precision; }
        if (this.relationshipOrder != null) { customField.relationshipOrder = this.relationshipOrder; }
        if (this.scale != null) { customField.scale = this.scale; }
        if (this.startingNumber != null) { customField.startingNumber = this.startingNumber; }
        if (this.visibleLines != null) { customField.visibleLines = this.visibleLines; }
        
        // String fields.
        if (this.defaultValue != null) { customField.defaultValue = this.defaultValue; }
        if (this.deleteConstraint != null) { customField.deleteConstraint = this.deleteConstraint; }
        if (this.description != null) { customField.description = this.description; }
        if (this.displayFormat != null) { customField.displayFormat = this.displayFormat; }
        if (this.externalDeveloperName != null) { customField.externalDeveloperName = this.externalDeveloperName; }
        if (this.formula != null) { customField.formula = this.formula; }
        if (this.formulaTreatBlanksAs != null) { customField.formulaTreatBlanksAs = this.formulaTreatBlanksAs; }
        if (this.inlineHelpText != null) { customField.inlineHelpText = this.inlineHelpText; }
        if (this.label != null) { customField.label = this.label; }
        if (this.maskChar != null) { customField.maskChar = this.maskChar; }
        if (this.maskType != null) { customField.maskType = this.maskType; }
        if (this.referenceTo != null) { customField.referenceTo = this.referenceTo; }
        if (this.relationshipLabel != null) { customField.relationshipLabel = this.relationshipLabel; }
        if (this.relationshipName != null) { customField.relationshipName = this.relationshipName; }
        if (this.summarizedField != null) { customField.summarizedField = this.summarizedField; }
        if (this.summaryForeignKey != null) { customField.summaryForeignKey = this.summaryForeignKey; }
        if (this.summaryOperation != null) { customField.summaryOperation = this.summaryOperation; }
        if (this.fieldType != null) { customField.type_x = this.fieldType; }
        
        // Boolean fields
        if (this.caseSensitive != null) { customField.caseSensitive = this.caseSensitive; }
        if (this.displayLocationInDecimal != null) { customField.displayLocationInDecimal = this.displayLocationInDecimal; }
        if (this.escapeMarkup != null) { customField.escapeMarkup = this.escapeMarkup; }
        if (this.externalId != null) { customField.externalId = this.externalId; }
        if (this.isFilteringDisabled != null) { customField.isFilteringDisabled = this.isFilteringDisabled; }
        if (this.isNameField != null) { customField.isNameField = this.isNameField; }
        if (this.isSortingDisabled != null) { customField.isSortingDisabled = this.isSortingDisabled; }
        if (this.populateExistingRows != null) { customField.populateExistingRows = this.populateExistingRows; }
        if (this.reparentableMasterDetail != null) { customField.reparentableMasterDetail = this.reparentableMasterDetail; }
        if (this.required != null) { customField.required = this.required; }
        if (this.restrictedAdminField != null) { customField.restrictedAdminField = this.restrictedAdminField; }
        if (this.stripMarkup != null) { customField.stripMarkup = this.stripMarkup; }
        if (this.trackFeedHistory != null) { customField.trackFeedHistory = this.trackFeedHistory; }
        if (this.trackHistory != null) { customField.trackHistory = this.trackHistory; }
        if (this.unique != null) { customField.unique = this.unique; }
        if (this.writeRequiresMasterRead != null) { customField.writeRequiresMasterRead = this.writeRequiresMasterRead; }
        
        // object fields
        if (this.summaryFilterItems != null) { customField.summaryFilterItems = this.summaryFilterItems; }
        
        fields.add(customField);
        
        MetadataService.SaveResult[] results = service.createMetadata(fields);
        
        return results;
    }

    public String deleteField(String objectAPIName, String fieldAPIName) {
        
        String returnValue = '';
        
        List<MetadataService.Metadata> fields = new List<MetadataService.Metadata>();
        MetadataService.CustomField customField = new MetadataService.CustomField();
		customField.fullName = objectAPIName + '.' + fieldAPIName;
        fields.add(customField);
        String[] newStringDeletedFields = new String[] { customField.fullName }; 
        List<MetadataService.DeleteResult> results = service.deleteMetadata('CustomField', newStringDeletedFields); 
        
        // Iterate through each returned result
        for(MetadataService.DeleteResult dr : results) {
            if (!dr.success) {
                // Operation failed, so get all errors
                for(MetadataService.Error err : dr.errors) {
                    returnValue += err.statusCode  + ': ' + err.message + '<br /><br />';
                }
            }
        }
        
        return returnValue;
    }
}