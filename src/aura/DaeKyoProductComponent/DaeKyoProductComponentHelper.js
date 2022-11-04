({
	getGetOption : function(component, event, helper){

    },

    setOption : function(component, event, helper){

            var action = component.get("c.GetOption");

            action.setParams({
                "recordId" : component.get("v.recordId")
            })

            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS" && component.isValid()){


                }
            });

            $A.enqueueAction(action);
        }
})