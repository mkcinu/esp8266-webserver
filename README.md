# esp8266-webserver
Esp8266 NodeMCU Webserver. Supports:
- static pages
- execution of any lua file saved on the chip

## Usage
- Configure routing in webserver.lua, for example:
  - If you add route `ROUTING['home'] = {PAGE, 'index.html'}`, when you open http://yourip/home, it will load content of `index.html`.
  - If you add route `ROUTING['dynamic_content'] = {FUNCTION, 'script.lua'}`, when you open http://yourip/dynamic_content?param=123, it will execute content of script.lua with one parameter `param` with value `123` and return the result to the browser (see testmodule.lua for a script template)
- Upload webserver.lua (for example with luatool - https://github.com/4refr0nt/luatool)
- Upload static pages (html, css, js) and scripts.
- If you want webserver to start automatically, name it init.lua

