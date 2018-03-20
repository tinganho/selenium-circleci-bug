
const webdriver = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');
const ScreenSizeTestPage = require('./test');
const testPage = new ScreenSizeTestPage();

async function visitPage(page) {
    const builder = new webdriver.Builder();
    builder.forBrowser('chrome');
    const chromeOptions = new chrome.Options()
        .detachDriver(false);
    chromeOptions.addArguments('--window-size=1024,860');
    builder.setChromeOptions(chromeOptions);
    builder.usingServer(process.env.CI ? 'http://localhost:24444/wd/hub' : 'http://selenium:24444/wd/hub');

    if (!testPage.started) {
        await testPage.start();
    }
    const wd = builder.build();
    await wd.get(page);
    await wd.executeScript(() => {
        const div = document.createElement('div');
        div.id = 'test';
        div.setAttribute('dimensions', 'window: ' + window.innerWidth + 'x' + window.innerHeight);
        document.body.appendChild(div);
    });
    await wd.sleep(1000);
    const dimensions = await wd.findElement(webdriver.By.id('test')).getAttribute('dimensions');
    console.log('WINDOW SIZE: ', dimensions);
    if (dimensions !== 'window: 1040x855') {
        await wd.quit();
        return await visitPage(page);
    }
    if (testPage.started) {
        await testPage.stop();
        await wd.quit();
    }
}
visitPage(process.env.CI ? 'http://localhost:3000/.screen-size-test' : 'http://tingan.dev.env:3000/.screen-size-test');