import { compileUiExtensions, setBranding } from '@vendure/ui-devkit/compiler';
import path from 'path';

compileUiExtensions({
    outputPath: path.join(__dirname, '../admin-ui'),
    extensions: [
        setBranding({
            smallLogoPath: path.join(__dirname, 'images/my-logo-sm.png'),
            largeLogoPath: path.join(__dirname, 'images/my-logo-lg.png'),
            faviconPath: path.join(__dirname, 'images/my-favicon.ico'),
        }),
    ],
})
    .compile?.()
    .then(() => {
        process.exit(0);
    })
    .catch(err => {
        console.error(err);
        process.exit(1);
    }); 