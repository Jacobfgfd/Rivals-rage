--// VOIDLINE // Rivals // Built by Olivia — https://discord.gg/ojailbreaks
--// loadstring(game:HttpGet("RAW_URL"))()

if game.CreatorId ~= 3461453 and not getgenv().VOIDLINE_BYPASS then
    warn("[VOIDLINE] not rivals — set getgenv().VOIDLINE_BYPASS=true to force")
end
if getgenv().VOIDLINE_LOADED then getgenv().VOIDLINE_LOADED:Destroy() end

--==[ services ]==--
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local HttpService      = game:GetService("HttpService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local GuiService       = game:GetService("GuiService")
local Stats            = game:GetService("Stats")
local CoreGui          = game:GetService("CoreGui")

local LP       = Players.LocalPlayer
local Mouse    = LP:GetMouse()
local Camera   = Workspace.CurrentCamera

--==[ safe wrappers ]==--
local function safe(fn, ...) local o={pcall(fn,...)} if o[1] then return select(2,unpack(o)) end end
local Drawing_new = Drawing and Drawing.new or function() return setmetatable({Remove=function()end,Visible=false},{__index=function()return 0 end,__newindex=function()end}) end
local hookmm       = hookmetamethod or function() end
local getconns     = getconnections or function() return {} end
local ftouch       = firetouchinterest or function() end
local clipset      = (setclipboard or (syn and syn.write_clipboard)) or function() end
local wfile        = writefile or function() end
local rfile        = readfile  or function() end
local isfile       = isfile    or function() return false end
local lsfiles      = listfiles or function() return {} end
local mkfolder     = makefolder or function() end
local getnil       = getnilinstances or function() return {} end
local protectgui   = (syn and syn.protect_gui) or protect_gui or (gethui and function(g) g.Parent=gethui() end) or function(g) g.Parent=CoreGui end

if not isfolder or not isfolder("voidline") then safe(mkfolder,"voidline") end
if not isfolder or not isfolder("voidline/configs") then safe(mkfolder,"voidline/configs") end

--==[ theme ]==--
local T = {
    bg       = Color3.fromRGB(10,10,12),
    panel    = Color3.fromRGB(19,19,22),
    inset    = Color3.fromRGB(22,22,26),
    outline  = Color3.fromRGB(23,23,29),
    stroke   = Color3.fromRGB(28,28,32),
    control  = Color3.fromRGB(32,32,36),
    accent   = Color3.fromRGB(0,162,255),
    text     = Color3.fromRGB(245,245,245),
    dim      = Color3.fromRGB(72,72,73),
    muted    = Color3.fromRGB(130,130,130),
    hover    = Color3.fromRGB(20,20,22),
    danger   = Color3.fromRGB(220,60,60),
    good     = Color3.fromRGB(80,220,120),
    black    = Color3.fromRGB(0,0,0),
    white    = Color3.fromRGB(255,255,255),
}

--==[ flags / config ]==--
local F = {
    -- rage
    rage_enabled=false, rage_mode="Silent", rage_key=Enum.KeyCode.E, rage_hold=false,
    rage_fov=120, rage_fov_show=true, rage_fov_color=T.accent,
    rage_smooth=1, rage_predict=0.165, rage_priority="FOV",
    rage_hitbox="Head", rage_wall=true, rage_visible=false, rage_team=true,
    rage_samples=8, rage_reject=6, rage_orbit=false, rage_orbit_r=10, rage_orbit_speed=22,
    rage_translocate=true, rage_melee=false, rage_backstab=true,
    rage_ignore={}, rage_priority_user={},
    -- anti-aim
    aa_enabled=false, aa_pitch="Down", aa_yaw="Backward", aa_speed=6, aa_jitter=25,
    aa_hidehead=false, aa_pause_attack=true, aa_lby=false, aa_custom_pitch=0, aa_custom_yaw=0,
    -- legit
    legit_enabled=false, legit_key=Enum.KeyCode.Q, legit_smooth=6, legit_fov=40,
    trigger_enabled=false, trigger_reaction=80, trigger_random=50, trigger_key=Enum.KeyCode.C,
    norecoil=false, nospread=false,
    -- visuals / esp
    esp_enabled=true, esp_team=false, esp_max=1200,
    esp_box=true, esp_box_mode="Full", esp_box_color=T.white, esp_box_outline=T.black,
    esp_name=true, esp_name_color=T.white,
    esp_hp=true, esp_hp_color_hi=T.good, esp_hp_color_lo=T.danger, esp_hp_number=true,
    esp_ammo=true, esp_weapon=true, esp_weapon_color=T.white,
    esp_dist=true, esp_rank=false, esp_streak=false,
    esp_deflect=true, esp_deflect_color=Color3.fromRGB(220,200,10),
    esp_headdot=false, esp_skeleton=false, esp_skeleton_color=T.white,
    esp_chams=false, esp_chams_fill=Color3.fromRGB(0,162,255), esp_chams_outline=T.white,
    esp_chams_depth=false,
    esp_font=Drawing and Drawing.Fonts and 3 or 2,
    tracer=false, tracer_origin="Bottom", tracer_color=T.accent, tracer_thickness=1,
    beams=false, beams_color=T.accent, impacts=false, impacts_color=T.accent,
    crosshair=false, cross_len=8, cross_gap=4, cross_thick=1, cross_dot=false,
    cross_rot=0, cross_bounce=false, cross_hitpulse=true, cross_color=T.accent,
    targethud=false, hitmark=true, hitmark_color=T.accent,
    vm_enabled=false, vm_fov=70, vm_ox=0, vm_oy=0, vm_oz=0,
    tp_enabled=false, tp_dist=12, world_fov=70,
    sky_preset="Default", no_fog=false, no_shake=false, no_flash=false,
    cc_enabled=false, cc_brightness=0, cc_contrast=0, cc_saturation=0, cc_tint=T.white,
    no_textures=false,
    -- void
    void_enabled=false, void_depth=50, void_cam=true, void_walk=true, void_noclip=true,
    void_handoff=true, void_box=true, void_box_color=Color3.fromRGB(0,162,255),
    void_jitter=false, void_jitter_amt=4, void_hide_mesh=false, void_freeze=false, void_zero_vel=false,
    angle_invert=false, angle_pitch=0, angle_yaw=0, spin_speed=0,
    choke_enabled=false, choke_mode="Hold", choke_lc=false, fakelag=false, fakelag_ticks=4,
    -- misc
    wspeed=false, wspeed_v=18, noclip=false, bhop=false,
    fly=false, fly_v=55, djump=false, ljump=false, ljump_mode="Strafe", ljump_force=80, ljump_up=30,
    autostrafe=false, strafe_pattern="Adaptive", strafe_i=80,
    autoloadout=false, loadout_slots={"","","",""},
    autoqueue=false,
    staff=false, staff_kw="moderator", staff_action="Notify",
    unlock_all=false,
    hit_sound=false, hit_preset="Bell", hit_vol=0.6, hit_pitch=1,
    kill_sound=false, kill_preset="Ding", kill_vol=0.6, kill_pitch=1,
    autoresp=true,
    no_killers=false, no_firedmg=false, no_oob=false,
    -- skins
    skins_enabled=true,
    skin_db="Ascension", skin_rev="Ascension", skin_shotgun="Ascension",
    skin_tac="Ascension", skin_smg="Ascension", skin_knife="Beta",
    -- ffa immortal
    ffa_enabled=false, ffa_height=60, ffa_jitter=12, ffa_vacuum=true, ffa_autofire=true,
    -- menu
    menu_key=Enum.KeyCode.RightShift, accent=T.accent,
    autosave=true,
}

--==[ util ]==--
local function new(cls, props)
    local i=Instance.new(cls)
    for k,v in pairs(props or {}) do if k~="Parent" then i[k]=v end end
    i.Parent = props and props.Parent
    return i
end
local function corner(p,r) return new("UICorner",{CornerRadius=UDim.new(0,r or 7),Parent=p}) end
local function stroke(p,c,t) return new("UIStroke",{Color=c or T.stroke,Thickness=t or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=p}) end
local function pad(p,l,r,t,b)
    return new("UIPadding",{PaddingLeft=UDim.new(0,l or 0),PaddingRight=UDim.new(0,r or 0),PaddingTop=UDim.new(0,t or 0),PaddingBottom=UDim.new(0,b or 0),Parent=p})
end
local function tween(o,ti,g) return TweenService:Create(o,TweenInfo.new(ti,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),g) end
local function round(v,d) local f=10^(d or 0) return math.floor(v*f+0.5)/f end
local function v3xz(v) return Vector3.new(v.X,0,v.Z) end
local function dist(a,b) return (a-b).Magnitude end

-- nested outline frame builder: outer 1px outline, inset inner, 1px stroke, content
local function panel(parent, pos, size, bg)
    local outer = new("Frame",{BackgroundColor3=T.outline,BorderSizePixel=0,Position=pos,Size=size,Parent=parent})
    corner(outer,7)
    local mid = new("Frame",{BackgroundColor3=bg or T.panel,BorderSizePixel=0,Position=UDim2.fromOffset(1,1),Size=UDim2.new(1,-2,1,-2),Parent=outer})
    corner(mid,7)
    stroke(mid,T.stroke,1)
    return outer, mid
end

--==[ screen ]==--
local Gui = new("ScreenGui",{Name="VOIDLINE_"..tostring(math.random(1e6,9e6)),ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=99999})
safe(protectgui,Gui)
if not Gui.Parent then Gui.Parent = LP:WaitForChild("PlayerGui") end
getgenv().VOIDLINE_LOADED = Gui

-- shadow
local shadow = new("ImageLabel",{BackgroundTransparency=1,Image="rbxassetid://5028857084",ImageColor3=T.black,ImageTransparency=0.35,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(24,24,276,276),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.fromOffset(820,545),Parent=Gui,ZIndex=0})

-- window
local win = new("Frame",{BackgroundColor3=T.outline,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.fromOffset(780,505),Parent=Gui,Active=true,ClipsDescendants=true})
corner(win,10)
local winInner = new("Frame",{BackgroundColor3=T.bg,BorderSizePixel=0,Position=UDim2.fromOffset(1,1),Size=UDim2.new(1,-2,1,-2),Parent=win})
corner(winInner,10)
stroke(winInner,T.stroke,1)

-- open anim
win.Size = UDim2.fromOffset(780*0.94, 505*0.94)
win.BackgroundTransparency = 1
winInner.BackgroundTransparency = 1
tween(win,0.18,{Size=UDim2.fromOffset(780,505),BackgroundTransparency=0}):Play()
tween(winInner,0.18,{BackgroundTransparency=0}):Play()

-- drag
do
    local dragging,dstart,wstart
    local function begin(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true dstart=input.Position wstart=win.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end
    winInner.InputBegan:Connect(begin)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local d=input.Position-dstart
            win.Position = UDim2.new(wstart.X.Scale,wstart.X.Offset+d.X,wstart.Y.Scale,wstart.Y.Offset+d.Y)
            shadow.Position = win.Position
        end
    end)
end

-- top strip
local top = new("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Size=UDim2.new(1,0,0,56),Parent=winInner})
local topRule = new("Frame",{BackgroundColor3=T.outline,BorderSizePixel=0,Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1),Parent=top})

local titleV = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(18,14),Size=UDim2.fromOffset(120,30),Font=Enum.Font.GothamBold,Text="VOID",TextColor3=T.accent,TextSize=26,TextXAlignment=Enum.TextXAlignment.Left,Parent=top})
local titleL = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(18+titleV.TextBounds.X+2,14),Size=UDim2.fromOffset(120,30),Font=Enum.Font.GothamBold,Text="LINE",TextColor3=T.white,TextSize=26,TextXAlignment=Enum.TextXAlignment.Left,Parent=top})

local ver = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-120,0,20),Size=UDim2.fromOffset(100,20),Font=Enum.Font.Code,Text="v1.0 · rivals",TextColor3=T.muted,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,Parent=top})
local fpsL = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-120,0,34),Size=UDim2.fromOffset(100,16),Font=Enum.Font.Code,Text="— fps",TextColor3=T.dim,TextSize=11,TextXAlignment=Enum.TextXAlignment.Right,Parent=top})

-- sidebar
local side = new("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Position=UDim2.fromOffset(0,56),Size=UDim2.fromOffset(196,505-56),Parent=winInner})
local sideRule = new("Frame",{BackgroundColor3=T.outline,BorderSizePixel=0,Position=UDim2.new(1,-1,0,0),Size=UDim2.new(0,1,1,0),Parent=side})

local sideList = new("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,14),Size=UDim2.new(1,-20,1,-100),Parent=side})
new("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=sideList})

local userTag = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.new(0,10,1,-70),Size=UDim2.new(1,-20,0,56),Parent=side})
corner(userTag,7) stroke(userTag,T.stroke)
new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-20,0,16),Font=Enum.Font.GothamBold,Text=LP.DisplayName,TextColor3=T.text,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=userTag})
new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,26),Size=UDim2.new(1,-20,0,14),Font=Enum.Font.Code,Text="@"..LP.Name,TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=userTag})
new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,40),Size=UDim2.new(1,-20,0,12),Font=Enum.Font.Code,Text="voidline connected",TextColor3=T.accent,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=userTag})

-- content host
local content = new("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(196,56),Size=UDim2.new(1,-196,1,-56),Parent=winInner})

--==[ tabs ]==--
local Tabs, currentTab = {}, nil
local function makeTab(name, icon)
    local btn = new("TextButton",{BackgroundColor3=T.panel,BackgroundTransparency=1,AutoButtonColor=false,BorderSizePixel=0,Size=UDim2.new(1,0,0,34),Text="",Parent=sideList})
    corner(btn,6)
    local ic = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,0),Size=UDim2.fromOffset(22,34),Font=Enum.Font.GothamBold,Text=icon or "•",TextColor3=T.muted,TextSize=16,Parent=btn})
    local lb = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(38,0),Size=UDim2.new(1,-40,1,0),Font=Enum.Font.Gotham,Text=name,TextColor3=T.muted,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=btn})

    local page = new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromScale(1,1),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3=T.accent,ScrollingDirection=Enum.ScrollingDirection.Y,Visible=false,Parent=content})
    pad(page,14,14,14,14)

    local cols = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,Parent=page})
    local col1 = new("Frame",{BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0.5,-4,0,0),AutomaticSize=Enum.AutomaticSize.Y,Parent=cols})
    local col2 = new("Frame",{BackgroundTransparency=1,Position=UDim2.new(0.5,4,0,0),Size=UDim2.new(0.5,-4,0,0),AutomaticSize=Enum.AutomaticSize.Y,Parent=cols})
    new("UIListLayout",{Padding=UDim.new(0,8),Parent=col1})
    new("UIListLayout",{Padding=UDim.new(0,8),Parent=col2})

    local tab = {btn=btn,ic=ic,lb=lb,page=page,c1=col1,c2=col2,name=name}
    btn.MouseEnter:Connect(function() if currentTab~=tab then tween(btn,0.12,{BackgroundTransparency=0,BackgroundColor3=T.hover}):Play() end end)
    btn.MouseLeave:Connect(function() if currentTab~=tab then tween(btn,0.12,{BackgroundTransparency=1}):Play() end end)
    btn.MouseButton1Click:Connect(function()
        if currentTab==tab then return end
        -- crossfade with black flash
        local flash = new("Frame",{BackgroundColor3=T.black,BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromScale(1,1),Parent=content,ZIndex=50})
        tween(flash,0.08,{BackgroundTransparency=0.4}):Play()
        task.wait(0.08)
        for _,t in ipairs(Tabs) do
            t.page.Visible=false
            tween(t.btn,0.12,{BackgroundTransparency=1}):Play()
            t.ic.TextColor3=T.muted t.lb.TextColor3=T.muted
        end
        tab.page.Visible=true
        tab.btn.BackgroundTransparency=0 tab.btn.BackgroundColor3=T.inset
        tab.ic.TextColor3=F.accent tab.lb.TextColor3=T.text
        currentTab=tab
        tween(flash,0.12,{BackgroundTransparency=1}):Play()
        task.wait(0.12) flash:Destroy()
    end)
    table.insert(Tabs,tab)
    if not currentTab then
        currentTab=tab
        page.Visible=true
        btn.BackgroundTransparency=0 btn.BackgroundColor3=T.inset
        ic.TextColor3=F.accent lb.TextColor3=T.text
    end
    return tab
end

--==[ ui kit — sections, rows, controls ]==--
local function section(parent, title)
    local outer,mid = panel(parent,UDim2.new(),UDim2.new(1,0,0,0),T.panel)
    outer.AutomaticSize = Enum.AutomaticSize.Y
    outer.Size = UDim2.new(1,0,0,0)
    local head = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,30),Parent=mid})
    local lab = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-54,1,0),Font=Enum.Font.Gotham,Text=string.upper(title),TextColor3=T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=head})
    local rule = new("Frame",{BackgroundColor3=T.outline,BorderSizePixel=0,Position=UDim2.new(0,8,1,-1),Size=UDim2.new(1,-16,0,1),Parent=head})
    -- fade toggle
    local fade = new("Frame",{BackgroundColor3=T.control,BorderSizePixel=0,Position=UDim2.new(1,-38,0.5,-8),Size=UDim2.fromOffset(26,16),Parent=head})
    corner(fade,8) stroke(fade,T.stroke)
    local fk = new("Frame",{BackgroundColor3=T.white,BorderSizePixel=0,Position=UDim2.fromOffset(12,2),Size=UDim2.fromOffset(12,12),Parent=fade})
    corner(fk,6)
    local fh = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),Parent=fade})
    local body = new("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,32),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,Parent=mid})
    pad(body,10,10,0,10)
    new("UIListLayout",{Padding=UDim.new(0,6),Parent=body})
    local collapsed=false
    fh.MouseButton1Click:Connect(function()
        collapsed=not collapsed
        tween(fade,0.15,{BackgroundColor3=collapsed and T.inset or T.control}):Play()
        tween(fk,0.15,{Position=collapsed and UDim2.fromOffset(2,2) or UDim2.fromOffset(12,2)}):Play()
        tween(body,0.2,{BackgroundTransparency=collapsed and 0.8 or 1}):Play()
        for _,c in ipairs(body:GetDescendants()) do
            if c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("TextBox") then
                tween(c,0.2,{TextTransparency=collapsed and 0.6 or 0}):Play()
            end
        end
    end)
    return body
end

local function row(parent,h)
    local f = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,h or 24),Parent=parent})
    return f
end

local function label(parent, text)
    local f = row(parent,22)
    new("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.Code,Text=text,TextColor3=T.muted,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    return f
end

local function swatch(parent, posRight, color, onChange)
    local sw = new("Frame",{BackgroundColor3=color,BorderSizePixel=0,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-posRight,0.5,0),Size=UDim2.fromOffset(40,13),Parent=parent})
    corner(sw,3) stroke(sw,T.black)
    local gloss = new("Frame",{BackgroundColor3=T.white,BackgroundTransparency=0.92,BorderSizePixel=0,Size=UDim2.new(1,-2,1,-2),Position=UDim2.fromOffset(1,1),Parent=sw})
    corner(gloss,3)
    new("UIGradient",{Color=ColorSequence.new(T.white,T.black),Rotation=90,Parent=gloss})
    local btn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),Parent=sw})
    btn.MouseButton1Click:Connect(function()
        -- quick cycle picker (full HSV popup is heavy; palette pop)
        local popup = new("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Position=UDim2.new(0,sw.AbsolutePosition.X-Gui.AbsolutePosition.X,0,sw.AbsolutePosition.Y-Gui.AbsolutePosition.Y+18),Size=UDim2.fromOffset(166,197),Parent=Gui,ZIndex=20})
        corner(popup,7) stroke(popup,T.stroke)
        local h,s,v = color:ToHSV()
        local sq = new("ImageLabel",{BackgroundColor3=Color3.fromHSV(h,1,1),BorderSizePixel=0,Image="rbxassetid://4155801252",Position=UDim2.fromOffset(8,8),Size=UDim2.fromOffset(120,120),ZIndex=21,Parent=popup})
        local sqBtn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),ZIndex=22,Parent=sq})
        local hueBar = new("Frame",{BorderSizePixel=0,Position=UDim2.fromOffset(136,8),Size=UDim2.fromOffset(16,120),ZIndex=21,Parent=popup})
        new("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),ColorSequenceKeypoint.new(0.17,Color3.fromHSV(0.17,1,1)),ColorSequenceKeypoint.new(0.33,Color3.fromHSV(0.33,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromHSV(0.5,1,1)),ColorSequenceKeypoint.new(0.66,Color3.fromHSV(0.66,1,1)),ColorSequenceKeypoint.new(0.83,Color3.fromHSV(0.83,1,1)),ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))}),Rotation=90,Parent=hueBar})
        local hueBtn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),ZIndex=22,Parent=hueBar})
        local rgbBox = new("TextBox",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.fromOffset(8,134),Size=UDim2.fromOffset(144,22),Font=Enum.Font.Code,PlaceholderText="r, g, b",Text=("%d, %d, %d"):format(color.R*255,color.G*255,color.B*255),TextColor3=T.text,TextSize=12,ZIndex=21,Parent=popup})
        corner(rgbBox,4) stroke(rgbBox,T.stroke)
        local closeBtn = new("TextButton",{BackgroundColor3=T.accent,BorderSizePixel=0,Position=UDim2.fromOffset(8,162),Size=UDim2.fromOffset(144,27),Font=Enum.Font.GothamBold,Text="apply",TextColor3=T.white,TextSize=12,ZIndex=21,Parent=popup})
        corner(closeBtn,4)
        local function refresh()
            local c = Color3.fromHSV(h,s,v)
            color = c
            sw.BackgroundColor3=c
            sq.BackgroundColor3=Color3.fromHSV(h,1,1)
            rgbBox.Text = ("%d, %d, %d"):format(c.R*255,c.G*255,c.B*255)
            if onChange then onChange(c) end
        end
        local draggingSq,draggingHue=false,false
        sqBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingSq=true end end)
        hueBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingHue=true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingSq=false draggingHue=false end end)
        UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType~=Enum.UserInputType.MouseMovement then return end
            if draggingSq then
                s=math.clamp((i.Position.X-sq.AbsolutePosition.X)/sq.AbsoluteSize.X,0,1)
                v=1-math.clamp((i.Position.Y-sq.AbsolutePosition.Y)/sq.AbsoluteSize.Y,0,1)
                refresh()
            elseif draggingHue then
                h=math.clamp((i.Position.Y-hueBar.AbsolutePosition.Y)/hueBar.AbsoluteSize.Y,0,1)
                refresh()
            end
        end)
        rgbBox.FocusLost:Connect(function()
            local r,g,b = rgbBox.Text:match("(%d+)[, ]+(%d+)[, ]+(%d+)")
            if r then color=Color3.fromRGB(tonumber(r),tonumber(g),tonumber(b)) h,s,v=color:ToHSV() refresh() end
        end)
        closeBtn.MouseButton1Click:Connect(function() popup:Destroy() end)
        refresh()
    end)
    return sw
end

local function toggle(parent, text, default, cb, opts)
    opts = opts or {}
    local r = row(parent,22)
    new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(44,0),Size=UDim2.new(1,-100,1,0),Font=Enum.Font.Code,Text=text,TextColor3=T.text,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=r})
    local bg = new("Frame",{BackgroundColor3=default and F.accent or T.control,BorderSizePixel=0,Position=UDim2.fromOffset(0,2),Size=UDim2.fromOffset(36,18),Parent=r})
    corner(bg,9) stroke(bg,T.stroke)
    local knob = new("Frame",{BackgroundColor3=T.white,BorderSizePixel=0,Position=default and UDim2.fromOffset(21,3) or UDim2.fromOffset(3,3),Size=UDim2.fromOffset(12,12),Parent=bg})
    corner(knob,6)
    local state = default or false
    local btn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),Parent=r})
    local function apply()
        tween(bg,0.14,{BackgroundColor3=state and F.accent or T.control}):Play()
        tween(knob,0.14,{Position=state and UDim2.fromOffset(21,3) or UDim2.fromOffset(3,3)}):Play()
        if cb then safe(cb,state) end
    end
    btn.MouseButton1Click:Connect(function() state=not state apply() end)
    if opts.swatch then
        swatch(r,0,opts.swatch,opts.onSwatch)
    end
    local api = {}
    function api:Set(v) state=v apply() end
    function api:Get() return state end
    return api
end

local function slider(parent, text, def, mn, mx, dec, cb)
    local r = row(parent,34)
    new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,-60,0,14),Font=Enum.Font.Code,Text=text,TextColor3=T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=r})
    local val = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-60,0,0),Size=UDim2.fromOffset(60,14),Font=Enum.Font.Code,Text=tostring(def),TextColor3=T.accent,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,Parent=r})
    local track = new("Frame",{BackgroundColor3=T.control,BorderSizePixel=0,Position=UDim2.new(0,0,0,22),Size=UDim2.new(1,0,0,4),Parent=r})
    corner(track,2)
    local fill = new("Frame",{BackgroundColor3=F.accent,BorderSizePixel=0,Size=UDim2.new((def-mn)/(mx-mn),0,1,0),Parent=track})
    corner(fill,2)
    local knob = new("Frame",{BackgroundColor3=T.white,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new((def-mn)/(mx-mn),0,0.5,0),Size=UDim2.fromOffset(12,12),Parent=track})
    corner(knob,6) stroke(knob,T.accent)
    local btn = new("TextButton",{BackgroundTransparency=1,Text="",Position=UDim2.new(0,0,0,16),Size=UDim2.new(1,0,0,16),Parent=r})
    local dragging=false
    local function set(px)
        local a = math.clamp((px - track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
        local v = round(mn+(mx-mn)*a,dec or 0)
        fill.Size = UDim2.new(a,0,1,0)
        knob.Position = UDim2.new(a,0,0.5,0)
        val.Text = tostring(v)
        if cb then safe(cb,v) end
    end
    btn.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true tween(knob,0.1,{Size=UDim2.fromOffset(14,14)}):Play() set(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then set(i.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) and dragging then
            dragging=false tween(knob,0.1,{Size=UDim2.fromOffset(12,12)}):Play()
        end
    end)
end

local function dropdown(parent, text, options, default, cb, multi)
    local r = row(parent,32)
    new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,12),Font=Enum.Font.Code,Text=text,TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=r})
    local field = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.new(0,0,0,14),Size=UDim2.new(1,0,0,18),Parent=r})
    corner(field,4) stroke(field,T.stroke)
    local lab = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(6,0),Size=UDim2.new(1,-24,1,0),Font=Enum.Font.Code,Text=type(default)=="table" and table.concat(default,", ") or tostring(default or "none"),TextColor3=T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=field})
    local ind = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-18,0,0),Size=UDim2.fromOffset(16,18),Font=Enum.Font.GothamBold,Text="+",TextColor3=T.muted,TextSize=14,Parent=field})
    local btn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),Parent=field})
    local open=false local popup
    local selected = multi and (type(default)=="table" and {} or {}) or default
    if multi and type(default)=="table" then for _,v in ipairs(default) do selected[v]=true end end
    local function refresh()
        if multi then
            local out={}
            for _,o in ipairs(options) do if selected[o] then table.insert(out,o) end end
            lab.Text = #out>0 and table.concat(out,", ") or "none"
        else
            lab.Text = tostring(selected)
        end
    end
    btn.MouseButton1Click:Connect(function()
        if open then if popup then popup:Destroy() end open=false ind.Text="+" return end
        open=true ind.Text="-"
        local h = math.min(#options*22+8,180)
        popup = new("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Size=UDim2.new(0,field.AbsoluteSize.X,0,h),Parent=Gui,ZIndex=25,ClipsDescendants=true})
        corner(popup,6) stroke(popup,T.stroke)
        local ap = field.AbsolutePosition - Gui.AbsolutePosition
        local sy = ap.Y + 20
        if sy + h > Gui.AbsoluteSize.Y then sy = ap.Y - h - 4 end
        popup.Position = UDim2.fromOffset(ap.X, sy)
        popup.Size = UDim2.fromOffset(field.AbsoluteSize.X, 0)
        tween(popup,0.15,{Size=UDim2.fromOffset(field.AbsoluteSize.X,h)}):Play()
        local sc = new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromScale(1,1),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3=T.accent,ZIndex=26,Parent=popup})
        new("UIListLayout",{Parent=sc})
        pad(sc,4,4,4,4)
        for _,opt in ipairs(options) do
            local ob = new("TextButton",{BackgroundColor3=T.inset,BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,0,22),Font=Enum.Font.Code,Text="  "..opt,TextColor3=(multi and selected[opt]) or (not multi and selected==opt) and T.accent or T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=27,Parent=sc})
            corner(ob,4)
            ob.MouseEnter:Connect(function() tween(ob,0.1,{BackgroundTransparency=0}):Play() end)
            ob.MouseLeave:Connect(function() tween(ob,0.1,{BackgroundTransparency=1}):Play() end)
            ob.MouseButton1Click:Connect(function()
                if multi then
                    selected[opt] = not selected[opt] or nil
                    ob.TextColor3 = selected[opt] and T.accent or T.text
                    local list = {}
                    for _,o in ipairs(options) do if selected[o] then table.insert(list,o) end end
                    refresh()
                    if cb then safe(cb,list) end
                else
                    selected = opt
                    refresh()
                    popup:Destroy() open=false ind.Text="+"
                    if cb then safe(cb,opt) end
                end
            end)
        end
    end)
end

local function keybind(parent, text, defaultKey, defaultMode, cb)
    local r = row(parent,22)
    new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,-100,1,0),Font=Enum.Font.Code,Text=text,TextColor3=T.text,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=r})
    local chip = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(94,18),Parent=r})
    corner(chip,4) stroke(chip,T.stroke)
    local lab = new("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.Code,Text=(defaultMode or "Toggle")..": "..(defaultKey and defaultKey.Name or "None"),TextColor3=T.text,TextSize=11,Parent=chip})
    local btn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),Parent=chip})
    local key, mode = defaultKey, defaultMode or "Toggle"
    local capturing = false
    local function refresh() lab.Text = mode..": "..(key and key.Name or "None") end
    btn.MouseButton1Click:Connect(function()
        capturing=true lab.Text=mode..": ..."
        local conn
        conn = UserInputService.InputBegan:Connect(function(i,gp)
            if gp then return end
            if i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode~=Enum.KeyCode.Unknown then
                key=i.KeyCode capturing=false conn:Disconnect() refresh() if cb then safe(cb,key,mode) end
            end
        end)
    end)
    btn.MouseButton2Click:Connect(function()
        local modes = {"Hold","Toggle","Always"}
        for i,m in ipairs(modes) do if m==mode then mode=modes[(i%3)+1] break end end
        refresh() if cb then safe(cb,key,mode) end
    end)
    return {Get=function() return key,mode end}
end

local function textbox(parent, placeholder, cb)
    local r = row(parent,30)
    local f = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Size=UDim2.new(1,0,0,26),Parent=r})
    corner(f,4) stroke(f,T.stroke)
    local tb = new("TextBox",{BackgroundTransparency=1,Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-16,1,0),Font=Enum.Font.Code,PlaceholderText=placeholder,PlaceholderColor3=T.dim,Text="",TextColor3=T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,Parent=f})
    tb.FocusLost:Connect(function(e) if cb then safe(cb,tb.Text,e) end end)
    return tb
end

local function button(parent, text, cb)
    local r = row(parent,30)
    local f = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Size=UDim2.new(1,0,0,26),Parent=r})
    corner(f,4) stroke(f,T.stroke)
    local b = new("TextButton",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.GothamBold,Text=text,TextColor3=T.text,TextSize=12,Parent=f})
    b.MouseButton1Click:Connect(function()
        tween(f,0.08,{BackgroundColor3=F.accent}):Play()
        task.delay(0.12,function() tween(f,0.15,{BackgroundColor3=T.inset}):Play() end)
        if cb then safe(cb) end
    end)
    return b
end

--==[ notifications stack ]==--
local notifHost = new("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,16,1,-16),Size=UDim2.fromOffset(210,400),Parent=Gui})
new("UIListLayout",{VerticalAlignment=Enum.VerticalAlignment.Bottom,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),Parent=notifHost})
local function notify(title, body, dur)
    dur = dur or 4
    local outer,mid = panel(notifHost,UDim2.new(),UDim2.new(1,0,0,0),T.panel)
    outer.Position = UDim2.fromOffset(-220,0)
    outer.AutomaticSize = Enum.AutomaticSize.Y
    new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,8),Size=UDim2.new(1,-20,0,14),Font=Enum.Font.GothamBold,Text=title,TextColor3=T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=mid})
    new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,24),Size=UDim2.new(1,-20,0,0),AutomaticSize=Enum.AutomaticSize.Y,Font=Enum.Font.Code,Text=body,TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=mid})
    local barBg = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.new(0,8,1,-6),Size=UDim2.new(1,-16,0,2),Parent=mid})
    local bar = new("Frame",{BackgroundColor3=F.accent,BorderSizePixel=0,Size=UDim2.new(1,0,1,0),Parent=barBg})
    pad(mid,0,0,0,10)
    tween(outer,0.25,{Position=UDim2.fromOffset(0,0)}):Play()
    tween(bar,dur,{Size=UDim2.new(0,0,1,0)}):Play()
    task.delay(dur,function()
        tween(outer,0.25,{Position=UDim2.fromOffset(-220,0)}):Play()
        task.wait(0.25) outer:Destroy()
    end)
end

--==[ drawing wrapper ]==--
local function drawText(props) local d=Drawing_new("Text") for k,v in pairs(props) do pcall(function() d[k]=v end) end return d end
local function drawLine(props) local d=Drawing_new("Line") for k,v in pairs(props) do pcall(function() d[k]=v end) end return d end
local function drawSquare(props) local d=Drawing_new("Square") for k,v in pairs(props) do pcall(function() d[k]=v end) end return d end
local function drawQuad(props) local d=Drawing_new("Quad") for k,v in pairs(props) do pcall(function() d[k]=v end) end return d end
local function drawCircle(props) local d=Drawing_new("Circle") for k,v in pairs(props) do pcall(function() d[k]=v end) end return d end

--==[ TABS BUILD ]==--
local tRage    = makeTab("Rage",      "◢")
local tAA      = makeTab("Anti-Aim",  "◇")
local tLegit   = makeTab("Legit",     "◉")
local tVisuals = makeTab("Visuals",   "◈")
local tVoid    = makeTab("Void",      "☠")
local tMisc    = makeTab("Misc",      "⚙")
local tSkins   = makeTab("Skins",     "✦")
local tFFA     = makeTab("FFA",       "♆")
local tConf    = makeTab("Configs",   "❐")
local tSet     = makeTab("Settings",  "⚒")

--==[ RAGE ]==--
do
    local s1 = section(tRage.c1,"Rage Main")
    toggle(s1,"Enabled",F.rage_enabled,function(v) F.rage_enabled=v end)
    keybind(s1,"Aim Key",F.rage_key,F.rage_hold and "Hold" or "Toggle",function(k,m) F.rage_key=k F.rage_hold=(m=="Hold") end)
    dropdown(s1,"Mode",{"Silent","Snap"},F.rage_mode,function(v) F.rage_mode=v end)
    dropdown(s1,"Priority",{"FOV","Distance","Lowest HP","Crosshair"},F.rage_priority,function(v) F.rage_priority=v end)
    dropdown(s1,"Hitbox",{"Head","Torso","Random"},F.rage_hitbox,function(v) F.rage_hitbox=v end)
    toggle(s1,"Team Check",F.rage_team,function(v) F.rage_team=v end)
    toggle(s1,"Wall Check",F.rage_wall,function(v) F.rage_wall=v end)
    toggle(s1,"Visible Only",F.rage_visible,function(v) F.rage_visible=v end)
    slider(s1,"FOV",F.rage_fov,10,600,0,function(v) F.rage_fov=v end)
    toggle(s1,"Draw FOV",F.rage_fov_show,function(v) F.rage_fov_show=v end,{swatch=F.rage_fov_color,onSwatch=function(c) F.rage_fov_color=c end})
    slider(s1,"Smoothness",F.rage_smooth,1,10,2,function(v) F.rage_smooth=v end)
    slider(s1,"Prediction",F.rage_predict,0,0.5,3,function(v) F.rage_predict=v end)

    local s2 = section(tRage.c2,"Resolver")
    slider(s2,"Sample Count",F.rage_samples,2,30,0,function(v) F.rage_samples=v end)
    slider(s2,"Reject Threshold",F.rage_reject,0.5,50,1,function(v) F.rage_reject=v end)
    toggle(s2,"Translocate Counter",F.rage_translocate,function(v) F.rage_translocate=v end)

    local s3 = section(tRage.c2,"Aura")
    toggle(s3,"Orbit Aura",F.rage_orbit,function(v) F.rage_orbit=v end)
    slider(s3,"Orbit Radius",F.rage_orbit_r,2,40,1,function(v) F.rage_orbit_r=v end)
    slider(s3,"Orbit Speed",F.rage_orbit_speed,1,60,0,function(v) F.rage_orbit_speed=v end)
    toggle(s3,"Melee Aura",F.rage_melee,function(v) F.rage_melee=v end)
    toggle(s3,"Backstab Facing",F.rage_backstab,function(v) F.rage_backstab=v end)

    local s4 = section(tRage.c1,"Target List")
    local inp = textbox(s4,"priority username",function(txt)
        if txt~="" then table.insert(F.rage_priority_user,txt) notify("priority",txt.." added",2) end
    end)
    button(s4,"add priority",function() if inp.Text~="" then table.insert(F.rage_priority_user,inp.Text) inp.Text="" end end)
    local ignoreInp = textbox(s4,"ignore username",function(txt) if txt~="" then table.insert(F.rage_ignore,txt) end end)
    button(s4,"add ignore",function() if ignoreInp.Text~="" then table.insert(F.rage_ignore,ignoreInp.Text) ignoreInp.Text="" end end)
    button(s4,"clear lists",function() F.rage_ignore={} F.rage_priority_user={} notify("lists","cleared",2) end)
end

--==[ ANTI-AIM ]==--
do
    local s1 = section(tAA.c1,"Anti-Aim")
    toggle(s1,"Enabled",F.aa_enabled,function(v) F.aa_enabled=v end)
    dropdown(s1,"Pitch",{"Down","Up","Jitter","Random","Zero","Custom"},F.aa_pitch,function(v) F.aa_pitch=v end)
    dropdown(s1,"Yaw",{"Backward","Left","Right","Spin","Sway","Jitter","Random","Custom"},F.aa_yaw,function(v) F.aa_yaw=v end)
    slider(s1,"Speed",F.aa_speed,1,30,0,function(v) F.aa_speed=v end)
    slider(s1,"Jitter Range",F.aa_jitter,0,180,0,function(v) F.aa_jitter=v end)
    slider(s1,"Custom Pitch",F.aa_custom_pitch,-90,90,0,function(v) F.aa_custom_pitch=v end)
    slider(s1,"Custom Yaw",F.aa_custom_yaw,-180,180,0,function(v) F.aa_custom_yaw=v end)
    local s2 = section(tAA.c2,"Extra")
    toggle(s2,"Hide Head",F.aa_hidehead,function(v) F.aa_hidehead=v end)
    toggle(s2,"Pause On Attack",F.aa_pause_attack,function(v) F.aa_pause_attack=v end)
    toggle(s2,"LBY Breaker",F.aa_lby,function(v) F.aa_lby=v end)
end

--==[ LEGIT ]==--
do
    local s1 = section(tLegit.c1,"Aimbot")
    toggle(s1,"Enabled",F.legit_enabled,function(v) F.legit_enabled=v end)
    keybind(s1,"Aim Key",F.legit_key,"Hold",function(k) F.legit_key=k end)
    slider(s1,"Smoothness",F.legit_smooth,1,20,1,function(v) F.legit_smooth=v end)
    slider(s1,"FOV",F.legit_fov,5,200,0,function(v) F.legit_fov=v end)
    local s2 = section(tLegit.c2,"Triggerbot")
    toggle(s2,"Enabled",F.trigger_enabled,function(v) F.trigger_enabled=v end)
    keybind(s2,"Trigger Key",F.trigger_key,"Hold",function(k) F.trigger_key=k end)
    slider(s2,"Reaction (ms)",F.trigger_reaction,0,500,0,function(v) F.trigger_reaction=v end)
    slider(s2,"Random (ms)",F.trigger_random,0,300,0,function(v) F.trigger_random=v end)
    local s3 = section(tLegit.c1,"Weapon")
    toggle(s3,"No Recoil",F.norecoil,function(v) F.norecoil=v end)
    toggle(s3,"No Spread",F.nospread,function(v) F.nospread=v end)
end

--==[ VISUALS ]==--
do
    local s1 = section(tVisuals.c1,"ESP Main")
    toggle(s1,"Enabled",F.esp_enabled,function(v) F.esp_enabled=v end)
    toggle(s1,"Team ESP",F.esp_team,function(v) F.esp_team=v end)
    slider(s1,"Max Distance",F.esp_max,50,5000,0,function(v) F.esp_max=v end)
    toggle(s1,"Box",F.esp_box,function(v) F.esp_box=v end,{swatch=F.esp_box_color,onSwatch=function(c) F.esp_box_color=c end})
    dropdown(s1,"Box Mode",{"Full","Corner"},F.esp_box_mode,function(v) F.esp_box_mode=v end)
    toggle(s1,"Name",F.esp_name,function(v) F.esp_name=v end,{swatch=F.esp_name_color,onSwatch=function(c) F.esp_name_color=c end})
    toggle(s1,"Health Bar",F.esp_hp,function(v) F.esp_hp=v end,{swatch=F.esp_hp_color_hi,onSwatch=function(c) F.esp_hp_color_hi=c end})
    toggle(s1,"HP Number",F.esp_hp_number,function(v) F.esp_hp_number=v end)
    toggle(s1,"Weapon",F.esp_weapon,function(v) F.esp_weapon=v end,{swatch=F.esp_weapon_color,onSwatch=function(c) F.esp_weapon_color=c end})
    toggle(s1,"Ammo Bar",F.esp_ammo,function(v) F.esp_ammo=v end)
    toggle(s1,"Distance",F.esp_dist,function(v) F.esp_dist=v end)
    toggle(s1,"Rank",F.esp_rank,function(v) F.esp_rank=v end)
    toggle(s1,"Streak",F.esp_streak,function(v) F.esp_streak=v end)
    toggle(s1,"Deflecting Flag",F.esp_deflect,function(v) F.esp_deflect=v end,{swatch=F.esp_deflect_color,onSwatch=function(c) F.esp_deflect_color=c end})
    toggle(s1,"Head Dot",F.esp_headdot,function(v) F.esp_headdot=v end)
    toggle(s1,"Skeleton",F.esp_skeleton,function(v) F.esp_skeleton=v end,{swatch=F.esp_skeleton_color,onSwatch=function(c) F.esp_skeleton_color=c end})

    local s2 = section(tVisuals.c2,"Chams")
    toggle(s2,"Chams",F.esp_chams,function(v) F.esp_chams=v end,{swatch=F.esp_chams_fill,onSwatch=function(c) F.esp_chams_fill=c end})
    toggle(s2,"Depth Check",F.esp_chams_depth,function(v) F.esp_chams_depth=v end)

    local s3 = section(tVisuals.c2,"Tracers")
    toggle(s3,"Tracer",F.tracer,function(v) F.tracer=v end,{swatch=F.tracer_color,onSwatch=function(c) F.tracer_color=c end})
    dropdown(s3,"Origin",{"Bottom","Top","Mouse"},F.tracer_origin,function(v) F.tracer_origin=v end)
    slider(s3,"Thickness",F.tracer_thickness,1,5,0,function(v) F.tracer_thickness=v end)
    toggle(s3,"Bullet Beams",F.beams,function(v) F.beams=v end,{swatch=F.beams_color,onSwatch=function(c) F.beams_color=c end})
    toggle(s3,"Impact Markers",F.impacts,function(v) F.impacts=v end)

    local s4 = section(tVisuals.c1,"Crosshair")
    toggle(s4,"Enabled",F.crosshair,function(v) F.crosshair=v end,{swatch=F.cross_color,onSwatch=function(c) F.cross_color=c end})
    slider(s4,"Length",F.cross_len,2,40,0,function(v) F.cross_len=v end)
    slider(s4,"Gap",F.cross_gap,0,20,0,function(v) F.cross_gap=v end)
    slider(s4,"Thickness",F.cross_thick,1,4,0,function(v) F.cross_thick=v end)
    toggle(s4,"Dot",F.cross_dot,function(v) F.cross_dot=v end)
    slider(s4,"Rotation",F.cross_rot,0,360,0,function(v) F.cross_rot=v end)
    toggle(s4,"Bounce",F.cross_bounce,function(v) F.cross_bounce=v end)
    toggle(s4,"Hit Pulse",F.cross_hitpulse,function(v) F.cross_hitpulse=v end)

    local s5 = section(tVisuals.c2,"World")
    toggle(s5,"Target HUD",F.targethud,function(v) F.targethud=v end)
    toggle(s5,"Hitmarker",F.hitmark,function(v) F.hitmark=v end,{swatch=F.hitmark_color,onSwatch=function(c) F.hitmark_color=c end})
    toggle(s5,"Viewmodel Override",F.vm_enabled,function(v) F.vm_enabled=v end)
    slider(s5,"VM FOV",F.vm_fov,30,120,0,function(v) F.vm_fov=v end)
    slider(s5,"VM X",F.vm_ox,-10,10,1,function(v) F.vm_ox=v end)
    slider(s5,"VM Y",F.vm_oy,-10,10,1,function(v) F.vm_oy=v end)
    slider(s5,"VM Z",F.vm_oz,-10,10,1,function(v) F.vm_oz=v end)
    toggle(s5,"Third Person",F.tp_enabled,function(v) F.tp_enabled=v end)
    slider(s5,"TP Distance",F.tp_dist,2,40,0,function(v) F.tp_dist=v end)
    slider(s5,"World FOV",F.world_fov,30,120,0,function(v) F.world_fov=v end)
    dropdown(s5,"Sky",{"Default","Night","Sunset","Space"},F.sky_preset,function(v) F.sky_preset=v end)
    toggle(s5,"No Fog",F.no_fog,function(v) F.no_fog=v end)
    toggle(s5,"No Shake",F.no_shake,function(v) F.no_shake=v end)
    toggle(s5,"No Flash",F.no_flash,function(v) F.no_flash=v end)
    toggle(s5,"No Textures",F.no_textures,function(v) F.no_textures=v end)
end

--==[ VOID ]==--
do
    local s1 = section(tVoid.c1,"Fake Position")
    toggle(s1,"Enabled",F.void_enabled,function(v) F.void_enabled=v end)
    slider(s1,"Depth",F.void_depth,10,500,0,function(v) F.void_depth=v end)
    toggle(s1,"Surface Camera",F.void_cam,function(v) F.void_cam=v end)
    toggle(s1,"Dynamic Walk",F.void_walk,function(v) F.void_walk=v end)
    toggle(s1,"Auto Noclip",F.void_noclip,function(v) F.void_noclip=v end)
    toggle(s1,"Shot Handoff",F.void_handoff,function(v) F.void_handoff=v end)
    toggle(s1,"Ghost Box",F.void_box,function(v) F.void_box=v end,{swatch=F.void_box_color,onSwatch=function(c) F.void_box_color=c end})
    toggle(s1,"Panic Jitter",F.void_jitter,function(v) F.void_jitter=v end)
    slider(s1,"Jitter Amount",F.void_jitter_amt,1,20,0,function(v) F.void_jitter_amt=v end)
    toggle(s1,"Hide Meshes",F.void_hide_mesh,function(v) F.void_hide_mesh=v end)
    toggle(s1,"Freeze Pose",F.void_freeze,function(v) F.void_freeze=v end)
    toggle(s1,"Zero Velocity",F.void_zero_vel,function(v) F.void_zero_vel=v end)

    local s2 = section(tVoid.c2,"Angles")
    toggle(s2,"Invert Pitch",F.angle_invert,function(v) F.angle_invert=v end)
    slider(s2,"Pitch",F.angle_pitch,-90,90,0,function(v) F.angle_pitch=v end)
    slider(s2,"Yaw",F.angle_yaw,-180,180,0,function(v) F.angle_yaw=v end)
    slider(s2,"Spin Speed",F.spin_speed,0,60,0,function(v) F.spin_speed=v end)

    local s3 = section(tVoid.c2,"Packet")
    toggle(s3,"Choke",F.choke_enabled,function(v) F.choke_enabled=v end)
    dropdown(s3,"Mode",{"Hold","Dynamic","Burst"},F.choke_mode,function(v) F.choke_mode=v end)
    toggle(s3,"LC Breaker",F.choke_lc,function(v) F.choke_lc=v end)
    toggle(s3,"Fake Lag",F.fakelag,function(v) F.fakelag=v end)
    slider(s3,"Fake Ticks",F.fakelag_ticks,1,16,0,function(v) F.fakelag_ticks=v end)
end

--==[ MISC ]==--
do
    local s1 = section(tMisc.c1,"Movement")
    toggle(s1,"Walk Speed",F.wspeed,function(v) F.wspeed=v end)
    slider(s1,"Speed",F.wspeed_v,16,200,0,function(v) F.wspeed_v=v end)
    toggle(s1,"Noclip",F.noclip,function(v) F.noclip=v end)
    toggle(s1,"Bunny Hop",F.bhop,function(v) F.bhop=v end)
    toggle(s1,"Fly",F.fly,function(v) F.fly=v end)
    slider(s1,"Fly Speed",F.fly_v,10,500,0,function(v) F.fly_v=v end)
    toggle(s1,"Double Jump",F.djump,function(v) F.djump=v end)
    toggle(s1,"Long Jump",F.ljump,function(v) F.ljump=v end)
    dropdown(s1,"LJ Mode",{"Strafe","Hop","Launch"},F.ljump_mode,function(v) F.ljump_mode=v end)
    slider(s1,"LJ Force",F.ljump_force,10,300,0,function(v) F.ljump_force=v end)
    slider(s1,"LJ Up",F.ljump_up,0,200,0,function(v) F.ljump_up=v end)
    toggle(s1,"Auto Strafe",F.autostrafe,function(v) F.autostrafe=v end)
    dropdown(s1,"Strafe Pattern",{"Adaptive","Forward","Sideways"},F.strafe_pattern,function(v) F.strafe_pattern=v end)
    slider(s1,"Strafe Intensity",F.strafe_i,0,100,0,function(v) F.strafe_i=v end)

    local s2 = section(tMisc.c2,"Loadout / Queue")
    toggle(s2,"Auto Loadout",F.autoloadout,function(v) F.autoloadout=v end)
    for i=1,4 do
        dropdown(s2,"Slot "..i,{"Revolver","DoubleBarrel","SMG","Shotgun","TacticalShotgun","Knife","None"},F.loadout_slots[i] or "None",function(v) F.loadout_slots[i]=v end)
    end
    toggle(s2,"Auto Queue",F.autoqueue,function(v) F.autoqueue=v end)
    toggle(s2,"Auto Respawn",F.autoresp,function(v) F.autoresp=v end)

    local s3 = section(tMisc.c1,"Staff Detector")
    toggle(s3,"Enabled",F.staff,function(v) F.staff=v end)
    textbox(s3,"keyword",function(t) F.staff_kw=t end)
    dropdown(s3,"Action",{"Notify","Hop","Kick"},F.staff_action,function(v) F.staff_action=v end)

    local s4 = section(tMisc.c2,"Sounds / World")
    toggle(s4,"Unlock All",F.unlock_all,function(v) F.unlock_all=v end)
    toggle(s4,"Hit Sound",F.hit_sound,function(v) F.hit_sound=v end)
    dropdown(s4,"Hit Preset",{"Bell","Skeet","Metal","Pop"},F.hit_preset,function(v) F.hit_preset=v end)
    slider(s4,"Hit Volume",F.hit_vol,0,1,2,function(v) F.hit_vol=v end)
    slider(s4,"Hit Pitch",F.hit_pitch,0.5,2,2,function(v) F.hit_pitch=v end)
    toggle(s4,"Kill Sound",F.kill_sound,function(v) F.kill_sound=v end)
    dropdown(s4,"Kill Preset",{"Ding","Boom","Vine"},F.kill_preset,function(v) F.kill_preset=v end)
    toggle(s4,"Remove Killers",F.no_killers,function(v) F.no_killers=v end)
    toggle(s4,"No Fire Damage",F.no_firedmg,function(v) F.no_firedmg=v end)
    toggle(s4,"Prevent OOB",F.no_oob,function(v) F.no_oob=v end)
end

--==[ SKINS ]==--
do
    local s1 = section(tSkins.c1,"Skin Changer")
    toggle(s1,"Enabled",F.skins_enabled,function(v) F.skins_enabled=v end)
    textbox(s1,"DoubleBarrel skin",function(t) if t~="" then F.skin_db=t end end)
    textbox(s1,"Revolver skin",function(t) if t~="" then F.skin_rev=t end end)
    textbox(s1,"Shotgun skin",function(t) if t~="" then F.skin_shotgun=t end end)
    textbox(s1,"TacticalShotgun skin",function(t) if t~="" then F.skin_tac=t end end)
    textbox(s1,"SMG skin",function(t) if t~="" then F.skin_smg=t end end)
    textbox(s1,"Knife skin",function(t) if t~="" then F.skin_knife=t end end)
    button(s1,"reapply",function() if LP.Character then applySkins() end end) -- forward ref
end

--==[ FFA ]==--
do
    local s1 = section(tFFA.c1,"FFA Immortal")
    toggle(s1,"Enabled",F.ffa_enabled,function(v) F.ffa_enabled=v end)
    slider(s1,"Float Height",F.ffa_height,20,200,0,function(v) F.ffa_height=v end)
    slider(s1,"Jitter",F.ffa_jitter,0,40,0,function(v) F.ffa_jitter=v end)
    toggle(s1,"Vacuum Drops",F.ffa_vacuum,function(v) F.ffa_vacuum=v end)
    toggle(s1,"Auto Fire (while held)",F.ffa_autofire,function(v) F.ffa_autofire=v end)
end

--==[ CONFIGS ]==--
local configList
do
    local s1 = section(tConf.c1,"Configs")
    local nameBox = textbox(s1,"config name",function() end)
    configList = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Size=UDim2.new(1,0,0,120),Parent=s1})
    corner(configList,4) stroke(configList,T.stroke)
    local sc = new("ScrollingFrame",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3=T.accent,Parent=configList})
    local layout = new("UIListLayout",{Padding=UDim.new(0,2),Parent=sc})
    pad(sc,4,4,4,4)
    local selected = nil
    local function rebuild()
        for _,c in ipairs(sc:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _,f in ipairs(safe(lsfiles,"voidline/configs") or {}) do
            local nm = f:match("([^/\\]+)%.json$")
            if nm then
                local b = new("TextButton",{BackgroundColor3=T.panel,BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,0,22),Font=Enum.Font.Code,Text="  "..nm,TextColor3=T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=sc})
                corner(b,4)
                b.MouseEnter:Connect(function() tween(b,0.1,{BackgroundTransparency=0}):Play() end)
                b.MouseLeave:Connect(function() if selected~=nm then tween(b,0.1,{BackgroundTransparency=1}):Play() end end)
                b.MouseButton1Click:Connect(function() selected=nm nameBox.Text=nm end)
            end
        end
    end
    local function serialize()
        local out={}
        for k,v in pairs(F) do
            local tp=type(v)
            if tp=="boolean" or tp=="number" or tp=="string" then out[k]=v
            elseif typeof(v)=="Color3" then out[k]={_c=true,r=v.R,g=v.G,b=v.B}
            elseif typeof(v)=="EnumItem" then out[k]={_e=true,t=tostring(v.EnumType),n=v.Name}
            elseif tp=="table" then out[k]=v end
        end
        return HttpService:JSONEncode(out)
    end
    local function deserialize(json)
        local ok,data = pcall(HttpService.JSONDecode,HttpService,json)
        if not ok then return end
        for k,v in pairs(data) do
            if type(v)=="table" and v._c then F[k]=Color3.new(v.r,v.g,v.b)
            elseif type(v)=="table" and v._e then F[k]=Enum[v.t:gsub("Enum%.","")][v.n]
            else F[k]=v end
        end
    end
    button(s1,"save",function() local n=nameBox.Text if n=="" then return end safe(wfile,"voidline/configs/"..n..".json",serialize()) rebuild() notify("config","saved "..n,2) end)
    button(s1,"load",function() local n=selected or nameBox.Text if n=="" or not safe(isfile,"voidline/configs/"..n..".json") then return end deserialize(safe(rfile,"voidline/configs/"..n..".json")) notify("config","loaded "..n,2) end)
    button(s1,"delete",function() local n=selected or nameBox.Text if n=="" then return end safe(delfile,"voidline/configs/"..n..".json") rebuild() notify("config","deleted "..n,2) end)
    button(s1,"export clipboard",function() safe(clipset,serialize()) notify("config","exported to clipboard",2) end)
    button(s1,"import clipboard",function() local g=getclipboard or (syn and syn.get_clipboard) if g then deserialize(g()) notify("config","imported",2) end end)
    button(s1,"reset",function()
        for k,v in pairs(F) do if type(v)=="boolean" then F[k]=false end end
        notify("config","flags reset",2)
    end)
    rebuild()
end

--==[ SETTINGS ]==--
do
    local s1 = section(tSet.c1,"Menu")
    local accentToggle = toggle(s1,"Accent",true,function() end,{swatch=F.accent,onSwatch=function(c)
        F.accent=c
        -- recolor live
        for _,d in ipairs(Gui:GetDescendants()) do
            if d:IsA("Frame") and d.BackgroundColor3==T.accent then d.BackgroundColor3=c end
        end
        T.accent=c
    end})
    keybind(s1,"Menu Key",F.menu_key,"Toggle",function(k) F.menu_key=k end)
    toggle(s1,"Autosave",F.autosave,function(v) F.autosave=v end)
    button(s1,"unload",function()
        getgenv().VOIDLINE_LOADED=nil
        Gui:Destroy()
    end)
    local s2 = section(tSet.c2,"Info")
    new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,100),Font=Enum.Font.Code,Text="VOIDLINE v1.0\nbuilt by olivia\ndiscord.gg/ojailbreaks\n\nmenu key toggles the window\nrage lock on aim key\nconfigs save as json",TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Parent=s2})
end

--==[ FLOATING: keybind widget ]==--
local kbWidget
do
    local outer,mid = panel(Gui,UDim2.new(0,16,0.5,-30),UDim2.fromOffset(180,60),T.panel)
    kbWidget = outer
    new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,4),Size=UDim2.new(1,-20,0,14),Font=Enum.Font.GothamBold,Text="KEYBINDS",TextColor3=T.text,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=mid})
    local body = new("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,20),Size=UDim2.new(1,-20,1,-24),Parent=mid})
    new("UIListLayout",{Parent=body})
    local lbl = new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,14),Font=Enum.Font.Code,Text="— no active binds",TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=body})
    -- simple drag
    local drag,start,sp
    outer.Active=true
    outer.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true start=i.Position sp=outer.Position end end)
    outer.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-start
            outer.Position = UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
    outer.Visible = false
    task.spawn(function()
        while Gui.Parent do
            local lines={}
            if F.rage_enabled then table.insert(lines,"rage: "..(F.rage_hold and "hold" or "toggle").." "..F.rage_key.Name) end
            if F.legit_enabled then table.insert(lines,"aim: hold "..F.legit_key.Name) end
            if F.trigger_enabled then table.insert(lines,"trig: hold "..F.trigger_key.Name) end
            lbl.Text = #lines>0 and table.concat(lines,"\n") or "— no active binds"
            outer.Size = UDim2.fromOffset(180, 24+#lines*14)
            task.wait(0.4)
        end
    end)
end

--==[ FLOATING: target hud ]==--
local tHud, tHudState
do
    local outer,mid = panel(Gui,UDim2.new(1,-240,0.5,-60),UDim2.fromOffset(220,120),T.panel)
    tHud = outer
    tHudState = {}
    tHudState.name = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-24,0,16),Font=Enum.Font.GothamBold,Text="no target",TextColor3=T.text,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=mid})
    tHudState.sub = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,26),Size=UDim2.new(1,-24,0,14),Font=Enum.Font.Code,RichText=true,Text="",TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=mid})
    local hpbg = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.fromOffset(12,48),Size=UDim2.new(1,-24,0,6),Parent=mid}) corner(hpbg,3)
    tHudState.hp = new("Frame",{BackgroundColor3=T.good,BorderSizePixel=0,Size=UDim2.new(1,0,1,0),Parent=hpbg}) corner(tHudState.hp,3)
    local ratiobg = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.fromOffset(12,60),Size=UDim2.new(1,-24,0,6),Parent=mid}) corner(ratiobg,3)
    tHudState.ratio = new("Frame",{BackgroundColor3=T.accent,BorderSizePixel=0,Size=UDim2.new(0.5,0,1,0),Parent=ratiobg}) corner(tHudState.ratio,3)
    local slots = new("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,74),Size=UDim2.new(1,-24,0,32),Parent=mid})
    new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),Parent=slots})
    tHudState.weapons = {}
    for i=1,4 do
        local s = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Size=UDim2.fromOffset(32,32),Parent=slots}) corner(s,4) stroke(s,T.stroke)
        local t = new("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.Code,Text="",TextColor3=T.muted,TextSize=10,Parent=s})
        tHudState.weapons[i]=t
    end
    outer.Visible=false
    local drag,start,sp
    outer.Active=true
    outer.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true start=i.Position sp=outer.Position end end)
    outer.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-start
            outer.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end

--==[ MOBILE OPEN ]==--
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    local pill = new("TextButton",{BackgroundColor3=T.panel,BorderSizePixel=0,Position=UDim2.new(0.5,-30,0,8),Size=UDim2.fromOffset(60,24),Font=Enum.Font.GothamBold,Text="OPEN",TextColor3=T.text,TextSize=12,Parent=Gui})
    corner(pill,12) stroke(pill,T.stroke)
    pill.MouseButton1Click:Connect(function() win.Visible = not win.Visible end)
end

--==[ FEATURE LOGIC ]==--

-- player caches
local espObjs = {}
local function clearEsp(plr)
    local o = espObjs[plr]
    if not o then return end
    for _,d in pairs(o.draw or {}) do safe(d.Remove,d) end
    if o.cham1 then safe(o.cham1.Destroy,o.cham1) end
    if o.cham2 then safe(o.cham2.Destroy,o.cham2) end
    espObjs[plr]=nil
end
local function getChar(plr) return plr.Character end
local function getHrp(c) return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum(c) return c and c:FindFirstChildOfClass("Humanoid") end
local function getHead(c) return c and c:FindFirstChild("Head") end
local function isEnemy(plr) return plr.Team==nil or plr.Team~=LP.Team end

-- resolver buffers
local resolver = {}
local function sampleRoot(plr)
    local c = getChar(plr); local h = getHrp(c); if not h then return end
    local buf = resolver[plr]
    if not buf then buf={pos={},vel={},i=1} resolver[plr]=buf end
    buf.pos[buf.i] = h.Position
    buf.vel[buf.i] = h.AssemblyLinearVelocity or Vector3.zero
    buf.i = buf.i%math.max(1,F.rage_samples)+1
end
local function medianV3(list)
    local xs,ys,zs={},{},{}
    for _,v in ipairs(list) do table.insert(xs,v.X) table.insert(ys,v.Y) table.insert(zs,v.Z) end
    table.sort(xs) table.sort(ys) table.sort(zs)
    local n=#xs; if n==0 then return nil end
    local m=math.max(1,math.floor(n/2))
    return Vector3.new(xs[m],ys[m],zs[m])
end
local function resolvePos(plr)
    local buf = resolver[plr]; if not buf or #buf.pos==0 then local c=getChar(plr) return c and getHrp(c) and getHrp(c).Position end
    local m = medianV3(buf.pos); if not m then return end
    local kept={}
    for _,p in ipairs(buf.pos) do if (p-m).Magnitude<=F.rage_reject then table.insert(kept,p) end end
    local med2 = medianV3(kept) or m
    local vmed = medianV3(buf.vel) or Vector3.zero
    return med2 + vmed*F.rage_predict
end

-- target selection
local function wallCheck(fromPos, toPos, charIgnore)
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {Camera, LP.Character, charIgnore}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local r = Workspace:Raycast(fromPos,(toPos-fromPos),rp)
    return r==nil
end
local function worldToScreen(v) local p,on=Camera:WorldToViewportPoint(v) return Vector2.new(p.X,p.Y),on,p.Z end
local function screenDist(v) local s,on=worldToScreen(v) if not on then return math.huge end local c=Camera.ViewportSize/2 return (s-c).Magnitude end

local function pickTarget()
    local bestPlr,bestScore=nil,math.huge
    local myChar = LP.Character; local myHrp = getHrp(myChar); if not myHrp then return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local skip=false
            for _,ig in ipairs(F.rage_ignore) do if plr.Name:lower():find(ig:lower()) then skip=true break end end
            if F.rage_team and not isEnemy(plr) then skip=true end
            if not skip then
                local c=getChar(plr); local h=getHrp(c); local hum=getHum(c)
                if h and hum and hum.Health>0 then
                    local pos = resolvePos(plr) or h.Position
                    local on = select(2,worldToScreen(pos))
                    local sdist = screenDist(pos)
                    if on and sdist<=F.rage_fov then
                        local vis = true
                        if F.rage_visible or F.rage_wall then vis = wallCheck(Camera.CFrame.Position,pos,c) end
                        if vis or not F.rage_visible then
                            local score
                            if F.rage_priority=="FOV" then score=sdist
                            elseif F.rage_priority=="Distance" then score=(myHrp.Position-pos).Magnitude
                            elseif F.rage_priority=="Lowest HP" then score=hum.Health
                            elseif F.rage_priority=="Crosshair" then score=sdist
                            else score=sdist end
                            for _,pr in ipairs(F.rage_priority_user) do if plr.Name:lower():find(pr:lower()) then score=score*0.1 end end
                            if score<bestScore then bestScore=score bestPlr=plr end
                        end
                    end
                end
            end
        end
    end
    return bestPlr
end

local function getAimPart(char)
    if F.rage_hitbox=="Head" then return getHead(char) or getHrp(char) end
    if F.rage_hitbox=="Torso" then return getHrp(char) end
    local parts={getHead(char),getHrp(char),char:FindFirstChild("LeftFoot"),char:FindFirstChild("RightFoot")}
    local avail={} for _,p in ipairs(parts) do if p then table.insert(avail,p) end end
    return avail[math.random(1,#avail)]
end

-- aim key state
local aimActive=false
UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==F.menu_key then win.Visible=not win.Visible end
    if i.KeyCode==F.rage_key and F.rage_enabled then
        if F.rage_hold then aimActive=true else aimActive=not aimActive end
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.KeyCode==F.rage_key and F.rage_hold then aimActive=false end
end)

-- ESP build
local function buildEsp(plr)
    if espObjs[plr] then return espObjs[plr] end
    local o = {draw={}}
    o.draw.box      = drawSquare({Visible=false,Color=F.esp_box_color,Thickness=1,Filled=false})
    o.draw.boxOut   = drawSquare({Visible=false,Color=T.black,Thickness=3,Filled=false})
    o.draw.name     = drawText({Visible=false,Center=true,Color=F.esp_name_color,Size=13,Outline=true,Font=F.esp_font})
    o.draw.hpBg     = drawLine({Visible=false,Color=T.black,Thickness=3})
    o.draw.hp       = drawLine({Visible=false,Color=F.esp_hp_color_hi,Thickness=1})
    o.draw.hpTxt    = drawText({Visible=false,Center=true,Color=T.white,Size=11,Outline=true,Font=F.esp_font})
    o.draw.ammoBg   = drawLine({Visible=false,Color=T.black,Thickness=3})
    o.draw.ammo     = drawLine({Visible=false,Color=F.accent,Thickness=1})
    o.draw.weap     = drawText({Visible=false,Center=true,Color=F.esp_weapon_color,Size=11,Outline=true,Font=F.esp_font})
    o.draw.dist     = drawText({Visible=false,Center=true,Color=T.white,Size=11,Outline=true,Font=F.esp_font})
    o.draw.extra    = drawText({Visible=false,Center=true,Color=F.esp_deflect_color,Size=11,Outline=true,Font=F.esp_font})
    o.draw.headdot  = drawCircle({Visible=false,Color=F.esp_box_color,Thickness=1,NumSides=12,Filled=false,Radius=3})
    o.draw.tracer   = drawLine({Visible=false,Color=F.tracer_color,Thickness=F.tracer_thickness})
    espObjs[plr]=o
    return o
end

Players.PlayerRemoving:Connect(clearEsp)

-- ESP render
local function cornerLines(s,t) -- corner mode helper
    -- s = squarePos, sz = size; we'll draw 8 small lines
end
local skeletonBones = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}

local skeletonLines = setmetatable({},{__index=function(t,k) local l=drawLine({Visible=false,Thickness=1,Color=F.esp_skeleton_color}) rawset(t,k,l) return l end})

-- CHAMS (highlight)
local function ensureChams(plr)
    local o = buildEsp(plr); local c=getChar(plr); if not c then return end
    if not o.highlight or not o.highlight.Parent then
        o.highlight = Instance.new("Highlight")
        o.highlight.FillColor = F.esp_chams_fill
        o.highlight.OutlineColor = F.esp_chams_outline
        o.highlight.DepthMode = F.esp_chams_depth and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
        o.highlight.Adornee = c
        o.highlight.Parent = c
    end
    o.highlight.FillColor = F.esp_chams_fill
    o.highlight.OutlineColor = F.esp_chams_outline
    o.highlight.DepthMode = F.esp_chams_depth and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
end
local function killChams(plr)
    local o = espObjs[plr]; if o and o.highlight then o.highlight:Destroy() o.highlight=nil end
end

-- FOV drawing
local fovCircle = drawCircle({Visible=false,Thickness=1,NumSides=64,Color=F.rage_fov_color,Filled=false,Radius=F.rage_fov})

-- Crosshair drawing
local cross = {
    t = drawLine({Visible=false,Thickness=F.cross_thick,Color=F.cross_color}),
    b = drawLine({Visible=false,Thickness=F.cross_thick,Color=F.cross_color}),
    l = drawLine({Visible=false,Thickness=F.cross_thick,Color=F.cross_color}),
    r = drawLine({Visible=false,Thickness=F.cross_thick,Color=F.cross_color}),
    d = drawCircle({Visible=false,Thickness=1,NumSides=8,Radius=1,Filled=true,Color=F.cross_color}),
}
local crossBounce = 0

-- Hit marker drawing
local hm = {
    l1 = drawLine({Visible=false,Thickness=1,Color=F.hitmark_color}),
    l2 = drawLine({Visible=false,Thickness=1,Color=F.hitmark_color}),
    l3 = drawLine({Visible=false,Thickness=1,Color=F.hitmark_color}),
    l4 = drawLine({Visible=false,Thickness=1,Color=F.hitmark_color}),
}
local hmTime = 0

-- Void ghost box
local ghostBox = drawSquare({Visible=false,Thickness=1,Color=F.void_box_color,Filled=false})

-- FFA state
local realRootCFrame
local ffaMuted = {}
local function muteDrop(obj)
    if ffaMuted[obj] then return end
    ffaMuted[obj]=true
    for _,c in ipairs(obj:GetDescendants()) do
        if c:IsA("BasePart") or c:IsA("MeshPart") or c:IsA("UnionOperation") then pcall(function() c.Transparency=1 end) end
        if c:IsA("ParticleEmitter") or c:IsA("BillboardGui") or c:IsA("SurfaceGui") or c:IsA("SelectionBox") or c:IsA("Beam") or c:IsA("Trail") then pcall(function() c.Enabled=false end) end
    end
    pcall(function() obj.Transparency=1 end)
end

-- Skins
local handlemap = {DB_HANDLE="DoubleBarrel",REV_HANDLE="Revolver"}
local function skinNameFor(weap)
    if weap=="DoubleBarrel" then return F.skin_db end
    if weap=="Revolver" then return F.skin_rev end
    if weap=="Shotgun" then return F.skin_shotgun end
    if weap=="TacticalShotgun" then return F.skin_tac end
    if weap=="SMG" then return F.skin_smg end
end
local function getWrap(weap,skin)
    local wraps = ReplicatedStorage:FindFirstChild("Wraps"); if not wraps then return end
    local folder = wraps:FindFirstChild("["..weap.."]"); if not folder then return end
    return folder:FindFirstChild(skin)
end
local function applyOnHolder(holder, skinmodel, isknife)
    local handle = holder:FindFirstChild("Handle"); if not handle or not handle:IsA("BasePart") then return end
    local old = holder:FindFirstChild("SkinModel"); if old then old:Destroy() end
    local clone = skinmodel:Clone(); clone.Name="SkinModel"
    if clone:IsA("Model") and not clone.PrimaryPart then
        local f = clone:FindFirstChildWhichIsA("BasePart"); if f then clone.PrimaryPart=f end
    end
    for _,p in ipairs(clone:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide=false p.Anchored=false p.Massless=true end
        if isknife and p:IsA("MeshPart") then
            local sa = p:FindFirstChildOfClass("SurfaceAppearance"); if sa then sa:Destroy() end
            if p.TextureID=="" then
                local n=p.Name:lower()
                if n:find("box") or n:find("cube") or n:find("part") or n:find("hit") then p.Transparency=1 end
            end
        end
    end
    clone.Parent = holder
    if clone:IsA("Model") then clone:PivotTo(handle.CFrame) end
    for _,p in ipairs(clone:GetDescendants()) do
        if p:IsA("BasePart") then
            local w = Instance.new("WeldConstraint"); w.Part0=handle; w.Part1=p; w.Parent=handle
        end
    end
    handle.Transparency = 1
end
function applySkins()
    if not F.skins_enabled then return end
    local c = LP.Character; if not c then return end
    for _,tool in ipairs(c:GetChildren()) do
        if tool:IsA("Tool") then
            local w = tool.Name:match("^%[(.+)%]$")
            if w then local sk=skinNameFor(w); if sk and sk~="" then local m=getWrap(w,sk); if m then applyOnHolder(tool,m,false) end end
            elseif tool.Name=="[Knife]" then
                local knives=ReplicatedStorage:FindFirstChild("Knives")
                if knives and F.skin_knife~="" then local m=knives:FindFirstChild(F.skin_knife); if m then applyOnHolder(tool,m,true) end end
            end
        end
    end
    for hfn,_ in pairs(handlemap) do
        local f=c:FindFirstChild(hfn); if f then local w=handlemap[hfn]; local sk=skinNameFor(w); if sk and sk~="" then local m=getWrap(w,sk); if m then applyOnHolder(f,m,false) end end end
    end
end

local function hookCharacter(char)
    char.ChildAdded:Connect(function(ch)
        if ch:IsA("Tool") or handlemap[ch.Name] then task.wait(0.1) applySkins() end
    end)
    local hum = char:WaitForChild("Humanoid",5)
    if hum then
        hum.Died:Connect(function()
            if not F.autoresp then return end
            task.wait(0.3)
            local rem = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Duels") and ReplicatedStorage.Remotes.Duels:FindFirstChild("RespawnNow")
            if rem and rem:IsA("RemoteEvent") then
                for _=1,10 do
                    local c2 = LP.Character; local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
                    if h2 and h2.Health>0 then break end
                    safe(rem.FireServer,rem)
                    task.wait(0.5)
                end
            end
        end)
    end
    task.defer(applySkins)
end
LP.CharacterAdded:Connect(hookCharacter)
if LP.Character then hookCharacter(LP.Character) end

--==[ MAIN LOOP ]==--
local lastHit = 0
local fpsAccum, fpsCount, fpsT = 0,0,0
local spinAcc = 0

local mainConn = RunService.RenderStepped:Connect(function(dt)
    -- fps
    fpsAccum = fpsAccum + dt; fpsCount = fpsCount + 1
    if fpsAccum>=0.5 then fpsL.Text = ("%d fps"):format(fpsCount/fpsAccum) fpsAccum=0 fpsCount=0 end

    -- sample resolver
    for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP then sampleRoot(plr) end end

    -- FOV circle
    local vp = Camera.ViewportSize/2
    fovCircle.Position = vp
    fovCircle.Radius = F.rage_fov
    fovCircle.Color = F.rage_fov_color
    fovCircle.Visible = F.rage_enabled and F.rage_fov_show

    -- crosshair
    if F.crosshair then
        local g = F.cross_gap; local l=F.cross_len; local bounce = F.cross_bounce and math.sin(tick()*4)*2 or 0
        local len = l + bounce
        cross.t.Visible=true cross.b.Visible=true cross.l.Visible=true cross.r.Visible=true
        cross.t.From=vp+Vector2.new(0,-g) cross.t.To=vp+Vector2.new(0,-g-len)
        cross.b.From=vp+Vector2.new(0,g)  cross.b.To=vp+Vector2.new(0,g+len)
        cross.l.From=vp+Vector2.new(-g,0) cross.l.To=vp+Vector2.new(-g-len,0)
        cross.r.From=vp+Vector2.new(g,0)  cross.r.To=vp+Vector2.new(g+len,0)
        for _,k in ipairs({"t","b","l","r"}) do cross[k].Color=F.cross_color cross[k].Thickness=F.cross_thick end
        cross.d.Position=vp cross.d.Visible=F.cross_dot cross.d.Color=F.cross_color
    else
        for _,k in ipairs({"t","b","l","r","d"}) do cross[k].Visible=false end
    end

    -- hitmarker decay
    if F.hitmark and tick()-hmTime<0.15 then
        local s = 10
        for _,k in ipairs({"l1","l2","l3","l4"}) do hm[k].Color=F.hitmark_color end
        hm.l1.Visible=true hm.l1.From=vp+Vector2.new(-s,-s) hm.l1.To=vp+Vector2.new(-3,-3)
        hm.l2.Visible=true hm.l2.From=vp+Vector2.new(s,-s)  hm.l2.To=vp+Vector2.new(3,-3)
        hm.l3.Visible=true hm.l3.From=vp+Vector2.new(-s,s)  hm.l3.To=vp+Vector2.new(-3,3)
        hm.l4.Visible=true hm.l4.From=vp+Vector2.new(s,s)   hm.l4.To=vp+Vector2.new(3,3)
    else
        for _,k in ipairs({"l1","l2","l3","l4"}) do hm[k].Visible=false end
    end

    -- ESP
    local myChar = LP.Character
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local c = getChar(plr); local h=getHrp(c); local hum=getHum(c); local head=getHead(c)
            local o = buildEsp(plr)
            local show = F.esp_enabled and c and h and hum and hum.Health>0 and (F.esp_team or isEnemy(plr))
            if show then
                local hp = hum.Health; local max = hum.MaxHealth
                local p,on,depth = worldToScreen(h.Position)
                local tdist = myChar and getHrp(myChar) and (getHrp(myChar).Position-h.Position).Magnitude or 0
                if on and tdist<=F.esp_max then
                    -- bbox via head + feet approximation
                    local topP = head and select(1,worldToScreen(head.Position+Vector3.new(0,0.8,0))) or (p+Vector2.new(0,-30))
                    local bottomP = select(1,worldToScreen(h.Position+Vector3.new(0,-3,0)))
                    local height = math.abs(bottomP.Y-topP.Y)
                    local width = height*0.55
                    local boxPos = Vector2.new(topP.X-width/2, topP.Y)
                    local boxSize = Vector2.new(width,height)

                    if F.esp_box then
                        o.draw.box.Visible=true o.draw.boxOut.Visible=true
                        o.draw.box.Position=boxPos o.draw.box.Size=boxSize o.draw.box.Color=F.esp_box_color
                        o.draw.boxOut.Position=boxPos o.draw.boxOut.Size=boxSize
                    else o.draw.box.Visible=false o.draw.boxOut.Visible=false end

                    if F.esp_name then
                        o.draw.name.Visible=true o.draw.name.Position=boxPos+Vector2.new(width/2,-14) o.draw.name.Text=plr.DisplayName o.draw.name.Color=F.esp_name_color
                    else o.draw.name.Visible=false end

                    if F.esp_hp then
                        local a = math.clamp(hp/max,0,1)
                        o.draw.hpBg.Visible=true o.draw.hp.Visible=true
                        o.draw.hpBg.From = boxPos+Vector2.new(-5,0); o.draw.hpBg.To = boxPos+Vector2.new(-5,height)
                        o.draw.hp.From = boxPos+Vector2.new(-5,height*(1-a)); o.draw.hp.To = boxPos+Vector2.new(-5,height)
                        o.draw.hp.Color = F.esp_hp_color_lo:Lerp(F.esp_hp_color_hi,a)
                        if F.esp_hp_number then o.draw.hpTxt.Visible=true o.draw.hpTxt.Position=boxPos+Vector2.new(-14,height-14) o.draw.hpTxt.Text=tostring(math.floor(hp)) else o.draw.hpTxt.Visible=false end
                    else o.draw.hpBg.Visible=false o.draw.hp.Visible=false o.draw.hpTxt.Visible=false end

                    local extras = {}
                    if F.esp_dist then table.insert(extras,("%dm"):format(tdist)) end
                    local tool = c:FindFirstChildOfClass("Tool")
                    if F.esp_weapon and tool then table.insert(extras,tool.Name:gsub("[%[%]]","")) end
                    if #extras>0 then
                        o.draw.weap.Visible=true o.draw.weap.Position=boxPos+Vector2.new(width/2,height+2) o.draw.weap.Text=table.concat(extras," · ") o.draw.weap.Color=F.esp_weapon_color
                    else o.draw.weap.Visible=false end
                    o.draw.dist.Visible=false

                    if F.esp_headdot and head then
                        local hp2,on2 = worldToScreen(head.Position)
                        o.draw.headdot.Visible=on2 o.draw.headdot.Position=hp2 o.draw.headdot.Color=F.esp_box_color
                    else o.draw.headdot.Visible=false end

                    if F.tracer then
                        local origin = F.tracer_origin=="Top" and Vector2.new(vp.X,0) or F.tracer_origin=="Mouse" and Vector2.new(Mouse.X,Mouse.Y) or Vector2.new(vp.X,Camera.ViewportSize.Y)
                        o.draw.tracer.Visible=true o.draw.tracer.From=origin o.draw.tracer.To=p o.draw.tracer.Color=F.tracer_color o.draw.tracer.Thickness=F.tracer_thickness
                    else o.draw.tracer.Visible=false end

                    if F.esp_chams then ensureChams(plr) else killChams(plr) end
                else
                    for _,d in pairs(o.draw) do d.Visible=false end
                    killChams(plr)
                end
            else
                for _,d in pairs(o.draw) do d.Visible=false end
                killChams(plr)
            end
        end
    end

    -- rage aim
    if F.rage_enabled and aimActive and myChar then
        local t = pickTarget()
        if t then
            local c=getChar(t); local part = c and getAimPart(c)
            if part then
                local pos = resolvePos(t) or part.Position
                if F.rage_mode=="Silent" then
                    local lookAt = CFrame.new(Camera.CFrame.Position, pos)
                    Camera.CFrame = Camera.CFrame:Lerp(lookAt, 1/math.max(1,F.rage_smooth))
                    -- fire via mouse1click if executor supports
                    safe(mouse1click)
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position,pos)
                end
                -- hud
                if F.targethud then
                    tHud.Visible=true
                    local hum=getHum(c)
                    tHudState.name.Text = t.DisplayName
                    tHudState.sub.Text = ("<font color=\"#828282\">lvl</font> %d  <font color=\"#828282\">·</font>  %dm"):format(0, (getHrp(myChar).Position-pos).Magnitude)
                    tHudState.hp.Size = UDim2.new(hum and math.clamp(hum.Health/hum.MaxHealth,0,1) or 0,0,1,0)
                end
                hmTime = tick()
            else
                tHud.Visible = F.targethud and false or tHud.Visible
            end
        else
            if F.targethud then tHud.Visible=false end
        end
    else
        if not F.targethud then tHud.Visible=false end
    end

    -- orbit aura
    if F.rage_orbit and F.rage_enabled and myChar then
        local hrp = getHrp(myChar)
        if hrp then
            local t = pickTarget()
            if t then
                local tc=getChar(t); local th=tc and getHrp(tc)
                if th then
                    spinAcc = spinAcc + dt*F.rage_orbit_speed
                    local off = Vector3.new(math.cos(spinAcc),0,math.sin(spinAcc))*F.rage_orbit_r
                    hrp.CFrame = CFrame.new(th.Position+off, th.Position)
                end
            end
        end
    end

    -- legit aim
    if F.legit_enabled and UserInputService:IsKeyDown(F.legit_key) and myChar then
        local bestPlr,bestDist=nil,math.huge
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LP and isEnemy(plr) then
                local c=getChar(plr); local hd=getHead(c); local hum=getHum(c)
                if hd and hum and hum.Health>0 then
                    local sd = screenDist(hd.Position)
                    if sd<F.legit_fov and sd<bestDist then bestDist=sd bestPlr=plr end
                end
            end
        end
        if bestPlr then
            local hd = getHead(getChar(bestPlr))
            if hd then
                local target = CFrame.new(Camera.CFrame.Position, hd.Position)
                Camera.CFrame = Camera.CFrame:Lerp(target, 1/math.max(1,F.legit_smooth))
            end
        end
    end

    -- triggerbot
    if F.trigger_enabled and UserInputService:IsKeyDown(F.trigger_key) then
        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances={myChar}
        rp.FilterType=Enum.RaycastFilterType.Exclude
        local r = Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector*300, rp)
        if r and r.Instance then
            local plr = Players:GetPlayerFromCharacter(r.Instance:FindFirstAncestorOfClass("Model"))
            if plr and isEnemy(plr) then
                task.wait((F.trigger_reaction+math.random(0,F.trigger_random))/1000)
                safe(mouse1click)
            end
        end
    end

    -- anti-aim
    if F.aa_enabled and myChar then
        local hrp = getHrp(myChar); if hrp then
            local pitch = 0
            if F.aa_pitch=="Down" then pitch=math.rad(89)
            elseif F.aa_pitch=="Up" then pitch=math.rad(-89)
            elseif F.aa_pitch=="Jitter" then pitch=math.rad(math.sin(tick()*F.aa_speed)*89)
            elseif F.aa_pitch=="Random" then pitch=math.rad(math.random(-89,89))
            elseif F.aa_pitch=="Zero" then pitch=0
            elseif F.aa_pitch=="Custom" then pitch=math.rad(F.aa_custom_pitch) end
            local yaw = 0
            if F.aa_yaw=="Backward" then yaw=math.rad(180)
            elseif F.aa_yaw=="Left" then yaw=math.rad(-90)
            elseif F.aa_yaw=="Right" then yaw=math.rad(90)
            elseif F.aa_yaw=="Spin" then yaw=tick()*F.aa_speed
            elseif F.aa_yaw=="Sway" then yaw=math.sin(tick()*F.aa_speed)*math.rad(F.aa_jitter)
            elseif F.aa_yaw=="Jitter" then yaw=math.rad(math.random(-F.aa_jitter,F.aa_jitter))
            elseif F.aa_yaw=="Random" then yaw=math.rad(math.random(-180,180))
            elseif F.aa_yaw=="Custom" then yaw=math.rad(F.aa_custom_yaw) end
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(pitch,yaw,0)
        end
    end

    -- void fake position
    if F.void_enabled and myChar then
        local hrp = getHrp(myChar)
        if hrp then
            if not realRootCFrame then realRootCFrame = hrp.CFrame end
            local base = realRootCFrame.Position
            local jx = F.void_jitter and math.sin(tick()*8)*F.void_jitter_amt or 0
            local jz = F.void_jitter and math.cos(tick()*8)*F.void_jitter_amt or 0
            hrp.CFrame = CFrame.new(base.X+jx, base.Y-F.void_depth, base.Z+jz)
            if F.void_zero_vel then hrp.AssemblyLinearVelocity = Vector3.zero end
            if F.void_cam then Camera.CFrame = CFrame.new(base+Vector3.new(0,3,0), base+Camera.CFrame.LookVector) end
            if F.void_box then
                local p,on = worldToScreen(base)
                if on then
                    ghostBox.Visible=true
                    ghostBox.Size=Vector2.new(30,60)
                    ghostBox.Position=Vector2.new(p.X-15,p.Y-30)
                    ghostBox.Color=F.void_box_color
                end
            else ghostBox.Visible=false end
        end
    else
        realRootCFrame=nil
        ghostBox.Visible=false
    end

    -- noclip
    if F.noclip or F.void_noclip and F.void_enabled then
        if myChar then for _,p in ipairs(myChar:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
    end

    -- walk speed / jump
    if F.wspeed and myChar then local h=getHum(myChar); if h then h.WalkSpeed=F.wspeed_v end end

    -- fly
    if F.fly and myChar then
        local hrp=getHrp(myChar); local hum=getHum(myChar)
        if hrp and hum then
            hum.PlatformStand=true
            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move=move+Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move=move-Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move=move-Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move=move+Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move=move+Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move=move-Vector3.new(0,1,0) end
            hrp.AssemblyLinearVelocity = move.Magnitude>0 and move.Unit*F.fly_v or Vector3.new(0,0,0)
        end
    end

    -- bhop
    if F.bhop and myChar then
        local h=getHum(myChar)
        if h and h:GetState()==Enum.HumanoidStateType.Landed then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end

    -- FFA immortal
    if F.ffa_enabled and myChar then
        local hrp = getHrp(myChar)
        if hrp then
            local base = hrp.Position
            local jx = math.sin(tick()*6)*F.ffa_jitter
            local jz = math.cos(tick()*5.3)*F.ffa_jitter
            hrp.CFrame = CFrame.new(base.X+jx, (realRootCFrame and realRootCFrame.Position.Y or base.Y)+F.ffa_height, base.Z+jz)
            if F.ffa_vacuum then
                for _,obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name=="_drop" and obj:IsA("BasePart") then
                        obj.Anchored=true
                        obj.CFrame = CFrame.new(hrp.Position+Vector3.new(0,math.sin(tick()*8)*3,0))
                        muteDrop(obj)
                    end
                end
            end
            if F.ffa_autofire and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                safe(mouse1click)
            end
        end
    end

    -- camera fov
    if F.world_fov~=70 then Camera.FieldOfView=F.world_fov end
end)

-- lighting / world tweaks reactor
task.spawn(function()
    while Gui.Parent do
        if F.no_fog then Lighting.FogEnd=1e6 end
        if F.sky_preset~="Default" then
            Lighting.ClockTime = F.sky_preset=="Night" and 0 or F.sky_preset=="Sunset" and 17 or F.sky_preset=="Space" and 2 or 14
        end
        task.wait(1)
    end
end)

-- tool bullet hook for impacts / beams
Workspace.DescendantAdded:Connect(function(d)
    if F.beams and d:IsA("BasePart") and (d.Name=="Bullet" or d.Name=="Projectile") then
        local line = drawLine({Visible=true,Thickness=1,Color=F.beams_color})
        local start = d.Position
        task.spawn(function()
            while d.Parent do
                local a,ona = worldToScreen(start)
                local b,onb = worldToScreen(d.Position)
                if ona and onb then line.From=a line.To=b end
                task.wait()
            end
            line:Remove()
        end)
    end
end)

-- autosave
task.spawn(function()
    while Gui.Parent do task.wait(30) if F.autosave then safe(wfile,"voidline/configs/_autosave.json",HttpService:JSONEncode({F_autosave=true})) end end
end)

-- staff detector
task.spawn(function()
    while Gui.Parent do
        if F.staff then
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and (p.Name:lower():find(F.staff_kw:lower()) or p.DisplayName:lower():find(F.staff_kw:lower())) then
                    if F.staff_action=="Notify" then notify("staff","spotted "..p.Name,5)
                    elseif F.staff_action=="Kick" then LP:Kick("voidline — staff detected")
                    elseif F.staff_action=="Hop" then safe(function() game:GetService("TeleportService"):Teleport(game.PlaceId,LP) end) end
                end
            end
        end
        task.wait(3)
    end
end)

-- cleanup
Gui.Destroying:Connect(function()
    mainConn:Disconnect()
    for _,o in pairs(espObjs) do for _,d in pairs(o.draw) do safe(d.Remove,d) end if o.highlight then o.highlight:Destroy() end end
    for _,d in ipairs({fovCircle,cross.t,cross.b,cross.l,cross.r,cross.d,hm.l1,hm.l2,hm.l3,hm.l4,ghostBox}) do safe(d.Remove,d) end
end)

notify("VOIDLINE","loaded · menu key: "..F.menu_key.Name,4)
notify("credits","built by olivia · discord.gg/ojailbreaks",6)
-- built by olivia — https://discord.gg/ojailbreaks
