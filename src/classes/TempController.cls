public class TempController {
	
    public List<Book__c> Books {get; set;}


    // 필드셋 연습용
    public TempController(ApexPages.StandardController stdController){
    	this.Books = getBooks();
    }
    
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Book__c.fieldSets.fieldSetSample.getFields();
    }
    
    public List<Book__c> getBooks(){
        String query = 'SELECT ';

		for(Schema.FieldSetMember field : this.getFields()) {

			query += field.getFieldPath() + ', ';

		}
        
		query += 'Type__c FROM Book__c where Type__c =' + '\'교양\'';
        
        System.debug(query);
		return Database.query(query);
    }
    
    
    
    
}