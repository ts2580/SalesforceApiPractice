({
	setOption : function(component, event, helper){

        var action = component.get("c.GetOption");

        action.setParams({
            "DaekyoProduct" : component.get("v.recordId")
        })

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS" && component.isValid()){

                component.set("v.OptionNumber", 1);
                component.set("v.OptionDetailNumber_1", 1);

            }
        });

        $A.enqueueAction(action);
    },

    addOptionDiv : function(component, event, helper){

        var OptionNumber = component.get("v.OptionNumber");

        OptionNumber++;

        var OptionDiv = document.createElement('div');
        OptionDiv.classList.add('slds-form-element');
        OptionDiv.classList.add('slds-m-around_xxx-small');
        document.querySelector('.slds-form-element__row').appendChild(OptionDiv);

        var OptionLabel = document.createElement('label');
        OptionLabel.classList.add('slds-form-element__label');
        OptionLabel.innerHTML = '옵션 ' + OptionNumber;
        OptionLabel.style.fontWeight = 'Bold';
        OptionDiv.appendChild(OptionLabel);

        var MainOptionDiv = document.createElement('div');
        MainOptionDiv.classList.add('slds-form-element__control');
        OptionDiv.appendChild(MainOptionDiv);

        var OptionInput = document.createElement('input');
        OptionInput.classList.add('slds-input');
        OptionInput.setAttribute('placeholder', '옵션 ' + OptionNumber + '을 입력해주세요');
        MainOptionDiv.appendChild(OptionInput);

        var OptionDetailLabel = document.createElement('label');
        OptionDetailLabel.classList.add('slds-form-element__label');
        OptionDetailLabel.innerHTML = '상세옵션 ' + 1
        OptionDiv.appendChild(OptionDetailLabel);

        var OptionDetailDiv = document.createElement('div');
        OptionDetailDiv.classList.add('slds-form-element__control');
        OptionDiv.appendChild(OptionDetailDiv);

        var addOptionDetailDiv = document.createElement('div');
        addOptionDetailDiv.classList.add('addOptionDetail_' + OptionNumber);
        addOptionDetailDiv.style.display = 'flex';
        OptionDiv.appendChild(addOptionDetailDiv);

        var OptionDetailInput = document.createElement('input');
        OptionDetailInput.classList.add('slds-input');
        OptionDetailInput.setAttribute('placeholder', '상세옵션 ' + 1 + '을 입력해주세요');
        OptionDetailInput.addEventListener("onchange", function(event){
            helper.setOptionTextToJSON(component, event, helper);
        });
        addOptionDetailDiv.appendChild(OptionDetailInput);

        var OptionDetailIcon = document.createElement('img');
        OptionDetailIcon.src = '/resource/1667788453000/addIcon';
        OptionDetailIcon.style.cursor = 'pointer';
        OptionDetailIcon.style.height = '30px';
        OptionDetailIcon.style.marginLeft = '3px';
        OptionDetailIcon.classList.add('addOptionDetailButton_' + OptionNumber + '-1');
        OptionDetailIcon.addEventListener("click", function(event){
            helper.addOptionDetailDiv(component, event, helper);
        });
        addOptionDetailDiv.appendChild(OptionDetailIcon);


        component.set("v.OptionNumber", OptionNumber);

    },

    addOptionDetailDiv : function(component, event, helper){

        var clickedNode = event.currentTarget.getAttribute('class');

        var OptionDetailParentDiv = document.querySelector('.' + clickedNode).parentNode.parentNode;

        var OptionDetailOriginalText = clickedNode.split('-');
        var OptionDetailClass = OptionDetailOriginalText[0];
        var OptionDetailNumber = parseInt(OptionDetailOriginalText[1]) +1;

        event.target.remove();

        var addedOptionDetailLabel = document.createElement('label');
        addedOptionDetailLabel.classList.add('slds-form-element__label');
        addedOptionDetailLabel.innerHTML = '상세옵션 ' + OptionDetailNumber
        OptionDetailParentDiv.appendChild(addedOptionDetailLabel);

        var addOptionDetail = document.createElement('div');
        addOptionDetail.classList.add('addOptionDetail_' + OptionDetailNumber);
        addOptionDetail.style.display = 'flex';
        OptionDetailParentDiv.appendChild(addOptionDetail);

        var addedOptionDetailInput = document.createElement('input');
        addedOptionDetailInput.classList.add('slds-input');
        addedOptionDetailInput.setAttribute('placeholder', '상세옵션 ' + OptionDetailNumber + '을 입력해주세요');
        addedOptionDetailInput.addEventListener("onchange", function(event){
            helper.setOptionTextToJSON(component, event, helper);
        });
        addOptionDetail.appendChild(addedOptionDetailInput);

        var addedOptionDetailIcon = document.createElement('img');
        addedOptionDetailIcon.src = '/resource/1667788453000/addIcon';
        addedOptionDetailIcon.style.cursor = 'pointer';
        addedOptionDetailIcon.style.height = '30px';
        addedOptionDetailIcon.style.marginLeft = '3px';
        addedOptionDetailIcon.classList.add(OptionDetailClass + '-' + OptionDetailNumber);
        addedOptionDetailIcon.addEventListener("click", function(event){
            helper.addOptionDetailDiv(component, event, helper);
        });

        addOptionDetail.appendChild(addedOptionDetailIcon);

    },

    setOptionTextToJSON : function(component, event, helper){

        let option = event.currentTarget.getAttribute('placeholder').split('을')[0];
        let inputText = event.currentTarget.value;

        console.dir(option);
        console.dir(inputText);



    }

})