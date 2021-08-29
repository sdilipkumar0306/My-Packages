var methods = {
    GET_PARAMS: async function (event, reqParams) {
        return new Promise(
            resolve => {
                console.log('get params started');
                var responseData = [];
                if (!event.body) {
                    console.log('GET_PARAMS END - Event Body Not Found : ' + JSON.stringify(event.body));
                    resolve({ code: 205, msg: 'Insuffient Required Params Data'});
                } else {
                  var isDataPresent = true;
                  var data = JSON.parse( event.body);  
                  for (let i = 0; i < reqParams.length; i++) {
                     var item = reqParams[i];
                     if (data[item]) {
                         responseData.push(data[item]);
                     } else {
                         isDataPresent = false;
                     }
                     if (isDataPresent) {
                         console.log('get params completed');
                         resolve({code: 200, msg: responseData});
                     } else {
                        console.log('get params completed');
                        resolve({code: 205, msg: 'Insufficient Data Provided'});
                         
                     }
                      
                  }
                }
            }
          
        )
        
    }
}
module.exports = methods;