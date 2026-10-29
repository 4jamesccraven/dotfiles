---[ Curves ]---
hl.curve('swift', {
    type = 'bezier',
    points = {
        { 0.55, 0 },
        { 0.1,  1 }
    },
})

---[ Workspaces ]---
hl.animation {
    enabled = true,
    leaf = 'workspaces',
    speed = 2,
    bezier = 'swift',
    style = 'slidevert'
}

---[ Layers ]---
hl.animation {
    enabled = true,
    leaf = 'layers',
    speed = 1.5,
    bezier = 'swift',
    style = 'fade',
}

-- Disable fade effect
hl.animation {
    enabled = false,
    leaf = 'fadeLayers',
}
