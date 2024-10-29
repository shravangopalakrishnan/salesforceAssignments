({
    handleMessage: function (component, message) {
        console.log('Message received in Aura:', message);

        if (message) {
            const countryId = message.getParam("countryId");
            const planId = message.getParam("planId");

            if (countryId) {
                console.log('Country ID received:', countryId);
                component.set("v.countryId", countryId);
            }

            if (planId) {
                console.log('Plan ID received:', planId);
                component.set("v.planId", planId);
            }
        }
    }
})
