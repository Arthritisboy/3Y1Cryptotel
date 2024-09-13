const http = require('http');

const server = http.createServer((req, res) => {
    try {
        res.statusCode = 200;
        res.setHeader('Content-Type', 'text/plain');
        res.end('Hello World');
    } catch (error) {
        res.statusCode = 500;
        res.setHeader('Content-Type', 'text/plain');
        res.end('Internal Server Error');

        console.warn('Error:', error.message)
    }
});

const port = 3000;

server.listen(port, () => {
    console.log(`Server is listening on port ${port}...`)
})