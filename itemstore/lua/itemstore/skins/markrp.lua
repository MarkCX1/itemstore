local SKIN = {}

SKIN.Blur = Material( "pp/blurscreen" )

-- ─────────────────────────────────────────────
--  Palette — pure monochrome, no accents
-- ─────────────────────────────────────────────
local C = {
    void       = Color(  8,  8,  8, 255 ),  -- deepest black — window body
    abyss      = Color( 14, 14, 14, 255 ),  -- title bar
    pit        = Color( 20, 20, 20, 255 ),  -- slot default
    shade      = Color( 32, 32, 32, 255 ),  -- slot hovered
    lift       = Color( 50, 50, 50, 255 ),  -- slot pressed / selected
    mist       = Color( 22, 22, 22, 255 ),  -- panel backgrounds
    ghost      = Color( 38, 38, 38, 255 ),  -- tab idle
    spectre    = Color( 55, 55, 55, 255 ),  -- tab active
    dim        = Color( 18, 18, 18, 255 ),  -- category header
    fog        = Color( 28, 28, 28, 200 ),  -- property sheet
    white      = color_white,
    danger     = Color( 160, 28, 28, 255 ), -- close hover
    dangerdown = Color( 120, 18, 18, 255 ), -- close pressed
    steelh     = Color(  38, 80, 120, 255 ),-- max hover
    steeld     = Color(  28, 60,  95, 255 ),-- max pressed
}

-- ─────────────────────────────────────────────
--  Frame
-- ─────────────────────────────────────────────
function SKIN:PaintFrame( panel, w, h )
    -- Subtle background blur
    self.Blur:SetFloat( "$blur", 3 )
    self.Blur:Recompute()
    render.UpdateScreenEffectTexture()

    local x, y = panel:LocalToScreen( 0, 0 )
    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial( self.Blur )
    surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )

    -- Body
    surface.SetDrawColor( C.void )
    surface.DrawRect( 0, 22, w, h - 22 )

    -- Title bar
    surface.SetDrawColor( C.abyss )
    surface.DrawRect( 0, 0, w, 22 )

    -- Single pixel separator under title
    surface.SetDrawColor( C.lift )
    surface.DrawRect( 0, 21, w, 1 )
end

-- ─────────────────────────────────────────────
--  Button / Slot  — completely flat, no border
-- ─────────────────────────────────────────────
function SKIN:PaintButton( panel, w, h )
    local col = C.pit

    if not panel.Disabled then
        if panel.Depressed then
            col = C.lift
        elseif panel.Hovered then
            col = C.shade
        end
    end

    surface.SetDrawColor( col )
    surface.DrawRect( 0, 0, w, h )
    -- no outline — fully flat
end

-- ─────────────────────────────────────────────
--  Tabs
-- ─────────────────────────────────────────────
function SKIN:PaintTab( panel, w, h )
    local col = panel:IsActive() and C.spectre or C.ghost
    surface.SetDrawColor( col )
    surface.DrawRect( 0, 0, w, h )

    -- Active tab: single pixel bottom highlight
    if panel:IsActive() then
        surface.SetDrawColor( C.lift )
        surface.DrawRect( 0, h - 1, w, 1 )
    end
end

-- ─────────────────────────────────────────────
--  Property sheet
-- ─────────────────────────────────────────────
function SKIN:PaintPropertySheet( panel, w, h )
    surface.SetDrawColor( C.fog )
    surface.DrawRect( 0, 20, w, h - 20 )
end

-- ─────────────────────────────────────────────
--  Category list
-- ─────────────────────────────────────────────
function SKIN:PaintCategoryList( panel, w, h )
    surface.SetDrawColor( C.void )
    surface.DrawRect( 0, 0, w, h )
end

-- ─────────────────────────────────────────────
--  Collapsible category
-- ─────────────────────────────────────────────
function SKIN:PaintCollapsibleCategory( panel, w, h )
    surface.SetDrawColor( C.dim )
    surface.DrawRect( 0, 0, w, 20 )

    surface.SetDrawColor( C.lift )
    surface.DrawRect( 0, 19, w, 1 )

    surface.SetDrawColor( C.void )
    surface.DrawRect( 0, 20, w, h - 20 )
end

-- ─────────────────────────────────────────────
--  Close button
-- ─────────────────────────────────────────────
function SKIN:PaintWindowCloseButton( panel, w, h )
    local col = Color( 0, 0, 0, 0 )

    if not panel:GetDisabled() and panel.Hovered then
        col = panel:IsDown() and C.dangerdown or C.danger
    end

    surface.SetDrawColor( col )
    surface.DrawRect( 0, 2, w, 18 )
    draw.SimpleText( "r", "Marlett", w / 2, 11, C.white,
        TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- ─────────────────────────────────────────────
--  Maximise button
-- ─────────────────────────────────────────────
function SKIN:PaintWindowMaximizeButton( panel, w, h )
    if panel:GetDisabled() then return end

    local col = Color( 0, 0, 0, 0 )

    if panel.Hovered then
        col = panel:IsDown() and C.steeld or C.steelh
    end

    surface.SetDrawColor( col )
    surface.DrawRect( 0, 2, w, 18 )
    draw.SimpleText( "1", "Marlett", w / 2, 11, C.white,
        TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- ─────────────────────────────────────────────
--  Minimise button — hidden
-- ─────────────────────────────────────────────
function SKIN:PaintWindowMinimizeButton( panel, w, h )
    if true then return end
end

-- ─────────────────────────────────────────────
--  Scrollbar
-- ─────────────────────────────────────────────
function SKIN:PaintScrollbarTrack( panel, w, h )
    surface.SetDrawColor( C.void )
    surface.DrawRect( 0, 0, w, h )
end

function SKIN:PaintScrollbarGrip( panel, w, h )
    local col = panel.Hovered and C.lift or C.ghost
    surface.SetDrawColor( col )
    surface.DrawRect( 1, 0, w - 2, h )
end

-- ─────────────────────────────────────────────
--  Register
-- ─────────────────────────────────────────────
derma.DefineSkin( "itemstore", "Skin for ItemStore", SKIN )