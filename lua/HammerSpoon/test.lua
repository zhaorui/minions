

function isTestOnly()
    -- test only, skip other configuration
    return false
end

function test()
    -- add test code here
    -- hs.notify.show('Title', 'subTitle', 'Hello, there~')
    return isTestOnly()
end