
require "hot_key_setup"
require "test"

if test() then
    print('test is done')
    return
end

-- 加载第三方spoon
hs.loadSpoon("SpeedMenu")
hs.loadSpoon("WindowScreenLeftAndRight")

-- 设置快捷键
hot_key_setup.setup()
