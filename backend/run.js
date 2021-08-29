exports.handler = async function (event) {

    try {
        var env = require('./env');
        var pathInfo = ((event.path) ? (event.path.split("/")) : []);
        var credentials = env;
        if (event.path && event.path.split('/').length === 3) {
            var handlerName = pathInfo[1];
            var taskName = pathInfo[2];

            console.log(handlerName + "------" + taskName);
            var localhandler = './endpoints/' + handlerName;

            const myHandler = require(localhandler);
            var handlerResponse = await myHandler[taskName](event, credentials);
            console.log(taskName + ' ------' + JSON.stringify(handlerResponse));
            var response = {
                statusCode: 200,
                body: JSON.stringify(handlerResponse)
            };
            return response;
        } else {
            console.log("Insufficient Path variables : " + pathInfo.length + " - " + JSON.stringify(pathInfo));
            throw new Error({ code: 221, msg: 'InSufficient Data' });
        }

    } catch (error) {
        console.log(error);
        const response = {
            statusCode: 200,
            body: error
        }
        return response;
    }

}