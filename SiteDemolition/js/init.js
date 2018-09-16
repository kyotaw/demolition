(function(callback) {
    var script = document.createElement("script");
    script.setAttribute('src', '//code.jquery.com/jquery-2.0.0.min.js');
    script.addEventListener('load', function() {
        script = document.createElement('script');
        script.textContent = '(' + callback.toString() + ')(jQuery.noConflict(true));';
        document.body.appendChild(script);
    }, false);
    document.body.appendChild(script);
})(($) => {
    window.$ = $;
    if (!$) {
        webkit.messageHandlers.initHandler.postMessage('no $');
    } else {
        var style = '';
        style += '<style type="text/css" id="StyleId">';
        style += '.webbreaker-border { border: thin solid #ff0000; }';
        style += '</style>';
        $('head').append(style);
        webkit.messageHandlers.initHandler.postMessage('{error: false}');
    }
});
