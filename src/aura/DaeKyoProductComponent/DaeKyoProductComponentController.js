({
	fnInit : function(component, event, helper) {
        helper.setOption(component, event, helper);
	},

	setOption : function(component, event, helper) {

    },

    addOption : function(component, event, helper) {
        helper.addOptionDiv(component, event, helper);
    },

    addOptionDetail : function(component, event, helper) {
        helper.addOptionDetailDiv(component, event, helper);
    },

    saveOption : function(component, event, helper) {
        helper.setOptionTextToJSON(component, event, helper);
    },


})