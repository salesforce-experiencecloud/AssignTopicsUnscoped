public without sharing class ccp_assignTopicsUnscopedController {
    
    @AuraEnabled
    public static String doUnscopedTopicSearch(String recordId, String searchTerm, String networkId){
        
        Map<String,Object> mapOfObjects = new Map<String,Object>();
        
        try {
            
            Schema.DescribeSObjectResult dsr = Topic.sObjectType.getDescribe();
            Schema.DescribeSObjectResult dsr2 = TopicAssignment.sObjectType.getDescribe();
            
            if(!dsr.isAccessible() || !dsr2.isAccessible())
            {
                mapOfObjects.put('errorMsg', 'User must have Read access to Topics and TopicAssignments.');
                return JSON.serialize( mapOfObjects );
            }
            
            if(!System.String.isEmpty(searchTerm))
            {
                String searchTermWildCard = searchTerm + '*';
                networkId = (System.String.isEmpty(networkId)) ? '' : networkId;
                
                List<TopicAssignment> topicAssignmentList = getRecordTopicAssignment(recordId,networkId);
                Set<Id> excludeTopicSet = new Set<Id>();
                Set<String> excludeTopicNameSet = new Set<String>();
                for(TopicAssignment ta : topicAssignmentList)
                {
                    excludeTopicSet.add(ta.TopicId);
                    excludeTopicNameSet.add(ta.Topic.Name.toLowerCase());
                }
                
                List<List<SObject>> searchList = [FIND :searchTermWildCard IN ALL FIELDS RETURNING Topic 
                                                  (Id,Name,NetworkId WHERE NetworkId = :networkId AND 
                                                   (
                                                       NOT Id IN :excludeTopicSet 
                                                   )
                                                  )
                                                  LIMIT 6
                                                 ];
                
                List<Topic> topicListSearch = (List<Topic>) searchList[0];
                List<Topic> topicList = new List<Topic>();
                
                Map<Id,String> managedTopicsMap = getManagedTopics(networkId);
                
                Set<String> topicNames = new Set<String>();
                for(Topic t : topicListSearch)
                {
                    topicNames.add(t.Name.toLowerCase());
                    if(managedTopicsMap.keySet().contains(t.Id))
                    {
                        t.Description = managedTopicsMap.get(t.Id);
                    }
                }
                
                if(!topicNames.contains(searchTerm.toLowerCase()) && !excludeTopicNameSet.contains(searchTerm.toLowerCase()))
                {
                    
                    Topic t = new Topic();
                    t.Name = searchTerm;
                    t.networkId = (System.String.isEmpty(networkId)) ? null : networkId;
                    topicList.add(t);
                }
                
                topicList.addAll( topicListSearch );
                
                mapOfObjects.put('topicList', topicList);
            }
            
        } catch(Exception e) {
            mapOfObjects.put('errorMsg', e.getMessage());
        }
        
        return JSON.serialize( mapOfObjects );
    }
    
    @AuraEnabled
    public static String getRecordTopicInfo(String recordId, String networkId){
        
        Map<String,Object> mapOfObjects = new Map<String,Object>();
        
        try {
            
            Schema.DescribeSObjectResult dsr = Topic.sObjectType.getDescribe();
            Schema.DescribeSObjectResult dsr2 = TopicAssignment.sObjectType.getDescribe();
            
            if(!dsr.isAccessible() || !dsr2.isAccessible())
            {
                mapOfObjects.put('errorMsg', 'User must have Read access to Topics and TopicAssignments.');
                return JSON.serialize( mapOfObjects );
            }
            
            networkId = (System.String.isEmpty(networkId)) ? '' : networkId;
            List<TopicAssignment> topicAssignmentList = getRecordTopicAssignment(recordId,networkId);
            mapOfObjects.put('topicAssignmentList', topicAssignmentList);
            
            List<Network> networkList = [SELECT Id,Name FROM Network];
            mapOfObjects.put('networkList', networkList);
            
            
        } catch(Exception e) {
            mapOfObjects.put('errorMsg', e.getMessage());
        }
        
        return JSON.serialize( mapOfObjects );
    }
    
    @AuraEnabled
    public static String createTopicAssignment(String recordId, String networkId, String topicId, String searchTerm){
        
        Map<String,Object> mapOfObjects = new Map<String,Object>();
        
        try {
            
            Schema.DescribeSObjectResult dsr = Topic.sObjectType.getDescribe();
            Schema.DescribeSObjectResult dsr2 = TopicAssignment.sObjectType.getDescribe();
            
            if(!dsr2.isCreateable())
            {
                mapOfObjects.put('errorMsg', 'User must have Create access to TopicAssignments.');
                return JSON.serialize( mapOfObjects );
            }
            
            if(topicId == 'CREATE')
            {
                if(!dsr.isCreateable())
                {
                    mapOfObjects.put('errorMsg', 'User must have Create access to Topics.');
                    return JSON.serialize( mapOfObjects );
                }
                
                Topic t = new Topic();
                t.Name = searchTerm;
                t.networkId = System.String.isEmpty(networkId) ? null : networkId;
                insert t;
                topicId = t.Id;
            }
            
            TopicAssignment ta = new TopicAssignment();
            ta.NetworkId = System.String.isEmpty(networkId) ? null : networkId;
            ta.TopicId = topicId;
            ta.EntityId = recordId;
            insert ta;
            system.debug(ta);
            return getRecordTopicInfo(recordId, networkId);
            
            
        } catch(Exception e) {
            mapOfObjects.put('errorMsg', e.getMessage());
            return JSON.serialize( mapOfObjects );
        }
        
        
        
    }
    
    @AuraEnabled
    public static String deleteTopicAssignment(String recordId, String networkId, String topicAssignmentId){
        
        Map<String,Object> mapOfObjects = new Map<String,Object>();
        
        try {
            
            Schema.DescribeSObjectResult dsr2 = TopicAssignment.sObjectType.getDescribe();
            
            if(!dsr2.isDeletable())
            {
                mapOfObjects.put('errorMsg', 'User must have Delete access to TopicAssignments.');
                return JSON.serialize( mapOfObjects );
            }
            
            TopicAssignment ta = new TopicAssignment();
            ta.Id = topicAssignmentId;
            delete ta;
            
            return getRecordTopicInfo(recordId, networkId);
            
            
        } catch(Exception e) {
            mapOfObjects.put('errorMsg', e.getMessage());
            return JSON.serialize( mapOfObjects );
        }
        
        
        
    }
    
    private static List<TopicAssignment> getRecordTopicAssignment(String recordId, String networkId){
        
        List<TopicAssignment> topicAssignmentList = [SELECT Id,EntityId,EntityKeyPrefix,EntityType,NetworkId,TopicId,Topic.Name 
                                                     FROM TopicAssignment WHERE EntityId = :recordId AND NetworkId = :networkId];
        
        
        Map<Id,String> managedTopicsMap = getManagedTopics(networkId);
        
        for(TopicAssignment ta : topicAssignmentList)
        {
            if(managedTopicsMap.keySet().contains(ta.TopicId))
            {
                ta.Topic.Description = managedTopicsMap.get(ta.TopicId);
            }
        }
            
        return topicAssignmentList;
    }
    
    private static Map<Id,String> getManagedTopics(String networkId)
    {
        Map<Id,String> managedTopicsMap = new Map<Id,String>();
        if(!System.String.isEmpty(networkId))
        {
            
            ConnectApi.ManagedTopicCollection topicCollection = ConnectAPI.ManagedTopics.getManagedTopics(networkId);
            for(ConnectApi.ManagedTopic mtopic : topicCollection.managedTopics)
            {
                managedTopicsMap.put(mtopic.topic.Id, mtopic.managedTopicType + '' );
            }
        }
        return managedTopicsMap;
    }
    
}