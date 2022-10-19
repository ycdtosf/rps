public class Collection_getUniqueStringValues {
    
    @InvocableMethod
    public static List<List<String>> execute(List<Request> requests) {
        
        List<List<String>> output = new List<List<String>>();

        for(Request request : requests) {
            if(request.records == null) continue;
            Set<String> values = new Set<String>();
            for(sObject record : request.records) {
                values.add((String)record.get(request.field));
            }
            output.add(new List<String>(values));
        }

        return output;

    }

    public class Request {
        @InvocableVariable public List<sObject> records;
        @InvocableVariable public String field;
    }

}