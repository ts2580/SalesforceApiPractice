({
	getBranchBook : function(component, event, helper){
        var action = component.get("c.getBranchBook");

        /*action.setParams({
            "recordId" : component.get("v.recordId")
        })*/
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS" && component.isValid()){

                var ReturnMap = response.getReturnValue();

                for (var key in ReturnMap) {

                    console.log(key, ReturnMap[key]);

                    var BranchAndInventory = document.querySelector(".BookByBranch");

                    var BranchNameTR = document.createElement('tr');
                    BranchAndInventory.appendChild(BranchNameTR);

                    var BranchNameTd = document.createElement('td');
                    BranchNameTd.classList.add('BookByBranch-td');
                    BranchNameTd.innerHTML  = key;
                    BranchNameTR.appendChild(BranchNameTd);

                    var BooksTd = document.createElement("td");
                    BooksTd.classList.add('BookByBranch-td');
                    BooksTd.innerHTML  = ReturnMap[key];
                    BranchNameTR.appendChild(BooksTd);
                }

            }
        });

        $A.enqueueAction(action);
    }
})