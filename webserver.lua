local PAGE = 1;
local FUNCTION = 2;

local ROUTING = {};
ROUTING[''] = {PAGE, 'index.html'}; --default
ROUTING['testpage'] = {PAGE, 'test.html'};
ROUTING['testfunc'] = {FUNCTION, 'testmodule.lua'};

server = net.createServer(net.TCP)
server:listen(80, function(conn)
    conn:on("receive", function(client, request)
        -- with params. 
        -- (parsing borrowed from http://randomnerdtutorials.com/esp8266-web-server/ and changed)
        local _, _, method, path, get_params = string.find(request, "([A-Z]+) /(.+)?(.+) HTTP");
        if(method == nil) then --without params
            _, _, method, path = string.find(request, "([A-Z]+) /(.+) HTTP");
        end
        if path == nil then
            path = ''
        end

        local GET = {};
        if (get_params ~= nil) then
            for var, value in string.gmatch(get_params, '(%w+)=(%w+)&*') do
                GET[var] = value;
            end
        end
        
        local errorcode = nil;

        local routed = ROUTING[path];
        if routed ~= nil then
            local file_name = routed[2];
            if routed[1] == PAGE then
                if file.open(file_name) ~= nil then -- opened OK
                    local content = file.read();
                    while content ~= nil do
                        client:send(content);
                        content = file.read();
                    end
                    file.close();
                else
                    errorcode = '404';
                end
            else
                if file.open(file_name) then -- exists?
                    file.close(file_name);
                    local content = assert(loadfile(file_name))(GET);
                    client:send(content);
                else
                    errorcode = '404';
                end
            end
        else
            errorcode = '404';
        end

        if errorcode ~= nil then
            client:send(errorcode);
        end

        client:close();

        collectgarbage();
    end)
end)
