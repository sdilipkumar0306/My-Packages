var getParams = require('../util/get_params');
var mySQL = require('../util/db_mysql_service');

var method = {
    IS_USER_PRESENT: async function (event, credentials) {

        var reqParams = ["user_name", "password"];
        var reqparamsResponse = await getParams.GET_PARAMS(event, reqParams);
        var returnResponse ;
        if(reqparamsResponse && reqparamsResponse.code && reqparamsResponse.code === 200){
            var query = "SELECT * FROM user WHERE username = ? and password = ?";
            var values = [reqparamsResponse.msg[0], reqparamsResponse.msg[1]];
            var mySQLresponse = await mySQL.executeQuery(query, values, credentials);
            if (mySQLresponse && mySQLresponse.code && mySQLresponse.code === 200) {

                if (mySQLresponse.msg.length === 0) {
                    returnResponse = ({code: 201, msg: 'user Not present'});
                    
                } else {
                    returnResponse = mySQLresponse;
                    
                }
                
            } else {
                returnResponse =  mySQLresponse;
            }
        }else{
            returnResponse = reqparamsResponse;
        }
        return new Promise(resolve =>{
            resolve(returnResponse);
        });

    },
    CREATE_USER: async function (event, credentials) {
        var reqParams = ["user_name","email", "password"];
        var reqparamsResponse = await getParams.GET_PARAMS(event, reqParams);
        var returnResponse ;
        if(reqparamsResponse && reqparamsResponse.code && reqparamsResponse.code === 200){
            var query = "INSERT INTO user (username, email, password) VALUES(?, ?, ?)";
            var values = [reqparamsResponse.msg[0], reqparamsResponse.msg[1],  reqparamsResponse.msg[2]];
            var mySQLresponse = await mySQL.executeQuery(query, values, credentials);
            if (mySQLresponse && mySQLresponse.code && mySQLresponse.code === 200) {

                if (mySQLresponse.msg.length === 0) {
                    returnResponse = ({code: 201, msg: 'user not Created'});
                    
                } else {
                    returnResponse = ({code:200, msg:{ "insertID":mySQLresponse.msg["insertId"]

                    }});
                    
                }
                
            } else {
                returnResponse =  mySQLresponse;
            }
        }else{
            returnResponse = reqparamsResponse;
        }
        return new Promise(resolve =>{
            resolve(returnResponse);
        });
    },
}
module.exports = method;