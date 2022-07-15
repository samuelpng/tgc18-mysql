const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on'); 
const mysql2 = require('mysql2/promise')
//to use awit async, we must use promise version of mysql2


const app = express();
app.set('view engine', 'hbs');
wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts')

async function main() {
    const connection = await mysql2.createConnection({
        'host' : 'localhost', //->since my own, computer, us elocalhost
        'user' : 'ahkow',
        'database' : 'sakila',
        'password' : 'rotiprata123'
    })

    await connection.execute("SELECT * FROM actor");
}

main()

//create user 'ahkow'@'localhost' identified by 'rotiprata123'
//GRANT ALL PRIVILEGES ON sakila.* TO 'ahkow'@'localhost';


//using forms
app.use(express.urlencoded({
    'extended': false
}))

app.listen(3001, function(){
    console.log('server has started')
})