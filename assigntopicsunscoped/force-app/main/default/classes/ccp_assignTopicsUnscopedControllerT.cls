@isTest
public class ccp_assignTopicsUnscopedControllerT {

    
    @testsetup
    static void setupMethod1()
    {
        FeedItem fi = new FeedItem();
        fi.parentId = UserInfo.getUserId();
        fi.title = 'testingTopicAssignment';
        fi.body = 'testingTopicAssignment';
        insert fi;
        
        /*Topic t = new Topic();
        t.Name = 'testTopicAssignment';
        t.networkId = null;
        insert t;
        
        TopicAssignment ta = new TopicAssignment();
        ta.EntityId = fi.Id;
        ta.TopicId = t.Id;
        insert ta;
        */
        Topic t2 = new Topic();
        t2.Name = 'testTopicAssignment2';
        t2.networkId = null;
        insert t2;
    }
    
    public static testMethod void test_success_AssignSearchUnassign()
    {
        FeedItem fi = [SELECT Id FROM FeedItem WHERE title = 'testingTopicAssignment' LIMIT 1];
        
        Map<Id,Topic> topicList = new Map<Id,Topic>([SELECT Id,Name,NetworkId FROM Topic WHERE Name = 'testTopicAssignment2']);
        System.Test.setFixedSearchResults(new List<Id>(topicList.keySet()));
        
        
        System.Test.startTest();
        //test create topic assignment
        Map<String,Object> mapOfObjectsCreateTopicAssignment = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_assignTopicsUnscopedController.createTopicAssignment( fi.Id, null, 'CREATE', 'testTopicAssignment')
            );
        System.debug('mapOfObjectsCreateTopicAssignment: ' + mapOfObjectsCreateTopicAssignment);
        List<Object> topicAssignmentList = (List<Object>) mapOfObjectsCreateTopicAssignment.get('topicAssignmentList');
        System.assertNotEquals(0,topicAssignmentList.size());
        
        
        
        
        
        //test search topic 
        Map<String,Object> mapOfObjectsTopicSearch = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_assignTopicsUnscopedController.doUnscopedTopicSearch(fi.Id,'testTopicAssign',null)
        );
        System.debug('mapOfObjectsTopicSearch: ' + mapOfObjectsTopicSearch);
        
        List<Object> topicListObject = (List<Object>) mapOfObjectsTopicSearch.get('topicList');
        System.debug('topicListObject: ' + topicListObject);
        Set<String> topicNames = new Set<String>();
        for(Object ot : topicListObject)
        {
            Topic t = (Topic) System.JSON.deserialize(System.JSON.serialize(ot), Topic.class );
            String topicName = t.Name;
            topicNames.add(topicName.toLowerCase());
        }
        System.debug('topicNames: ' + topicNames);
        System.assertEquals(true,topicNames.contains('testtopicassignment2'));
        System.assertEquals(true,topicNames.contains('testtopicassign'));
		
        
        
        
        //test delete topic assignment
        TopicAssignment ta = (TopicAssignment) System.JSON.deserialize( System.JSON.serialize(topicAssignmentList[0]), TopicAssignment.class );
        Map<String,Object> mapOfObjectsDeleteTopicAssignment = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_assignTopicsUnscopedController.deleteTopicAssignment(fi.Id, null, ta.Id)
            );
        System.debug('mapOfObjectsDeleteTopicAssignment: ' + mapOfObjectsDeleteTopicAssignment);
        List<Object> deleteTopicAssignmentList = (List<Object>) mapOfObjectsDeleteTopicAssignment.get('topicAssignmentList');
        System.assertEquals(0,deleteTopicAssignmentList.size());
        
        System.Test.stopTest();
        
    }
    
    public static testMethod void test_fail_AssignTopic()
    {
        FeedItem fi = [SELECT Id FROM FeedItem WHERE title = 'testingTopicAssignment' LIMIT 1];
        
        System.Test.startTest();
        Map<String,Object> mapOfObjectsCreateTopicAssignment = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_assignTopicsUnscopedController.createTopicAssignment( fi.Id, 'bogusnetwork', 'CREATE', 'testTopicAssignment')
            );
        System.debug('mapOfObjectsCreateTopicAssignment: ' + mapOfObjectsCreateTopicAssignment);
        String errorMsg = (String) mapOfObjectsCreateTopicAssignment.get('errorMsg');
        System.assert(!System.String.isEmpty(errorMsg));
        System.Test.stopTest();
    }
    
    public static testMethod void test_fail_SearchTopic()
    {
        FeedItem fi = [SELECT Id FROM FeedItem WHERE title = 'testingTopicAssignment' LIMIT 1];
        
        System.Test.startTest();
        Map<String,Object> mapOfObjectsTopicSearch = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_assignTopicsUnscopedController.doUnscopedTopicSearch(fi.Id,'testTopicAssign','bogusnetwork')
            );
        System.debug('mapOfObjectsTopicSearch: ' + mapOfObjectsTopicSearch);
        String errorMsg = (String) mapOfObjectsTopicSearch.get('errorMsg');
        System.assert(!System.String.isEmpty(errorMsg));
        System.Test.stopTest();
    }
    
    public static testMethod void test_fail_UnassignTopic()
    {
        FeedItem fi = [SELECT Id FROM FeedItem WHERE title = 'testingTopicAssignment' LIMIT 1];
        
        System.Test.startTest();
        Map<String,Object> mapOfObjectsDeleteTopicAssignment = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_assignTopicsUnscopedController.deleteTopicAssignment(fi.Id, null, 'bogusid')
            );
        System.debug('mapOfObjectsDeleteTopicAssignment: ' + mapOfObjectsDeleteTopicAssignment);
        
        String errorMsg = (String) mapOfObjectsDeleteTopicAssignment.get('errorMsg');
        System.assert(!System.String.isEmpty(errorMsg));
        System.Test.stopTest();
    }
    
}