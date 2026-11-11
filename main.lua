--// VOIDLINE v2 // Rivals // Built by Olivia — https://discord.gg/ojailbreaks
--// loadstring(game:HttpGet("RAW_URL"))()

if getgenv().VOIDLINE_LOADED then pcall(function() getgenv().VOIDLINE_LOADED:Destroy() end) end

--==[ services ]==--
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local HttpService      = game:GetService("HttpService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Stats            = game:GetService("Stats")
local CoreGui          = game:GetService("CoreGui")
local VirtualInput     = game:FindService("VirtualInputManager")
local VirtualUser      = game:FindService("VirtualUser")

local LP      = Players.LocalPlayer
local Mouse   = LP:GetMouse()
local Camera  = Workspace.CurrentCamera

--==[ safe wrappers ]==--
local function safe(fn, ...) if not fn then return end local o={pcall(fn,...)} if o[1] then return select(2,unpack(o)) end end
local Drawing_ok   = Drawing ~= nil
local Drawing_new  = Drawing_ok and Drawing.new or function() return setmetatable({Remove=function()end,Visible=false},{__index=function()return 0 end,__newindex=function()end}) end
local hookmm       = hookmetamethod
local getnamecall  = getnamecallmethod
local checkcall    = checkcaller or function() return false end
local newcclosure  = newcclosure or function(f) return f end
local clipset      = setclipboard or (syn and syn.write_clipboard) or function() end
local clipget      = getclipboard or (syn and syn.get_clipboard) or function() return "" end
local wfile        = writefile  or function() end
local rfile        = readfile   or function() end
local isfile_      = isfile     or function() return false end
local lsfiles      = listfiles  or function() return {} end
local mkfolder     = makefolder or function() end
local protectgui   = (syn and syn.protect_gui) or protect_gui or (gethui and function(g) g.Parent=gethui() end) or function(g) g.Parent=CoreGui end

if not isfolder or not isfolder("voidline") then safe(mkfolder,"voidline") end
if not isfolder or not isfolder("voidline/configs") then safe(mkfolder,"voidline/configs") end

--==[ theme ]==--
local T = {
    bg=Color3.fromRGB(10,10,12), panel=Color3.fromRGB(19,19,22),
    inset=Color3.fromRGB(22,22,26), outline=Color3.fromRGB(23,23,29),
    stroke=Color3.fromRGB(28,28,32), control=Color3.fromRGB(32,32,36),
    accent=Color3.fromRGB(0,162,255), text=Color3.fromRGB(245,245,245),
    dim=Color3.fromRGB(72,72,73), muted=Color3.fromRGB(130,130,130),
    hover=Color3.fromRGB(20,20,22), danger=Color3.fromRGB(220,60,60),
    good=Color3.fromRGB(80,220,120), black=Color3.fromRGB(0,0,0), white=Color3.fromRGB(255,255,255),
}

--==[ flags ]==--
local F = {
    -- aim core
    aim_enabled=false, aim_mode="Camera", aim_key=Enum.KeyCode.E, aim_hold=true,
    aim_fov=120, aim_fov_show=true, aim_fov_color=T.accent,
    aim_smooth=3, aim_predict=0.165,
    aim_priority="FOV", aim_hitbox="Head",
    aim_wall=true, aim_visible=false, aim_team=true,
    aim_pause_menu=true,
    -- silent
    silent_enabled=false, silent_hitchance=100,
    -- resolver
    res_samples=8, res_reject=6, res_translocate=true,
    -- orbit
    orbit_enabled=false, orbit_r=10, orbit_speed=22, orbit_show=true, orbit_color=T.accent,
    -- ragebot FSM
    rage_enabled=false, rage_engage=80, rage_approach_delay=0.08,
    rage_confirm_window=0.45, rage_retreat=40, rage_cooldown=0.6,
    rage_hp_threshold=0.5, rage_hp_mult=2.5, rage_short_hop=8,
    rage_auto_orbit=true, rage_auto_void=true,
    -- void / fake pos
    void_enabled=false, void_depth=50, void_stay=true, void_cam=true,
    void_noclip=true, void_zero_vel=true, void_box=true, void_box_color=T.accent,
    void_jitter=false, void_jitter_amt=4, void_hide_mesh=false, void_freeze=false,
    -- voidspam
    vs_enabled=false, vs_retreat=35, vs_jitter=6, vs_depth=40, vs_panic=false, vs_outofsight=true,
    -- anti-aim
    aa_enabled=false, aa_pitch="Down", aa_yaw="Backward", aa_speed=6, aa_jitter=25,
    aa_hidehead=false, aa_pause_attack=true, aa_lby=false, aa_custom_pitch=0, aa_custom_yaw=0,
    -- legit
    legit_enabled=false, legit_key=Enum.KeyCode.Q, legit_smooth=6, legit_fov=40,
    trigger_enabled=false, trigger_reaction=80, trigger_random=50, trigger_key=Enum.KeyCode.C,
    norecoil=false, nospread=false,
    -- esp
    esp_enabled=true, esp_team=false, esp_max=1200,
    esp_box=true, esp_box_mode="Full", esp_box_color=T.white,
    esp_name=true, esp_name_color=T.white,
    esp_hp=true, esp_hp_hi=T.good, esp_hp_lo=T.danger, esp_hp_num=true,
    esp_ammo=true, esp_weapon=true, esp_weapon_color=T.white,
    esp_dist=true, esp_headdot=false, esp_skeleton=false, esp_skeleton_color=T.white,
    esp_chams=false, esp_chams_fill=T.accent, esp_chams_outline=T.white, esp_chams_depth=false,
    tracer=false, tracer_origin="Bottom", tracer_color=T.accent, tracer_thickness=1,
    crosshair=false, cross_len=8, cross_gap=4, cross_thick=1, cross_dot=false,
    cross_rot=0, cross_bounce=false, cross_hitpulse=true, cross_color=T.accent,
    targethud=true, hitmark=true, hitmark_color=T.accent,
    vm_enabled=false, vm_fov=70, tp_enabled=false, tp_dist=12, world_fov=70,
    sky_preset="Default", no_fog=false, no_shake=false, no_flash=false, no_textures=false,
    -- misc
    wspeed=false, wspeed_v=18, noclip=false, bhop=false,
    fly=false, fly_v=55, djump=false, ljump=false, ljump_force=80, ljump_up=30,
    autostrafe=false, strafe_i=80,
    autoresp=true,
    staff=false, staff_kw="moderator", staff_action="Notify",
    hit_sound=false, hit_vol=0.6,
    -- skins
    skins_enabled=true,
    skin_db="Ascension", skin_rev="Ascension", skin_shotgun="Ascension",
    skin_tac="Ascension", skin_smg="Ascension", skin_knife="Beta",
    -- debug
    debug_enabled=false,
    -- menu
    menu_key=Enum.KeyCode.RightShift, accent=T.accent, autosave=true,
    -- runtime
    _hits=0, _misses=0, _rage_state="IDLE", _silent_live=false,
    rage_priority_user={}, rage_ignore={},
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
local function pad(p,l,r,t,b) return new("UIPadding",{PaddingLeft=UDim.new(0,l or 0),PaddingRight=UDim.new(0,r or 0),PaddingTop=UDim.new(0,t or 0),PaddingBottom=UDim.new(0,b or 0),Parent=p}) end
local function tween(o,ti,g) return TweenService:Create(o,TweenInfo.new(ti,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),g) end
local function round(v,d) local f=10^(d or 0) return math.floor(v*f+0.5)/f end

local function panel(parent,pos,size,bg)
    local outer = new("Frame",{BackgroundColor3=T.outline,BorderSizePixel=0,Position=pos,Size=size,Parent=parent})
    corner(outer,7)
    local mid = new("Frame",{BackgroundColor3=bg or T.panel,BorderSizePixel=0,Position=UDim2.fromOffset(1,1),Size=UDim2.new(1,-2,1,-2),Parent=outer})
    corner(mid,7) stroke(mid,T.stroke,1)
    return outer, mid
end

local DEBUG_LOG = {}
local function dbg(...)
    if not F.debug_enabled then return end
    local s = table.concat({...}," ")
    table.insert(DEBUG_LOG,("[%s] %s"):format(os.date("%H:%M:%S"),s))
    if #DEBUG_LOG>60 then table.remove(DEBUG_LOG,1) end
end

--==[ screen ]==--
local Gui = new("ScreenGui",{Name="VOIDLINE_"..tostring(math.random(1e6,9e6)),ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=99999})
safe(protectgui,Gui)
if not Gui.Parent then Gui.Parent = LP:WaitForChild("PlayerGui") end
getgenv().VOIDLINE_LOADED = Gui

local shadow = new("ImageLabel",{BackgroundTransparency=1,Image="rbxassetid://5028857084",ImageColor3=T.black,ImageTransparency=0.4,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(24,24,276,276),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.fromOffset(820,545),Parent=Gui,ZIndex=0})

local win = new("Frame",{BackgroundColor3=T.outline,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.fromOffset(780,505),Parent=Gui,Active=true,ClipsDescendants=true})
corner(win,10)
local winInner = new("Frame",{BackgroundColor3=T.bg,BorderSizePixel=0,Position=UDim2.fromOffset(1,1),Size=UDim2.new(1,-2,1,-2),Parent=win})
corner(winInner,10) stroke(winInner,T.stroke,1)

win.Size = UDim2.fromOffset(780*0.94,505*0.94)
win.BackgroundTransparency=1 winInner.BackgroundTransparency=1
tween(win,0.2,{Size=UDim2.fromOffset(780,505),BackgroundTransparency=0}):Play()
tween(winInner,0.2,{BackgroundTransparency=0}):Play()

do
    local drag,dstart,wstart
    winInner.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true dstart=i.Position wstart=win.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-dstart
            win.Position=UDim2.new(wstart.X.Scale,wstart.X.Offset+d.X,wstart.Y.Scale,wstart.Y.Offset+d.Y)
            shadow.Position=win.Position
        end
    end)
end

local top = new("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Size=UDim2.new(1,0,0,56),Parent=winInner})
new("Frame",{BackgroundColor3=T.outline,BorderSizePixel=0,Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1),Parent=top})
local tVOID = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(18,14),Size=UDim2.fromOffset(90,30),Font=Enum.Font.GothamBold,Text="VOID",TextColor3=T.accent,TextSize=26,TextXAlignment=Enum.TextXAlignment.Left,Parent=top})
new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(18+tVOID.TextBounds.X+2,14),Size=UDim2.fromOffset(90,30),Font=Enum.Font.GothamBold,Text="LINE",TextColor3=T.white,TextSize=26,TextXAlignment=Enum.TextXAlignment.Left,Parent=top})

local topRight = new("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-14,0,10),Size=UDim2.fromOffset(240,40),Parent=top})
local stateLbl = new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,14),Font=Enum.Font.Code,Text="STATE: IDLE",TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Right,Parent=topRight})
local silentLbl = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,0,0,14),Size=UDim2.new(1,0,0,14),Font=Enum.Font.Code,Text="SILENT: off",TextColor3=T.dim,TextSize=11,TextXAlignment=Enum.TextXAlignment.Right,Parent=topRight})
local hitLbl = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,0,0,28),Size=UDim2.new(1,0,0,12),Font=Enum.Font.Code,Text="hits 0 · misses 0",TextColor3=T.dim,TextSize=10,TextXAlignment=Enum.TextXAlignment.Right,Parent=topRight})

local side = new("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Position=UDim2.fromOffset(0,56),Size=UDim2.fromOffset(196,449),Parent=winInner})
new("Frame",{BackgroundColor3=T.outline,BorderSizePixel=0,Position=UDim2.new(1,-1,0,0),Size=UDim2.new(0,1,1,0),Parent=side})
local sideList = new("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,14),Size=UDim2.new(1,-20,1,-100),Parent=side})
new("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder,Parent=sideList})

local tag = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.new(0,10,1,-70),Size=UDim2.new(1,-20,0,56),Parent=side})
corner(tag,7) stroke(tag,T.stroke)
new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-20,0,16),Font=Enum.Font.GothamBold,Text=LP.DisplayName,TextColor3=T.text,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=tag})
new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,26),Size=UDim2.new(1,-20,0,14),Font=Enum.Font.Code,Text="@"..LP.Name,TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=tag})
new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,40),Size=UDim2.new(1,-20,0,12),Font=Enum.Font.Code,Text="voidline v2",TextColor3=T.accent,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=tag})

local content = new("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(196,56),Size=UDim2.new(1,-196,1,-56),Parent=winInner})

local Tabs, currentTab = {}, nil
local function makeTab(name,icon)
    local btn = new("TextButton",{BackgroundColor3=T.inset,BackgroundTransparency=1,AutoButtonColor=false,BorderSizePixel=0,Size=UDim2.new(1,0,0,32),Text="",Parent=sideList})
    corner(btn,6)
    local ic = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,0),Size=UDim2.fromOffset(22,32),Font=Enum.Font.GothamBold,Text=icon,TextColor3=T.muted,TextSize=16,Parent=btn})
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
        local flash = new("Frame",{BackgroundColor3=T.black,BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromScale(1,1),Parent=content,ZIndex=50})
        tween(flash,0.08,{BackgroundTransparency=0.4}):Play()
        task.wait(0.08)
        for _,t in ipairs(Tabs) do t.page.Visible=false t.btn.BackgroundTransparency=1 t.ic.TextColor3=T.muted t.lb.TextColor3=T.muted end
        tab.page.Visible=true tab.btn.BackgroundTransparency=0 tab.btn.BackgroundColor3=T.inset
        tab.ic.TextColor3=F.accent tab.lb.TextColor3=T.text
        currentTab=tab
        tween(flash,0.12,{BackgroundTransparency=1}):Play() task.wait(0.12) flash:Destroy()
    end)
    table.insert(Tabs,tab)
    if not currentTab then currentTab=tab page.Visible=true btn.BackgroundTransparency=0 btn.BackgroundColor3=T.inset ic.TextColor3=F.accent lb.TextColor3=T.text end
    return tab
end

--==[ UI KIT ]==--
local function section(parent,title)
    local outer,mid = panel(parent,UDim2.new(),UDim2.new(1,0,0,0),T.panel)
    outer.AutomaticSize=Enum.AutomaticSize.Y outer.Size=UDim2.new(1,0,0,0)
    local head = new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,30),Parent=mid})
    new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-54,1,0),Font=Enum.Font.Gotham,Text=string.upper(title),TextColor3=T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=head})
    new("Frame",{BackgroundColor3=T.outline,BorderSizePixel=0,Position=UDim2.new(0,8,1,-1),Size=UDim2.new(1,-16,0,1),Parent=head})
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
        for _,c in ipairs(body:GetDescendants()) do if c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("TextBox") then tween(c,0.2,{TextTransparency=collapsed and 0.6 or 0}):Play() end end
    end)
    return body
end
local function row(parent,h) return new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,h or 24),Parent=parent}) end

local function swatch(parent,color,onChange)
    local sw = new("Frame",{BackgroundColor3=color,BorderSizePixel=0,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(40,13),Parent=parent})
    corner(sw,3) stroke(sw,T.black)
    local gloss = new("Frame",{BackgroundColor3=T.white,BackgroundTransparency=0.92,BorderSizePixel=0,Size=UDim2.new(1,-2,1,-2),Position=UDim2.fromOffset(1,1),Parent=sw})
    corner(gloss,3) new("UIGradient",{Color=ColorSequence.new(T.white,T.black),Rotation=90,Parent=gloss})
    local btn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),Parent=sw})
    btn.MouseButton1Click:Connect(function()
        local popup = new("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Size=UDim2.fromOffset(166,197),Parent=Gui,ZIndex=25})
        corner(popup,7) stroke(popup,T.stroke)
        local ap = sw.AbsolutePosition - Gui.AbsolutePosition
        popup.Position = UDim2.fromOffset(ap.X-150, ap.Y+20)
        local h,s,v = color:ToHSV()
        local sq = new("ImageLabel",{BackgroundColor3=Color3.fromHSV(h,1,1),BorderSizePixel=0,Image="rbxassetid://4155801252",Position=UDim2.fromOffset(8,8),Size=UDim2.fromOffset(120,120),ZIndex=26,Parent=popup})
        local sqBtn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),ZIndex=27,Parent=sq})
        local hueBar = new("Frame",{BorderSizePixel=0,Position=UDim2.fromOffset(136,8),Size=UDim2.fromOffset(16,120),ZIndex=26,Parent=popup})
        new("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),ColorSequenceKeypoint.new(0.17,Color3.fromHSV(0.17,1,1)),ColorSequenceKeypoint.new(0.33,Color3.fromHSV(0.33,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromHSV(0.5,1,1)),ColorSequenceKeypoint.new(0.66,Color3.fromHSV(0.66,1,1)),ColorSequenceKeypoint.new(0.83,Color3.fromHSV(0.83,1,1)),ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))}),Rotation=90,Parent=hueBar})
        local hueBtn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),ZIndex=27,Parent=hueBar})
        local box = new("TextBox",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.fromOffset(8,134),Size=UDim2.fromOffset(144,22),Font=Enum.Font.Code,PlaceholderText="r,g,b",Text=("%d,%d,%d"):format(color.R*255,color.G*255,color.B*255),TextColor3=T.text,TextSize=12,ZIndex=26,Parent=popup})
        corner(box,4) stroke(box,T.stroke)
        local apply = new("TextButton",{BackgroundColor3=T.accent,BorderSizePixel=0,Position=UDim2.fromOffset(8,162),Size=UDim2.fromOffset(144,27),Font=Enum.Font.GothamBold,Text="close",TextColor3=T.white,TextSize=12,ZIndex=26,Parent=popup})
        corner(apply,4)
        local ds,dh=false,false
        local function refresh()
            local c=Color3.fromHSV(h,s,v) color=c sw.BackgroundColor3=c sq.BackgroundColor3=Color3.fromHSV(h,1,1)
            box.Text=("%d,%d,%d"):format(c.R*255,c.G*255,c.B*255)
            if onChange then onChange(c) end
        end
        sqBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then ds=true end end)
        hueBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dh=true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then ds=false dh=false end end)
        UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType~=Enum.UserInputType.MouseMovement then return end
            if ds then s=math.clamp((i.Position.X-sq.AbsolutePosition.X)/sq.AbsoluteSize.X,0,1) v=1-math.clamp((i.Position.Y-sq.AbsolutePosition.Y)/sq.AbsoluteSize.Y,0,1) refresh()
            elseif dh then h=math.clamp((i.Position.Y-hueBar.AbsolutePosition.Y)/hueBar.AbsoluteSize.Y,0,1) refresh() end
        end)
        box.FocusLost:Connect(function() local r,g,b=box.Text:match("(%d+)[, ]+(%d+)[, ]+(%d+)") if r then color=Color3.fromRGB(tonumber(r),tonumber(g),tonumber(b)) h,s,v=color:ToHSV() refresh() end end)
        apply.MouseButton1Click:Connect(function() popup:Destroy() end)
        refresh()
    end)
    return sw
end

local function toggle(parent,text,default,cb,opts)
    opts=opts or {}
    local r = row(parent,22)
    new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(44,0),Size=UDim2.new(1,-100,1,0),Font=Enum.Font.Code,Text=text,TextColor3=T.text,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=r})
    local bg = new("Frame",{BackgroundColor3=default and F.accent or T.control,BorderSizePixel=0,Position=UDim2.fromOffset(0,2),Size=UDim2.fromOffset(36,18),Parent=r})
    corner(bg,9) stroke(bg,T.stroke)
    local knob = new("Frame",{BackgroundColor3=T.white,BorderSizePixel=0,Position=default and UDim2.fromOffset(21,3) or UDim2.fromOffset(3,3),Size=UDim2.fromOffset(12,12),Parent=bg})
    corner(knob,6)
    local state=default or false
    local btn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),Parent=r})
    local function apply()
        tween(bg,0.14,{BackgroundColor3=state and F.accent or T.control}):Play()
        tween(knob,0.14,{Position=state and UDim2.fromOffset(21,3) or UDim2.fromOffset(3,3)}):Play()
        if cb then safe(cb,state) end
    end
    btn.MouseButton1Click:Connect(function() state=not state apply() end)
    if opts.swatch then swatch(r,opts.swatch,opts.onSwatch) end
    return {Set=function(_,v) state=v apply() end, Get=function() return state end}
end

local function slider(parent,text,def,mn,mx,dec,cb)
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
    local d=false
    local function set(px)
        local a=math.clamp((px-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
        local v=round(mn+(mx-mn)*a,dec or 0)
        fill.Size=UDim2.new(a,0,1,0) knob.Position=UDim2.new(a,0,0.5,0) val.Text=tostring(v)
        if cb then safe(cb,v) end
    end
    btn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true tween(knob,0.1,{Size=UDim2.fromOffset(14,14)}):Play() set(i.Position.X) end end)
    UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then set(i.Position.X) end end)
    UserInputService.InputEnded:Connect(function(i) if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) and d then d=false tween(knob,0.1,{Size=UDim2.fromOffset(12,12)}):Play() end end)
end

local function dropdown(parent,text,options,default,cb)
    local r = row(parent,32)
    new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,12),Font=Enum.Font.Code,Text=text,TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=r})
    local field = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.new(0,0,0,14),Size=UDim2.new(1,0,0,18),Parent=r})
    corner(field,4) stroke(field,T.stroke)
    local lab = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(6,0),Size=UDim2.new(1,-24,1,0),Font=Enum.Font.Code,Text=tostring(default or "none"),TextColor3=T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=field})
    local ind = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-18,0,0),Size=UDim2.fromOffset(16,18),Font=Enum.Font.GothamBold,Text="+",TextColor3=T.muted,TextSize=14,Parent=field})
    local btn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),Parent=field})
    local open=false local popup
    local selected = default
    btn.MouseButton1Click:Connect(function()
        if open then if popup then popup:Destroy() end open=false ind.Text="+" return end
        open=true ind.Text="-"
        local h=math.min(#options*22+8,180)
        popup = new("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Size=UDim2.new(0,field.AbsoluteSize.X,0,h),Parent=Gui,ZIndex=25,ClipsDescendants=true})
        corner(popup,6) stroke(popup,T.stroke)
        local ap=field.AbsolutePosition-Gui.AbsolutePosition
        local sy=ap.Y+20 if sy+h>Gui.AbsoluteSize.Y then sy=ap.Y-h-4 end
        popup.Position=UDim2.fromOffset(ap.X,sy)
        popup.Size=UDim2.fromOffset(field.AbsoluteSize.X,0)
        tween(popup,0.15,{Size=UDim2.fromOffset(field.AbsoluteSize.X,h)}):Play()
        local sc = new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromScale(1,1),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3=T.accent,ZIndex=26,Parent=popup})
        new("UIListLayout",{Parent=sc}) pad(sc,4,4,4,4)
        for _,opt in ipairs(options) do
            local ob = new("TextButton",{BackgroundColor3=T.inset,BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,0,22),Font=Enum.Font.Code,Text="  "..opt,TextColor3=selected==opt and T.accent or T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=27,Parent=sc})
            corner(ob,4)
            ob.MouseEnter:Connect(function() tween(ob,0.1,{BackgroundTransparency=0}):Play() end)
            ob.MouseLeave:Connect(function() tween(ob,0.1,{BackgroundTransparency=1}):Play() end)
            ob.MouseButton1Click:Connect(function()
                selected=opt lab.Text=opt popup:Destroy() open=false ind.Text="+"
                if cb then safe(cb,opt) end
            end)
        end
    end)
end

local function keybind(parent,text,defKey,defMode,cb)
    local r = row(parent,22)
    new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,-100,1,0),Font=Enum.Font.Code,Text=text,TextColor3=T.text,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=r})
    local chip = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(94,18),Parent=r})
    corner(chip,4) stroke(chip,T.stroke)
    local lab = new("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.Code,Text=(defMode or "Hold")..": "..(defKey and defKey.Name or "None"),TextColor3=T.text,TextSize=11,Parent=chip})
    local btn = new("TextButton",{BackgroundTransparency=1,Text="",Size=UDim2.fromScale(1,1),Parent=chip})
    local key, mode = defKey, defMode or "Hold"
    local function refresh() lab.Text=mode..": "..(key and key.Name or "None") end
    btn.MouseButton1Click:Connect(function()
        lab.Text=mode..": ..."
        local conn conn = UserInputService.InputBegan:Connect(function(i,gp)
            if gp then return end
            if i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode~=Enum.KeyCode.Unknown then
                key=i.KeyCode conn:Disconnect() refresh() if cb then safe(cb,key,mode) end
            end
        end)
    end)
    btn.MouseButton2Click:Connect(function()
        local modes={"Hold","Toggle","Always"}
        for i,m in ipairs(modes) do if m==mode then mode=modes[(i%3)+1] break end end
        refresh() if cb then safe(cb,key,mode) end
    end)
end

local function textbox(parent,placeholder,cb)
    local r = row(parent,30)
    local f = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Size=UDim2.new(1,0,0,26),Parent=r})
    corner(f,4) stroke(f,T.stroke)
    local tb = new("TextBox",{BackgroundTransparency=1,Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-16,1,0),Font=Enum.Font.Code,PlaceholderText=placeholder,PlaceholderColor3=T.dim,Text="",TextColor3=T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,Parent=f})
    tb.FocusLost:Connect(function() if cb then safe(cb,tb.Text) end end)
    return tb
end

local function button(parent,text,cb)
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

--==[ notifications ]==--
local notifHost = new("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,16,1,-16),Size=UDim2.fromOffset(210,400),Parent=Gui})
new("UIListLayout",{VerticalAlignment=Enum.VerticalAlignment.Bottom,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),Parent=notifHost})
local function notify(title,body,dur)
    dur=dur or 4
    local outer,mid = panel(notifHost,UDim2.new(),UDim2.new(1,0,0,0),T.panel)
    outer.Position=UDim2.fromOffset(-220,0) outer.AutomaticSize=Enum.AutomaticSize.Y
    new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,8),Size=UDim2.new(1,-20,0,14),Font=Enum.Font.GothamBold,Text=title,TextColor3=T.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=mid})
    new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(10,24),Size=UDim2.new(1,-20,0,0),AutomaticSize=Enum.AutomaticSize.Y,Font=Enum.Font.Code,Text=body,TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=mid})
    local barBg = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.new(0,8,1,-6),Size=UDim2.new(1,-16,0,2),Parent=mid})
    local bar = new("Frame",{BackgroundColor3=F.accent,BorderSizePixel=0,Size=UDim2.new(1,0,1,0),Parent=barBg})
    pad(mid,0,0,0,10)
    tween(outer,0.25,{Position=UDim2.fromOffset(0,0)}):Play()
    tween(bar,dur,{Size=UDim2.new(0,0,1,0)}):Play()
    task.delay(dur,function() tween(outer,0.25,{Position=UDim2.fromOffset(-220,0)}):Play() task.wait(0.25) outer:Destroy() end)
end

--==[ drawing helpers ]==--
local function dnew(cls,props) local d=Drawing_new(cls) for k,v in pairs(props or {}) do pcall(function() d[k]=v end) end return d end

--==[ TABS ]==--
local tRage    = makeTab("Ragebot",   "☠")
local tAim     = makeTab("Aim",       "◢")
local tAA      = makeTab("Anti-Aim",  "◇")
local tLegit   = makeTab("Legit",     "◉")
local tVisuals = makeTab("Visuals",   "◈")
local tVoid    = makeTab("Void",      "♆")
local tMisc    = makeTab("Misc",      "⚙")
local tSkins   = makeTab("Skins",     "✦")
local tConf    = makeTab("Configs",   "❐")
local tDbg     = makeTab("Debug",     "ℹ")
local tSet     = makeTab("Settings",  "⚒")

--==[ Ragebot UI ]==--
do
    local s = section(tRage.c1,"Ragebot FSM")
    toggle(s,"Enabled",F.rage_enabled,function(v) F.rage_enabled=v end)
    slider(s,"Engage Range",F.rage_engage,10,500,0,function(v) F.rage_engage=v end)
    slider(s,"Approach Delay",F.rage_approach_delay,0,1,2,function(v) F.rage_approach_delay=v end)
    slider(s,"Confirm Window",F.rage_confirm_window,0.1,2,2,function(v) F.rage_confirm_window=v end)
    slider(s,"Retreat Distance",F.rage_retreat,5,200,0,function(v) F.rage_retreat=v end)
    slider(s,"Re-engage Cooldown",F.rage_cooldown,0.1,5,2,function(v) F.rage_cooldown=v end)
    local s2 = section(tRage.c2,"HP Branch")
    slider(s2,"HP Threshold",F.rage_hp_threshold,0,1,2,function(v) F.rage_hp_threshold=v end)
    slider(s2,"Above HP Multiplier",F.rage_hp_mult,1,5,1,function(v) F.rage_hp_mult=v end)
    slider(s2,"Below HP Short Hop",F.rage_short_hop,2,30,0,function(v) F.rage_short_hop=v end)
    toggle(s2,"Auto Orbit",F.rage_auto_orbit,function(v) F.rage_auto_orbit=v end)
    toggle(s2,"Auto Void",F.rage_auto_void,function(v) F.rage_auto_void=v end)
    local s3 = section(tRage.c1,"Voidspam")
    toggle(s3,"Enabled",F.vs_enabled,function(v) F.vs_enabled=v end)
    slider(s3,"Retreat",F.vs_retreat,5,100,0,function(v) F.vs_retreat=v end)
    slider(s3,"Jitter",F.vs_jitter,0,30,0,function(v) F.vs_jitter=v end)
    slider(s3,"Depth",F.vs_depth,10,200,0,function(v) F.vs_depth=v end)
    toggle(s3,"Panic",F.vs_panic,function(v) F.vs_panic=v end)
    toggle(s3,"Only When Not Seen",F.vs_outofsight,function(v) F.vs_outofsight=v end)
end

--==[ Aim UI ]==--
do
    local s = section(tAim.c1,"Aim Core")
    toggle(s,"Enabled",F.aim_enabled,function(v) F.aim_enabled=v end)
    keybind(s,"Aim Key",F.aim_key,F.aim_hold and "Hold" or "Toggle",function(k,m) F.aim_key=k F.aim_hold=(m=="Hold") end)
    dropdown(s,"Aim Mode",{"Camera","Mouse"},F.aim_mode,function(v) F.aim_mode=v end)
    dropdown(s,"Priority",{"FOV","Distance","Lowest HP","Crosshair"},F.aim_priority,function(v) F.aim_priority=v end)
    dropdown(s,"Hitbox",{"Head","Torso","Random"},F.aim_hitbox,function(v) F.aim_hitbox=v end)
    toggle(s,"Team Check",F.aim_team,function(v) F.aim_team=v end)
    toggle(s,"Wall Check",F.aim_wall,function(v) F.aim_wall=v end)
    toggle(s,"Visible Only",F.aim_visible,function(v) F.aim_visible=v end)
    toggle(s,"Pause When Menu Open",F.aim_pause_menu,function(v) F.aim_pause_menu=v end)
    slider(s,"FOV",F.aim_fov,10,600,0,function(v) F.aim_fov=v end)
    toggle(s,"Draw FOV",F.aim_fov_show,function(v) F.aim_fov_show=v end,{swatch=F.aim_fov_color,onSwatch=function(c) F.aim_fov_color=c end})
    slider(s,"Smoothness",F.aim_smooth,1,10,1,function(v) F.aim_smooth=v end)
    slider(s,"Prediction",F.aim_predict,0,0.5,3,function(v) F.aim_predict=v end)

    local s2 = section(tAim.c2,"Silent Aim")
    toggle(s2,"Enabled",F.silent_enabled,function(v) F.silent_enabled=v end)
    slider(s2,"Hit Chance",F.silent_hitchance,0,100,0,function(v) F.silent_hitchance=v end)

    local s3 = section(tAim.c2,"Resolver")
    slider(s3,"Samples",F.res_samples,2,30,0,function(v) F.res_samples=v end)
    slider(s3,"Reject Threshold",F.res_reject,0.5,50,1,function(v) F.res_reject=v end)
    toggle(s3,"Translocate Counter",F.res_translocate,function(v) F.res_translocate=v end)

    local s4 = section(tAim.c2,"Orbit")
    toggle(s4,"Enabled",F.orbit_enabled,function(v) F.orbit_enabled=v end)
    slider(s4,"Radius",F.orbit_r,2,40,1,function(v) F.orbit_r=v end)
    slider(s4,"Speed",F.orbit_speed,1,60,0,function(v) F.orbit_speed=v end)
    toggle(s4,"Show Ring",F.orbit_show,function(v) F.orbit_show=v end,{swatch=F.orbit_color,onSwatch=function(c) F.orbit_color=c end})

    local s5 = section(tAim.c1,"Target Lists")
    local pInp = textbox(s5,"priority username",function() end)
    button(s5,"add priority",function() if pInp.Text~="" then table.insert(F.rage_priority_user,pInp.Text) pInp.Text="" notify("priority","added",2) end end)
    local iInp = textbox(s5,"ignore username",function() end)
    button(s5,"add ignore",function() if iInp.Text~="" then table.insert(F.rage_ignore,iInp.Text) iInp.Text="" notify("ignore","added",2) end end)
    button(s5,"clear lists",function() F.rage_priority_user={} F.rage_ignore={} notify("lists","cleared",2) end)
end

--==[ Anti-Aim UI ]==--
do
    local s = section(tAA.c1,"Anti-Aim")
    toggle(s,"Enabled",F.aa_enabled,function(v) F.aa_enabled=v end)
    dropdown(s,"Pitch",{"Down","Up","Jitter","Random","Zero","Custom"},F.aa_pitch,function(v) F.aa_pitch=v end)
    dropdown(s,"Yaw",{"Backward","Left","Right","Spin","Sway","Jitter","Random","Custom"},F.aa_yaw,function(v) F.aa_yaw=v end)
    slider(s,"Speed",F.aa_speed,1,30,0,function(v) F.aa_speed=v end)
    slider(s,"Jitter Range",F.aa_jitter,0,180,0,function(v) F.aa_jitter=v end)
    slider(s,"Custom Pitch",F.aa_custom_pitch,-90,90,0,function(v) F.aa_custom_pitch=v end)
    slider(s,"Custom Yaw",F.aa_custom_yaw,-180,180,0,function(v) F.aa_custom_yaw=v end)
    local s2 = section(tAA.c2,"Extra")
    toggle(s2,"Pause On Attack",F.aa_pause_attack,function(v) F.aa_pause_attack=v end)
    toggle(s2,"LBY Breaker",F.aa_lby,function(v) F.aa_lby=v end)
    toggle(s2,"Hide Head",F.aa_hidehead,function(v) F.aa_hidehead=v end)
end

--==[ Legit UI ]==--
do
    local s = section(tLegit.c1,"Aimbot")
    toggle(s,"Enabled",F.legit_enabled,function(v) F.legit_enabled=v end)
    keybind(s,"Aim Key",F.legit_key,"Hold",function(k) F.legit_key=k end)
    slider(s,"Smooth",F.legit_smooth,1,20,1,function(v) F.legit_smooth=v end)
    slider(s,"FOV",F.legit_fov,5,200,0,function(v) F.legit_fov=v end)
    local s2 = section(tLegit.c2,"Triggerbot")
    toggle(s2,"Enabled",F.trigger_enabled,function(v) F.trigger_enabled=v end)
    keybind(s2,"Key",F.trigger_key,"Hold",function(k) F.trigger_key=k end)
    slider(s2,"Reaction (ms)",F.trigger_reaction,0,500,0,function(v) F.trigger_reaction=v end)
    slider(s2,"Random (ms)",F.trigger_random,0,300,0,function(v) F.trigger_random=v end)
    local s3 = section(tLegit.c1,"Weapon")
    toggle(s3,"No Recoil",F.norecoil,function(v) F.norecoil=v end)
    toggle(s3,"No Spread",F.nospread,function(v) F.nospread=v end)
end

--==[ Visuals UI ]==--
do
    local s = section(tVisuals.c1,"ESP Main")
    toggle(s,"Enabled",F.esp_enabled,function(v) F.esp_enabled=v end)
    toggle(s,"Team ESP",F.esp_team,function(v) F.esp_team=v end)
    slider(s,"Max Distance",F.esp_max,50,5000,0,function(v) F.esp_max=v end)
    toggle(s,"Box",F.esp_box,function(v) F.esp_box=v end,{swatch=F.esp_box_color,onSwatch=function(c) F.esp_box_color=c end})
    dropdown(s,"Box Mode",{"Full","Corner"},F.esp_box_mode,function(v) F.esp_box_mode=v end)
    toggle(s,"Name",F.esp_name,function(v) F.esp_name=v end,{swatch=F.esp_name_color,onSwatch=function(c) F.esp_name_color=c end})
    toggle(s,"HP Bar",F.esp_hp,function(v) F.esp_hp=v end,{swatch=F.esp_hp_hi,onSwatch=function(c) F.esp_hp_hi=c end})
    toggle(s,"HP Number",F.esp_hp_num,function(v) F.esp_hp_num=v end)
    toggle(s,"Weapon",F.esp_weapon,function(v) F.esp_weapon=v end,{swatch=F.esp_weapon_color,onSwatch=function(c) F.esp_weapon_color=c end})
    toggle(s,"Distance",F.esp_dist,function(v) F.esp_dist=v end)
    toggle(s,"Head Dot",F.esp_headdot,function(v) F.esp_headdot=v end)

    local s2 = section(tVisuals.c2,"Chams")
    toggle(s2,"Chams",F.esp_chams,function(v) F.esp_chams=v end,{swatch=F.esp_chams_fill,onSwatch=function(c) F.esp_chams_fill=c end})
    toggle(s2,"Depth Check",F.esp_chams_depth,function(v) F.esp_chams_depth=v end)

    local s3 = section(tVisuals.c2,"Tracers / Crosshair")
    toggle(s3,"Tracer",F.tracer,function(v) F.tracer=v end,{swatch=F.tracer_color,onSwatch=function(c) F.tracer_color=c end})
    dropdown(s3,"Origin",{"Bottom","Top","Mouse"},F.tracer_origin,function(v) F.tracer_origin=v end)
    toggle(s3,"Crosshair",F.crosshair,function(v) F.crosshair=v end,{swatch=F.cross_color,onSwatch=function(c) F.cross_color=c end})
    slider(s3,"Length",F.cross_len,2,40,0,function(v) F.cross_len=v end)
    slider(s3,"Gap",F.cross_gap,0,20,0,function(v) F.cross_gap=v end)
    toggle(s3,"Dot",F.cross_dot,function(v) F.cross_dot=v end)
    toggle(s3,"Bounce",F.cross_bounce,function(v) F.cross_bounce=v end)
    toggle(s3,"Hit Pulse",F.cross_hitpulse,function(v) F.cross_hitpulse=v end)

    local s4 = section(tVisuals.c1,"World")
    toggle(s4,"Target HUD",F.targethud,function(v) F.targethud=v end)
    toggle(s4,"Hitmarker",F.hitmark,function(v) F.hitmark=v end,{swatch=F.hitmark_color,onSwatch=function(c) F.hitmark_color=c end})
    toggle(s4,"Third Person",F.tp_enabled,function(v) F.tp_enabled=v end)
    slider(s4,"TP Dist",F.tp_dist,2,40,0,function(v) F.tp_dist=v end)
    slider(s4,"World FOV",F.world_fov,30,120,0,function(v) F.world_fov=v end)
    dropdown(s4,"Sky",{"Default","Night","Sunset","Space"},F.sky_preset,function(v) F.sky_preset=v end)
    toggle(s4,"No Fog",F.no_fog,function(v) F.no_fog=v end)
end

--==[ Void UI ]==--
do
    local s = section(tVoid.c1,"Fake Position")
    toggle(s,"Enabled",F.void_enabled,function(v) F.void_enabled=v end)
    slider(s,"Depth",F.void_depth,10,500,0,function(v) F.void_depth=v end)
    toggle(s,"Stay Buried",F.void_stay,function(v) F.void_stay=v end)
    toggle(s,"Surface Camera",F.void_cam,function(v) F.void_cam=v end)
    toggle(s,"Auto Noclip",F.void_noclip,function(v) F.void_noclip=v end)
    toggle(s,"Zero Velocity",F.void_zero_vel,function(v) F.void_zero_vel=v end)
    toggle(s,"Ghost Box",F.void_box,function(v) F.void_box=v end,{swatch=F.void_box_color,onSwatch=function(c) F.void_box_color=c end})
    toggle(s,"Panic Jitter",F.void_jitter,function(v) F.void_jitter=v end)
    slider(s,"Jitter Amt",F.void_jitter_amt,1,20,0,function(v) F.void_jitter_amt=v end)
    toggle(s,"Freeze Pose",F.void_freeze,function(v) F.void_freeze=v end)
end

--==[ Misc UI ]==--
do
    local s = section(tMisc.c1,"Movement")
    toggle(s,"Walk Speed",F.wspeed,function(v) F.wspeed=v end)
    slider(s,"Speed",F.wspeed_v,16,200,0,function(v) F.wspeed_v=v end)
    toggle(s,"Noclip",F.noclip,function(v) F.noclip=v end)
    toggle(s,"Bunny Hop",F.bhop,function(v) F.bhop=v end)
    toggle(s,"Fly",F.fly,function(v) F.fly=v end)
    slider(s,"Fly Speed",F.fly_v,10,500,0,function(v) F.fly_v=v end)
    toggle(s,"Long Jump",F.ljump,function(v) F.ljump=v end)
    slider(s,"LJ Force",F.ljump_force,10,300,0,function(v) F.ljump_force=v end)
    toggle(s,"Auto Strafe",F.autostrafe,function(v) F.autostrafe=v end)
    slider(s,"Strafe Intensity",F.strafe_i,0,100,0,function(v) F.strafe_i=v end)
    local s2 = section(tMisc.c2,"Utility")
    toggle(s2,"Auto Respawn",F.autoresp,function(v) F.autoresp=v end)
    toggle(s2,"Staff Detector",F.staff,function(v) F.staff=v end)
    textbox(s2,"staff keyword",function(t) F.staff_kw=t end)
    dropdown(s2,"Staff Action",{"Notify","Hop","Kick"},F.staff_action,function(v) F.staff_action=v end)
    toggle(s2,"Hit Sound",F.hit_sound,function(v) F.hit_sound=v end)
end

--==[ Skins UI ]==--
local applySkins
do
    local s = section(tSkins.c1,"Skin Changer")
    toggle(s,"Enabled",F.skins_enabled,function(v) F.skins_enabled=v end)
    textbox(s,"DoubleBarrel",function(t) if t~="" then F.skin_db=t end end)
    textbox(s,"Revolver",function(t) if t~="" then F.skin_rev=t end end)
    textbox(s,"Shotgun",function(t) if t~="" then F.skin_shotgun=t end end)
    textbox(s,"TacticalShotgun",function(t) if t~="" then F.skin_tac=t end end)
    textbox(s,"SMG",function(t) if t~="" then F.skin_smg=t end end)
    textbox(s,"Knife",function(t) if t~="" then F.skin_knife=t end end)
    button(s,"reapply",function() if applySkins then applySkins() end end)
end

--==[ Configs UI ]==--
do
    local s = section(tConf.c1,"Configs")
    local nameBox = textbox(s,"config name",function() end)
    local function serialize()
        local out={}
        for k,v in pairs(F) do
            if k:sub(1,1)~="_" then
                local tp=type(v)
                if tp=="boolean" or tp=="number" or tp=="string" then out[k]=v
                elseif typeof(v)=="Color3" then out[k]={_c=true,r=v.R,g=v.G,b=v.B}
                elseif typeof(v)=="EnumItem" then out[k]={_e=true,t=tostring(v.EnumType),n=v.Name}
                elseif tp=="table" then out[k]=v end
            end
        end
        return HttpService:JSONEncode(out)
    end
    local function deserialize(json)
        local ok,data = pcall(HttpService.JSONDecode,HttpService,json); if not ok then return end
        for k,v in pairs(data) do
            if type(v)=="table" and v._c then F[k]=Color3.new(v.r,v.g,v.b)
            elseif type(v)=="table" and v._e then F[k]=Enum[v.t:gsub("Enum%.","")][v.n]
            else F[k]=v end
        end
    end
    button(s,"save",function() local n=nameBox.Text if n=="" then return end safe(wfile,"voidline/configs/"..n..".json",serialize()) notify("config","saved "..n,2) end)
    button(s,"load",function() local n=nameBox.Text if n=="" or not safe(isfile_,"voidline/configs/"..n..".json") then return end deserialize(safe(rfile,"voidline/configs/"..n..".json")) notify("config","loaded "..n,2) end)
    button(s,"delete",function() local n=nameBox.Text if n=="" then return end safe(delfile,"voidline/configs/"..n..".json") notify("config","deleted "..n,2) end)
    button(s,"export",function() safe(clipset,serialize()) notify("config","clipboard",2) end)
    button(s,"import",function() local c=safe(clipget) if c then deserialize(c) notify("config","imported",2) end end)
end

--==[ Debug UI ]==--
local dbgText
do
    local s = section(tDbg.c1,"Debug Console")
    toggle(s,"Enabled",F.debug_enabled,function(v) F.debug_enabled=v end)
    local panelF = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Size=UDim2.new(1,0,0,240),Parent=s})
    corner(panelF,4) stroke(panelF,T.stroke)
    local sc = new("ScrollingFrame",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3=T.accent,Parent=panelF})
    pad(sc,6,6,6,6)
    dbgText = new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,Font=Enum.Font.Code,Text="",TextColor3=T.muted,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=false,Parent=sc})
    button(s,"clear",function() DEBUG_LOG={} end)
end

--==[ Settings UI ]==--
do
    local s = section(tSet.c1,"Menu")
    toggle(s,"Accent",true,function() end,{swatch=F.accent,onSwatch=function(c) F.accent=c T.accent=c end})
    keybind(s,"Menu Key",F.menu_key,"Toggle",function(k) F.menu_key=k end)
    toggle(s,"Autosave",F.autosave,function(v) F.autosave=v end)
    button(s,"unload",function() getgenv().VOIDLINE_LOADED=nil Gui:Destroy() end)
    local s2 = section(tSet.c2,"Info")
    new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,120),Font=Enum.Font.Code,Text="VOIDLINE v2\nbuilt by olivia\ndiscord.gg/ojailbreaks\n\nmenu: RightShift\naim: E · hold\nragebot: hp-branched FSM",TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Parent=s2})
end

--==[ FLOATING TARGET HUD ]==--
local tHud, tHudState
do
    local outer,mid = panel(Gui,UDim2.new(1,-240,0.5,-60),UDim2.fromOffset(220,120),T.panel)
    tHud = outer tHudState = {}
    tHudState.name = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-24,0,16),Font=Enum.Font.GothamBold,Text="no target",TextColor3=T.text,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=mid})
    tHudState.sub = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,26),Size=UDim2.new(1,-24,0,14),Font=Enum.Font.Code,RichText=true,Text="",TextColor3=T.muted,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=mid})
    local hpbg = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.fromOffset(12,48),Size=UDim2.new(1,-24,0,6),Parent=mid}) corner(hpbg,3)
    tHudState.hp = new("Frame",{BackgroundColor3=T.good,BorderSizePixel=0,Size=UDim2.new(1,0,1,0),Parent=hpbg}) corner(tHudState.hp,3)
    local ratiobg = new("Frame",{BackgroundColor3=T.inset,BorderSizePixel=0,Position=UDim2.fromOffset(12,60),Size=UDim2.new(1,-24,0,6),Parent=mid}) corner(ratiobg,3)
    tHudState.ratio = new("Frame",{BackgroundColor3=T.accent,BorderSizePixel=0,Size=UDim2.new(0.5,0,1,0),Parent=ratiobg}) corner(tHudState.ratio,3)
    tHudState.state = new("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,72),Size=UDim2.new(1,-24,0,14),Font=Enum.Font.Code,Text="STATE: IDLE",TextColor3=T.accent,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=mid})
    outer.Visible=false
end

--==[ FEATURE LOGIC ]==--
local function getChar(p) return p.Character end
local function getHrp(c) return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum(c) return c and c:FindFirstChildOfClass("Humanoid") end
local function getHead(c) return c and c:FindFirstChild("Head") end
local function isEnemy(p) return p.Team==nil or p.Team~=LP.Team end

local function worldToScreen(v) local p,on=Camera:WorldToViewportPoint(v) return Vector2.new(p.X,p.Y),on,p.Z end
local function screenDistToCenter(v) local s,on=worldToScreen(v) if not on then return math.huge end return (s-Camera.ViewportSize/2).Magnitude end
local function wallClear(fromPos,toPos,charIgnore)
    local rp=RaycastParams.new()
    rp.FilterDescendantsInstances={Camera,LP.Character,charIgnore}
    rp.FilterType=Enum.RaycastFilterType.Exclude
    local r=Workspace:Raycast(fromPos,(toPos-fromPos),rp)
    return r==nil
end

-- resolver
local resolver = {}
local function sampleRoot(p)
    local c=getChar(p); local h=getHrp(c); if not h then return end
    local b=resolver[p]; if not b then b={pos={},vel={},i=1} resolver[p]=b end
    b.pos[b.i]=h.Position; b.vel[b.i]=h.AssemblyLinearVelocity or Vector3.zero
    b.i=b.i%math.max(1,F.res_samples)+1
end
local function medianV3(list)
    local xs,ys,zs={},{},{}
    for _,v in ipairs(list) do table.insert(xs,v.X) table.insert(ys,v.Y) table.insert(zs,v.Z) end
    table.sort(xs) table.sort(ys) table.sort(zs)
    local n=#xs if n==0 then return nil end
    local m=math.max(1,math.floor(n/2))
    return Vector3.new(xs[m],ys[m],zs[m])
end
local function resolvePos(p)
    local b=resolver[p]
    if not b or #b.pos==0 then local c=getChar(p) return c and getHrp(c) and getHrp(c).Position end
    local m=medianV3(b.pos) if not m then return end
    local kept={} for _,pp in ipairs(b.pos) do if (pp-m).Magnitude<=F.res_reject then table.insert(kept,pp) end end
    local m2=medianV3(kept) or m
    local vmed=medianV3(b.vel) or Vector3.zero
    return m2 + vmed*F.aim_predict
end

-- target pick
local function pickTarget()
    local best,score=nil,math.huge
    local myC=LP.Character; local myH=getHrp(myC); if not myH then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then
            local skip=false
            for _,ig in ipairs(F.rage_ignore) do if p.Name:lower():find(ig:lower()) then skip=true break end end
            if F.aim_team and not isEnemy(p) then skip=true end
            if not skip then
                local c=getChar(p); local h=getHrp(c); local hum=getHum(c)
                if h and hum and hum.Health>0 then
                    local pos=resolvePos(p) or h.Position
                    local sv,on=worldToScreen(pos)
                    local sd = on and (sv-Camera.ViewportSize/2).Magnitude or math.huge
                    if on and sd<=F.aim_fov then
                        local vis=true
                        if F.aim_wall or F.aim_visible then vis=wallClear(Camera.CFrame.Position,pos,c) end
                        if vis or not F.aim_visible then
                            local sc
                            if F.aim_priority=="Distance" then sc=(myH.Position-pos).Magnitude
                            elseif F.aim_priority=="Lowest HP" then sc=hum.Health
                            else sc=sd end
                            for _,pr in ipairs(F.rage_priority_user) do if p.Name:lower():find(pr:lower()) then sc=sc*0.1 end end
                            if sc<score then score=sc best=p end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function getAimPart(c)
    if F.aim_hitbox=="Head" then return getHead(c) or getHrp(c) end
    if F.aim_hitbox=="Torso" then return getHrp(c) end
    local pool={getHead(c),getHrp(c)} local avail={}
    for _,p in ipairs(pool) do if p then table.insert(avail,p) end end
    return avail[math.random(1,#avail)]
end

-- SILENT AIM via __namecall hook
local currentSilentTarget
local hookInstalled = false
local function installSilentHook()
    if hookInstalled or not hookmm then return end
    hookInstalled = true
    local old
    local function newCall(self, ...)
        local m = getnamecall and getnamecall() or ""
        if not checkcall() and F.silent_enabled and currentSilentTarget and (m=="Raycast" or m=="FindPartOnRayWithIgnoreList" or m=="FindPartOnRay") then
            if math.random(1,100)<=F.silent_hitchance then
                local args = {...}
                local tc=getChar(currentSilentTarget); local part = tc and getAimPart(tc)
                if part then
                    local origin = Camera.CFrame.Position
                    local dir = (part.Position - origin)
                    if m=="Raycast" then args[1] = origin; args[2] = dir elseif m=="FindPartOnRay" or m=="FindPartOnRayWithIgnoreList" then args[1] = Ray.new(origin, dir) end
                    F._silent_live = true
                    return old(self, unpack(args))
                end
            end
        end
        F._silent_live = false
        return old(self, ...)
    end
    local ok,err = pcall(function() old = hookmm(Workspace, "__namecall", newcclosure(newCall)) end)
    if not ok then
        dbg("silent hook failed:",tostring(err))
        hookInstalled=false
    else
        dbg("silent hook installed")
    end
end
installSilentHook()

-- Aim driver: Camera mode or Mouse mode
local function driveAim(targetPos, smooth)
    smooth = smooth or F.aim_smooth
    if F.aim_mode == "Mouse" and VirtualInput then
        local sv,on = worldToScreen(targetPos)
        if on then
            local cx,cy = Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2
            local dx, dy = (sv.X-cx)/smooth, (sv.Y-cy)/smooth
            safe(function() VirtualInput:SendMouseMoveEvent(sv.X,sv.Y,game) end)
        end
    else
        local target = CFrame.new(Camera.CFrame.Position, targetPos)
        Camera.CFrame = Camera.CFrame:Lerp(target, 1/math.max(1,smooth))
    end
end

-- aim key state
local aimActive=false
UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==F.menu_key then win.Visible=not win.Visible end
    if i.KeyCode==F.aim_key and F.aim_enabled then
        if F.aim_hold then aimActive=true else aimActive=not aimActive end
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.KeyCode==F.aim_key and F.aim_hold then aimActive=false end
end)

-- damage counter via humanoid HealthChanged on target
local lastTargetHealth = {}
local function trackDamage(target)
    if not target then return end
    local c=getChar(target); local hum=getHum(c); if not hum then return end
    local prev = lastTargetHealth[target]
    if prev and hum.Health < prev then
        F._hits = F._hits + 1
        hitLbl.Text = ("hits %d · misses %d"):format(F._hits,F._misses)
        dbg("hit on",target.Name,"dmg",round(prev-hum.Health,1))
        lastTargetHealth[target] = hum.Health
        return true
    end
    lastTargetHealth[target] = hum.Health
    return false
end

-- FOV + orbit ring + crosshair + hitmarker + ghost box
local fovCircle = dnew("Circle",{Visible=false,Thickness=1,NumSides=64,Color=F.aim_fov_color,Filled=false,Radius=F.aim_fov})
local orbitRing = dnew("Circle",{Visible=false,Thickness=1,NumSides=48,Color=F.orbit_color,Filled=false,Radius=50})
local cross = {
    t=dnew("Line",{Visible=false,Color=F.cross_color,Thickness=1}),
    b=dnew("Line",{Visible=false,Color=F.cross_color,Thickness=1}),
    l=dnew("Line",{Visible=false,Color=F.cross_color,Thickness=1}),
    r=dnew("Line",{Visible=false,Color=F.cross_color,Thickness=1}),
    d=dnew("Circle",{Visible=false,Color=F.cross_color,Thickness=1,NumSides=8,Radius=1,Filled=true}),
}
local hm = {
    l1=dnew("Line",{Visible=false,Color=F.hitmark_color,Thickness=1}),
    l2=dnew("Line",{Visible=false,Color=F.hitmark_color,Thickness=1}),
    l3=dnew("Line",{Visible=false,Color=F.hitmark_color,Thickness=1}),
    l4=dnew("Line",{Visible=false,Color=F.hitmark_color,Thickness=1}),
}
local hmTime = 0
local ghostBox = dnew("Square",{Visible=false,Color=F.void_box_color,Thickness=1,Filled=false})

-- ESP registry (totally separate from aim)
local espObjs = {}
local function espBuild(p)
    if espObjs[p] then return espObjs[p] end
    local o = {draw={}}
    o.draw.box      = dnew("Square",{Visible=false,Color=F.esp_box_color,Thickness=1,Filled=false})
    o.draw.boxOut   = dnew("Square",{Visible=false,Color=T.black,Thickness=3,Filled=false})
    o.draw.name     = dnew("Text",{Visible=false,Center=true,Color=F.esp_name_color,Size=13,Outline=true})
    o.draw.hpBg     = dnew("Line",{Visible=false,Color=T.black,Thickness=3})
    o.draw.hp       = dnew("Line",{Visible=false,Color=F.esp_hp_hi,Thickness=1})
    o.draw.hpTxt    = dnew("Text",{Visible=false,Center=true,Color=T.white,Size=11,Outline=true})
    o.draw.weap     = dnew("Text",{Visible=false,Center=true,Color=F.esp_weapon_color,Size=11,Outline=true})
    o.draw.headdot  = dnew("Circle",{Visible=false,Color=F.esp_box_color,Thickness=1,NumSides=12,Filled=false,Radius=3})
    o.draw.tracer   = dnew("Line",{Visible=false,Color=F.tracer_color,Thickness=1})
    espObjs[p] = o
    return o
end
local function espKill(p)
    local o=espObjs[p]; if not o then return end
    for _,d in pairs(o.draw) do safe(d.Remove,d) end
    if o.highlight then o.highlight:Destroy() end
    espObjs[p]=nil
end
Players.PlayerRemoving:Connect(espKill)
local function ensureChams(p)
    local o=espBuild(p); local c=getChar(p); if not c then return end
    if not o.highlight or not o.highlight.Parent then
        o.highlight = Instance.new("Highlight")
        o.highlight.Adornee = c
        o.highlight.Parent = c
    end
    o.highlight.FillColor = F.esp_chams_fill
    o.highlight.OutlineColor = F.esp_chams_outline
    o.highlight.DepthMode = F.esp_chams_depth and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
end
local function killChams(p)
    local o=espObjs[p]; if o and o.highlight then o.highlight:Destroy() o.highlight=nil end
end

-- SKINS
local handlemap = {DB_HANDLE="DoubleBarrel",REV_HANDLE="Revolver"}
local function skinFor(w)
    if w=="DoubleBarrel" then return F.skin_db
    elseif w=="Revolver" then return F.skin_rev
    elseif w=="Shotgun" then return F.skin_shotgun
    elseif w=="TacticalShotgun" then return F.skin_tac
    elseif w=="SMG" then return F.skin_smg end
end
local function getWrap(w,sk)
    local wraps=ReplicatedStorage:FindFirstChild("Wraps"); if not wraps then return end
    local f=wraps:FindFirstChild("["..w.."]"); if not f then return end
    return f:FindFirstChild(sk)
end
local function applyOnHolder(holder, model, isknife)
    local handle = holder:FindFirstChild("Handle"); if not handle or not handle:IsA("BasePart") then return end
    local old = holder:FindFirstChild("SkinModel"); if old then old:Destroy() end
    local clone = model:Clone(); clone.Name="SkinModel"
    if clone:IsA("Model") and not clone.PrimaryPart then local f=clone:FindFirstChildWhichIsA("BasePart") if f then clone.PrimaryPart=f end end
    for _,p in ipairs(clone:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide=false p.Anchored=false p.Massless=true end
        if isknife and p:IsA("MeshPart") then local sa=p:FindFirstChildOfClass("SurfaceAppearance") if sa then sa:Destroy() end end
    end
    clone.Parent = holder
    if clone:IsA("Model") then clone:PivotTo(handle.CFrame) end
    for _,p in ipairs(clone:GetDescendants()) do if p:IsA("BasePart") then local w=Instance.new("WeldConstraint") w.Part0=handle w.Part1=p w.Parent=handle end end
    handle.Transparency = 1
end
applySkins = function()
    if not F.skins_enabled then return end
    local c = LP.Character; if not c then return end
    for _,tool in ipairs(c:GetChildren()) do
        if tool:IsA("Tool") then
            local w = tool.Name:match("^%[(.+)%]$")
            if w then local sk=skinFor(w); if sk and sk~="" then local m=getWrap(w,sk); if m then applyOnHolder(tool,m,false) end end
            elseif tool.Name=="[Knife]" then
                local knives=ReplicatedStorage:FindFirstChild("Knives")
                if knives and F.skin_knife~="" then local m=knives:FindFirstChild(F.skin_knife); if m then applyOnHolder(tool,m,true) end end
            end
        end
    end
    for hfn,_ in pairs(handlemap) do
        local f=c:FindFirstChild(hfn)
        if f then local w=handlemap[hfn]; local sk=skinFor(w); if sk and sk~="" then local m=getWrap(w,sk); if m then applyOnHolder(f,m,false) end end end
    end
end

local function hookChar(char)
    char.ChildAdded:Connect(function(ch) if ch:IsA("Tool") or handlemap[ch.Name] then task.wait(0.1) applySkins() end end)
    local hum = char:WaitForChild("Humanoid",5)
    if hum then
        hum.Died:Connect(function()
            dbg("local died")
            if not F.autoresp then return end
            task.wait(0.3)
            local rem = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Duels") and ReplicatedStorage.Remotes.Duels:FindFirstChild("RespawnNow")
            if rem and rem:IsA("RemoteEvent") then
                for _=1,10 do
                    local c2=LP.Character; local h2=c2 and c2:FindFirstChildOfClass("Humanoid")
                    if h2 and h2.Health>0 then break end
                    safe(rem.FireServer,rem) task.wait(0.5)
                end
            end
        end)
    end
    task.defer(applySkins)
end
LP.CharacterAdded:Connect(hookChar)
if LP.Character then hookChar(LP.Character) end

--==[ FIRE primitive — tries every path, keeps running on miss ]==--
local lastFire = 0
local function fireShot()
    if tick()-lastFire < 0.04 then return end
    lastFire = tick()
    -- 1) mouse1click (Synapse / KRNL)
    if safe(mouse1click) then return end
    -- 2) VirtualInputManager
    if VirtualInput then
        safe(function()
            VirtualInput:SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, true, game, 1)
            VirtualInput:SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, false, game, 1)
        end)
        return
    end
    -- 3) VirtualUser
    if VirtualUser then safe(function() VirtualUser:ClickButton1(Vector2.new()) end) return end
end

--==[ RAGEBOT FSM ]==--
local rageState = {name="IDLE", t=0, target=nil, buriedUntil=0}
local realRootCFrame
local function burySelf()
    local myC=LP.Character; local h=getHrp(myC); if not h then return end
    if not realRootCFrame then realRootCFrame = h.CFrame end
    for _,p in ipairs(myC:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
    local depth = F.rage_enabled and (realRootCFrame.Position.Y - ((F.rage_hp_mult and F.vs_depth) or F.void_depth)) or (realRootCFrame.Position.Y - F.void_depth)
    h.CFrame = CFrame.new(realRootCFrame.Position.X, depth, realRootCFrame.Position.Z)
    if F.void_zero_vel then h.AssemblyLinearVelocity = Vector3.zero end
end
local function surfaceSelf()
    local myC=LP.Character; local h=getHrp(myC); if not h or not realRootCFrame then return end
    h.CFrame = realRootCFrame
end
local function handoffFire(targetPos)
    local myC=LP.Character; local h=getHrp(myC); if not h then return end
    local saved = h.CFrame
    -- flash root to shoot origin near camera, fire, restore
    h.CFrame = CFrame.new(Camera.CFrame.Position - Camera.CFrame.LookVector*2, targetPos)
    task.wait()
    fireShot()
    task.wait(0.03)
    h.CFrame = saved
end

local function rageTick(dt)
    if not F.rage_enabled then rageState.name="IDLE" F._rage_state="IDLE" return end
    local myC=LP.Character; local myH=getHrp(myC); local myHum=getHum(myC); if not myH or not myHum then return end

    if rageState.name=="IDLE" then
        local t = pickTarget()
        if t then
            local tc=getChar(t); local th=tc and getHrp(tc)
            if th and (myH.Position-th.Position).Magnitude <= F.rage_engage then
                rageState.name="APPROACH" rageState.target=t rageState.t=tick()+F.rage_approach_delay
                local hum=getHum(tc); if hum then lastTargetHealth[t] = hum.Health end
                dbg("APPROACH",t.Name)
            end
        end
    elseif rageState.name=="APPROACH" then
        if tick() >= rageState.t then
            local t = rageState.target
            local tc=t and getChar(t); local part = tc and getAimPart(tc)
            if part then
                currentSilentTarget = t
                local pos = resolvePos(t) or part.Position
                driveAim(pos, 1)
                if F.void_enabled and F.void_stay then handoffFire(pos) else fireShot() end
                rageState.name="CONFIRM" rageState.t = tick()+F.rage_confirm_window
                dbg("CONFIRM",t.Name)
            else
                rageState.name="IDLE"
            end
        end
    elseif rageState.name=="CONFIRM" then
        if rageState.target and trackDamage(rageState.target) then
            rageState.name="RETREAT"
            local ratio = myHum.Health / math.max(1,myHum.MaxHealth)
            local tcH = getHum(getChar(rageState.target))
            local enemyRatio = tcH and tcH.Health/math.max(1,tcH.MaxHealth) or 1
            local d = F.rage_retreat
            if ratio > F.rage_hp_threshold and ratio > enemyRatio then d = d * F.rage_hp_mult
            elseif ratio < F.rage_hp_threshold then d = F.rage_short_hop end
            rageState.retreatDist = d
            rageState.t = tick()+0.25
            dbg("RETREAT dist",d)
        elseif tick() >= rageState.t then
            -- one re-aim
            local t = rageState.target
            local tc=t and getChar(t); local part=tc and getAimPart(tc)
            if part then
                local pos=resolvePos(t) or part.Position
                driveAim(pos,1)
                fireShot()
            end
            rageState.name="COOLDOWN" rageState.t=tick()+F.rage_cooldown
            F._misses = F._misses+1
            hitLbl.Text=("hits %d · misses %d"):format(F._hits,F._misses)
        end
    elseif rageState.name=="RETREAT" then
        -- fake-pos away using void handoff while keeping shot alive
        if F.rage_auto_void and not F.void_enabled then F.void_enabled=true end
        local t = rageState.target
        local tc=t and getChar(t); local th=tc and getHrp(tc)
        if th then
            local away = (myH.Position - th.Position)
            if away.Magnitude<1 then away=Vector3.new(1,0,0) end
            away = away.Unit * (rageState.retreatDist or F.rage_retreat)
            realRootCFrame = CFrame.new(th.Position + Vector3.new(away.X,0,away.Z))
            burySelf()
        end
        if tick()>=rageState.t then rageState.name="COOLDOWN" rageState.t=tick()+F.rage_cooldown dbg("COOLDOWN") end
    elseif rageState.name=="COOLDOWN" then
        if tick()>=rageState.t then rageState.name="IDLE" currentSilentTarget=nil dbg("IDLE") end
    end
    F._rage_state = rageState.name
end

--==[ MAIN LOOP ]==--
local spinAcc = 0
local hmTime = 0
local mainConn = RunService.RenderStepped:Connect(function(dt)
    -- sample resolver
    for _,p in ipairs(Players:GetPlayers()) do if p~=LP then sampleRoot(p) end end

    local vp = Camera.ViewportSize/2
    local menuPaused = F.aim_pause_menu and win.Visible

    -- FOV ring
    fovCircle.Position=vp fovCircle.Radius=F.aim_fov fovCircle.Color=F.aim_fov_color
    fovCircle.Visible = F.aim_enabled and F.aim_fov_show

    -- crosshair
    if F.crosshair then
        local bn = F.cross_bounce and math.sin(tick()*4)*2 or 0
        local len = F.cross_len + bn
        cross.t.Visible=true cross.b.Visible=true cross.l.Visible=true cross.r.Visible=true
        cross.t.From=vp+Vector2.new(0,-F.cross_gap) cross.t.To=vp+Vector2.new(0,-F.cross_gap-len)
        cross.b.From=vp+Vector2.new(0,F.cross_gap)  cross.b.To=vp+Vector2.new(0,F.cross_gap+len)
        cross.l.From=vp+Vector2.new(-F.cross_gap,0) cross.l.To=vp+Vector2.new(-F.cross_gap-len,0)
        cross.r.From=vp+Vector2.new(F.cross_gap,0)  cross.r.To=vp+Vector2.new(F.cross_gap+len,0)
        for _,k in ipairs({"t","b","l","r"}) do cross[k].Color=F.cross_color cross[k].Thickness=F.cross_thick end
        cross.d.Position=vp cross.d.Visible=F.cross_dot cross.d.Color=F.cross_color
    else for _,k in ipairs({"t","b","l","r","d"}) do cross[k].Visible=false end end

    -- hitmarker
    if F.hitmark and tick()-hmTime<0.15 then
        local s=10
        hm.l1.Visible=true hm.l1.From=vp+Vector2.new(-s,-s) hm.l1.To=vp+Vector2.new(-3,-3)
        hm.l2.Visible=true hm.l2.From=vp+Vector2.new(s,-s)  hm.l2.To=vp+Vector2.new(3,-3)
        hm.l3.Visible=true hm.l3.From=vp+Vector2.new(-s,s)  hm.l3.To=vp+Vector2.new(-3,3)
        hm.l4.Visible=true hm.l4.From=vp+Vector2.new(s,s)   hm.l4.To=vp+Vector2.new(3,3)
        for _,k in ipairs({"l1","l2","l3","l4"}) do hm[k].Color=F.hitmark_color end
    else for _,k in ipairs({"l1","l2","l3","l4"}) do hm[k].Visible=false end end

    -- ESP render (always its own, never touches aim)
    local myChar=LP.Character
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then
            local c=getChar(p); local h=getHrp(c); local hum=getHum(c); local head=getHead(c)
            local o = espBuild(p)
            local show = F.esp_enabled and c and h and hum and hum.Health>0 and (F.esp_team or isEnemy(p))
            if show then
                local p2,on = worldToScreen(h.Position)
                local td = myChar and getHrp(myChar) and (getHrp(myChar).Position-h.Position).Magnitude or 0
                if on and td<=F.esp_max then
                    local topP = head and select(1,worldToScreen(head.Position+Vector3.new(0,0.8,0))) or (p2+Vector2.new(0,-30))
                    local botP = select(1,worldToScreen(h.Position+Vector3.new(0,-3,0)))
                    local height = math.abs(botP.Y-topP.Y); local width = height*0.55
                    local boxPos = Vector2.new(topP.X-width/2, topP.Y)
                    local boxSize = Vector2.new(width,height)
                    if F.esp_box then
                        o.draw.box.Visible=true o.draw.boxOut.Visible=true
                        o.draw.box.Position=boxPos o.draw.box.Size=boxSize o.draw.box.Color=F.esp_box_color
                        o.draw.boxOut.Position=boxPos o.draw.boxOut.Size=boxSize
                    else o.draw.box.Visible=false o.draw.boxOut.Visible=false end
                    if F.esp_name then o.draw.name.Visible=true o.draw.name.Position=boxPos+Vector2.new(width/2,-14) o.draw.name.Text=p.DisplayName o.draw.name.Color=F.esp_name_color else o.draw.name.Visible=false end
                    if F.esp_hp then
                        local a=math.clamp(hum.Health/math.max(1,hum.MaxHealth),0,1)
                        o.draw.hpBg.Visible=true o.draw.hp.Visible=true
                        o.draw.hpBg.From=boxPos+Vector2.new(-5,0) o.draw.hpBg.To=boxPos+Vector2.new(-5,height)
                        o.draw.hp.From=boxPos+Vector2.new(-5,height*(1-a)) o.draw.hp.To=boxPos+Vector2.new(-5,height)
                        o.draw.hp.Color=F.esp_hp_lo:Lerp(F.esp_hp_hi,a)
                        if F.esp_hp_num then o.draw.hpTxt.Visible=true o.draw.hpTxt.Position=boxPos+Vector2.new(-14,height-14) o.draw.hpTxt.Text=tostring(math.floor(hum.Health)) else o.draw.hpTxt.Visible=false end
                    else o.draw.hpBg.Visible=false o.draw.hp.Visible=false o.draw.hpTxt.Visible=false end
                    local extras={}
                    if F.esp_dist then table.insert(extras,("%dm"):format(td)) end
                    local tool=c:FindFirstChildOfClass("Tool"); if F.esp_weapon and tool then table.insert(extras,tool.Name:gsub("[%[%]]","")) end
                    if #extras>0 then o.draw.weap.Visible=true o.draw.weap.Position=boxPos+Vector2.new(width/2,height+2) o.draw.weap.Text=table.concat(extras," · ") o.draw.weap.Color=F.esp_weapon_color else o.draw.weap.Visible=false end
                    if F.esp_headdot and head then local hp2,on2=worldToScreen(head.Position) o.draw.headdot.Visible=on2 o.draw.headdot.Position=hp2 o.draw.headdot.Color=F.esp_box_color else o.draw.headdot.Visible=false end
                    if F.tracer then
                        local origin = F.tracer_origin=="Top" and Vector2.new(vp.X,0) or F.tracer_origin=="Mouse" and Vector2.new(Mouse.X,Mouse.Y) or Vector2.new(vp.X,Camera.ViewportSize.Y)
                        o.draw.tracer.Visible=true o.draw.tracer.From=origin o.draw.tracer.To=p2 o.draw.tracer.Color=F.tracer_color
                    else o.draw.tracer.Visible=false end
                    if F.esp_chams then ensureChams(p) else killChams(p) end
                else
                    for _,d in pairs(o.draw) do d.Visible=false end killChams(p)
                end
            else
                for _,d in pairs(o.draw) do d.Visible=false end killChams(p)
            end
        end
    end

    -- MANUAL AIM
    if F.aim_enabled and aimActive and not menuPaused and myChar then
        local t = pickTarget()
        if t then
            currentSilentTarget = t
            local c=getChar(t); local part=c and getAimPart(c)
            if part then
                local pos = resolvePos(t) or part.Position
                driveAim(pos, F.aim_smooth)
                if F.targethud then
                    tHud.Visible=true
                    local hum=getHum(c)
                    tHudState.name.Text = t.DisplayName
                    tHudState.sub.Text = ("<font color=\"#828282\">dist</font> %dm"):format(myChar and getHrp(myChar) and (getHrp(myChar).Position-pos).Magnitude or 0)
                    if hum then tHudState.hp.Size = UDim2.new(math.clamp(hum.Health/math.max(1,hum.MaxHealth),0,1),0,1,0) end
                    tHudState.state.Text = "STATE: AIM"
                end
            end
        end
    elseif not F.rage_enabled then
        currentSilentTarget = nil
        if F.targethud and not F.rage_enabled then tHud.Visible=false end
    end

    -- ORBIT
    if F.orbit_enabled and myChar then
        local myH = getHrp(myChar)
        if myH then
            local t = currentSilentTarget or pickTarget()
            if t then
                local tc=getChar(t); local th=tc and getHrp(tc)
                if th then
                    spinAcc = spinAcc + dt*F.orbit_speed
                    local off = Vector3.new(math.cos(spinAcc),0,math.sin(spinAcc))*F.orbit_r
                    myH.CFrame = CFrame.new(th.Position+off, th.Position)
                    if F.void_zero_vel then myH.AssemblyLinearVelocity = Vector3.zero end
                    if F.orbit_show then
                        local sv,on = worldToScreen(th.Position)
                        if on then
                            orbitRing.Visible=true orbitRing.Position=sv
                            orbitRing.Radius=math.max(10,F.orbit_r*8)
                            orbitRing.Color=F.orbit_color
                        end
                    else orbitRing.Visible=false end
                else orbitRing.Visible=false end
            else orbitRing.Visible=false end
        end
    else orbitRing.Visible=false end

    -- RAGEBOT FSM
    rageTick(dt)
    stateLbl.Text = "STATE: "..F._rage_state
    silentLbl.Text = "SILENT: "..(F._silent_live and "LIVE" or (F.silent_enabled and "armed" or "off"))
    silentLbl.TextColor3 = F._silent_live and T.good or (F.silent_enabled and T.accent or T.dim)
    hitLbl.Text = ("hits %d · misses %d"):format(F._hits,F._misses)

    -- VOID fake position (manual)
    if F.void_enabled and not F.rage_enabled and myChar then
        local h = getHrp(myChar)
        if h then
            if not realRootCFrame then realRootCFrame = h.CFrame end
            if F.void_stay then
                local base = realRootCFrame.Position
                local jx = F.void_jitter and math.sin(tick()*8)*F.void_jitter_amt or 0
                local jz = F.void_jitter and math.cos(tick()*8)*F.void_jitter_amt or 0
                h.CFrame = CFrame.new(base.X+jx, base.Y-F.void_depth, base.Z+jz)
                if F.void_zero_vel then h.AssemblyLinearVelocity = Vector3.zero end
                if F.void_noclip then for _,p in ipairs(myChar:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
                if F.void_cam then Camera.CFrame = CFrame.new(base+Vector3.new(0,3,0), base+Camera.CFrame.LookVector) end
                if F.void_box then
                    local sv,on=worldToScreen(base)
                    if on then ghostBox.Visible=true ghostBox.Size=Vector2.new(30,60) ghostBox.Position=Vector2.new(sv.X-15,sv.Y-30) ghostBox.Color=F.void_box_color end
                else ghostBox.Visible=false end
            end
        end
    elseif not F.rage_enabled then
        realRootCFrame = nil
        ghostBox.Visible = false
    end

    -- ANTI-AIM
    if F.aa_enabled and myChar then
        local h=getHrp(myChar)
        if h and not (F.aa_pause_attack and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
            local pitch=0
            if F.aa_pitch=="Down" then pitch=math.rad(89)
            elseif F.aa_pitch=="Up" then pitch=math.rad(-89)
            elseif F.aa_pitch=="Jitter" then pitch=math.rad(math.sin(tick()*F.aa_speed)*89)
            elseif F.aa_pitch=="Random" then pitch=math.rad(math.random(-89,89))
            elseif F.aa_pitch=="Custom" then pitch=math.rad(F.aa_custom_pitch) end
            local camYaw = math.atan2(-Camera.CFrame.LookVector.X, -Camera.CFrame.LookVector.Z)
            local yaw=camYaw
            if F.aa_yaw=="Backward" then yaw=camYaw+math.pi
            elseif F.aa_yaw=="Left" then yaw=camYaw-math.pi/2
            elseif F.aa_yaw=="Right" then yaw=camYaw+math.pi/2
            elseif F.aa_yaw=="Spin" then yaw=tick()*F.aa_speed
            elseif F.aa_yaw=="Sway" then yaw=camYaw+math.sin(tick()*F.aa_speed)*math.rad(F.aa_jitter)
            elseif F.aa_yaw=="Jitter" then yaw=camYaw+math.rad(math.random(-F.aa_jitter,F.aa_jitter))
            elseif F.aa_yaw=="Random" then yaw=math.rad(math.random(-180,180))
            elseif F.aa_yaw=="Custom" then yaw=math.rad(F.aa_custom_yaw) end
            if F.aa_lby then
                local vel = h.AssemblyLinearVelocity or Vector3.zero
                if Vector3.new(vel.X,0,vel.Z).Magnitude < 0.5 then yaw = yaw + math.pi end
            end
            h.CFrame = CFrame.new(h.Position) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
        end
    end

    -- LEGIT aim
    if F.legit_enabled and UserInputService:IsKeyDown(F.legit_key) and not menuPaused and myChar then
        local best,bd=nil,math.huge
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and isEnemy(p) then
                local c=getChar(p); local hd=getHead(c); local hum=getHum(c)
                if hd and hum and hum.Health>0 then
                    local sd=screenDistToCenter(hd.Position)
                    if sd<F.legit_fov and sd<bd then bd=sd best=p end
                end
            end
        end
        if best then local hd=getHead(getChar(best)) if hd then driveAim(hd.Position,F.legit_smooth) end end
    end

    -- TRIGGERBOT
    if F.trigger_enabled and UserInputService:IsKeyDown(F.trigger_key) then
        local rp=RaycastParams.new() rp.FilterDescendantsInstances={myChar} rp.FilterType=Enum.RaycastFilterType.Exclude
        local r=Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector*300, rp)
        if r and r.Instance then
            local p=Players:GetPlayerFromCharacter(r.Instance:FindFirstAncestorOfClass("Model"))
            if p and isEnemy(p) then
                task.wait((F.trigger_reaction+math.random(0,F.trigger_random))/1000)
                fireShot()
            end
        end
    end

    -- MOVEMENT
    if F.wspeed and myChar then local h=getHum(myChar); if h then h.WalkSpeed=F.wspeed_v end end
    if F.noclip and myChar then for _,p in ipairs(myChar:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
    if F.bhop and myChar then local h=getHum(myChar); if h and h:GetState()==Enum.HumanoidStateType.Landed then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
    if F.fly and myChar then
        local h=getHrp(myChar); local hum=getHum(myChar)
        if h and hum then
            hum.PlatformStand=true
            local mv=Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv=mv+Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv=mv-Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv=mv-Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv=mv+Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv=mv+Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then mv=mv-Vector3.new(0,1,0) end
            h.AssemblyLinearVelocity = mv.Magnitude>0 and mv.Unit*F.fly_v or Vector3.new(0,0,0)
        end
    end

    -- Camera FOV
    if F.world_fov ~= 70 then Camera.FieldOfView = F.world_fov end

    -- debug text
    if F.debug_enabled and dbgText then dbgText.Text = table.concat(DEBUG_LOG,"\n") end
end)

-- lighting tweaks
task.spawn(function()
    while Gui.Parent do
        if F.no_fog then Lighting.FogEnd=1e6 end
        if F.sky_preset~="Default" then
            Lighting.ClockTime = F.sky_preset=="Night" and 0 or F.sky_preset=="Sunset" and 17 or F.sky_preset=="Space" and 2 or 14
        end
        task.wait(1)
    end
end)

-- staff detector
task.spawn(function()
    while Gui.Parent do
        if F.staff then
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and (p.Name:lower():find(F.staff_kw:lower()) or p.DisplayName:lower():find(F.staff_kw:lower())) then
                    if F.staff_action=="Notify" then notify("staff","spotted "..p.Name,5) dbg("staff",p.Name)
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
    for _,d in ipairs({fovCircle,orbitRing,cross.t,cross.b,cross.l,cross.r,cross.d,hm.l1,hm.l2,hm.l3,hm.l4,ghostBox}) do safe(d.Remove,d) end
end)

notify("VOIDLINE v2","loaded · menu "..F.menu_key.Name,4)
notify("credits","built by olivia · discord.gg/ojailbreaks",6)
dbg("voidline v2 up")
-- built by olivia — https://discord.gg/ojailbreaks
