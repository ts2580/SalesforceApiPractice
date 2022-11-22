/**
 * Created by 한성진 on 2022-11-11.
 */

({
    getOption : function(component, event, helper){

        let action = component.get("c.GetOption");

        action.setParams({
            "recordId" : component.get("v.recordId")
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS" && component.isValid()){

                let MapOptionOptionDetail =  response.getReturnValue();

                let i = 1;
                for (let key in MapOptionOptionDetail) {

                    $A.createComponent(
                        "lightning:input",
                        {
                            "label": "옵션 " + i,
                            "value": key,
                            // "onclick": component.getReference("c.addOption")
                        },
                        function(option, status, errorMessage){
                            if (status === "SUCCESS") {
                                let body = component.get("v.body");
                                body.push(option);
                                component.set("v.body", body);
                                let j = 1;
                                for (let detailedOption of MapOptionOptionDetail[key]){
                                    $A.createComponent(
                                        "lightning:input",
                                        {
                                            "label": "상세옵션 " + j,
                                            "value": detailedOption["Name"],
                                            "aura:id": detailedOption["Id"],
                                        },
                                        function(option, status, errorMessage){
                                            if (status === "SUCCESS") {
                                                let body = component.get("v.body");
                                                body.push(option);
                                                component.set("v.body", body);
                                            }else if (status === "INCOMPLETE") {
                                                console.log("서버 응답 없음")
                                            }
                                            else if (status === "ERROR") {
                                                console.log("에러: " + errorMessage);
                                            }
                                        }
                                    );
                                    j++;
                                }
                            }
                            else if (status === "INCOMPLETE") {
                                console.log("서버 응답 없음")
                            }
                            else if (status === "ERROR") {
                                console.log("에러: " + errorMessage);
                            }
                        }
                    );
                    i++;
                }
            }
        });

        $A.enqueueAction(action);
    },
});