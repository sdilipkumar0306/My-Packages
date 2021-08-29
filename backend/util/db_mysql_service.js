const { json } = require('express');
var mysql = require('mysql');

let statusCode = 400;
let responseBody = { code: 202, msg: 'SDK initial Testing in db_mysql_service' };
let query = {
    sql : '',
    timeout : 3000,
    values: []
};

var method = {
    executeQuery: async function (sql, values, credentials) {
        return new Promise(
            resolve => {
                console.log('Query stating point');
                var connectionparams = {
                    host: credentials.DB_HOST,
                    user: credentials.DB_USER_NAME,
                    password: credentials.DB_PASSWORD,
                    database: credentials.DB_NAME
                };
                var connection = mysql.createConnection(connectionparams);

                query.sql = sql;
                query.values = values;

                connection.query(query, function (error, result) {
                    connection.destroy();
                    if (error) {
                        console.log('invalid Query' + '---' + JSON.stringify(query) + '----' + responseBody.code + '-----' + 'mysql error  ----' + JSON.stringify(error));
                        console.log('Query completed');
                        resolve({
                            code: 201, msg: 'error ****************', err: error
                        });
                    } else {
                        console.log('Query completed');
                        resolve({ code: 200, msg: result });
                    }
                });
            }
        )
    }
};
module.exports = method;