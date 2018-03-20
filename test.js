const express = require('express');
const httpShutdown = require('http-shutdown');

module.exports = class ScreenSizeTestPage {
    start() {
        this.started = true;
        return new Promise((resolve) => {
            const app = express();
            app.get('/.screen-size-test', (req, res) => {
                res.send('<html><body></body></html>');
            });
            const server = app.listen(3000, resolve);
            this.server = httpShutdown(server);
        });
    }

    stop() {
        return new Promise((resolve) => {
            this.server.shutdown(resolve);
        });
    }
}