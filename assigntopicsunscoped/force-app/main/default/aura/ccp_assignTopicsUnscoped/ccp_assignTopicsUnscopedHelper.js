/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

({
	fetchRecordTopicInfo : function(component,event,helper) {
		var action = component.get("c.getRecordTopicInfo");
        
        action.setParams({
            recordId : component.get("v.recordId"),
            networkId: component.get("v.networkId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS")
            {
                
                var response = JSON.parse(response.getReturnValue());
                
                if(!$A.util.isEmpty(response.errorMsg))
                {
                    this.showToast(component,'error','ERROR',response.errorMsg, 'dismiss');
                }
                else if(!$A.util.isEmpty(response))
                {
                    component.set("v.recordTopicInfo",response);
                }
                
                
                
                
            }
            else
            {
                this.showToast(component,'error','ERROR','Error completing action! Please check debug logs.');
            }
            
            component.set("v.readyToDisplay",true);
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action);
	},
    
    executeUnscopedTopicSearch : function(component,event,helper,searchTerm) {
		var action = component.get("c.doUnscopedTopicSearch");
        
        action.setParams({
            recordId : component.get("v.recordId"),
            searchTerm : searchTerm,
            networkId: component.get("v.networkId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS")
            {
                
                var response = JSON.parse(response.getReturnValue());
                
                if(!$A.util.isEmpty(response.errorMsg))
                {
                    this.showToast(component,'error','ERROR',response.errorMsg, 'dismiss');
                }
                else if(!$A.util.isEmpty(response))
                {
                    component.set("v.recordTopicSearchInfo",response);
                }
                
                
                
                
            }
            else
            {
                this.showToast(component,'error','ERROR','Error completing action! Please check debug logs.');
            }
            
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action);
	},
    
    addTopicAssignment : function(component,event,helper,topicId,searchTerm) {
		var action = component.get("c.createTopicAssignment");
        
        action.setParams({
            recordId : component.get("v.recordId"),
            networkId: component.get("v.networkId"),
            topicId: topicId,
            searchTerm: searchTerm
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS")
            {
                
                var response = JSON.parse(response.getReturnValue());
                
                if(!$A.util.isEmpty(response.errorMsg))
                {
                    this.showToast(component,'error','ERROR',response.errorMsg, 'dismiss');
                }
                else if(!$A.util.isEmpty(response))
                {
                    component.set("v.recordTopicInfo",response);
                }
                
                
                
                
            }
            else
            {
                this.showToast(component,'error','ERROR','Error completing action! Please check debug logs.');
            }
            
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action);
	},
    
    doDeleteTopicAssignment : function(component,event,helper,topicAssignmentIdToDelete) {
		var action = component.get("c.deleteTopicAssignment");
        
        action.setParams({
            recordId : component.get("v.recordId"),
            networkId: component.get("v.networkId"),
            topicAssignmentId: topicAssignmentIdToDelete
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS")
            {
                
                var response = JSON.parse(response.getReturnValue());
                
                if(!$A.util.isEmpty(response.errorMsg))
                {
                    this.showToast(component,'error','ERROR',response.errorMsg, 'dismiss');
                }
                else if(!$A.util.isEmpty(response))
                {
                    component.set("v.recordTopicInfo",response);
                }
                
                
                
                
            }
            else
            {
                this.showToast(component,'error','ERROR','Error completing action! Please check debug logs.');
            }
            
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action);
	},
    
    validateSearchTerm : function(component,event,helper) {
        var searchTerm = component.get("v.searchTerm");
        
        if(!$A.util.isEmpty(searchTerm))
        {
            searchTerm = searchTerm.trim();
        }
        
        if ($A.util.isEmpty(searchTerm)) 
        {
            component.set("v.recordTopicSearchInfo",null);
        }
        else if(searchTerm.length > 1)
        {
            component.set("v.showSpinner",true);
            helper.executeUnscopedTopicSearch(component, helper, event,searchTerm);
        }
        
    },
    
    showToast : function(component,type,title,message, mode){
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type,
            "mode" : mode,
            "duration" : 8000
            
        });
        toastEvent.fire();        
    }
})