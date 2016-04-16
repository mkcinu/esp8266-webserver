local args = ...; --varargs

print(args['testparam']);
return "Hi from testmodule" .. args['testparam2'];
