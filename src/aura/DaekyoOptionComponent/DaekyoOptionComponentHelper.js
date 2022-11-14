/**
 * Created by 한성진 on 2022-11-11.
 */

({
    getOption : function(component, event, helper){

        var action = component.get("c.GetOption");

        action.setParams({
            "recordId" : component.get("v.recordId")
        })

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS" && component.isValid()){

                var ReturnedOption =  response.getReturnValue();

                component.set("v.option", ReturnedOption);


                let aaa = component.get("v.option");
                console.dir(aaa);

            }
        });

        $A.enqueueAction(action);
    },
});