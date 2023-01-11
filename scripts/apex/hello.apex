// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

Boolean remove = false;

if(remove){
    MetadataTooling tool = new MetadataTooling();
    String result = tool.deleteField(
        'Opportunity',
        'Stages__c'
    );
    System.debug(result);
}


MetadataPicklist.testRun();
