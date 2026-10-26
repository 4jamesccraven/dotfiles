local hostname = require 'config.local.hostname'

if hostname == "celebrant" then
    hl.monitor {
        output = 'eDP-1',
        mode = '1920x1200',
        position = '0x0',
        scale = '1.2',
    }

    -- Dad's monitors (for connecting to his docking station).
    hl.monitor {
        output = 'desc:LG Electronics LG ULTRAGEAR 407NTXR69146',
        mode = 'preferred',
        position = '-2560x0',
        scale = 1,
    }

    hl.monitor {
        output = 'desc:Lenovo Group Limited LEN LI2323swA 31611F19G3389',
        mode = 'preferred',
        position = '-4480x0',
        scale = 1,
    }
end
