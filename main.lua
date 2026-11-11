-- VOIDLINE v4 — Built by Olivia — https://discord.gg/ojailbreaks
-- single file, loadstring-ready
-- services -> config -> theme -> ui kit -> modules -> init

local SCRIPT_VERSION = "4.0.0"
local SCRIPT_BUILD = "voidline-v4"

--==[ services ]==--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Cam = Workspace.CurrentCamera

--==[ executor capability probe ]==--
local EXE = {
    hookmetamethod = typeof(hookmetamethod) == "function",
    getnamecallmethod = typeof(getnamecallmethod) == "function",
    checkcaller = typeof(checkcaller) == "function",
    newcclosure = typeof(newcclosure) == "function",
    Drawing = typeof(Drawing) == "table" or typeof(Drawing) == "userdata",
    setclipboard = typeof(setclipboard) == "function",
    writefile = typeof(writefile) == "function",
    readfile = typeof(readfile) == "function",
    isfile = typeof(isfile) == "function",
    makefolder = typeof(makefolder) == "function",
    isfolder = typeof(isfolder) == "function",
    listfiles = typeof(listfiles) == "function",
    getconnections = typeof(getconnections) == "function",
    firetouchinterest = typeof(firetouchinterest) == "function",
    gethui = typeof(gethui) == "function",
    mousemoverel = typeof(mousemoverel) == "function",
    mouse1click = typeof(mouse1click) == "function",
    queue_on_teleport = typeof(queue_on_teleport) == "function",
    identifyexecutor = typeof(identifyexecutor) == "function",
}

local function newcc(fn) if EXE.newcclosure then return newcclosure(fn) else return fn end end

--==[ debug console (always on) ]==--
local DBG = { lines = {}, cap = 500, subs = {} }
local function stamp()
    local t = os.date("*t")
    return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
end
local function dbg(tag, msg)
    local line = "["..stamp().."] ["..tostring(tag).."] "..tostring(msg)
    table.insert(DBG.lines, line)
    if #DBG.lines > DBG.cap then table.remove(DBG.lines, 1) end
    for _, fn in ipairs(DBG.subs) do pcall(fn, line) end
end
local function dbgsub(fn) table.insert(DBG.subs, fn) end

dbg("boot", "voidline "..SCRIPT_VERSION.." mounting")
dbg("exe", "hookmetamethod="..tostring(EXE.hookmetamethod).." newcclosure="..tostring(EXE.newcclosure).." Drawing="..tostring(EXE.Drawing))
dbg("exe", "writefile="..tostring(EXE.writefile).." setclipboard="..tostring(EXE.setclipboard).." VIM="..tostring(VirtualInputManager ~= nil))

--==[ theme ]==--
local T = {
    bg       = Color3.fromRGB(10,10,12),
    panel    = Color3.fromRGB(19,19,22),
    panel2   = Color3.fromRGB(22,22,26),
    panel3   = Color3.fromRGB(23,23,29),
    ridge    = Color3.fromRGB(32,32,36),
    accent   = Color3.fromRGB(0,162,255),
    accent2  = Color3.fromRGB(0,122,204),
    good     = Color3.fromRGB(80,220,120),
    warn     = Color3.fromRGB(255,180,60),
    bad      = Color3.fromRGB(230,70,70),
    text     = Color3.fromRGB(245,245,245),
    text2    = Color3.fromRGB(190,190,195),
    dim      = Color3.fromRGB(72,72,73),
    stroke   = Color3.fromRGB(38,38,44),
    shadow   = "rbxassetid://5028857084",
    hsvAsset = "rbxassetid://4155801252",
    fontBold = Enum.Font.GothamBold,
    fontReg  = Enum.Font.Gotham,
    fontMono = Enum.Font.RobotoMono,
}

--==[ config / flags ]==--
local F = {
    menu_open = true, menu_key = Enum.KeyCode.RightShift,
    debug_show = true,
    esp_enabled = false, esp_enemy_only = true, esp_team_check = true,
    esp_box = true, esp_box_outline = true, esp_box_filled = false, esp_box_color = Color3.fromRGB(0,162,255),
    esp_name = true, esp_name_color = Color3.fromRGB(255,255,255),
    esp_health_bar = true, esp_health_text = true, esp_health_bar_color_lerp = true, esp_health_bar_color = Color3.fromRGB(80,220,120),
    esp_distance = true, esp_distance_color = Color3.fromRGB(200,200,200),
    esp_weapon = true, esp_weapon_color = Color3.fromRGB(190,190,195),
    esp_tracer = false, esp_tracer_from = "Bottom", esp_tracer_color = Color3.fromRGB(0,162,255), esp_tracer_thickness = 1,
    esp_chams = false, esp_chams_mode = "Highlight", esp_chams_vis = Color3.fromRGB(0,162,255), esp_chams_ovis = Color3.fromRGB(230,70,70), esp_chams_fill = 0.5, esp_chams_outline = 0,
    esp_font = 2, esp_text_size = 13, esp_outline = true, esp_max_distance = 2000, esp_min_distance = 0,
    aim_enabled = false, aim_mode = "Mouse", aim_hitpart = "Head",
    aim_key = Enum.UserInputType.MouseButton2, aim_hold = true,
    aim_fov = 90, aim_fov_show = true, aim_fov_color = Color3.fromRGB(0,162,255),
    aim_smooth = 4, aim_smooth_min = 1,
    aim_prediction = 0.165, aim_prediction_dynamic = true,
    aim_wall_check = true, aim_team_check = true, aim_visible_only = false,
    aim_target_lock = true, aim_lock_time = 0.08,
    aim_hitchance = 60, aim_hitchance_backtrack = true,
    aim_auto_shoot = false, aim_auto_shoot_delay = 0.05,
    aim_sticky = true, aim_sticky_fov = 20,
    aim_multipoint = true, aim_multipoint_scale = 0.75,
    aim_resolver = true, aim_resolver_samples = 6, aim_resolver_threshold = 32,
    silent_enabled = false, silent_fov = 50, silent_hitpart = "Head",
    silent_hitchance = 70, silent_hitchance_fallback = true,
    silent_resolver = true, silent_prediction = 0.165,
    silent_wall_check = true, silent_visible_only = false,
    silent_multipoint = true, silent_multipoint_scale = 0.7,
    silent_team_check = true, silent_min_damage = 1,
    rage_enabled = false,
    rage_approach_dist = 28, rage_confirm_dmg = 30, rage_retreat_dist = 55,
    rage_cooldown = 0.35, rage_reengage = 1.2,
    rage_hp_threshold = 55, rage_hp_mult = 1.6, rage_short_hop = 14,
    rage_auto_orbit = true, rage_auto_void = true, rage_auto_vs = true, rage_auto_silent = true,
    rage_state_hud = true,
    orbit_enabled = false, orbit_radius = 18, orbit_speed = 7.5, orbit_height = 2,
    orbit_direction = 1, orbit_jitter = 0.4,
    orbit_ring_show = true, orbit_ring_color = Color3.fromRGB(0,162,255),
    aa_enabled = false,
    aa_pitch = "Down", aa_pitch_angle = 89,
    aa_yaw = "Spin", aa_yaw_offset = 180, aa_yaw_jitter = 15, aa_spin_speed = 720, aa_sway_speed = 2.5, aa_sway_range = 160,
    aa_lby = "Opposite", aa_desync = true, aa_desync_amount = 58,
    aa_fake_lag = false, aa_fake_lag_ticks = 2,
    aa_edge = false, aa_preset = "Custom",
    void_enabled = false, void_depth = -500,
    void_zero_vel = true, void_cancollide_off = true, void_hipheight_pin = true,
    void_handoff = true, void_handoff_frames = 2,
    void_rebind_on_spawn = true,
    vs_enabled = false, vs_interval = 0.35, vs_distance = 24, vs_jitter = 0.5, vs_return_delay = 0.08,
    legit_enabled = false, legit_smooth = 10, legit_fov = 25, legit_bone = "Head",
    legit_predict = 0.15, legit_wall_check = true, legit_key = Enum.UserInputType.MouseButton2,
    trig_enabled = false, trig_key_only = false, trig_key = Enum.KeyCode.X, trig_delay = 0.02, trig_team_check = true, trig_wall_check = true,
    mv_bhop = false, mv_speed = false, mv_speed_val = 24, mv_jump = false, mv_jump_val = 68, mv_fly = false, mv_fly_speed = 60, mv_noclip = false,
    mv_inf_jump = false,
    vis_crosshair = false, vis_crosshair_color = Color3.fromRGB(0,162,255), vis_crosshair_size = 8, vis_crosshair_gap = 3, vis_crosshair_thickness = 1,
    vis_hitmark = true, vis_hitmark_color = Color3.fromRGB(255,255,255), vis_hitmark_size = 10, vis_hitmark_time = 0.4,
    vis_hit_sound = true,
    vis_fullbright = false, vis_fullbright_val = 2,
    vis_no_fog = false,
    skin_enabled = false,
    skin_map = {
        ["DoubleBarrel"] = "Ascension", ["Revolver"] = "Ascension",
        ["TacticalShotgun"] = "Ascension", ["SMG"] = "Ascension",
        ["Shotgun"] = "Ascension", ["Knife"] = "Beta",
    },
    ffa_immortal = false, ffa_autorespawn = true, ffa_auto_pickup_ammo = true, ffa_auto_pickup_hp = true,
    _hits = 0, _shots = 0, _dmg = 0,
}

local WEAPON_TUNE = {
    ["[Knife]"]           = { pred = 0.05, hitpart = "Torso", mindmg = 1,  max_range = 14 },
    ["[Revolver]"]        = { pred = 0.14, hitpart = "Head",  mindmg = 35, max_range = 220 },
    ["[DoubleBarrel]"]    = { pred = 0.09, hitpart = "Torso", mindmg = 45, max_range = 60 },
    ["[Shotgun]"]         = { pred = 0.10, hitpart = "Torso", mindmg = 30, max_range = 80 },
    ["[TacticalShotgun]"] = { pred = 0.10, hitpart = "Torso", mindmg = 30, max_range = 90 },
    ["[SMG]"]             = { pred = 0.16, hitpart = "Head",  mindmg = 10, max_range = 200 },
    ["[Default]"]         = { pred = 0.165, hitpart = "Head", mindmg = 1,  max_range = 500 },
}

local AA_PRESETS = {
    Custom     = {},
    Legit      = { aa_pitch="Down", aa_pitch_angle=45, aa_yaw="Static", aa_yaw_offset=90, aa_desync=true, aa_desync_amount=20 },
    Rage       = { aa_pitch="Down", aa_pitch_angle=89, aa_yaw="Jitter", aa_yaw_jitter=58, aa_desync=true, aa_desync_amount=58 },
    Spin       = { aa_pitch="Down", aa_pitch_angle=89, aa_yaw="Spin",   aa_spin_speed=720, aa_desync=true, aa_desync_amount=45 },
    Sway       = { aa_pitch="Down", aa_pitch_angle=70, aa_yaw="Sway",   aa_sway_speed=2.5, aa_sway_range=140, aa_desync=true },
    JitterLBY  = { aa_pitch="Down", aa_pitch_angle=89, aa_yaw="Jitter", aa_yaw_jitter=89, aa_lby="Flicker", aa_desync=true, aa_desync_amount=60 },
    Edge       = { aa_pitch="Down", aa_pitch_angle=89, aa_yaw="Static", aa_yaw_offset=180, aa_edge=true, aa_desync=true, aa_desync_amount=58 },
}

--==[ gui root ]==--
local function mountGui()
    local g = Instance.new("ScreenGui")
    g.Name = "voidline_"..tostring(math.random(1e6, 9e6))
    g.ResetOnSpawn = false
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.IgnoreGuiInset = true
    g.DisplayOrder = 10
    if EXE.gethui then
        local ok, h = pcall(gethui)
        if ok and h then g.Parent = h; return g end
    end
    if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
        pcall(function() syn.protect_gui(g) end)
    end
    local ok = pcall(function() g.Parent = CoreGui end)
    if not ok then g.Parent = LP:WaitForChild("PlayerGui") end
    return g
end
local Gui = mountGui()

local function new(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end
local function corner(p, r) new("UICorner",{CornerRadius=UDim.new(0,r or 6),Parent=p}) end
local function stroke(p, c, t, tr)
    local s = new("UIStroke",{Color=c or T.stroke,Thickness=t or 1,Parent=p,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
    if tr then s.Transparency = tr end
    return s
end
local function pad(p, a, b, c, d) new("UIPadding",{PaddingTop=UDim.new(0,a or 0),PaddingBottom=UDim.new(0,b or a or 0),PaddingLeft=UDim.new(0,c or a or 0),PaddingRight=UDim.new(0,d or c or a or 0),Parent=p}) end
local function list(p, pdn, dir, align)
    return new("UIListLayout",{Padding=UDim.new(0,pdn or 6),FillDirection=dir or Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=align or Enum.HorizontalAlignment.Left,Parent=p})
end

local function panel(parent, size, pos, radius)
    local outer = new("Frame",{BackgroundColor3=T.stroke,BorderSizePixel=0,Size=size,Position=pos,Parent=parent})
    corner(outer, radius or 10)
    local inner = new("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Size=UDim2.new(1,-2,1,-2),Position=UDim2.new(0,1,0,1),Parent=outer})
    corner(inner, (radius or 10) - 1)
    stroke(inner, T.ridge, 1)
    return outer, inner
end

local function addShadow(parent, trans)
    return new("ImageLabel",{BackgroundTransparency=1,Image=T.shadow,ImageColor3=Color3.new(0,0,0),ImageTransparency=trans or 0.5,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(24,24,276,276),Size=UDim2.new(1,56,1,56),Position=UDim2.new(0,-28,0,-28),ZIndex=-1,Parent=parent})
end

--==[ main window ]==--
local Root = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(0,780,0,505),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Parent=Gui})
addShadow(Root, 0.4)
local WinOuter, WinInner = panel(Root, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), 10)
WinInner.ClipsDescendants = true

Root.Size = UDim2.new(0, 780*0.94, 0, 505*0.94)
TweenService:Create(Root, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=UDim2.new(0,780,0,505)}):Play()

local TitleBar = new("Frame",{BackgroundColor3=T.panel2,BorderSizePixel=0,Size=UDim2.new(1,0,0,42),Parent=WinInner})
corner(TitleBar, 9)
new("Frame",{BackgroundColor3=T.panel2,BorderSizePixel=0,Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,1,-10),Parent=TitleBar})
stroke(TitleBar, T.ridge, 1)

new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,16,0,0),Size=UDim2.new(0,80,1,0),Text="VOID",Font=T.fontBold,TextSize=30,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Parent=TitleBar})
new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,78,0,0),Size=UDim2.new(0,80,1,0),Text="LINE",Font=T.fontBold,TextSize=30,TextColor3=T.accent,TextXAlignment=Enum.TextXAlignment.Left,Parent=TitleBar})
new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,154,0,8),Size=UDim2.new(0,90,0,20),Text="v"..SCRIPT_VERSION,Font=T.fontMono,TextSize=12,TextColor3=T.dim,TextXAlignment=Enum.TextXAlignment.Left,Parent=TitleBar})

local HudState = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-440,0,0),Size=UDim2.new(0,180,1,0),Text="IDLE",Font=T.fontMono,TextSize=12,TextColor3=T.dim,TextXAlignment=Enum.TextXAlignment.Right,Parent=TitleBar})
local HudHits = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-260,0,0),Size=UDim2.new(0,80,1,0),Text="H 0",Font=T.fontMono,TextSize=12,TextColor3=T.good,TextXAlignment=Enum.TextXAlignment.Right,Parent=TitleBar})
local HudFps  = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-180,0,0),Size=UDim2.new(0,70,1,0),Text="FPS 0",Font=T.fontMono,TextSize=12,TextColor3=T.text2,TextXAlignment=Enum.TextXAlignment.Right,Parent=TitleBar})
local HudPing = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-110,0,0),Size=UDim2.new(0,60,1,0),Text="P 0",Font=T.fontMono,TextSize=12,TextColor3=T.text2,TextXAlignment=Enum.TextXAlignment.Right,Parent=TitleBar})
local HudBadge = new("TextLabel",{BackgroundColor3=T.panel3,BorderSizePixel=0,Position=UDim2.new(1,-54,0.5,-10),Size=UDim2.new(0,44,0,20),Text="off",Font=T.fontMono,TextSize=11,TextColor3=T.dim,Parent=TitleBar})
corner(HudBadge, 4); stroke(HudBadge, T.ridge, 1)

local Side = new("Frame",{BackgroundColor3=T.panel2,BorderSizePixel=0,Position=UDim2.new(0,0,0,42),Size=UDim2.new(0,196,1,-42),Parent=WinInner})
stroke(Side, T.ridge, 1); pad(Side, 10, 10, 8, 8)
list(Side, 2)
local Content = new("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Position=UDim2.new(0,196,0,42),Size=UDim2.new(1,-196,1,-42),Parent=WinInner})

local Tabs, ActiveTab = {}, nil
local function activateTab(name)
    if ActiveTab and Tabs[ActiveTab] then
        local p = Tabs[ActiveTab]
        p.body.Visible = false
        p.nameLbl.TextColor3 = T.text2
        p.iconLbl.TextColor3 = T.dim
        p.pill.BackgroundTransparency = 1
    end
    ActiveTab = name
    local t = Tabs[name]
    if not t then return end
    t.body.Visible = true
    t.nameLbl.TextColor3 = T.text
    t.iconLbl.TextColor3 = T.accent
    t.pill.BackgroundTransparency = 0
end
local function mkTab(name, icon)
    local btn = new("TextButton",{BackgroundColor3=T.panel2,BorderSizePixel=0,Size=UDim2.new(1,0,0,30),Text="",AutoButtonColor=false,Parent=Side})
    corner(btn, 5)
    local iconLbl = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,10,0,0),Size=UDim2.new(0,20,1,0),Text=icon or "•",Font=T.fontBold,TextSize=14,TextColor3=T.dim,Parent=btn})
    local nameLbl = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,34,0,0),Size=UDim2.new(1,-40,1,0),Text=name,Font=T.fontReg,TextSize=13,TextColor3=T.text2,TextXAlignment=Enum.TextXAlignment.Left,Parent=btn})
    local pill = new("Frame",{BackgroundColor3=T.accent,BorderSizePixel=0,Position=UDim2.new(0,0,0.5,-8),Size=UDim2.new(0,3,0,16),BackgroundTransparency=1,Parent=btn})
    corner(pill, 2)
    local body = new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,1,0),CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=2,ScrollBarImageColor3=T.accent,Visible=false,AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=Content})
    pad(body, 12, 12, 12, 12)
    list(body, 10)
    btn.MouseEnter:Connect(function() if ActiveTab ~= name then nameLbl.TextColor3 = T.text end end)
    btn.MouseLeave:Connect(function() if ActiveTab ~= name then nameLbl.TextColor3 = T.text2 end end)
    btn.MouseButton1Click:Connect(function() activateTab(name) end)
    Tabs[name] = {btn=btn,body=body,nameLbl=nameLbl,iconLbl=iconLbl,pill=pill}
    return Tabs[name]
end

local function section(parent, title)
    local holder = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,Parent=parent})
    local head = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,24),Parent=holder})
    local titleLbl = new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,-32,1,0),Text=string.upper(title),Font=T.fontReg,TextSize=12,TextColor3=T.text2,TextXAlignment=Enum.TextXAlignment.Left,Parent=head})
    new("Frame",{BackgroundColor3=T.ridge,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),Parent=head})
    local pill = new("TextButton",{BackgroundColor3=T.panel2,BorderSizePixel=0,Position=UDim2.new(1,-24,0,2),Size=UDim2.new(0,20,0,20),Text="–",Font=T.fontBold,TextSize=12,TextColor3=T.text2,AutoButtonColor=false,Parent=head})
    corner(pill, 4); stroke(pill, T.ridge, 1)
    local body = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,30),AutomaticSize=Enum.AutomaticSize.Y,Parent=holder})
    pad(body, 2, 2, 2, 2); list(body, 4)
    local open = true
    pill.MouseButton1Click:Connect(function()
        open = not open
        body.Visible = open
        pill.Text = open and "–" or "+"
        titleLbl.TextTransparency = open and 0 or 0.2
    end)
    return body
end

local function stateColors(btn, base, hover, active)
    local pressed = false
    btn.MouseEnter:Connect(function() if not pressed then btn.BackgroundColor3 = hover or base end end)
    btn.MouseLeave:Connect(function() if not pressed then btn.BackgroundColor3 = base end end)
    btn.MouseButton1Down:Connect(function() pressed = true; btn.BackgroundColor3 = active or hover or base end)
    btn.MouseButton1Up:Connect(function() pressed = false; btn.BackgroundColor3 = base end)
end

local function urow(parent, label)
    local row = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),Parent=parent})
    new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(0.55,0,1,0),Text=label,Font=T.fontMono,TextSize=13,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
    return row
end

local function utoggle(parent, label, key, onChange)
    local row = urow(parent, label)
    local bg = new("Frame",{BackgroundColor3=T.panel3,BorderSizePixel=0,Position=UDim2.new(1,-30,0.5,-8),Size=UDim2.new(0,28,0,15),Parent=row})
    corner(bg, 8); stroke(bg, T.ridge, 1)
    local knob = new("Frame",{BackgroundColor3=T.dim,BorderSizePixel=0,Position=UDim2.new(0,2,0.5,-5),Size=UDim2.new(0,11,0,11),Parent=bg})
    corner(knob, 6)
    local btn = new("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text="",Parent=row})
    local function paint()
        local v = F[key]
        TweenService:Create(bg, TweenInfo.new(0.12), {BackgroundColor3 = v and T.accent or T.panel3}):Play()
        TweenService:Create(knob, TweenInfo.new(0.12), {Position = v and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,2,0.5,-5), BackgroundColor3 = v and T.text or T.dim}):Play()
    end
    btn.MouseButton1Click:Connect(function()
        F[key] = not F[key]
        paint()
        if onChange then pcall(onChange, F[key]) end
    end)
    paint()
    return row
end

local function uslider(parent, label, key, mn, mx, decimals, suffix, onChange)
    local row = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,32),Parent=parent})
    new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,-50,0,16),Text=label,Font=T.fontMono,TextSize=13,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
    local val = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-50,0,0),Size=UDim2.new(0,50,0,16),Font=T.fontMono,TextSize=12,TextColor3=T.accent,TextXAlignment=Enum.TextXAlignment.Right,Parent=row})
    local track = new("Frame",{BackgroundColor3=T.panel3,BorderSizePixel=0,Position=UDim2.new(0,0,0,20),Size=UDim2.new(1,0,0,4),Parent=row})
    corner(track, 2)
    local fill = new("Frame",{BackgroundColor3=T.accent,BorderSizePixel=0,Size=UDim2.new(0,0,1,0),Parent=track})
    corner(fill, 2)
    local knob = new("Frame",{BackgroundColor3=T.text,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(0,10,0,10),Parent=track})
    corner(knob, 5); stroke(knob, T.accent, 2)
    local fmt = decimals and ("%."..decimals.."f") or "%d"
    local function paint()
        local v = F[key]
        local a = math.clamp((v - mn) / (mx - mn), 0, 1)
        fill.Size = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
        val.Text = string.format(fmt, v) .. (suffix or "")
    end
    local dragging = false
    local function setFromX(x)
        local a = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = mn + (mx - mn) * a
        if not decimals then v = math.floor(v + 0.5) end
        F[key] = v
        paint()
        if onChange then pcall(onChange, v) end
    end
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; setFromX(i.Position.X)
            TweenService:Create(knob, TweenInfo.new(0.1), {Size=UDim2.new(0,14,0,14)}):Play()
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            setFromX(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            TweenService:Create(knob, TweenInfo.new(0.1), {Size=UDim2.new(0,10,0,10)}):Play()
        end
    end)
    paint()
    return row
end

local function udrop(parent, label, key, options, onChange)
    local row = urow(parent, label)
    local btn = new("TextButton",{BackgroundColor3=T.panel3,BorderSizePixel=0,Position=UDim2.new(1,-120,0.5,-10),Size=UDim2.new(0,116,0,20),Text=tostring(F[key] or options[1]),Font=T.fontMono,TextSize=12,TextColor3=T.text,AutoButtonColor=false,Parent=row})
    corner(btn, 4); stroke(btn, T.ridge, 1)
    local arrow = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-16,0,0),Size=UDim2.new(0,12,1,0),Text="▾",Font=T.fontBold,TextSize=10,TextColor3=T.dim,Parent=btn})
    stateColors(btn, T.panel3, T.ridge, T.accent2)
    local open, popup = false, nil
    local function closePopup() if popup then popup:Destroy(); popup = nil end; open = false; arrow.Text = "▾" end
    btn.MouseButton1Click:Connect(function()
        if open then closePopup() return end
        open = true; arrow.Text = "▴"
        popup = new("Frame",{BackgroundColor3=T.panel3,BorderSizePixel=0,Size=UDim2.new(0,116,0,math.min(#options*22+6, 160)),ZIndex=50,Parent=Gui})
        corner(popup, 4); stroke(popup, T.ridge, 1)
        local sc = new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,1,0),CanvasSize=UDim2.new(0,0,0,#options*22),ScrollBarThickness=2,ScrollBarImageColor3=T.accent,ZIndex=50,Parent=popup})
        pad(sc,3,3,3,3); list(sc,2)
        local abp = btn.AbsolutePosition
        popup.Position = UDim2.new(0, abp.X, 0, abp.Y + 22)
        for _, opt in ipairs(options) do
            local ob = new("TextButton",{BackgroundColor3=T.panel2,BorderSizePixel=0,Size=UDim2.new(1,0,0,20),Text=tostring(opt),Font=T.fontMono,TextSize=12,TextColor3=T.text,AutoButtonColor=false,ZIndex=51,Parent=sc})
            corner(ob, 3)
            ob.MouseEnter:Connect(function() ob.BackgroundColor3 = T.ridge end)
            ob.MouseLeave:Connect(function() ob.BackgroundColor3 = T.panel2 end)
            ob.MouseButton1Click:Connect(function()
                F[key] = opt; btn.Text = tostring(opt); closePopup()
                if onChange then pcall(onChange, opt) end
            end)
        end
    end)
    return row
end

local function ukey(parent, label, key)
    local row = urow(parent, label)
    local b = new("TextButton",{BackgroundColor3=T.panel3,BorderSizePixel=0,Position=UDim2.new(1,-80,0.5,-10),Size=UDim2.new(0,76,0,20),Text=tostring(F[key]):gsub("Enum.KeyCode.",""):gsub("Enum.UserInputType.",""),Font=T.fontMono,TextSize=11,TextColor3=T.accent,AutoButtonColor=false,Parent=row})
    corner(b, 4); stroke(b, T.ridge, 1)
    local listening = false
    b.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true; b.Text = "..."; b.TextColor3 = T.warn
    end)
    UserInputService.InputBegan:Connect(function(i)
        if not listening then return end
        if i.KeyCode ~= Enum.KeyCode.Unknown then
            F[key] = i.KeyCode
            b.Text = tostring(i.KeyCode):gsub("Enum.KeyCode.","")
        elseif i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.MouseButton2 or i.UserInputType == Enum.UserInputType.MouseButton3 then
            F[key] = i.UserInputType
            b.Text = tostring(i.UserInputType):gsub("Enum.UserInputType.","")
        end
        b.TextColor3 = T.accent
        listening = false
    end)
    return row
end

local function ucolor(parent, label, key, onChange)
    local row = urow(parent, label)
    local sw = new("TextButton",{BackgroundColor3=F[key] or T.accent,BorderSizePixel=0,Position=UDim2.new(1,-44,0.5,-7),Size=UDim2.new(0,40,0,13),Text="",AutoButtonColor=false,Parent=row})
    corner(sw, 3); stroke(sw, T.ridge, 1)
    local open, popup = false, nil
    local function build()
        popup = new("Frame",{BackgroundColor3=T.panel2,BorderSizePixel=0,Size=UDim2.new(0,166,0,197),ZIndex=60,Parent=Gui})
        corner(popup, 6); stroke(popup, T.ridge, 1)
        local abp = sw.AbsolutePosition
        popup.Position = UDim2.new(0, math.min(abp.X - 100, Gui.AbsoluteSize.X - 170), 0, abp.Y + 18)
        local hsv = new("ImageLabel",{BackgroundTransparency=1,Image=T.hsvAsset,Size=UDim2.new(0,150,0,120),Position=UDim2.new(0,8,0,8),ZIndex=61,Parent=popup})
        local pick = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(0,8,0,8),ZIndex=62,Parent=hsv})
        stroke(pick, T.text, 2)
        local huebar = new("TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0,Size=UDim2.new(0,150,0,12),Position=UDim2.new(0,8,0,132),ZIndex=61,AutoButtonColor=false,Text="",Parent=popup})
        new("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))}),Parent=huebar})
        local preview = new("Frame",{BackgroundColor3=F[key] or T.accent,BorderSizePixel=0,Size=UDim2.new(0,30,0,24),Position=UDim2.new(0,8,0,150),ZIndex=61,Parent=popup})
        corner(preview, 3); stroke(preview, T.ridge, 1)
        local hex = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,46,0,150),Size=UDim2.new(0,110,0,24),Font=T.fontMono,TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=61,Parent=popup})
        local h, s, v = Color3.toHSV(F[key] or T.accent)
        local dHSV, dHue = false, false
        hsv.ImageColor3 = Color3.fromHSV(h, 1, 1)
        pick.Position = UDim2.new(s, -4, 1-v, -4)
        local function update()
            local c = Color3.fromHSV(h, s, v)
            F[key] = c; preview.BackgroundColor3 = c; sw.BackgroundColor3 = c
            hex.Text = string.format("#%02X%02X%02X", c.R*255, c.G*255, c.B*255)
            if onChange then pcall(onChange, c) end
        end
        update()
        hsv.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dHSV = true end end)
        hsv.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dHSV = false end end)
        huebar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dHue = true end end)
        huebar.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dHue = false end end)
        UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            if dHSV then
                local ap, sz = hsv.AbsolutePosition, hsv.AbsoluteSize
                s = math.clamp((i.Position.X - ap.X)/sz.X, 0, 1)
                v = 1 - math.clamp((i.Position.Y - ap.Y)/sz.Y, 0, 1)
                pick.Position = UDim2.new(s, -4, 1-v, -4)
                update()
            elseif dHue then
                local ap, sz = huebar.AbsolutePosition, huebar.AbsoluteSize
                h = math.clamp((i.Position.X - ap.X)/sz.X, 0, 0.999)
                hsv.ImageColor3 = Color3.fromHSV(h, 1, 1)
                update()
            end
        end)
    end
    sw.MouseButton1Click:Connect(function()
        if open and popup then popup:Destroy(); popup=nil; open=false; return end
        open = true; build()
    end)
    return row
end

local function ubtn(parent, label, onClick)
    local b = new("TextButton",{BackgroundColor3=T.panel3,BorderSizePixel=0,Size=UDim2.new(1,0,0,22),Text=label,Font=T.fontMono,TextSize=12,TextColor3=T.text,AutoButtonColor=false,Parent=parent})
    corner(b, 4); stroke(b, T.ridge, 1)
    stateColors(b, T.panel3, T.ridge, T.accent2)
    b.MouseButton1Click:Connect(function() if onClick then pcall(onClick) end end)
    return b
end

local function utext(parent, label, defaultText, onChanged)
    local row = urow(parent, label)
    local tb = new("TextBox",{BackgroundColor3=T.panel3,BorderSizePixel=0,Position=UDim2.new(1,-150,0.5,-10),Size=UDim2.new(0,146,0,20),Text=defaultText or "",Font=T.fontMono,TextSize=12,TextColor3=T.text,ClearTextOnFocus=false,Parent=row})
    corner(tb, 4); stroke(tb, T.ridge, 1)
    tb.FocusLost:Connect(function() if onChanged then pcall(onChanged, tb.Text) end end)
    return row, tb
end

local NotifStack = new("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-16,1,-16),Size=UDim2.new(0,260,0,300),Parent=Gui})
local nsl = list(NotifStack, 6, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Right)
nsl.VerticalAlignment = Enum.VerticalAlignment.Bottom

local function notify(title, msg, kind, dur)
    kind = kind or "info"; dur = dur or 3
    local col = kind == "good" and T.good or kind == "bad" and T.bad or kind == "warn" and T.warn or T.accent
    local card = new("Frame",{BackgroundColor3=T.panel2,BorderSizePixel=0,Size=UDim2.new(1,0,0,52),Parent=NotifStack})
    corner(card, 6); stroke(card, T.ridge, 1)
    local bar = new("Frame",{BackgroundColor3=col,BorderSizePixel=0,Size=UDim2.new(0,3,1,-8),Position=UDim2.new(0,4,0,4),Parent=card})
    corner(bar, 2)
    new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,14,0,4),Size=UDim2.new(1,-18,0,16),Text=title,Font=T.fontBold,TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Parent=card})
    new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,14,0,20),Size=UDim2.new(1,-18,0,18),Text=msg,Font=T.fontMono,TextSize=11,TextColor3=T.text2,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=card})
    local cd = new("Frame",{BackgroundColor3=col,BorderSizePixel=0,Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),Parent=card})
    card.Position = UDim2.new(1, 0, 0, 0)
    TweenService:Create(card, TweenInfo.new(0.22), {Position=UDim2.new(0,0,0,0)}):Play()
    TweenService:Create(cd, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size=UDim2.new(0,0,0,2)}):Play()
    task.delay(dur, function()
        TweenService:Create(card, TweenInfo.new(0.22), {Position=UDim2.new(1,0,0,0),BackgroundTransparency=1}):Play()
        task.wait(0.26); card:Destroy()
    end)
end

local OpenPill = new("TextButton",{BackgroundColor3=T.accent,BorderSizePixel=0,Position=UDim2.new(0,16,0,16),Size=UDim2.new(0,64,0,24),Text="OPEN",Font=T.fontBold,TextSize=12,TextColor3=T.text,AutoButtonColor=false,Visible=false,Parent=Gui})
corner(OpenPill, 12); stroke(OpenPill, T.accent2, 1)
OpenPill.MouseButton1Click:Connect(function()
    F.menu_open = true; Root.Visible = true; OpenPill.Visible = false
end)

do
    local dragging, dstart, pstart
    TitleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dstart = i.Position; pstart = Root.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dstart
            Root.Position = UDim2.new(pstart.X.Scale, pstart.X.Offset + d.X, pstart.Y.Scale, pstart.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == F.menu_key then
        F.menu_open = not F.menu_open
        Root.Visible = F.menu_open
        OpenPill.Visible = not F.menu_open
    end
end)

local function safeDraw(cls)
    if not EXE.Drawing then return nil end
    local ok, o = pcall(Drawing.new, cls)
    if ok then return o end
    return nil
end

--==[ module factory ]==--
local MODULES = {}
local function Module(name)
    local M = {name=name, running=false, conns={}, data={}}
    function M:connect(signal, fn)
        local c = signal:Connect(fn)
        table.insert(self.conns, c)
        return c
    end
    function M:disconnectAll()
        for _, c in ipairs(self.conns) do pcall(function() c:Disconnect() end) end
        self.conns = {}
    end
    function M:log(msg) dbg(self.name, msg) end
    MODULES[name] = M
    return M
end

local function myChar() return LP.Character end
local function myRoot()
    local c = LP.Character; if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart")
end
local function myHum()
    local c = LP.Character; if not c then return nil end
    return c:FindFirstChildOfClass("Humanoid")
end
local function teamCheck(p)
    if not p.Team or not LP.Team then return true end
    return p.Team ~= LP.Team
end
local function partOf(char, bone)
    if not char then return nil end
    if bone == "Head" then return char:FindFirstChild("Head") end
    if bone == "Torso" then return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
    return char:FindFirstChild(bone) or char:FindFirstChild("HumanoidRootPart")
end
local function wallCheck(fromPos, toPart)
    if not toPart then return false end
    local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude
    local ex = {}
    if LP.Character then table.insert(ex, LP.Character) end
    rp.FilterDescendantsInstances = ex
    local dir = (toPart.Position - fromPos)
    local hit = Workspace:Raycast(fromPos, dir, rp)
    if not hit then return true end
    return hit.Instance:IsDescendantOf(toPart.Parent)
end

local function equippedTool()
    local c = LP.Character; if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") then return t end end
    return nil
end
local function weaponTune()
    local t = equippedTool()
    if not t then return WEAPON_TUNE["[Default]"] end
    return WEAPON_TUNE[t.Name] or WEAPON_TUNE["[Default]"]
end

local CAM_CACHE = { cf = CFrame.new(), pos = Vector3.new(), fov = 70, viewport = Vector2.new(1920,1080) }
RunService:BindToRenderStep("voidline_camcache", Enum.RenderPriority.Camera.Value - 1, function()
    CAM_CACHE.cf = Cam.CFrame
    CAM_CACHE.pos = Cam.CFrame.Position
    CAM_CACHE.fov = Cam.FieldOfView
    CAM_CACHE.viewport = Cam.ViewportSize
end)

local Resolver = { samples = {}, max = 10 }
function Resolver:feed(player, pos)
    local s = self.samples[player] or {}
    table.insert(s, {t=tick(), pos=pos})
    if #s > self.max then table.remove(s, 1) end
    self.samples[player] = s
end
function Resolver:resolve(player, currentPos)
    local s = self.samples[player]; if not s or #s < 3 then return currentPos end
    local xs, ys, zs = {}, {}, {}
    for _, e in ipairs(s) do table.insert(xs, e.pos.X); table.insert(ys, e.pos.Y); table.insert(zs, e.pos.Z) end
    table.sort(xs); table.sort(ys); table.sort(zs)
    local mx, my, mz = xs[math.ceil(#xs/2)], ys[math.ceil(#ys/2)], zs[math.ceil(#zs/2)]
    local good = {}
    for _, e in ipairs(s) do
        local d = (e.pos - Vector3.new(mx,my,mz)).Magnitude
        if d < F.aim_resolver_threshold then table.insert(good, e.pos) end
    end
    if #good == 0 then return Vector3.new(mx,my,mz) end
    local sum = Vector3.new()
    for _, p in ipairs(good) do sum = sum + p end
    return sum / #good
end

local function scanTargets(fovRadius, hitpartName)
    local best, bestDist, bestInfo
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and teamCheck(p) and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local part = partOf(p.Character, hitpartName or "Head")
                if part then
                    Resolver:feed(p, part.Position)
                    local wp, onScreen = Cam:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local center = CAM_CACHE.viewport * 0.5
                        local delta = (Vector2.new(wp.X, wp.Y) - center).Magnitude
                        if delta < fovRadius and (not bestDist or delta < bestDist) then
                            bestDist = delta; best = p
                            bestInfo = { part = part, screen = Vector2.new(wp.X, wp.Y), world = part.Position }
                        end
                    end
                end
            end
        end
    end
    return best, bestInfo
end

--==[ ESP ]==--
local ESP = Module("ESP")
ESP.data.objs = {}
function ESP:build(p)
    local o = {
        player = p,
        box = safeDraw("Square"),
        boxOut = safeDraw("Square"),
        name = safeDraw("Text"),
        dist = safeDraw("Text"),
        weap = safeDraw("Text"),
        hpBg = safeDraw("Square"),
        hpFill = safeDraw("Square"),
        tracer = safeDraw("Line"),
        chams = nil, chamsAdornee = nil,
    }
    local function cfg(d, props) if not d then return end for k, v in pairs(props) do pcall(function() d[k] = v end) end end
    cfg(o.box, {Thickness=1,Filled=false,Visible=false,Color=F.esp_box_color})
    cfg(o.boxOut, {Thickness=3,Filled=false,Visible=false,Color=Color3.new(0,0,0),Transparency=0.5})
    cfg(o.name, {Size=F.esp_text_size,Center=true,Outline=F.esp_outline,Visible=false,Color=F.esp_name_color})
    cfg(o.dist, {Size=F.esp_text_size,Center=true,Outline=F.esp_outline,Visible=false,Color=F.esp_distance_color})
    cfg(o.weap, {Size=F.esp_text_size,Center=true,Outline=F.esp_outline,Visible=false,Color=F.esp_weapon_color})
    cfg(o.hpBg, {Thickness=1,Filled=true,Visible=false,Color=Color3.new(0,0,0)})
    cfg(o.hpFill, {Thickness=1,Filled=true,Visible=false,Color=F.esp_health_bar_color})
    cfg(o.tracer, {Thickness=F.esp_tracer_thickness,Visible=false,Color=F.esp_tracer_color})
    self.data.objs[p] = o
    return o
end
function ESP:killOne(p)
    local o = self.data.objs[p]; if not o then return end
    for _, d in pairs({o.box,o.boxOut,o.name,o.dist,o.weap,o.hpBg,o.hpFill,o.tracer}) do if d then pcall(function() d:Remove() end) end end
    if o.chams then pcall(function() o.chams:Destroy() end) end
    self.data.objs[p] = nil
end
function ESP:killAll() for p, _ in pairs(self.data.objs) do self:killOne(p) end end
function ESP:hideOne(p)
    local o = self.data.objs[p]; if not o then return end
    for _, d in pairs({o.box,o.boxOut,o.name,o.dist,o.weap,o.hpBg,o.hpFill,o.tracer}) do if d then pcall(function() d.Visible = false end) end end
end
function ESP:updateChams(p, o, char)
    if not F.esp_chams then if o.chams then o.chams:Destroy(); o.chams=nil; o.chamsAdornee=nil end return end
    if o.chamsAdornee ~= char then
        if o.chams then o.chams:Destroy() end
        local hl = Instance.new("Highlight")
        hl.Adornee = char
        hl.FillColor = F.esp_chams_vis
        hl.OutlineColor = F.esp_chams_ovis
        hl.FillTransparency = F.esp_chams_fill
        hl.OutlineTransparency = F.esp_chams_outline
        hl.DepthMode = F.esp_chams_mode == "Visible" and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = Gui
        o.chams = hl; o.chamsAdornee = char
    end
    o.chams.FillColor = F.esp_chams_vis
    o.chams.OutlineColor = F.esp_chams_ovis
    o.chams.FillTransparency = F.esp_chams_fill
    o.chams.OutlineTransparency = F.esp_chams_outline
end
function ESP:renderOne(p)
    local o = self.data.objs[p] or self:build(p)
    if not F.esp_enabled or (F.esp_team_check and not teamCheck(p)) or not p.Character then self:hideOne(p); if o.chams then o.chams:Destroy(); o.chams=nil; o.chamsAdornee=nil end return end
    local char = p.Character
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then self:hideOne(p); return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then self:hideOne(p); return end
    local head = char:FindFirstChild("Head") or root
    local myP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if myP then
        local d = (root.Position - myP.Position).Magnitude
        if d > F.esp_max_distance or d < F.esp_min_distance then self:hideOne(p); return end
    end
    local head2, onScreen = Cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
    local foot2 = Cam:WorldToViewportPoint(root.Position + Vector3.new(0,-3,0))
    if not onScreen then self:hideOne(p); self:updateChams(p, o, char); return end
    local h = math.abs(head2.Y - foot2.Y)
    local w = h * 0.6
    local tl = Vector2.new(head2.X - w/2, head2.Y)
    if o.box then o.box.Visible = F.esp_box; o.box.Size = Vector2.new(w, h); o.box.Position = tl; o.box.Color = F.esp_box_color; o.box.Filled = F.esp_box_filled end
    if o.boxOut then o.boxOut.Visible = F.esp_box and F.esp_box_outline; o.boxOut.Size = Vector2.new(w, h); o.boxOut.Position = tl end
    if o.name then o.name.Visible = F.esp_name; o.name.Text = p.DisplayName; o.name.Position = Vector2.new(head2.X, head2.Y - 16); o.name.Color = F.esp_name_color; o.name.Size = F.esp_text_size end
    if o.dist and myP then
        local d = (root.Position - myP.Position).Magnitude
        o.dist.Visible = F.esp_distance; o.dist.Text = string.format("%dm", d); o.dist.Position = Vector2.new(head2.X, foot2.Y + 2); o.dist.Color = F.esp_distance_color
    end
    local tool
    for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then tool = t break end end
    if o.weap then o.weap.Visible = F.esp_weapon and tool ~= nil; if tool then o.weap.Text = tool.Name; o.weap.Position = Vector2.new(head2.X, foot2.Y + 14); o.weap.Color = F.esp_weapon_color end end
    if F.esp_health_bar then
        local a = math.clamp(hum.Health/hum.MaxHealth, 0, 1)
        local bx, by = tl.X - 6, tl.Y
        if o.hpBg then o.hpBg.Visible = true; o.hpBg.Size = Vector2.new(4, h); o.hpBg.Position = Vector2.new(bx, by); o.hpBg.Color = Color3.new(0,0,0) end
        if o.hpFill then
            local fh = h * a
            o.hpFill.Visible = true; o.hpFill.Size = Vector2.new(4, fh); o.hpFill.Position = Vector2.new(bx, by + h - fh)
            o.hpFill.Color = F.esp_health_bar_color_lerp and Color3.fromHSV(a * 0.33, 0.8, 1) or F.esp_health_bar_color
        end
    else
        if o.hpBg then o.hpBg.Visible = false end
        if o.hpFill then o.hpFill.Visible = false end
    end
    if o.tracer and F.esp_tracer then
        local vp = CAM_CACHE.viewport
        local from
        if F.esp_tracer_from == "Top" then from = Vector2.new(vp.X/2, 0)
        elseif F.esp_tracer_from == "Center" then from = vp/2
        else from = Vector2.new(vp.X/2, vp.Y) end
        o.tracer.Visible = true; o.tracer.From = from; o.tracer.To = Vector2.new(head2.X, foot2.Y); o.tracer.Color = F.esp_tracer_color; o.tracer.Thickness = F.esp_tracer_thickness
    elseif o.tracer then o.tracer.Visible = false end
    self:updateChams(p, o, char)
end
function ESP:start()
    if self.running then return end
    self.running = true; self:log("start")
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then self:build(p) end end
    self:connect(Players.PlayerAdded, function(p) self:build(p) end)
    self:connect(Players.PlayerRemoving, function(p) self:killOne(p) end)
    RunService:BindToRenderStep("voidline_esp", Enum.RenderPriority.Camera.Value + 1, function()
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then self:renderOne(p) end end
    end)
end
function ESP:stop()
    if not self.running then return end
    self.running = false; self:log("stop")
    pcall(function() RunService:UnbindFromRenderStep("voidline_esp") end)
    self:disconnectAll(); self:killAll()
end

--==[ SILENT ]==--
local SILENT = Module("SILENT")
SILENT.data.hookInstalled = false
SILENT.data.badge = "off"
SILENT.data.lastLive = 0
function SILENT:setBadge(s)
    self.data.badge = s
    HudBadge.Text = s
    if s == "LIVE" then HudBadge.TextColor3 = T.good
    elseif s == "armed" then HudBadge.TextColor3 = T.warn
    elseif s == "FALLBACK" then HudBadge.TextColor3 = T.bad
    else HudBadge.TextColor3 = T.dim end
end
function SILENT:pickTarget(origin)
    local best, bestDelta, bestPart
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and (not F.silent_team_check or teamCheck(p)) and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local part = partOf(p.Character, F.silent_hitpart)
                if part then
                    local wp, onScreen = Cam:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local d = (Vector2.new(wp.X, wp.Y) - CAM_CACHE.viewport * 0.5).Magnitude
                        if d < F.silent_fov and (not bestDelta or d < bestDelta) then
                            if (not F.silent_visible_only) or wallCheck(origin, part) then
                                best = p; bestDelta = d; bestPart = part
                            end
                        end
                    end
                end
            end
        end
    end
    return best, bestPart
end
function SILENT:resolveAim(origin, part, player)
    if not part then return nil end
    local pos = part.Position
    if F.silent_resolver then pos = Resolver:resolve(player, pos) end
    pos = pos + (part.AssemblyLinearVelocity or Vector3.new()) * F.silent_prediction
    if F.silent_hitchance < 100 then
        if math.random(1,100) > F.silent_hitchance then
            if not F.silent_hitchance_fallback then return nil end
        end
    end
    return pos
end
function SILENT:installHook()
    if self.data.hookInstalled then return end
    if not EXE.hookmetamethod then
        dbg("SILENT", "hookmetamethod missing — FALLBACK")
        self:setBadge("FALLBACK"); return
    end
    local ok, err = pcall(function()
        local oldCall
        oldCall = hookmetamethod(game, "__namecall", newcc(function(self_, ...)
            local nm = getnamecallmethod and getnamecallmethod() or ""
            if F.silent_enabled and (not EXE.checkcaller or not checkcaller()) and self_ == Workspace then
                if nm == "Raycast" then
                    local args = {...}
                    if typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                        local origin = args[1]
                        local player, part = SILENT:pickTarget(origin)
                        if player and part then
                            local aim = SILENT:resolveAim(origin, part, player)
                            if aim then
                                args[2] = (aim - origin)
                                SILENT.data.lastLive = tick()
                                return oldCall(self_, table.unpack(args))
                            end
                        end
                    end
                elseif nm == "FindPartOnRay" or nm == "FindPartOnRayWithIgnoreList" or nm == "FindPartOnRayWithWhitelist" then
                    local args = {...}
                    if typeof(args[1]) == "Ray" then
                        local ray = args[1]
                        local player, part = SILENT:pickTarget(ray.Origin)
                        if player and part then
                            local aim = SILENT:resolveAim(ray.Origin, part, player)
                            if aim then
                                args[1] = Ray.new(ray.Origin, aim - ray.Origin)
                                SILENT.data.lastLive = tick()
                                return oldCall(self_, table.unpack(args))
                            end
                        end
                    end
                end
            end
            return oldCall(self_, ...)
        end))
        self.data.hookInstalled = true
    end)
    if not ok then
        dbg("SILENT", "hook error: "..tostring(err))
        self:setBadge("FALLBACK")
    else
        self:log("hook installed globally")
        self:setBadge("armed")
    end
end
function SILENT:start()
    if self.running then return end
    self.running = true; F.silent_enabled = true; self:log("start")
    self:installHook()
    self.data.badgeLoop = RunService.Heartbeat:Connect(function()
        if not F.silent_enabled then return end
        if tick() - self.data.lastLive < 0.25 then self:setBadge("LIVE")
        else if self.data.hookInstalled then self:setBadge("armed") else self:setBadge("FALLBACK") end end
    end)
    table.insert(self.conns, self.data.badgeLoop)
    self:connect(LP.CharacterAdded, function() self:log("respawn — global hook stays live") end)
end
function SILENT:stop()
    if not self.running then return end
    self.running = false; F.silent_enabled = false; self:log("stop")
    self:disconnectAll(); self:setBadge("off")
end

--==[ AIM ]==--
local AIM = Module("AIM")
AIM.data.locked = nil
AIM.data.lockUntil = 0
AIM.data.lastConvergePrint = 0
AIM.data.lastFire = 0
function AIM:drive(target, info, dt)
    if not target or not info then return end
    local part = info.part; if not part then return end
    local tune = weaponTune()
    local pred = F.aim_prediction_dynamic and tune.pred or F.aim_prediction
    local aimPos = part.Position + (part.AssemblyLinearVelocity or Vector3.new()) * pred
    if F.aim_resolver then aimPos = Resolver:resolve(target, aimPos) end
    local wp, onScreen = Cam:WorldToViewportPoint(aimPos)
    if not onScreen then return end
    local screenPt = Vector2.new(wp.X, wp.Y)
    local toAim = (aimPos - CAM_CACHE.pos)
    if toAim.Magnitude < 0.01 then return end
    toAim = toAim.Unit
    local forward = CAM_CACHE.cf.LookVector
    local dot = math.clamp(forward:Dot(toAim), -1, 1)
    local angErr = math.deg(math.acos(dot))
    if angErr < 0.5 and tick() - self.data.lastConvergePrint > 0.25 then
        dbg("AIM", string.format("CONVERGED err=%.2fdeg mode=%s", angErr, F.aim_mode))
        self.data.lastConvergePrint = tick()
    end
    if F.aim_mode == "Mouse" then
        local mouse = UserInputService:GetMouseLocation()
        local dx = screenPt.X - mouse.X
        local dy = screenPt.Y - mouse.Y
        local smooth = math.max(F.aim_smooth_min, F.aim_smooth)
        local alpha = math.clamp(dt * 60 / smooth, 0, 1)
        local mx = dx * alpha
        local my = dy * alpha
        if EXE.mousemoverel then
            pcall(function() mousemoverel(mx, my) end)
        elseif VirtualInputManager then
            pcall(function() VirtualInputManager:SendMouseMoveEvent(mouse.X + mx, mouse.Y + my, game) end)
        end
    else
        local targetCF = CFrame.new(CAM_CACHE.pos, aimPos)
        local smooth = math.max(F.aim_smooth_min, F.aim_smooth)
        local alpha = math.clamp(dt * 60 / smooth, 0, 1)
        Cam.CFrame = CAM_CACHE.cf:Lerp(targetCF, alpha)
    end
end
function AIM:active()
    if not F.aim_enabled then return false end
    local k = F.aim_key
    if typeof(k) == "EnumItem" then
        if tostring(k):find("MouseButton") then return UserInputService:IsMouseButtonPressed(k) end
        return UserInputService:IsKeyDown(k)
    end
    return true
end
function AIM:trackDamage()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and not self.data["w_"..p.UserId] then
                self.data["w_"..p.UserId] = true
                local last = hum.Health
                hum.HealthChanged:Connect(function(h)
                    local d = last - h
                    if d > 0.1 and (self.data.locked == p or (tick() - self.data.lastFire) < 0.35) then
                        F._hits = F._hits + 1
                        F._dmg = F._dmg + d
                        HudHits.Text = "H "..F._hits
                        dbg("AIM", string.format("hit dmg=%.1f on=%s", d, p.Name))
                    end
                    last = h
                end)
                hum.Died:Connect(function() self.data["w_"..p.UserId] = nil end)
            end
        end
    end
end
function AIM:start()
    if self.running then return end
    self.running = true; self:log("start")
    self.data.loop = RunService.RenderStepped:Connect(function(dt)
        self:trackDamage()
        if not self:active() then self.data.locked = nil return end
        local target, info
        if F.aim_target_lock and self.data.locked and self.data.locked.Character and tick() < self.data.lockUntil then
            local lp = self.data.locked
            local part = partOf(lp.Character, F.aim_hitpart)
            if part then target = lp; info = { part = part, world = part.Position } end
        end
        if not target then
            target, info = scanTargets(F.aim_fov, F.aim_hitpart)
            if target then self.data.locked = target; self.data.lockUntil = tick() + F.aim_lock_time end
        end
        if target then self:drive(target, info, dt); self.data.lastFire = tick() end
    end)
    table.insert(self.conns, self.data.loop)
    self:connect(LP.CharacterAdded, function() self.data.locked = nil; self.data.lockUntil = 0 end)
end
function AIM:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
end

--==[ FOV CIRCLE ]==--
local FOV = Module("FOV")
function FOV:start()
    if self.running then return end
    self.running = true; self:log("start")
    self.data.circle = safeDraw("Circle")
    if self.data.circle then self.data.circle.Thickness = 1; self.data.circle.Transparency = 0.9; self.data.circle.NumSides = 64; self.data.circle.Filled = false end
    self.data.loop = RunService.RenderStepped:Connect(function()
        local c = self.data.circle; if not c then return end
        local show = (F.aim_enabled and F.aim_fov_show) or F.silent_enabled
        c.Visible = show
        if show then
            c.Position = CAM_CACHE.viewport * 0.5
            c.Radius = F.aim_enabled and F.aim_fov or F.silent_fov
            c.Color = F.aim_fov_color
        end
    end)
    table.insert(self.conns, self.data.loop)
end
function FOV:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
    if self.data.circle then pcall(function() self.data.circle:Remove() end); self.data.circle = nil end
end

--==[ ORBIT ]==--
local ORBIT = Module("ORBIT")
ORBIT.data.theta = 0
function ORBIT:start()
    if self.running then return end
    self.running = true; self:log("start")
    self.data.ring = safeDraw("Circle")
    if self.data.ring then self.data.ring.Thickness=1; self.data.ring.Transparency=0.8; self.data.ring.NumSides=48; self.data.ring.Filled=false end
    self.data.loop = RunService.Heartbeat:Connect(function(dt)
        local root = myRoot(); if not root then return end
        self.data.theta = self.data.theta + dt * F.orbit_speed * F.orbit_direction
        local target
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and teamCheck(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if dist < F.orbit_radius * 4 then target = p.Character.HumanoidRootPart.Position; break end
            end
        end
        local center = target or (root.Position - CAM_CACHE.cf.LookVector * F.orbit_radius)
        local jitter = (math.random() - 0.5) * F.orbit_jitter
        local x = math.cos(self.data.theta) * (F.orbit_radius + jitter)
        local z = math.sin(self.data.theta) * (F.orbit_radius + jitter)
        local goal = center + Vector3.new(x, F.orbit_height, z)
        root.CFrame = CFrame.new(goal, center)
        if self.data.ring and F.orbit_ring_show then
            local sp = Cam:WorldToViewportPoint(center)
            self.data.ring.Visible = true; self.data.ring.Position = Vector2.new(sp.X, sp.Y); self.data.ring.Radius = 40; self.data.ring.Color = F.orbit_ring_color
        elseif self.data.ring then self.data.ring.Visible = false end
    end)
    table.insert(self.conns, self.data.loop)
end
function ORBIT:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
    if self.data.ring then pcall(function() self.data.ring:Remove() end); self.data.ring = nil end
end

--==[ ANTI-AIM ]==--
local AA = Module("AA")
AA.data.yaw = 0
function AA:applyPreset(p)
    local preset = AA_PRESETS[p]; if not preset then return end
    for k, v in pairs(preset) do F[k] = v end
    dbg("AA", "preset="..p)
end
function AA:start()
    if self.running then return end
    self.running = true; self:log("start")
    self.data.loop = RunService.Heartbeat:Connect(function(dt)
        local root = myRoot(); if not root then return end
        local camYaw = math.atan2(-CAM_CACHE.cf.LookVector.X, -CAM_CACHE.cf.LookVector.Z)
        local pitch = 0
        if F.aa_pitch == "Down" then pitch = math.rad(F.aa_pitch_angle)
        elseif F.aa_pitch == "Up" then pitch = -math.rad(F.aa_pitch_angle) end
        local yaw = camYaw
        if F.aa_yaw == "Static" then yaw = camYaw + math.rad(F.aa_yaw_offset)
        elseif F.aa_yaw == "Jitter" then yaw = camYaw + math.rad((math.random()*2-1) * F.aa_yaw_jitter)
        elseif F.aa_yaw == "Spin" then self.data.yaw = (self.data.yaw + dt * math.rad(F.aa_spin_speed)) % (math.pi*2); yaw = self.data.yaw
        elseif F.aa_yaw == "Sway" then yaw = camYaw + math.sin(tick() * F.aa_sway_speed) * math.rad(F.aa_sway_range) * 0.5 end
        if F.aa_desync then yaw = yaw + math.rad(F.aa_desync_amount) * (math.sin(tick() * 25) * 0.5 + 0.5) end
        if F.aa_lby == "Opposite" then yaw = yaw + math.pi
        elseif F.aa_lby == "Flicker" and math.random() < 0.3 then yaw = yaw + math.pi end
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(pitch, yaw, 0)
    end)
    table.insert(self.conns, self.data.loop)
end
function AA:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
end

--==[ VOID ]==--
local VOID = Module("VOID")
VOID.data.homeCF = nil
VOID.data.handoffQueued = false
VOID.data.handoffTarget = nil
VOID.data.handoffFrames = 0
function VOID:captureHome()
    local root = myRoot(); if not root then return end
    self.data.homeCF = root.CFrame
end
function VOID:bury()
    local char = myChar(); if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            if F.void_cancollide_off then p.CanCollide = false end
            p.AssemblyLinearVelocity = Vector3.new(0,0,0)
            p.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end
    end
    if hum and F.void_hipheight_pin then
        pcall(function() hum.HipHeight = 0 end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)
    end
    root.CFrame = CFrame.new(root.Position.X, F.void_depth, root.Position.Z) * (root.CFrame - root.CFrame.Position)
end
function VOID:surface()
    local root = myRoot(); if not root then return end
    if self.data.homeCF then root.CFrame = self.data.homeCF end
    local hum = myHum()
    if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
end
function VOID:handoffFire(targetPos)
    self.data.handoffQueued = true
    self.data.handoffTarget = targetPos
    self.data.handoffFrames = F.void_handoff_frames
end
function VOID:start()
    if self.running then return end
    self.running = true; self:log("start")
    self:captureHome()
    if F.void_rebind_on_spawn then
        self:connect(LP.CharacterAdded, function()
            task.wait(0.4); self:captureHome(); self:log("rebind on respawn")
        end)
    end
    RunService:BindToRenderStep("voidline_void", Enum.RenderPriority.Character.Value - 1, function()
        if not F.void_enabled then return end
        local hum = myHum()
        if hum and hum.Health <= 0 then dbg("VOID", "death state="..tostring(hum:GetState())) return end
        if self.data.handoffQueued and self.data.handoffFrames > 0 then
            local root = myRoot()
            if root and self.data.handoffTarget then
                root.CFrame = CFrame.new(CAM_CACHE.pos - CAM_CACHE.cf.LookVector * 2, self.data.handoffTarget)
            end
            self.data.handoffFrames = self.data.handoffFrames - 1
            if self.data.handoffFrames <= 0 then self.data.handoffQueued = false; self:bury() end
            return
        end
        self:bury()
    end)
end
function VOID:stop()
    if not self.running then return end
    self.running = false; self:log("stop")
    pcall(function() RunService:UnbindFromRenderStep("voidline_void") end)
    self:disconnectAll(); self:surface()
end

--==[ VOIDSPAM ]==--
local VS = Module("VS")
VS.data.home = nil
VS.data.phase = "IN"
VS.data.acc = 0
function VS:captureHome()
    local root = myRoot(); if not root then self.data.home = nil return end
    self.data.home = root.CFrame
end
function VS:start()
    if self.running then return end
    self.running = true; self:log("start")
    self:captureHome()
    self.data.acc = 0; self.data.phase = "IN"
    self:connect(LP.CharacterAdded, function() task.wait(0.35); self:captureHome(); self:log("rebind") end)
    self.data.loop = RunService.Heartbeat:Connect(function(dt)
        if not F.vs_enabled then return end
        local root = myRoot(); if not root then return end
        if not self.data.home then self:captureHome(); return end
        self.data.acc = self.data.acc + dt
        if self.data.phase == "IN" and self.data.acc >= F.vs_interval then
            self.data.acc = 0; self.data.phase = "OUT"
            local dir = Vector3.new(math.random()*2-1, 0, math.random()*2-1)
            if dir.Magnitude > 0.001 then dir = dir.Unit else dir = Vector3.new(1,0,0) end
            local jitter = (math.random()*2-1) * F.vs_jitter
            local offset = dir * (F.vs_distance + jitter)
            root.CFrame = self.data.home + offset
            dbg("VS", "hop "..string.format("%.1f %.1f %.1f", offset.X, offset.Y, offset.Z))
        elseif self.data.phase == "OUT" and self.data.acc >= F.vs_return_delay then
            self.data.acc = 0; self.data.phase = "IN"
            if self.data.home then root.CFrame = self.data.home end
        end
    end)
    table.insert(self.conns, self.data.loop)
end
function VS:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
    if self.data.home then local r = myRoot(); if r then r.CFrame = self.data.home end end
end

--==[ RAGEBOT ]==--
local RAGE = Module("RAGE")
RAGE.data.state = "IDLE"
RAGE.data.until_ = 0
RAGE.data.target = nil
RAGE.data.lastHits = 0
function RAGE:setState(s)
    self.data.state = s
    self:log("state -> "..s)
    HudState.Text = "RAGE: "..s
end
function RAGE:tick(dt)
    if not F.rage_enabled then return end
    local me = myRoot(); if not me then return end
    local now = tick()
    local st = self.data.state
    if st == "IDLE" then
        local t = scanTargets(240, F.aim_hitpart)
        if t then self.data.target = t; self:setState("APPROACH") end
    elseif st == "APPROACH" then
        local t = self.data.target
        if not t or not t.Character then self:setState("IDLE") return end
        local tp = t.Character:FindFirstChild("HumanoidRootPart"); if not tp then self:setState("IDLE") return end
        local to = tp.Position - me.Position
        if to.Magnitude > F.rage_approach_dist then
            me.CFrame = me.CFrame:Lerp(CFrame.new(tp.Position - to.Unit * F.rage_approach_dist, tp.Position), math.clamp(dt*4, 0, 1))
        else
            self.data.lastHits = F._hits
            self.data.until_ = now + 0.6
            self:setState("CONFIRM")
            if F.rage_auto_void and VOID.running then
                VOID:handoffFire(tp.Position)
            end
        end
    elseif st == "CONFIRM" then
        if F._hits > self.data.lastHits or now > self.data.until_ then self:setState("RETREAT") end
    elseif st == "RETREAT" then
        local t = self.data.target
        local hum = myHum()
        local myHP = hum and hum.Health or 100
        local tHP = (t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") and t.Character:FindFirstChildOfClass("Humanoid").Health) or 100
        local dist = F.rage_retreat_dist
        if myHP > F.rage_hp_threshold and myHP > tHP then dist = dist * F.rage_hp_mult
        elseif myHP < F.rage_hp_threshold then dist = F.rage_short_hop end
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            local away = (me.Position - t.Character.HumanoidRootPart.Position)
            if away.Magnitude > 0.001 then away = away.Unit else away = Vector3.new(1,0,0) end
            me.CFrame = me.CFrame + away * dist
        end
        self.data.until_ = now + F.rage_cooldown
        self:setState("COOLDOWN")
    elseif st == "COOLDOWN" then
        if now > self.data.until_ then self.data.until_ = now + F.rage_reengage; self:setState("IDLE") end
    end
end
function RAGE:start()
    if self.running then return end
    self.running = true; self:log("start")
    if F.rage_auto_orbit and not ORBIT.running then F.orbit_enabled = true; ORBIT:start(); self:log("auto: ORBIT") end
    if F.rage_auto_void and not VOID.running then F.void_enabled = true; VOID:start(); self:log("auto: VOID") end
    if F.rage_auto_vs and not VS.running then F.vs_enabled = true; VS:start(); self:log("auto: VS") end
    if F.rage_auto_silent and not SILENT.running then SILENT:start(); self:log("auto: SILENT") end
    self.data.loop = RunService.Heartbeat:Connect(function(dt) self:tick(dt) end)
    table.insert(self.conns, self.data.loop)
    self:setState("IDLE")
end
function RAGE:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
    HudState.Text = "IDLE"
end

--==[ LEGIT ]==--
local LEGIT = Module("LEGIT")
function LEGIT:active()
    local k = F.legit_key
    if typeof(k) == "EnumItem" then
        if tostring(k):find("MouseButton") then return UserInputService:IsMouseButtonPressed(k) end
        return UserInputService:IsKeyDown(k)
    end
    return false
end
function LEGIT:start()
    if self.running then return end
    self.running = true; self:log("start")
    self.data.loop = RunService.RenderStepped:Connect(function(dt)
        if not F.legit_enabled or not self:active() then return end
        local target, info = scanTargets(F.legit_fov, F.legit_bone)
        if not target then return end
        local aim = info.world + (info.part.AssemblyLinearVelocity or Vector3.new()) * F.legit_predict
        if F.legit_wall_check and not wallCheck(CAM_CACHE.pos, info.part) then return end
        local tcf = CFrame.new(CAM_CACHE.pos, aim)
        local alpha = math.clamp(dt * 60 / F.legit_smooth, 0, 1)
        Cam.CFrame = CAM_CACHE.cf:Lerp(tcf, alpha)
    end)
    table.insert(self.conns, self.data.loop)
end
function LEGIT:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
end

--==[ TRIGGER ]==--
local TRIG = Module("TRIG")
function TRIG:start()
    if self.running then return end
    self.running = true; self:log("start")
    self.data.loop = RunService.Heartbeat:Connect(function()
        if not F.trig_enabled then return end
        if F.trig_key_only and not UserInputService:IsKeyDown(F.trig_key) then return end
        local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude
        if LP.Character then rp.FilterDescendantsInstances = {LP.Character} end
        local hit = Workspace:Raycast(CAM_CACHE.pos, CAM_CACHE.cf.LookVector * 500, rp)
        if hit and hit.Instance then
            local p = hit.Instance.Parent
            local hum = p and p:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pl = Players:GetPlayerFromCharacter(p)
                if pl and (not F.trig_team_check or teamCheck(pl)) then
                    task.wait(F.trig_delay)
                    if VirtualInputManager then
                        pcall(function()
                            VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 0)
                            task.wait(0.03)
                            VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 0)
                        end)
                    end
                end
            end
        end
    end)
    table.insert(self.conns, self.data.loop)
end
function TRIG:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
end

--==[ MOVEMENT ]==--
local MOVE = Module("MOVE")
function MOVE:start()
    if self.running then return end
    self.running = true; self:log("start")
    self:connect(UserInputService.JumpRequest, function() if F.mv_bhop then local h = myHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)
    self.data.loop = RunService.Heartbeat:Connect(function()
        local hum = myHum(); if not hum then return end
        if F.mv_speed then hum.WalkSpeed = F.mv_speed_val end
        if F.mv_jump then hum.JumpPower = F.mv_jump_val end
        if F.mv_noclip then
            local c = LP.Character; if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end
    end)
    table.insert(self.conns, self.data.loop)
    self:connect(UserInputService.InputBegan, function(i, gp)
        if gp then return end
        if F.mv_inf_jump and i.KeyCode == Enum.KeyCode.Space then
            local h = myHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end
function MOVE:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
    local h = myHum(); if h then h.WalkSpeed = 16; h.JumpPower = 50 end
end

--==[ VISUALS ]==--
local VIS = Module("VIS")
VIS.data.cross = {}
VIS.data.hitmark = {}
VIS.data.hitmarkEnd = 0
function VIS:start()
    if self.running then return end
    self.running = true; self:log("start")
    for _ = 1, 4 do
        local l = safeDraw("Line"); if l then l.Thickness = F.vis_crosshair_thickness; l.Visible = false; l.Color = F.vis_crosshair_color end
        table.insert(self.data.cross, l)
    end
    for _ = 1, 4 do
        local l = safeDraw("Line"); if l then l.Thickness = 1; l.Visible = false; l.Color = F.vis_hitmark_color end
        table.insert(self.data.hitmark, l)
    end
    AIM.data.onHit = function() self.data.hitmarkEnd = tick() + F.vis_hitmark_time end
    self.data.loop = RunService.RenderStepped:Connect(function()
        local vp = CAM_CACHE.viewport; local c = vp * 0.5
        if F.vis_crosshair then
            local sz = F.vis_crosshair_size; local gap = F.vis_crosshair_gap
            local lines = self.data.cross
            if lines[1] then lines[1].Visible=true; lines[1].From=Vector2.new(c.X-gap-sz,c.Y); lines[1].To=Vector2.new(c.X-gap,c.Y); lines[1].Color=F.vis_crosshair_color; lines[1].Thickness=F.vis_crosshair_thickness end
            if lines[2] then lines[2].Visible=true; lines[2].From=Vector2.new(c.X+gap,c.Y); lines[2].To=Vector2.new(c.X+gap+sz,c.Y); lines[2].Color=F.vis_crosshair_color; lines[2].Thickness=F.vis_crosshair_thickness end
            if lines[3] then lines[3].Visible=true; lines[3].From=Vector2.new(c.X,c.Y-gap-sz); lines[3].To=Vector2.new(c.X,c.Y-gap); lines[3].Color=F.vis_crosshair_color; lines[3].Thickness=F.vis_crosshair_thickness end
            if lines[4] then lines[4].Visible=true; lines[4].From=Vector2.new(c.X,c.Y+gap); lines[4].To=Vector2.new(c.X,c.Y+gap+sz); lines[4].Color=F.vis_crosshair_color; lines[4].Thickness=F.vis_crosshair_thickness end
        else
            for _, l in ipairs(self.data.cross) do if l then l.Visible = false end end
        end
        if F.vis_hitmark and self.data.hitmarkEnd > tick() then
            local sz = F.vis_hitmark_size
            local hm = self.data.hitmark
            if hm[1] then hm[1].Visible=true; hm[1].From=Vector2.new(c.X-sz,c.Y-sz); hm[1].To=Vector2.new(c.X-2,c.Y-2) end
            if hm[2] then hm[2].Visible=true; hm[2].From=Vector2.new(c.X+2,c.Y+2); hm[2].To=Vector2.new(c.X+sz,c.Y+sz) end
            if hm[3] then hm[3].Visible=true; hm[3].From=Vector2.new(c.X-sz,c.Y+sz); hm[3].To=Vector2.new(c.X-2,c.Y+2) end
            if hm[4] then hm[4].Visible=true; hm[4].From=Vector2.new(c.X+2,c.Y-2); hm[4].To=Vector2.new(c.X+sz,c.Y-sz) end
        else
            for _, l in ipairs(self.data.hitmark) do if l then l.Visible=false end end
        end
    end)
    table.insert(self.conns, self.data.loop)
    self:connect(RunService.Heartbeat, function()
        if F.vis_fullbright then
            Lighting.Brightness = F.vis_fullbright_val
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        end
        if F.vis_no_fog then Lighting.FogEnd = 1e10 end
    end)
end
function VIS:stop()
    if not self.running then return end
    self.running = false; self:log("stop")
    for _, l in ipairs(self.data.cross) do if l then pcall(function() l:Remove() end) end end
    for _, l in ipairs(self.data.hitmark) do if l then pcall(function() l:Remove() end) end end
    self.data.cross = {}; self.data.hitmark = {}
    self:disconnectAll()
end

--==[ SKINS ]==--
local SKIN = Module("SKIN")
SKIN.data.handlemap = { DB_HANDLE = "DoubleBarrel", REV_HANDLE = "Revolver" }
function SKIN:getSkinModel(wname, sname)
    local wraps = ReplicatedStorage:FindFirstChild("Wraps"); if not wraps then return nil end
    local folder = wraps:FindFirstChild("["..wname.."]"); if not folder then return nil end
    return folder:FindFirstChild(sname)
end
function SKIN:prep(model, isknife)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false; part.Anchored = false; part.Massless = true end
        if isknife and part:IsA("MeshPart") then
            local sa = part:FindFirstChildOfClass("SurfaceAppearance"); if sa then sa:Destroy() end
            if part.TextureID == "" then
                local n = part.Name:lower()
                if n:find("box") or n:find("cube") or n:find("part") or n:find("hit") then part.Transparency = 1 end
            end
        end
    end
end
function SKIN:apply(holder, skinmodel)
    if not holder or not skinmodel then return end
    local handle = holder:FindFirstChild("Handle"); if not handle or not handle:IsA("BasePart") then return end
    local old = holder:FindFirstChild("SkinModel"); if old then old:Destroy() end
    local clone = skinmodel:Clone()
    clone.Name = "SkinModel"
    if clone:IsA("Model") and not clone.PrimaryPart then clone.PrimaryPart = clone:FindFirstChildWhichIsA("BasePart") end
    local isknife = holder.Name:find("Knife") and true or false
    self:prep(clone, isknife)
    clone.Parent = holder
    if clone:IsA("Model") and clone.PrimaryPart then clone:PivotTo(handle.CFrame) end
    for _, p in ipairs(clone:GetDescendants()) do
        if p:IsA("BasePart") then
            local w = Instance.new("WeldConstraint"); w.Part0 = handle; w.Part1 = p; w.Parent = handle
        end
    end
    handle.Transparency = 1
end
function SKIN:applyTool(tool)
    if not tool:IsA("Tool") then return end
    local wname = tool.Name:match("^%[(.+)%]$"); if not wname then return end
    local sname = F.skin_map[wname]; if not sname then return end
    if wname == "Knife" then
        local knives = ReplicatedStorage:FindFirstChild("Knives")
        if knives then local m = knives:FindFirstChild(sname); if m then self:apply(tool, m) end end
    else
        local m = self:getSkinModel(wname, sname); if m then self:apply(tool, m) end
    end
end
function SKIN:applyAll(char)
    if not F.skin_enabled then return end
    for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then self:applyTool(t) end end
    for hn, wn in pairs(self.data.handlemap) do
        local h = char:FindFirstChild(hn); if h then local m = self:getSkinModel(wn, F.skin_map[wn]); if m then self:apply(h, m) end end
    end
end
function SKIN:hookChar(char)
    self:connect(char.ChildAdded, function(c)
        if c:IsA("Tool") then self:applyTool(c)
        elseif self.data.handlemap[c.Name] then
            task.defer(function() local wn = self.data.handlemap[c.Name]; local m = self:getSkinModel(wn, F.skin_map[wn]); if m then self:apply(c, m) end end)
        end
    end)
    self:applyAll(char)
end
function SKIN:start()
    if self.running then return end
    self.running = true; self:log("start")
    if LP.Character then self:hookChar(LP.Character) end
    self:connect(LP.CharacterAdded, function(c) task.wait(0.3); self:hookChar(c) end)
end
function SKIN:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
end

--==[ FFA ]==--
local FFA = Module("FFA")
function FFA:start()
    if self.running then return end
    self.running = true; self:log("start")
    self:connect(LP.CharacterAdded, function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            if not F.ffa_autorespawn then return end
            task.wait(0.3)
            pcall(function()
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                if r then local d = r:FindFirstChild("Duels")
                    if d then local rr = d:FindFirstChild("RespawnNow"); if rr and rr:IsA("RemoteEvent") then rr:FireServer() end end
                end
            end)
        end)
    end)
    self.data.loop = RunService.RenderStepped:Connect(function(dt)
        if not (F.ffa_auto_pickup_ammo or F.ffa_auto_pickup_hp) then return end
        local root = myRoot(); if not root then return end
        self.data.t = (self.data.t or 0) + dt * 8
        local bounce = math.sin(self.data.t) * 4
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "_drop" and obj:IsA("BasePart") then
                if (F.ffa_auto_pickup_ammo and obj:FindFirstChild("Ammo")) or (F.ffa_auto_pickup_hp and obj:FindFirstChild("Health")) then
                    obj.Anchored = true
                    obj.CFrame = CFrame.new(root.Position + Vector3.new(0, bounce, 0))
                    obj.Transparency = 1
                    for _, c in ipairs(obj:GetDescendants()) do
                        if c:IsA("BasePart") or c:IsA("UnionOperation") or c:IsA("MeshPart") then pcall(function() c.Transparency = 1 end) end
                        if c:IsA("BillboardGui") or c:IsA("ParticleEmitter") or c:IsA("SelectionBox") then pcall(function() c.Enabled = false end) end
                    end
                end
            end
        end
    end)
    table.insert(self.conns, self.data.loop)
end
function FFA:stop()
    if not self.running then return end
    self.running = false; self:log("stop"); self:disconnectAll()
end

--==[ CONFIG IO ]==--
local CONF_DIR = "voidline_configs"
local CONF_SCHEMA = 4
local function enc(v)
    if typeof(v) == "Color3" then return {_c=true, r=v.R, g=v.G, b=v.B} end
    if typeof(v) == "EnumItem" then return {_e=true, t=tostring(v.EnumType), n=v.Name} end
    if typeof(v) == "table" then local t = {} for k, x in pairs(v) do t[k] = enc(x) end return t end
    return v
end
local function dec(v)
    if typeof(v) == "table" then
        if v._c then return Color3.new(v.r, v.g, v.b) end
        if v._e then local ok, e = pcall(function() return Enum[v.t:gsub("Enum.","")][v.n] end); if ok then return e end end
        local t = {}; for k, x in pairs(v) do t[k] = dec(x) end; return t
    end
    return v
end
local function saveConfig(name)
    if not EXE.writefile then notify("Config", "no writefile", "bad"); return end
    if EXE.makefolder and EXE.isfolder and not isfolder(CONF_DIR) then pcall(function() makefolder(CONF_DIR) end) end
    local out = { version = CONF_SCHEMA, flags = {} }
    for k, v in pairs(F) do if k:sub(1,1) ~= "_" then out.flags[k] = enc(v) end end
    local ok = pcall(function() writefile(CONF_DIR.."/"..name..".json", HttpService:JSONEncode(out)) end)
    if ok then notify("Config", "saved "..name, "good") else notify("Config", "save fail", "bad") end
end
local function loadConfig(name)
    if not EXE.readfile then notify("Config", "no readfile", "bad"); return end
    local ok, data = pcall(function() return readfile(CONF_DIR.."/"..name..".json") end)
    if not ok then notify("Config", "load fail", "bad"); return end
    local ok2, decoded = pcall(function() return HttpService:JSONDecode(data) end)
    if not ok2 then notify("Config", "parse fail", "bad"); return end
    if decoded.version and decoded.version > CONF_SCHEMA then notify("Config", "schema mismatch", "warn"); return end
    for k, v in pairs(decoded.flags or {}) do F[k] = dec(v) end
    notify("Config", "loaded "..name, "good")
end
local function listConfigs()
    if not EXE.listfiles then return {} end
    local out = {}; local ok, files = pcall(function() return listfiles(CONF_DIR) end)
    if not ok then return {} end
    for _, f in ipairs(files) do local n = f:match("([^/\\]+)%.json$"); if n then table.insert(out, n) end end
    return out
end

--==[ TABS ]==--
local tESP = mkTab("ESP", "E")
local tAim = mkTab("Aim", "A")
local tSilent = mkTab("Silent", "S")
local tRage = mkTab("Ragebot", "R")
local tVoid = mkTab("Void", "V")
local tAA = mkTab("Anti-Aim", "⥮")
local tLegit = mkTab("Legit", "L")
local tTrig = mkTab("Trigger", "T")
local tMove = mkTab("Move", "M")
local tVis = mkTab("Visuals", "◎")
local tSkin = mkTab("Skins", "K")
local tFFA = mkTab("FFA", "F")
local tConf = mkTab("Configs", "C")
local tDbg = mkTab("Debug", "D")
local tSet = mkTab("Settings", "⚙")

do
    local s = section(tESP.body, "Master")
    utoggle(s, "ESP Enabled", "esp_enabled", function(v) if v then ESP:start() else ESP:stop() end end)
    utoggle(s, "Team Check", "esp_team_check")
    local s2 = section(tESP.body, "Box")
    utoggle(s2, "Box", "esp_box"); utoggle(s2, "Box Outline", "esp_box_outline"); utoggle(s2, "Box Filled", "esp_box_filled")
    ucolor(s2, "Box Color", "esp_box_color")
    local s3 = section(tESP.body, "Text")
    utoggle(s3, "Name", "esp_name"); ucolor(s3, "Name Color", "esp_name_color")
    utoggle(s3, "Distance", "esp_distance"); ucolor(s3, "Distance Color", "esp_distance_color")
    utoggle(s3, "Weapon", "esp_weapon"); ucolor(s3, "Weapon Color", "esp_weapon_color")
    uslider(s3, "Text Size", "esp_text_size", 10, 20, nil, "px")
    utoggle(s3, "Outline", "esp_outline")
    local s4 = section(tESP.body, "Health")
    utoggle(s4, "Health Bar", "esp_health_bar"); utoggle(s4, "Color Lerp", "esp_health_bar_color_lerp"); ucolor(s4, "Health Color", "esp_health_bar_color")
    local s5 = section(tESP.body, "Tracer")
    utoggle(s5, "Tracer", "esp_tracer"); udrop(s5, "Origin", "esp_tracer_from", {"Top","Center","Bottom"})
    ucolor(s5, "Color", "esp_tracer_color"); uslider(s5, "Thickness", "esp_tracer_thickness", 1, 4)
    local s6 = section(tESP.body, "Chams")
    utoggle(s6, "Chams", "esp_chams"); udrop(s6, "Mode", "esp_chams_mode", {"Visible","Highlight"})
    ucolor(s6, "Visible", "esp_chams_vis"); ucolor(s6, "Occluded", "esp_chams_ovis")
    uslider(s6, "Fill", "esp_chams_fill", 0, 1, 2); uslider(s6, "Outline", "esp_chams_outline", 0, 1, 2)
    local s7 = section(tESP.body, "Distance")
    uslider(s7, "Max Distance", "esp_max_distance", 0, 5000, nil, "m")
    uslider(s7, "Min Distance", "esp_min_distance", 0, 500, nil, "m")
end

do
    local s = section(tAim.body, "Aimbot")
    utoggle(s, "Enabled", "aim_enabled", function(v) if v then AIM:start(); FOV:start() else AIM:stop() end end)
    udrop(s, "Mode", "aim_mode", {"Mouse","Camera"})
    udrop(s, "Hitpart", "aim_hitpart", {"Head","Torso","HumanoidRootPart"})
    ukey(s, "Key", "aim_key"); utoggle(s, "Hold", "aim_hold")
    uslider(s, "FOV", "aim_fov", 10, 400, nil, "px")
    utoggle(s, "FOV Circle", "aim_fov_show"); ucolor(s, "FOV Color", "aim_fov_color")
    uslider(s, "Smooth", "aim_smooth", 1, 20)
    uslider(s, "Prediction", "aim_prediction", 0, 0.5, 3, "s")
    utoggle(s, "Dynamic Prediction", "aim_prediction_dynamic")
    local s2 = section(tAim.body, "Checks")
    utoggle(s2, "Wall Check", "aim_wall_check"); utoggle(s2, "Team Check", "aim_team_check"); utoggle(s2, "Visible Only", "aim_visible_only")
    utoggle(s2, "Target Lock", "aim_target_lock"); uslider(s2, "Lock Time", "aim_lock_time", 0, 1, 2, "s")
    local s3 = section(tAim.body, "Hitchance")
    uslider(s3, "Hitchance", "aim_hitchance", 0, 100, nil, "%"); utoggle(s3, "Backtrack", "aim_hitchance_backtrack")
    local s4 = section(tAim.body, "Resolver")
    utoggle(s4, "Resolver", "aim_resolver"); uslider(s4, "Samples", "aim_resolver_samples", 3, 15)
    uslider(s4, "Threshold", "aim_resolver_threshold", 4, 80, nil, "m")
end

do
    local s = section(tSilent.body, "Silent Aim")
    utoggle(s, "Enabled", "silent_enabled", function(v) if v then SILENT:start() else SILENT:stop() end end)
    uslider(s, "FOV", "silent_fov", 10, 400, nil, "px")
    udrop(s, "Hitpart", "silent_hitpart", {"Head","Torso","HumanoidRootPart"})
    uslider(s, "Hitchance", "silent_hitchance", 0, 100, nil, "%")
    utoggle(s, "Hitchance Fallback", "silent_hitchance_fallback")
    utoggle(s, "Resolver", "silent_resolver")
    uslider(s, "Prediction", "silent_prediction", 0, 0.5, 3, "s")
    utoggle(s, "Wall Check", "silent_wall_check"); utoggle(s, "Visible Only", "silent_visible_only")
    utoggle(s, "Team Check", "silent_team_check")
end

do
    local s = section(tRage.body, "Ragebot")
    utoggle(s, "Enabled", "rage_enabled", function(v) if v then RAGE:start() else RAGE:stop() end end)
    uslider(s, "Approach Dist", "rage_approach_dist", 5, 200, nil, "m")
    uslider(s, "Confirm Damage", "rage_confirm_dmg", 1, 200, nil, "hp")
    uslider(s, "Retreat Dist", "rage_retreat_dist", 5, 300, nil, "m")
    uslider(s, "Cooldown", "rage_cooldown", 0, 3, 2, "s")
    uslider(s, "Re-engage", "rage_reengage", 0, 5, 2, "s")
    local s2 = section(tRage.body, "HP Branch")
    uslider(s2, "HP Threshold", "rage_hp_threshold", 0, 100, nil, "%")
    uslider(s2, "HP Multiplier", "rage_hp_mult", 1, 4, 2, "x")
    uslider(s2, "Short Hop", "rage_short_hop", 2, 60, nil, "m")
    local s3 = section(tRage.body, "Auto Modules")
    utoggle(s3, "Auto Orbit", "rage_auto_orbit")
    utoggle(s3, "Auto Void", "rage_auto_void")
    utoggle(s3, "Auto Voidspam", "rage_auto_vs")
    utoggle(s3, "Auto Silent", "rage_auto_silent")
end

do
    local s = section(tVoid.body, "Void")
    utoggle(s, "Enabled", "void_enabled", function(v) if v then VOID:start() else VOID:stop() end end)
    uslider(s, "Depth", "void_depth", -2000, 0, nil, "y")
    utoggle(s, "Zero Velocity", "void_zero_vel"); utoggle(s, "CanCollide Off", "void_cancollide_off")
    utoggle(s, "HipHeight Pin", "void_hipheight_pin"); utoggle(s, "Rebind on Respawn", "void_rebind_on_spawn")
    local s2 = section(tVoid.body, "Handoff")
    utoggle(s2, "Handoff Fire", "void_handoff"); uslider(s2, "Handoff Frames", "void_handoff_frames", 1, 10)
    local s3 = section(tVoid.body, "Voidspam")
    utoggle(s3, "Voidspam", "vs_enabled", function(v) if v then VS:start() else VS:stop() end end)
    uslider(s3, "Interval", "vs_interval", 0.05, 2, 2, "s")
    uslider(s3, "Distance", "vs_distance", 1, 80, nil, "m")
    uslider(s3, "Jitter", "vs_jitter", 0, 5, 2)
    uslider(s3, "Return Delay", "vs_return_delay", 0.02, 1, 2, "s")
    local s4 = section(tVoid.body, "Orbit")
    utoggle(s4, "Orbit", "orbit_enabled", function(v) if v then ORBIT:start() else ORBIT:stop() end end)
    uslider(s4, "Radius", "orbit_radius", 4, 60, nil, "m")
    uslider(s4, "Speed", "orbit_speed", 0.5, 20, 2)
    uslider(s4, "Height", "orbit_height", -10, 10, 1)
    uslider(s4, "Jitter", "orbit_jitter", 0, 3, 2)
    utoggle(s4, "Ring", "orbit_ring_show"); ucolor(s4, "Ring Color", "orbit_ring_color")
end

do
    local s = section(tAA.body, "Anti-Aim")
    utoggle(s, "Enabled", "aa_enabled", function(v) if v then AA:start() else AA:stop() end end)
    udrop(s, "Preset", "aa_preset", {"Custom","Legit","Rage","Spin","Sway","JitterLBY","Edge"}, function(p) AA:applyPreset(p) end)
    local s2 = section(tAA.body, "Pitch")
    udrop(s2, "Pitch Mode", "aa_pitch", {"Down","Up","Zero"})
    uslider(s2, "Pitch Angle", "aa_pitch_angle", 0, 89, nil, "°")
    local s3 = section(tAA.body, "Yaw")
    udrop(s3, "Yaw Mode", "aa_yaw", {"Static","Jitter","Spin","Sway"})
    uslider(s3, "Yaw Offset", "aa_yaw_offset", 0, 360, nil, "°")
    uslider(s3, "Jitter Range", "aa_yaw_jitter", 0, 180, nil, "°")
    uslider(s3, "Spin Speed", "aa_spin_speed", 60, 2160, nil, "°/s")
    uslider(s3, "Sway Speed", "aa_sway_speed", 0.1, 10, 2)
    uslider(s3, "Sway Range", "aa_sway_range", 10, 360, nil, "°")
    local s4 = section(tAA.body, "LBY & Desync")
    udrop(s4, "LBY Mode", "aa_lby", {"None","Opposite","Flicker"})
    utoggle(s4, "Desync", "aa_desync")
    uslider(s4, "Desync Amount", "aa_desync_amount", 0, 180, nil, "°")
end

do
    local s = section(tLegit.body, "Legit Aim")
    utoggle(s, "Enabled", "legit_enabled", function(v) if v then LEGIT:start() else LEGIT:stop() end end)
    uslider(s, "Smooth", "legit_smooth", 2, 30)
    uslider(s, "FOV", "legit_fov", 5, 120, nil, "px")
    udrop(s, "Bone", "legit_bone", {"Head","Torso","HumanoidRootPart"})
    uslider(s, "Prediction", "legit_predict", 0, 0.5, 3, "s")
    utoggle(s, "Wall Check", "legit_wall_check")
    ukey(s, "Key", "legit_key")
end

do
    local s = section(tTrig.body, "Triggerbot")
    utoggle(s, "Enabled", "trig_enabled", function(v) if v then TRIG:start() else TRIG:stop() end end)
    utoggle(s, "Key Only", "trig_key_only"); ukey(s, "Key", "trig_key")
    uslider(s, "Delay", "trig_delay", 0, 0.5, 2, "s")
    utoggle(s, "Team Check", "trig_team_check"); utoggle(s, "Wall Check", "trig_wall_check")
end

do
    local s = section(tMove.body, "Movement")
    utoggle(s, "Module On", "mv_bhop", function(v) if v then MOVE:start() else MOVE:stop() end end)
    utoggle(s, "Bhop", "mv_bhop")
    utoggle(s, "Speed", "mv_speed"); uslider(s, "Speed Value", "mv_speed_val", 16, 100)
    utoggle(s, "Jump", "mv_jump"); uslider(s, "Jump Value", "mv_jump_val", 50, 300)
    utoggle(s, "Noclip", "mv_noclip")
    utoggle(s, "Infinite Jump", "mv_inf_jump")
end

do
    local s = section(tVis.body, "Visuals")
    utoggle(s, "Enabled", "vis_crosshair", function(v) if v then VIS:start() else VIS:stop() end end)
    local s2 = section(tVis.body, "Crosshair")
    utoggle(s2, "Crosshair", "vis_crosshair"); ucolor(s2, "Color", "vis_crosshair_color")
    uslider(s2, "Size", "vis_crosshair_size", 2, 30)
    uslider(s2, "Gap", "vis_crosshair_gap", 0, 20)
    uslider(s2, "Thickness", "vis_crosshair_thickness", 1, 5)
    local s3 = section(tVis.body, "Hitmarker")
    utoggle(s3, "Hitmarker", "vis_hitmark"); ucolor(s3, "Color", "vis_hitmark_color")
    uslider(s3, "Size", "vis_hitmark_size", 4, 30)
    uslider(s3, "Time", "vis_hitmark_time", 0.1, 2, 2, "s")
    local s4 = section(tVis.body, "World")
    utoggle(s4, "Fullbright", "vis_fullbright"); uslider(s4, "Brightness", "vis_fullbright_val", 1, 5, 1)
    utoggle(s4, "No Fog", "vis_no_fog")
end

do
    local s = section(tSkin.body, "Skin Changer")
    utoggle(s, "Enabled", "skin_enabled", function(v) if v then SKIN:start() else SKIN:stop() end end)
    for _, weap in ipairs({"DoubleBarrel","Revolver","TacticalShotgun","SMG","Shotgun","Knife"}) do
        utext(s, weap, F.skin_map[weap], function(t) F.skin_map[weap] = t; if LP.Character then SKIN:applyAll(LP.Character) end end)
    end
    ubtn(s, "Reapply All", function() if LP.Character then SKIN:applyAll(LP.Character) end end)
end

do
    local s = section(tFFA.body, "FFA")
    utoggle(s, "Module On", "ffa_autorespawn", function(v) if v then FFA:start() else FFA:stop() end end)
    utoggle(s, "Auto Respawn", "ffa_autorespawn")
    utoggle(s, "Auto Pickup Ammo", "ffa_auto_pickup_ammo")
    utoggle(s, "Auto Pickup HP", "ffa_auto_pickup_hp")
end

do
    local s = section(tConf.body, "Configs")
    local _, tb = utext(s, "Name", "default")
    ubtn(s, "Save", function() saveConfig(tb.Text ~= "" and tb.Text or "default") end)
    ubtn(s, "Load", function() loadConfig(tb.Text ~= "" and tb.Text or "default") end)
    ubtn(s, "List → Console", function() local l = listConfigs(); for _, n in ipairs(l) do dbg("conf", n) end; notify("Configs", #l.." found", "info") end)
end

do
    local s = section(tDbg.body, "Status")
    local status = new("TextLabel",{BackgroundColor3=T.panel3,BorderSizePixel=0,Size=UDim2.new(1,0,0,170),Font=T.fontMono,TextSize=11,TextColor3=T.text2,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Text="",RichText=true,Parent=s})
    corner(status, 4); stroke(status, T.ridge, 1); pad(status, 6, 6, 8, 8)
    task.spawn(function()
        while Gui.Parent do
            local names = {"ESP","SILENT","AIM","FOV","ORBIT","AA","VOID","VS","RAGE","LEGIT","TRIG","MOVE","VIS","SKIN","FFA"}
            local out = {}
            for _, n in ipairs(names) do
                local m = MODULES[n]; local on = m and m.running
                local col = on and "rgb(80,220,120)" or "rgb(72,72,73)"
                table.insert(out, string.format('<font color="%s">%s</font>  %s', col, n, on and "ON" or "off"))
            end
            table.insert(out, string.format('<font color="rgb(0,162,255)">silent</font> %s   <font color="rgb(0,162,255)">rage</font> %s   <font color="rgb(0,162,255)">hits</font> %d   <font color="rgb(0,162,255)">dmg</font> %.0f', SILENT.data.badge, RAGE.data.state, F._hits, F._dmg))
            status.Text = table.concat(out, "\n")
            task.wait(0.25)
        end
    end)
    local s2 = section(tDbg.body, "Console")
    local box = new("ScrollingFrame",{BackgroundColor3=T.panel3,BorderSizePixel=0,Size=UDim2.new(1,0,0,220),CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3=T.accent,Parent=s2})
    corner(box, 4); stroke(box, T.ridge, 1); pad(box, 4, 4, 6, 6); list(box, 1)
    local function append(line)
        new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,14),Font=T.fontMono,TextSize=11,TextColor3=T.text2,TextXAlignment=Enum.TextXAlignment.Left,Text=line,Parent=box})
    end
    for _, l in ipairs(DBG.lines) do append(l) end
    dbgsub(function(l) append(l); task.defer(function() box.CanvasPosition = Vector2.new(0, 1e9) end) end)
    ubtn(s2, "Clear", function() for _, c in ipairs(box:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end end)
end

do
    local s = section(tSet.body, "Interface")
    ukey(s, "Menu Key", "menu_key")
    ubtn(s, "Unload", function()
        for _, m in pairs(MODULES) do pcall(function() m:stop() end) end
        Gui:Destroy()
        notify("voidline", "unloaded", "warn")
    end)
end

activateTab("ESP")

do
    local frames, lastT = 0, tick()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local n = tick()
        if n - lastT >= 0.5 then
            HudFps.Text = "FPS "..math.floor(frames / (n - lastT))
            frames = 0; lastT = n
            local stats = game:GetService("Stats")
            local ok, net = pcall(function() return stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if ok then HudPing.Text = "P "..math.floor(net) end
        end
    end)
end

Gui.Destroying:Connect(function()
    for _, m in pairs(MODULES) do pcall(function() m:stop() end) end
    pcall(function() RunService:UnbindFromRenderStep("voidline_camcache") end)
    dbg("boot", "unmounted")
end)

dbg("boot", "mount complete — voidline "..SCRIPT_VERSION)
notify("VOIDLINE", "v"..SCRIPT_VERSION.." mounted", "good", 3)

-- auto-install silent hook at load so badge reads before toggle
if EXE.hookmetamethod then SILENT:installHook(); SILENT:setBadge("armed") else SILENT:setBadge("FALLBACK") end

-- Built by Olivia — https://discord.gg/ojailbreaks
