({
	init : function(component, event, helper) {
		helper.fetchRecordTopicInfo(component,event,helper);
	},
    handleScopeChange : function (component,event,helper){
        component.set("v.showSpinner",true);
        helper.fetchRecordTopicInfo(component,event,helper);
    },
    handleRemoveTopic : function(component,event,helper){
        var topicAssignmentIdToDelete = event.getSource().get("v.name");
        if(!$A.util.isEmpty(topicAssignmentIdToDelete))
        {
            var taWrapper = document.getElementById(topicAssignmentIdToDelete);
            $A.util.addClass(taWrapper,"slds-hide");
            component.set("v.showSpinner",true);
            helper.doDeleteTopicAssignment(component, helper, event,topicAssignmentIdToDelete);
        }
    },
    handleKeyUp: function (component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            var queryTerm = component.find('enter-search').get('v.value');
            component.set("v.searchTerm", queryTerm);
            helper.validateSearchTerm(component, event, helper);
        }
    },
    handleSearchTermChange: function (component, event, helper) {
        helper.validateSearchTerm(component, event, helper);
    },
    handleAddTopic:function(component, event, helper){
        var targetElInitial = event.target;
        if(!$A.util.isEmpty(targetElInitial) && !$A.util.isEmpty(targetElInitial.id))
        {
            var topicId = targetElInitial.id;
            $A.util.addClass(targetElInitial,"slds-hide");
            var searchTerm = component.get("v.searchTerm");
            component.set("v.searchTerm",null);
            component.set("v.showSpinner",true);
            helper.addTopicAssignment(component, helper, event,topicId,searchTerm);
        }
    },
    handleSearchOnBlur:function(component, event, helper){
        component.set("v.recordTopicSearchInfo",null);
    }
})