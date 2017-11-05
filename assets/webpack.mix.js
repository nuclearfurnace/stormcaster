let mix = require('laravel-mix');

mix.setPublicPath('../priv/static')
    .js('js/app.js', 'js/app.js')
    .sass('css/app.scss', 'css/app.css')
    .copyDirectory('./static', '../priv/static');

mix.options({
  clearConsole: false,
  processCssUrls: false
});
