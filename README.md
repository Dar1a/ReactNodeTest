# ReactNodeTest
Test solution for React + Node + DB interaction

Deployment details:
1. DB.
* Create DB and put name into ReactNodeSql/NodeJs/node_impl.js file (config variable initialization);
* Update ReactNodeSql/NodeJs/node_impl.js file (config variable initialization) with actual user/password/server/host/domain/port/db;
* Run ReactNodeSql/Sql/DbScripting.sql.

2. NodeJs (assuming that Node is already installed). I used steps from here: https://www.tutorialspoint.com/nodejs/nodejs_environment_setup.htm
* Additional packages used in the script: express, mssql, url, body-parser, multer, cors.
* Run "node node_impl.js" in ReactNodeSql/NodeJs/ folder.

3. ReactJs (assuming that ReactJs is already installed). I used steps from here: https://www.tutorialspoint.com/reactjs/reactjs_environment_setup.htm
* Additional packages used in the scripts: axios.
* Run "npm start" in ReactNodeSql/ReactJs/ folder.

Assumptions:
1. NodeJs and ReactJs apps have to run on the same machine as ReactJs has hardcoded links to backend like "http://localhost:5000".
