module LibCImPlot

using CEnum

using CImPlot_jll

using CImGui

import CImGui: 
    # Vector primitives:
    ImVec2, ImVec4,
    # Enums
    ImGuiMouseButton, ImGuiKeyModFlags, ImGuiCond, ImGuiDragDropFlags,
    # Primitive type aliases; uncomment after CImGui update
    #=ImS8,=# ImU8, ImS16, ImU16, ImS32, ImU32, ImS64, ImU64,
    ImTextureID,
    ImDrawList,
    ImGuiContext
            
#Temporary patch; CImGui.jl v1.79.0 aliases ImS8 incorrectly
const ImS8 = Int8

const IMPLOT_AUTO = Cint(-1)
const IMPLOT_AUTO_COL = ImVec4(0,0,0,-1)


const ImGuiID = Cuint

const ImS8 = Int8

const ImGuiTableColumnIdx = ImS8

const ImU8 = Cuchar

struct ImGuiTableColumnSettings
    data::NTuple{12, UInt8}
end

function Base.getproperty(x::Ptr{ImGuiTableColumnSettings}, f::Symbol)
    f === :WidthOrWeight && return Ptr{Cfloat}(x + 0)
    f === :UserID && return Ptr{ImGuiID}(x + 4)
    f === :Index && return Ptr{ImGuiTableColumnIdx}(x + 8)
    f === :DisplayOrder && return Ptr{ImGuiTableColumnIdx}(x + 9)
    f === :SortOrder && return Ptr{ImGuiTableColumnIdx}(x + 10)
    f === :SortDirection && return Ptr{ImU8}(x + 11)
    f === :IsEnabled && return (Ptr{ImU8}(x + 11), 2, 1)
    f === :IsStretch && return (Ptr{ImU8}(x + 11), 3, 1)
    return getfield(x, f)
end

function Base.getproperty(x::ImGuiTableColumnSettings, f::Symbol)
    r = Ref{ImGuiTableColumnSettings}(x)
    ptr = Base.unsafe_convert(Ptr{ImGuiTableColumnSettings}, r)
    fptr = getproperty(ptr, f)
    begin
        if fptr isa Ptr
            return GC.@preserve(r, unsafe_load(fptr))
        else
            (baseptr, offset, width) = fptr
            ty = eltype(baseptr)
            i8 = GC.@preserve(r, unsafe_load(baseptr))
            bitstr = bitstring(i8)
            sig = bitstr[(end - offset) - (width - 1):end - offset]
            zexted = lpad(sig, 8 * sizeof(ty), '0')
            return parse(ty, zexted; base = 2)
        end
    end
end

function Base.setproperty!(x::Ptr{ImGuiTableColumnSettings}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const ImU32 = Cuint

struct ImGuiTableCellData
    BgColor::ImU32
    Column::ImGuiTableColumnIdx
end

struct ImGuiViewportP
    _ImGuiViewport::ImGuiViewport
    DrawListsLastFrame::NTuple{2, Cint}
    DrawLists::NTuple{2, Ptr{ImDrawList}}
    DrawDataP::ImDrawData
    DrawDataBuilder::ImDrawDataBuilder
    WorkOffsetMin::ImVec2
    WorkOffsetMax::ImVec2
    CurrWorkOffsetMin::ImVec2
    CurrWorkOffsetMax::ImVec2
end

struct ImGuiPtrOrIndex
    Ptr::Ptr{Cvoid}
    Index::Cint
end

struct ImGuiShrinkWidthItem
    Index::Cint
    Width::Cfloat
end

mutable struct ImGuiDataTypeTempStorage
    Data::NTuple{8, ImU8}
end

mutable struct ImVec2ih
    x::Cshort
    y::Cshort
end

mutable struct ImVec1
    x::Cfloat
end

mutable struct StbTexteditRow
    x0::Cfloat
    x1::Cfloat
    baseline_y_delta::Cfloat
    ymin::Cfloat
    ymax::Cfloat
    num_chars::Cint
end

struct StbUndoRecord
    where::Cint
    insert_length::Cint
    delete_length::Cint
    char_storage::Cint
end

const ImWchar16 = Cushort

const ImWchar = ImWchar16

struct StbUndoState
    undo_rec::NTuple{99, StbUndoRecord}
    undo_char::NTuple{999, ImWchar}
    undo_point::Cshort
    redo_point::Cshort
    undo_char_point::Cint
    redo_char_point::Cint
end

mutable struct STB_TexteditState
    cursor::Cint
    select_start::Cint
    select_end::Cint
    insert_mode::Cuchar
    row_count_per_page::Cint
    cursor_at_end_of_line::Cuchar
    initialized::Cuchar
    has_preferred_x::Cuchar
    single_line::Cuchar
    padding1::Cuchar
    padding2::Cuchar
    padding3::Cuchar
    preferred_x::Cfloat
    undostate::StbUndoState
end

struct ImGuiWindowSettings
    ID::ImGuiID
    Pos::ImVec2ih
    Size::ImVec2ih
    Collapsed::Cint
    WantApply::Cint
end

mutable struct ImGuiWindowTempData
    CursorPos::ImVec2
    CursorPosPrevLine::ImVec2
    CursorStartPos::ImVec2
    CursorMaxPos::ImVec2
    IdealMaxPos::ImVec2
    CurrLineSize::ImVec2
    PrevLineSize::ImVec2
    CurrLineTextBaseOffset::Cfloat
    PrevLineTextBaseOffset::Cfloat
    Indent::ImVec1
    ColumnsOffset::ImVec1
    GroupOffset::ImVec1
    LastItemId::ImGuiID
    LastItemStatusFlags::ImGuiItemStatusFlags
    LastItemRect::ImRect
    LastItemDisplayRect::ImRect
    NavLayerCurrent::ImGuiNavLayer
    NavLayerActiveMask::Cint
    NavLayerActiveMaskNext::Cint
    NavFocusScopeIdCurrent::ImGuiID
    NavHideHighlightOneFrame::Cint
    NavHasScroll::Cint
    MenuBarAppending::Cint
    MenuBarOffset::ImVec2
    MenuColumns::ImGuiMenuColumns
    TreeDepth::Cint
    TreeJumpToParentOnPopMask::ImU32
    ChildWindows::ImVector_ImGuiWindowPtr
    StateStorage::Ptr{ImGuiStorage}
    CurrentColumns::Ptr{ImGuiOldColumns}
    CurrentTableIdx::Cint
    LayoutType::ImGuiLayoutType
    ParentLayoutType::ImGuiLayoutType
    FocusCounterRegular::Cint
    FocusCounterTabStop::Cint
    ItemFlags::ImGuiItemFlags
    ItemWidth::Cfloat
    TextWrapPos::Cfloat
    ItemWidthStack::ImVector_float
    TextWrapPosStack::ImVector_float
    StackSizesOnBegin::ImGuiStackSizes
end

struct ImGuiWindow
    Name::Cstring
    ID::ImGuiID
    Flags::ImGuiWindowFlags
    Pos::ImVec2
    Size::ImVec2
    SizeFull::ImVec2
    ContentSize::ImVec2
    ContentSizeIdeal::ImVec2
    ContentSizeExplicit::ImVec2
    WindowPadding::ImVec2
    WindowRounding::Cfloat
    WindowBorderSize::Cfloat
    NameBufLen::Cint
    MoveId::ImGuiID
    ChildId::ImGuiID
    Scroll::ImVec2
    ScrollMax::ImVec2
    ScrollTarget::ImVec2
    ScrollTargetCenterRatio::ImVec2
    ScrollTargetEdgeSnapDist::ImVec2
    ScrollbarSizes::ImVec2
    ScrollbarX::Cint
    ScrollbarY::Cint
    Active::Cint
    WasActive::Cint
    WriteAccessed::Cint
    Collapsed::Cint
    WantCollapseToggle::Cint
    SkipItems::Cint
    Appearing::Cint
    Hidden::Cint
    IsFallbackWindow::Cint
    HasCloseButton::Cint
    ResizeBorderHeld::Int8
    BeginCount::Cshort
    BeginOrderWithinParent::Cshort
    BeginOrderWithinContext::Cshort
    PopupId::ImGuiID
    AutoFitFramesX::ImS8
    AutoFitFramesY::ImS8
    AutoFitChildAxises::ImS8
    AutoFitOnlyGrows::Cint
    AutoPosLastDirection::ImGuiDir
    HiddenFramesCanSkipItems::ImS8
    HiddenFramesCannotSkipItems::ImS8
    HiddenFramesForRenderOnly::ImS8
    SetWindowPosAllowFlags::ImGuiCond
    SetWindowSizeAllowFlags::ImGuiCond
    SetWindowCollapsedAllowFlags::ImGuiCond
    SetWindowPosVal::ImVec2
    SetWindowPosPivot::ImVec2
    IDStack::ImVector_ImGuiID
    DC::ImGuiWindowTempData
    OuterRectClipped::ImRect
    InnerRect::ImRect
    InnerClipRect::ImRect
    WorkRect::ImRect
    ParentWorkRect::ImRect
    ClipRect::ImRect
    ContentRegionRect::ImRect
    HitTestHoleSize::ImVec2ih
    HitTestHoleOffset::ImVec2ih
    LastFrameActive::Cint
    LastTimeActive::Cfloat
    ItemWidthDefault::Cfloat
    StateStorage::ImGuiStorage
    ColumnsStorage::ImVector_ImGuiOldColumns
    FontWindowScale::Cfloat
    SettingsOffset::Cint
    DrawList::Ptr{ImDrawList}
    DrawListInst::ImDrawList
    ParentWindow::Ptr{ImGuiWindow}
    RootWindow::Ptr{ImGuiWindow}
    RootWindowForTitleBarHighlight::Ptr{ImGuiWindow}
    RootWindowForNav::Ptr{ImGuiWindow}
    NavLastChildNavWindow::Ptr{ImGuiWindow}
    NavLastIds::NTuple{2, ImGuiID}
    NavRectRel::NTuple{2, ImRect}
    MemoryDrawListIdxCapacity::Cint
    MemoryDrawListVtxCapacity::Cint
    MemoryCompacted::Cint
end

mutable struct ImGuiTableColumnsSettings end

struct ImGuiTableSettings
    ID::ImGuiID
    SaveFlags::ImGuiTableFlags
    RefScale::Cfloat
    ColumnsCount::ImGuiTableColumnIdx
    ColumnsCountMax::ImGuiTableColumnIdx
    WantApply::Cint
end

struct ImGuiTableColumn
    Flags::ImGuiTableColumnFlags
    WidthGiven::Cfloat
    MinX::Cfloat
    MaxX::Cfloat
    WidthRequest::Cfloat
    WidthAuto::Cfloat
    StretchWeight::Cfloat
    InitStretchWeightOrWidth::Cfloat
    ClipRect::ImRect
    UserID::ImGuiID
    WorkMinX::Cfloat
    WorkMaxX::Cfloat
    ItemWidth::Cfloat
    ContentMaxXFrozen::Cfloat
    ContentMaxXUnfrozen::Cfloat
    ContentMaxXHeadersUsed::Cfloat
    ContentMaxXHeadersIdeal::Cfloat
    NameOffset::ImS16
    DisplayOrder::ImGuiTableColumnIdx
    IndexWithinEnabledSet::ImGuiTableColumnIdx
    PrevEnabledColumn::ImGuiTableColumnIdx
    NextEnabledColumn::ImGuiTableColumnIdx
    SortOrder::ImGuiTableColumnIdx
    DrawChannelCurrent::ImGuiTableDrawChannelIdx
    DrawChannelFrozen::ImGuiTableDrawChannelIdx
    DrawChannelUnfrozen::ImGuiTableDrawChannelIdx
    IsEnabled::Cint
    IsEnabledNextFrame::Cint
    IsVisibleX::Cint
    IsVisibleY::Cint
    IsRequestOutput::Cint
    IsSkipItems::Cint
    IsPreserveWidthAuto::Cint
    NavLayerCurrent::ImS8
    AutoFitQueue::ImU8
    CannotSkipItemsQueue::ImU8
    SortDirection::ImU8
    SortDirectionsAvailCount::ImU8
    SortDirectionsAvailMask::ImU8
    SortDirectionsAvailList::ImU8
end

struct ImGuiTable
    ID::ImGuiID
    Flags::ImGuiTableFlags
    RawData::Ptr{Cvoid}
    Columns::ImSpan_ImGuiTableColumn
    DisplayOrderToIndex::ImSpan_ImGuiTableColumnIdx
    RowCellData::ImSpan_ImGuiTableCellData
    EnabledMaskByDisplayOrder::ImU64
    EnabledMaskByIndex::ImU64
    VisibleMaskByIndex::ImU64
    RequestOutputMaskByIndex::ImU64
    SettingsLoadedFlags::ImGuiTableFlags
    SettingsOffset::Cint
    LastFrameActive::Cint
    ColumnsCount::Cint
    CurrentRow::Cint
    CurrentColumn::Cint
    InstanceCurrent::ImS16
    InstanceInteracted::ImS16
    RowPosY1::Cfloat
    RowPosY2::Cfloat
    RowMinHeight::Cfloat
    RowTextBaseline::Cfloat
    RowIndentOffsetX::Cfloat
    RowFlags::ImGuiTableRowFlags
    LastRowFlags::ImGuiTableRowFlags
    RowBgColorCounter::Cint
    RowBgColor::NTuple{2, ImU32}
    BorderColorStrong::ImU32
    BorderColorLight::ImU32
    BorderX1::Cfloat
    BorderX2::Cfloat
    HostIndentX::Cfloat
    MinColumnWidth::Cfloat
    OuterPaddingX::Cfloat
    CellPaddingX::Cfloat
    CellPaddingY::Cfloat
    CellSpacingX1::Cfloat
    CellSpacingX2::Cfloat
    LastOuterHeight::Cfloat
    LastFirstRowHeight::Cfloat
    InnerWidth::Cfloat
    ColumnsGivenWidth::Cfloat
    ColumnsAutoFitWidth::Cfloat
    ResizedColumnNextWidth::Cfloat
    ResizeLockMinContentsX2::Cfloat
    RefScale::Cfloat
    OuterRect::ImRect
    InnerRect::ImRect
    WorkRect::ImRect
    InnerClipRect::ImRect
    BgClipRect::ImRect
    Bg0ClipRectForDrawCmd::ImRect
    Bg2ClipRectForDrawCmd::ImRect
    HostClipRect::ImRect
    HostBackupWorkRect::ImRect
    HostBackupParentWorkRect::ImRect
    HostBackupInnerClipRect::ImRect
    HostBackupPrevLineSize::ImVec2
    HostBackupCurrLineSize::ImVec2
    HostBackupCursorMaxPos::ImVec2
    UserOuterSize::ImVec2
    HostBackupColumnsOffset::ImVec1
    HostBackupItemWidth::Cfloat
    HostBackupItemWidthStackSize::Cint
    OuterWindow::Ptr{ImGuiWindow}
    InnerWindow::Ptr{ImGuiWindow}
    ColumnsNames::ImGuiTextBuffer
    DrawSplitter::ImDrawListSplitter
    SortSpecsSingle::ImGuiTableColumnSortSpecs
    SortSpecsMulti::ImVector_ImGuiTableColumnSortSpecs
    SortSpecs::ImGuiTableSortSpecs
    SortSpecsCount::ImGuiTableColumnIdx
    ColumnsEnabledCount::ImGuiTableColumnIdx
    ColumnsEnabledFixedCount::ImGuiTableColumnIdx
    DeclColumnsCount::ImGuiTableColumnIdx
    HoveredColumnBody::ImGuiTableColumnIdx
    HoveredColumnBorder::ImGuiTableColumnIdx
    AutoFitSingleColumn::ImGuiTableColumnIdx
    ResizedColumn::ImGuiTableColumnIdx
    LastResizedColumn::ImGuiTableColumnIdx
    HeldHeaderColumn::ImGuiTableColumnIdx
    ReorderColumn::ImGuiTableColumnIdx
    ReorderColumnDir::ImGuiTableColumnIdx
    LeftMostEnabledColumn::ImGuiTableColumnIdx
    RightMostEnabledColumn::ImGuiTableColumnIdx
    LeftMostStretchedColumn::ImGuiTableColumnIdx
    RightMostStretchedColumn::ImGuiTableColumnIdx
    ContextPopupColumn::ImGuiTableColumnIdx
    FreezeRowsRequest::ImGuiTableColumnIdx
    FreezeRowsCount::ImGuiTableColumnIdx
    FreezeColumnsRequest::ImGuiTableColumnIdx
    FreezeColumnsCount::ImGuiTableColumnIdx
    RowCellDataCurrent::ImGuiTableColumnIdx
    DummyDrawChannel::ImGuiTableDrawChannelIdx
    Bg2DrawChannelCurrent::ImGuiTableDrawChannelIdx
    Bg2DrawChannelUnfrozen::ImGuiTableDrawChannelIdx
    IsLayoutLocked::Cint
    IsInsideRow::Cint
    IsInitializing::Cint
    IsSortSpecsDirty::Cint
    IsUsingHeaders::Cint
    IsContextPopupOpen::Cint
    IsSettingsRequestLoad::Cint
    IsSettingsDirty::Cint
    IsDefaultDisplayOrder::Cint
    IsResetAllRequest::Cint
    IsResetDisplayOrderRequest::Cint
    IsUnfrozenRows::Cint
    IsDefaultSizingPolicy::Cint
    MemoryCompacted::Cint
    HostSkipItems::Cint
end

struct ImGuiTabItem
    ID::ImGuiID
    Flags::ImGuiTabItemFlags
    LastFrameVisible::Cint
    LastFrameSelected::Cint
    Offset::Cfloat
    Width::Cfloat
    ContentWidth::Cfloat
    NameOffset::ImS16
    BeginOrder::ImS16
    IndexDuringLayout::ImS16
    WantClose::Cint
end

struct ImGuiTabBar
    Tabs::ImVector_ImGuiTabItem
    Flags::ImGuiTabBarFlags
    ID::ImGuiID
    SelectedTabId::ImGuiID
    NextSelectedTabId::ImGuiID
    VisibleTabId::ImGuiID
    CurrFrameVisible::Cint
    PrevFrameVisible::Cint
    BarRect::ImRect
    CurrTabsContentsHeight::Cfloat
    PrevTabsContentsHeight::Cfloat
    WidthAllTabs::Cfloat
    WidthAllTabsIdeal::Cfloat
    ScrollingAnim::Cfloat
    ScrollingTarget::Cfloat
    ScrollingTargetDistToVisibility::Cfloat
    ScrollingSpeed::Cfloat
    ScrollingRectMinX::Cfloat
    ScrollingRectMaxX::Cfloat
    ReorderRequestTabId::ImGuiID
    ReorderRequestDir::ImS8
    BeginCount::ImS8
    WantLayout::Cint
    VisibleTabWasSubmitted::Cint
    TabsAddedNew::Cint
    TabsActiveCount::ImS16
    LastTabItemIdx::ImS16
    ItemSpacingY::Cfloat
    FramePadding::ImVec2
    BackupCursorPos::ImVec2
    TabsNames::ImGuiTextBuffer
end

const ImGuiStyleVar = Cint

struct ImGuiStyleMod
    data::NTuple{12, UInt8}
end

function Base.getproperty(x::Ptr{ImGuiStyleMod}, f::Symbol)
    f === :VarIdx && return Ptr{ImGuiStyleVar}(x + 0)
    f === :BackupInt && return Ptr{NTuple{2, Cint}}(x + 4)
    f === :BackupFloat && return Ptr{NTuple{2, Cfloat}}(x + 4)
    return getfield(x, f)
end

function Base.getproperty(x::ImGuiStyleMod, f::Symbol)
    r = Ref{ImGuiStyleMod}(x)
    ptr = Base.unsafe_convert(Ptr{ImGuiStyleMod}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{ImGuiStyleMod}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

mutable struct ImGuiStackSizes
    SizeOfIDStack::Cshort
    SizeOfColorStack::Cshort
    SizeOfStyleVarStack::Cshort
    SizeOfFontStack::Cshort
    SizeOfFocusScopeStack::Cshort
    SizeOfGroupStack::Cshort
    SizeOfBeginPopupStack::Cshort
end

struct ImGuiSettingsHandler
    TypeName::Cstring
    TypeHash::ImGuiID
    ClearAllFn::Ptr{Cvoid}
    ReadInitFn::Ptr{Cvoid}
    ReadOpenFn::Ptr{Cvoid}
    ReadLineFn::Ptr{Cvoid}
    ApplyAllFn::Ptr{Cvoid}
    WriteAllFn::Ptr{Cvoid}
    UserData::Ptr{Cvoid}
end

struct ImVec2
    x::Cfloat
    y::Cfloat
end

struct ImGuiPopupData
    PopupId::ImGuiID
    Window::Ptr{ImGuiWindow}
    SourceWindow::Ptr{ImGuiWindow}
    OpenFrameCount::Cint
    OpenParentId::ImGuiID
    OpenPopupPos::ImVec2
    OpenMousePos::ImVec2
end

struct ImGuiOldColumns
    ID::ImGuiID
    Flags::ImGuiOldColumnFlags
    IsFirstFrame::Cint
    IsBeingResized::Cint
    Current::Cint
    Count::Cint
    OffMinX::Cfloat
    OffMaxX::Cfloat
    LineMinY::Cfloat
    LineMaxY::Cfloat
    HostCursorPosY::Cfloat
    HostCursorMaxPosX::Cfloat
    HostInitialClipRect::ImRect
    HostBackupClipRect::ImRect
    HostBackupParentWorkRect::ImRect
    Columns::ImVector_ImGuiOldColumnData
    Splitter::ImDrawListSplitter
end

const ImGuiOldColumnFlags = Cint

struct ImRect
    Min::ImVec2
    Max::ImVec2
end

struct ImGuiOldColumnData
    OffsetNorm::Cfloat
    OffsetNormBeforeResize::Cfloat
    Flags::ImGuiOldColumnFlags
    ClipRect::ImRect
end

mutable struct ImGuiNextItemData
    Flags::ImGuiNextItemDataFlags
    Width::Cfloat
    FocusScopeId::ImGuiID
    OpenCond::ImGuiCond
    OpenVal::Cint
end

mutable struct ImGuiNextWindowData
    Flags::ImGuiNextWindowDataFlags
    PosCond::ImGuiCond
    SizeCond::ImGuiCond
    CollapsedCond::ImGuiCond
    PosVal::ImVec2
    PosPivotVal::ImVec2
    SizeVal::ImVec2
    ContentSizeVal::ImVec2
    ScrollVal::ImVec2
    CollapsedVal::Cint
    SizeConstraintRect::ImRect
    SizeCallback::ImGuiSizeCallback
    SizeCallbackUserData::Ptr{Cvoid}
    BgAlphaVal::Cfloat
    MenuBarOffsetMinVal::ImVec2
end

mutable struct ImGuiMetricsConfig
    ShowWindowsRects::Cint
    ShowWindowsBeginOrder::Cint
    ShowTablesRects::Cint
    ShowDrawCmdMesh::Cint
    ShowDrawCmdBoundingBoxes::Cint
    ShowWindowsRectsType::Cint
    ShowTablesRectsType::Cint
end

mutable struct ImGuiNavMoveResult
    Window::Ptr{ImGuiWindow}
    ID::ImGuiID
    FocusScopeId::ImGuiID
    DistBox::Cfloat
    DistCenter::Cfloat
    DistAxial::Cfloat
    RectRel::ImRect
end

struct ImGuiMenuColumns
    Spacing::Cfloat
    Width::Cfloat
    NextWidth::Cfloat
    Pos::NTuple{3, Cfloat}
    NextWidths::NTuple{3, Cfloat}
end

const ImGuiItemStatusFlags = Cint

mutable struct ImGuiLastItemDataBackup
    LastItemId::ImGuiID
    LastItemStatusFlags::ImGuiItemStatusFlags
    LastItemRect::ImRect
    LastItemDisplayRect::ImRect
end

struct ImGuiInputTextState
    ID::ImGuiID
    CurLenW::Cint
    CurLenA::Cint
    TextW::ImVector_ImWchar
    TextA::ImVector_char
    InitialTextA::ImVector_char
    TextAIsValid::Cint
    BufCapacityA::Cint
    ScrollX::Cfloat
    Stb::STB_TexteditState
    CursorAnim::Cfloat
    CursorFollow::Cint
    SelectedAllMouseLock::Cint
    Edited::Cint
    UserFlags::ImGuiInputTextFlags
    UserCallback::ImGuiInputTextCallback
    UserCallbackData::Ptr{Cvoid}
end

struct ImGuiGroupData
    WindowID::ImGuiID
    BackupCursorPos::ImVec2
    BackupCursorMaxPos::ImVec2
    BackupIndent::ImVec1
    BackupGroupOffset::ImVec1
    BackupCurrLineSize::ImVec2
    BackupCurrLineTextBaseOffset::Cfloat
    BackupActiveIdIsAlive::ImGuiID
    BackupActiveIdPreviousFrameIsAlive::Cint
    BackupHoveredIdIsAlive::Cint
    EmitItem::Cint
end

mutable struct ImGuiDataTypeInfo
    Size::Cint
    Name::Cstring
    PrintFmt::Cstring
    ScanFmt::Cstring
end

@cenum ImGuiContextHookType::UInt32 begin
    ImGuiContextHookType_NewFramePre = 0
    ImGuiContextHookType_NewFramePost = 1
    ImGuiContextHookType_EndFramePre = 2
    ImGuiContextHookType_EndFramePost = 3
    ImGuiContextHookType_RenderPre = 4
    ImGuiContextHookType_RenderPost = 5
    ImGuiContextHookType_Shutdown = 6
    ImGuiContextHookType_PendingRemoval_ = 7
end

# typedef void ( * ImGuiContextHookCallback ) ( ImGuiContext * ctx , ImGuiContextHook * hook )
const ImGuiContextHookCallback = Ptr{Cvoid}

struct ImGuiContextHook
    HookId::ImGuiID
    Type::ImGuiContextHookType
    Owner::ImGuiID
    Callback::ImGuiContextHookCallback
    UserData::Ptr{Cvoid}
end

const ImGuiCol = Cint

struct ImVec4
    x::Cfloat
    y::Cfloat
    z::Cfloat
    w::Cfloat
end

struct ImGuiColorMod
    Col::ImGuiCol
    BackupValue::ImVec4
end

const ImTextureID = Ptr{Cvoid}

# typedef void ( * ImDrawCallback ) ( const ImDrawList * parent_list , const ImDrawCmd * cmd )
const ImDrawCallback = Ptr{Cvoid}

struct ImDrawCmd
    ClipRect::ImVec4
    TextureId::ImTextureID
    VtxOffset::Cuint
    IdxOffset::Cuint
    ElemCount::Cuint
    UserCallback::ImDrawCallback
    UserCallbackData::Ptr{Cvoid}
end

struct ImVector_ImDrawCmd
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImDrawCmd}
end

const ImDrawIdx = Cushort

struct ImVector_ImDrawIdx
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImDrawIdx}
end

struct ImDrawVert
    pos::ImVec2
    uv::ImVec2
    col::ImU32
end

struct ImVector_ImDrawVert
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImDrawVert}
end

const ImDrawListFlags = Cint

struct ImFont
    IndexAdvanceX::ImVector_float
    FallbackAdvanceX::Cfloat
    FontSize::Cfloat
    IndexLookup::ImVector_ImWchar
    Glyphs::ImVector_ImFontGlyph
    FallbackGlyph::Ptr{ImFontGlyph}
    ContainerAtlas::Ptr{ImFontAtlas}
    ConfigData::Ptr{ImFontConfig}
    ConfigDataCount::Cshort
    FallbackChar::ImWchar
    EllipsisChar::ImWchar
    DirtyLookupTables::Cint
    Scale::Cfloat
    Ascent::Cfloat
    Descent::Cfloat
    MetricsTotalSurface::Cint
    Used4kPagesMap::NTuple{2, ImU8}
end

struct ImDrawListSharedData
    TexUvWhitePixel::ImVec2
    Font::Ptr{ImFont}
    FontSize::Cfloat
    CurveTessellationTol::Cfloat
    CircleSegmentMaxError::Cfloat
    ClipRectFullscreen::ImVec4
    InitialFlags::ImDrawListFlags
    ArcFastVtx::NTuple{48, ImVec2}
    ArcFastRadiusCutoff::Cfloat
    CircleSegmentCounts::NTuple{64, ImU8}
    TexUvLines::Ptr{ImVec4}
end

struct ImVector_ImVec4
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImVec4}
end

struct ImVector_ImTextureID
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImTextureID}
end

struct ImVector_ImVec2
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImVec2}
end

struct ImDrawCmdHeader
    ClipRect::ImVec4
    TextureId::ImTextureID
    VtxOffset::Cuint
end

struct ImDrawChannel
    _CmdBuffer::ImVector_ImDrawCmd
    _IdxBuffer::ImVector_ImDrawIdx
end

struct ImVector_ImDrawChannel
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImDrawChannel}
end

struct ImDrawListSplitter
    _Current::Cint
    _Count::Cint
    _Channels::ImVector_ImDrawChannel
end

struct ImDrawList
    CmdBuffer::ImVector_ImDrawCmd
    IdxBuffer::ImVector_ImDrawIdx
    VtxBuffer::ImVector_ImDrawVert
    Flags::ImDrawListFlags
    _VtxCurrentIdx::Cuint
    _Data::Ptr{ImDrawListSharedData}
    _OwnerName::Cstring
    _VtxWritePtr::Ptr{ImDrawVert}
    _IdxWritePtr::Ptr{ImDrawIdx}
    _ClipRectStack::ImVector_ImVec4
    _TextureIdStack::ImVector_ImTextureID
    _Path::ImVector_ImVec2
    _CmdHeader::ImDrawCmdHeader
    _Splitter::ImDrawListSplitter
    _FringeScale::Cfloat
end

struct ImVector_ImDrawListPtr
    Size::Cint
    Capacity::Cint
    Data::Ptr{Ptr{ImDrawList}}
end

mutable struct ImDrawDataBuilder
    Layers::NTuple{2, ImVector_ImDrawListPtr}
end

struct ImVector_ImU32
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImU32}
end

struct ImBitVector
    Storage::ImVector_ImU32
end

struct ImFontAtlasCustomRect
    Width::Cushort
    Height::Cushort
    X::Cushort
    Y::Cushort
    GlyphID::Cuint
    GlyphAdvanceX::Cfloat
    GlyphOffset::ImVec2
    Font::Ptr{ImFont}
end

struct ImGuiStoragePair
    data::NTuple{16, UInt8}
end

function Base.getproperty(x::Ptr{ImGuiStoragePair}, f::Symbol)
    f === :key && return Ptr{ImGuiID}(x + 0)
    f === :val_i && return Ptr{Cint}(x + 8)
    f === :val_f && return Ptr{Cfloat}(x + 8)
    f === :val_p && return Ptr{Ptr{Cvoid}}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::ImGuiStoragePair, f::Symbol)
    r = Ref{ImGuiStoragePair}(x)
    ptr = Base.unsafe_convert(Ptr{ImGuiStoragePair}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{ImGuiStoragePair}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct ImGuiTextRange
    b::Cstring
    e::Cstring
end

const ImGuiViewportFlags = Cint

mutable struct ImGuiViewport
    Flags::ImGuiViewportFlags
    Pos::ImVec2
    Size::ImVec2
    WorkPos::ImVec2
    WorkSize::ImVec2
end

struct ImVector_ImGuiTextRange
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiTextRange}
end

mutable struct ImGuiTextFilter
    InputBuf::NTuple{256, Cchar}
    Filters::ImVector_ImGuiTextRange
    CountGrep::Cint
end

struct ImVector_char
    Size::Cint
    Capacity::Cint
    Data::Cstring
end

struct ImGuiTextBuffer
    Buf::ImVector_char
end

const ImS16 = Cshort

const ImGuiSortDirection = Cint

struct ImGuiTableColumnSortSpecs
    data::NTuple{12, UInt8}
end

function Base.getproperty(x::Ptr{ImGuiTableColumnSortSpecs}, f::Symbol)
    f === :ColumnUserID && return Ptr{ImGuiID}(x + 0)
    f === :ColumnIndex && return Ptr{ImS16}(x + 4)
    f === :SortOrder && return Ptr{ImS16}(x + 6)
    f === :SortDirection && return Ptr{ImGuiSortDirection}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::ImGuiTableColumnSortSpecs, f::Symbol)
    r = Ref{ImGuiTableColumnSortSpecs}(x)
    ptr = Base.unsafe_convert(Ptr{ImGuiTableColumnSortSpecs}, r)
    fptr = getproperty(ptr, f)
    begin
        if fptr isa Ptr
            return GC.@preserve(r, unsafe_load(fptr))
        else
            (baseptr, offset, width) = fptr
            ty = eltype(baseptr)
            i8 = GC.@preserve(r, unsafe_load(baseptr))
            bitstr = bitstring(i8)
            sig = bitstr[(end - offset) - (width - 1):end - offset]
            zexted = lpad(sig, 8 * sizeof(ty), '0')
            return parse(ty, zexted; base = 2)
        end
    end
end

function Base.setproperty!(x::Ptr{ImGuiTableColumnSortSpecs}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

mutable struct ImGuiTableSortSpecs
    Specs::Ptr{ImGuiTableColumnSortSpecs}
    SpecsCount::Cint
    SpecsDirty::Cint
end

mutable struct ImGuiStyle
    Alpha::Cfloat
    WindowPadding::ImVec2
    WindowRounding::Cfloat
    WindowBorderSize::Cfloat
    WindowMinSize::ImVec2
    WindowTitleAlign::ImVec2
    WindowMenuButtonPosition::ImGuiDir
    ChildRounding::Cfloat
    ChildBorderSize::Cfloat
    PopupRounding::Cfloat
    PopupBorderSize::Cfloat
    FramePadding::ImVec2
    FrameRounding::Cfloat
    FrameBorderSize::Cfloat
    ItemSpacing::ImVec2
    ItemInnerSpacing::ImVec2
    CellPadding::ImVec2
    TouchExtraPadding::ImVec2
    IndentSpacing::Cfloat
    ColumnsMinSpacing::Cfloat
    ScrollbarSize::Cfloat
    ScrollbarRounding::Cfloat
    GrabMinSize::Cfloat
    GrabRounding::Cfloat
    LogSliderDeadzone::Cfloat
    TabRounding::Cfloat
    TabBorderSize::Cfloat
    TabMinWidthForCloseButton::Cfloat
    ColorButtonPosition::ImGuiDir
    ButtonTextAlign::ImVec2
    SelectableTextAlign::ImVec2
    DisplayWindowPadding::ImVec2
    DisplaySafeAreaPadding::ImVec2
    MouseCursorScale::Cfloat
    AntiAliasedLines::Cint
    AntiAliasedLinesUseTex::Cint
    AntiAliasedFill::Cint
    CurveTessellationTol::Cfloat
    CircleTessellationMaxError::Cfloat
    Colors::NTuple{53, ImVec4}
end

struct ImVector_ImGuiStoragePair
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiStoragePair}
end

struct ImGuiStorage
    Data::ImVector_ImGuiStoragePair
end

mutable struct ImGuiSizeCallbackData
    UserData::Ptr{Cvoid}
    Pos::ImVec2
    CurrentSize::ImVec2
    DesiredSize::ImVec2
end

mutable struct ImGuiPayload
    Data::Ptr{Cvoid}
    DataSize::Cint
    SourceId::ImGuiID
    SourceParentId::ImGuiID
    DataFrameCount::Cint
    DataType::NTuple{33, Cchar}
    Preview::Cint
    Delivery::Cint
end

mutable struct ImGuiOnceUponAFrame
    RefFrame::Cint
end

struct ImGuiListClipper
    DisplayStart::Cint
    DisplayEnd::Cint
    ItemsCount::Cint
    StepNo::Cint
    ItemsFrozen::Cint
    ItemsHeight::Cfloat
    StartPosY::Cfloat
end

struct ImGuiInputTextCallbackData
    EventFlag::ImGuiInputTextFlags
    Flags::ImGuiInputTextFlags
    UserData::Ptr{Cvoid}
    EventChar::ImWchar
    EventKey::ImGuiKey
    Buf::Cstring
    BufTextLen::Cint
    BufSize::Cint
    BufDirty::Cint
    CursorPos::Cint
    SelectionStart::Cint
    SelectionEnd::Cint
end

struct ImGuiIO
    ConfigFlags::ImGuiConfigFlags
    BackendFlags::ImGuiBackendFlags
    DisplaySize::ImVec2
    DeltaTime::Cfloat
    IniSavingRate::Cfloat
    IniFilename::Cstring
    LogFilename::Cstring
    MouseDoubleClickTime::Cfloat
    MouseDoubleClickMaxDist::Cfloat
    MouseDragThreshold::Cfloat
    KeyMap::NTuple{22, Cint}
    KeyRepeatDelay::Cfloat
    KeyRepeatRate::Cfloat
    UserData::Ptr{Cvoid}
    Fonts::Ptr{ImFontAtlas}
    FontGlobalScale::Cfloat
    FontAllowUserScaling::Cint
    FontDefault::Ptr{ImFont}
    DisplayFramebufferScale::ImVec2
    MouseDrawCursor::Cint
    ConfigMacOSXBehaviors::Cint
    ConfigInputTextCursorBlink::Cint
    ConfigDragClickToInputText::Cint
    ConfigWindowsResizeFromEdges::Cint
    ConfigWindowsMoveFromTitleBarOnly::Cint
    ConfigMemoryCompactTimer::Cfloat
    BackendPlatformName::Cstring
    BackendRendererName::Cstring
    BackendPlatformUserData::Ptr{Cvoid}
    BackendRendererUserData::Ptr{Cvoid}
    BackendLanguageUserData::Ptr{Cvoid}
    GetClipboardTextFn::Ptr{Cvoid}
    SetClipboardTextFn::Ptr{Cvoid}
    ClipboardUserData::Ptr{Cvoid}
    ImeSetInputScreenPosFn::Ptr{Cvoid}
    ImeWindowHandle::Ptr{Cvoid}
    MousePos::ImVec2
    MouseDown::NTuple{5, Cint}
    MouseWheel::Cfloat
    MouseWheelH::Cfloat
    KeyCtrl::Cint
    KeyShift::Cint
    KeyAlt::Cint
    KeySuper::Cint
    KeysDown::NTuple{512, Cint}
    NavInputs::NTuple{21, Cfloat}
    WantCaptureMouse::Cint
    WantCaptureKeyboard::Cint
    WantTextInput::Cint
    WantSetMousePos::Cint
    WantSaveIniSettings::Cint
    NavActive::Cint
    NavVisible::Cint
    Framerate::Cfloat
    MetricsRenderVertices::Cint
    MetricsRenderIndices::Cint
    MetricsRenderWindows::Cint
    MetricsActiveWindows::Cint
    MetricsActiveAllocations::Cint
    MouseDelta::ImVec2
    KeyMods::ImGuiKeyModFlags
    MousePosPrev::ImVec2
    MouseClickedPos::NTuple{5, ImVec2}
    MouseClickedTime::NTuple{5, Cdouble}
    MouseClicked::NTuple{5, Cint}
    MouseDoubleClicked::NTuple{5, Cint}
    MouseReleased::NTuple{5, Cint}
    MouseDownOwned::NTuple{5, Cint}
    MouseDownWasDoubleClick::NTuple{5, Cint}
    MouseDownDuration::NTuple{5, Cfloat}
    MouseDownDurationPrev::NTuple{5, Cfloat}
    MouseDragMaxDistanceAbs::NTuple{5, ImVec2}
    MouseDragMaxDistanceSqr::NTuple{5, Cfloat}
    KeysDownDuration::NTuple{512, Cfloat}
    KeysDownDurationPrev::NTuple{512, Cfloat}
    NavInputsDownDuration::NTuple{21, Cfloat}
    NavInputsDownDurationPrev::NTuple{21, Cfloat}
    PenPressure::Cfloat
    InputQueueSurrogate::ImWchar16
    InputQueueCharacters::ImVector_ImWchar
end

mutable struct ImGuiContext
    Initialized::Cint
    FontAtlasOwnedByContext::Cint
    IO::ImGuiIO
    Style::ImGuiStyle
    Font::Ptr{ImFont}
    FontSize::Cfloat
    FontBaseSize::Cfloat
    DrawListSharedData::ImDrawListSharedData
    Time::Cdouble
    FrameCount::Cint
    FrameCountEnded::Cint
    FrameCountRendered::Cint
    WithinFrameScope::Cint
    WithinFrameScopeWithImplicitWindow::Cint
    WithinEndChild::Cint
    GcCompactAll::Cint
    TestEngineHookItems::Cint
    TestEngineHookIdInfo::ImGuiID
    TestEngine::Ptr{Cvoid}
    Windows::ImVector_ImGuiWindowPtr
    WindowsFocusOrder::ImVector_ImGuiWindowPtr
    WindowsTempSortBuffer::ImVector_ImGuiWindowPtr
    CurrentWindowStack::ImVector_ImGuiWindowPtr
    WindowsById::ImGuiStorage
    WindowsActiveCount::Cint
    CurrentWindow::Ptr{ImGuiWindow}
    HoveredWindow::Ptr{ImGuiWindow}
    HoveredWindowUnderMovingWindow::Ptr{ImGuiWindow}
    MovingWindow::Ptr{ImGuiWindow}
    WheelingWindow::Ptr{ImGuiWindow}
    WheelingWindowRefMousePos::ImVec2
    WheelingWindowTimer::Cfloat
    HoveredId::ImGuiID
    HoveredIdPreviousFrame::ImGuiID
    HoveredIdAllowOverlap::Cint
    HoveredIdUsingMouseWheel::Cint
    HoveredIdPreviousFrameUsingMouseWheel::Cint
    HoveredIdDisabled::Cint
    HoveredIdTimer::Cfloat
    HoveredIdNotActiveTimer::Cfloat
    ActiveId::ImGuiID
    ActiveIdIsAlive::ImGuiID
    ActiveIdTimer::Cfloat
    ActiveIdIsJustActivated::Cint
    ActiveIdAllowOverlap::Cint
    ActiveIdNoClearOnFocusLoss::Cint
    ActiveIdHasBeenPressedBefore::Cint
    ActiveIdHasBeenEditedBefore::Cint
    ActiveIdHasBeenEditedThisFrame::Cint
    ActiveIdUsingMouseWheel::Cint
    ActiveIdUsingNavDirMask::ImU32
    ActiveIdUsingNavInputMask::ImU32
    ActiveIdUsingKeyInputMask::ImU64
    ActiveIdClickOffset::ImVec2
    ActiveIdWindow::Ptr{ImGuiWindow}
    ActiveIdSource::ImGuiInputSource
    ActiveIdMouseButton::Cint
    ActiveIdPreviousFrame::ImGuiID
    ActiveIdPreviousFrameIsAlive::Cint
    ActiveIdPreviousFrameHasBeenEditedBefore::Cint
    ActiveIdPreviousFrameWindow::Ptr{ImGuiWindow}
    LastActiveId::ImGuiID
    LastActiveIdTimer::Cfloat
    NextWindowData::ImGuiNextWindowData
    NextItemData::ImGuiNextItemData
    ColorStack::ImVector_ImGuiColorMod
    StyleVarStack::ImVector_ImGuiStyleMod
    FontStack::ImVector_ImFontPtr
    FocusScopeStack::ImVector_ImGuiID
    ItemFlagsStack::ImVector_ImGuiItemFlags
    GroupStack::ImVector_ImGuiGroupData
    OpenPopupStack::ImVector_ImGuiPopupData
    BeginPopupStack::ImVector_ImGuiPopupData
    Viewports::ImVector_ImGuiViewportPPtr
    NavWindow::Ptr{ImGuiWindow}
    NavId::ImGuiID
    NavFocusScopeId::ImGuiID
    NavActivateId::ImGuiID
    NavActivateDownId::ImGuiID
    NavActivatePressedId::ImGuiID
    NavInputId::ImGuiID
    NavJustTabbedId::ImGuiID
    NavJustMovedToId::ImGuiID
    NavJustMovedToFocusScopeId::ImGuiID
    NavJustMovedToKeyMods::ImGuiKeyModFlags
    NavNextActivateId::ImGuiID
    NavInputSource::ImGuiInputSource
    NavScoringRect::ImRect
    NavScoringCount::Cint
    NavLayer::ImGuiNavLayer
    NavIdTabCounter::Cint
    NavIdIsAlive::Cint
    NavMousePosDirty::Cint
    NavDisableHighlight::Cint
    NavDisableMouseHover::Cint
    NavAnyRequest::Cint
    NavInitRequest::Cint
    NavInitRequestFromMove::Cint
    NavInitResultId::ImGuiID
    NavInitResultRectRel::ImRect
    NavMoveRequest::Cint
    NavMoveRequestFlags::ImGuiNavMoveFlags
    NavMoveRequestForward::ImGuiNavForward
    NavMoveRequestKeyMods::ImGuiKeyModFlags
    NavMoveDir::ImGuiDir
    NavMoveDirLast::ImGuiDir
    NavMoveClipDir::ImGuiDir
    NavMoveResultLocal::ImGuiNavMoveResult
    NavMoveResultLocalVisibleSet::ImGuiNavMoveResult
    NavMoveResultOther::ImGuiNavMoveResult
    NavWrapRequestWindow::Ptr{ImGuiWindow}
    NavWrapRequestFlags::ImGuiNavMoveFlags
    NavWindowingTarget::Ptr{ImGuiWindow}
    NavWindowingTargetAnim::Ptr{ImGuiWindow}
    NavWindowingListWindow::Ptr{ImGuiWindow}
    NavWindowingTimer::Cfloat
    NavWindowingHighlightAlpha::Cfloat
    NavWindowingToggleLayer::Cint
    TabFocusRequestCurrWindow::Ptr{ImGuiWindow}
    TabFocusRequestNextWindow::Ptr{ImGuiWindow}
    TabFocusRequestCurrCounterRegular::Cint
    TabFocusRequestCurrCounterTabStop::Cint
    TabFocusRequestNextCounterRegular::Cint
    TabFocusRequestNextCounterTabStop::Cint
    TabFocusPressed::Cint
    DimBgRatio::Cfloat
    MouseCursor::ImGuiMouseCursor
    DragDropActive::Cint
    DragDropWithinSource::Cint
    DragDropWithinTarget::Cint
    DragDropSourceFlags::ImGuiDragDropFlags
    DragDropSourceFrameCount::Cint
    DragDropMouseButton::Cint
    DragDropPayload::ImGuiPayload
    DragDropTargetRect::ImRect
    DragDropTargetId::ImGuiID
    DragDropAcceptFlags::ImGuiDragDropFlags
    DragDropAcceptIdCurrRectSurface::Cfloat
    DragDropAcceptIdCurr::ImGuiID
    DragDropAcceptIdPrev::ImGuiID
    DragDropAcceptFrameCount::Cint
    DragDropHoldJustPressedId::ImGuiID
    DragDropPayloadBufHeap::ImVector_unsigned_char
    DragDropPayloadBufLocal::NTuple{16, Cuchar}
    CurrentTable::Ptr{ImGuiTable}
    Tables::ImPool_ImGuiTable
    CurrentTableStack::ImVector_ImGuiPtrOrIndex
    TablesLastTimeActive::ImVector_float
    DrawChannelsTempMergeBuffer::ImVector_ImDrawChannel
    CurrentTabBar::Ptr{ImGuiTabBar}
    TabBars::ImPool_ImGuiTabBar
    CurrentTabBarStack::ImVector_ImGuiPtrOrIndex
    ShrinkWidthBuffer::ImVector_ImGuiShrinkWidthItem
    LastValidMousePos::ImVec2
    InputTextState::ImGuiInputTextState
    InputTextPasswordFont::ImFont
    TempInputId::ImGuiID
    ColorEditOptions::ImGuiColorEditFlags
    ColorEditLastHue::Cfloat
    ColorEditLastSat::Cfloat
    ColorEditLastColor::NTuple{3, Cfloat}
    ColorPickerRef::ImVec4
    SliderCurrentAccum::Cfloat
    SliderCurrentAccumDirty::Cint
    DragCurrentAccumDirty::Cint
    DragCurrentAccum::Cfloat
    DragSpeedDefaultRatio::Cfloat
    ScrollbarClickDeltaToGrabCenter::Cfloat
    TooltipOverrideCount::Cint
    TooltipSlowDelay::Cfloat
    ClipboardHandlerData::ImVector_char
    MenusIdSubmittedThisFrame::ImVector_ImGuiID
    PlatformImePos::ImVec2
    PlatformImeLastPos::ImVec2
    PlatformLocaleDecimalPoint::Cchar
    SettingsLoaded::Cint
    SettingsDirtyTimer::Cfloat
    SettingsIniData::ImGuiTextBuffer
    SettingsHandlers::ImVector_ImGuiSettingsHandler
    SettingsWindows::ImChunkStream_ImGuiWindowSettings
    SettingsTables::ImChunkStream_ImGuiTableSettings
    Hooks::ImVector_ImGuiContextHook
    HookIdNext::ImGuiID
    LogEnabled::Cint
    LogType::ImGuiLogType
    LogFile::ImFileHandle
    LogBuffer::ImGuiTextBuffer
    LogNextPrefix::Cstring
    LogNextSuffix::Cstring
    LogLinePosY::Cfloat
    LogLineFirstItem::Cint
    LogDepthRef::Cint
    LogDepthToExpand::Cint
    LogDepthToExpandDefault::Cint
    DebugItemPickerActive::Cint
    DebugItemPickerBreakId::ImGuiID
    DebugMetricsConfig::ImGuiMetricsConfig
    FramerateSecPerFrame::NTuple{120, Cfloat}
    FramerateSecPerFrameIdx::Cint
    FramerateSecPerFrameAccum::Cfloat
    WantCaptureMouseNextFrame::Cint
    WantCaptureKeyboardNextFrame::Cint
    WantTextInputNextFrame::Cint
    TempBuffer::NTuple{3073, Cchar}
end

mutable struct ImColor
    Value::ImVec4
end

struct ImFontGlyphRangesBuilder
    UsedChars::ImVector_ImU32
end

struct ImFontGlyph
    data::NTuple{40, UInt8}
end

function Base.getproperty(x::Ptr{ImFontGlyph}, f::Symbol)
    f === :Colored && return Ptr{Cuint}(x + 0)
    f === :Visible && return (Ptr{Cuint}(x + 0), 1, 1)
    f === :Codepoint && return (Ptr{Cuint}(x + 0), 2, 30)
    f === :AdvanceX && return Ptr{Cfloat}(x + 4)
    f === :X0 && return Ptr{Cfloat}(x + 8)
    f === :Y0 && return Ptr{Cfloat}(x + 12)
    f === :X1 && return Ptr{Cfloat}(x + 16)
    f === :Y1 && return Ptr{Cfloat}(x + 20)
    f === :U0 && return Ptr{Cfloat}(x + 24)
    f === :V0 && return Ptr{Cfloat}(x + 28)
    f === :U1 && return Ptr{Cfloat}(x + 32)
    f === :V1 && return Ptr{Cfloat}(x + 36)
    return getfield(x, f)
end

function Base.getproperty(x::ImFontGlyph, f::Symbol)
    r = Ref{ImFontGlyph}(x)
    ptr = Base.unsafe_convert(Ptr{ImFontGlyph}, r)
    fptr = getproperty(ptr, f)
    begin
        if fptr isa Ptr
            return GC.@preserve(r, unsafe_load(fptr))
        else
            (baseptr, offset, width) = fptr
            ty = eltype(baseptr)
            i8 = GC.@preserve(r, unsafe_load(baseptr))
            bitstr = bitstring(i8)
            sig = bitstr[(end - offset) - (width - 1):end - offset]
            zexted = lpad(sig, 8 * sizeof(ty), '0')
            return parse(ty, zexted; base = 2)
        end
    end
end

function Base.setproperty!(x::Ptr{ImFontGlyph}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct ImFontConfig
    FontData::Ptr{Cvoid}
    FontDataSize::Cint
    FontDataOwnedByAtlas::Cint
    FontNo::Cint
    SizePixels::Cfloat
    OversampleH::Cint
    OversampleV::Cint
    PixelSnapH::Cint
    GlyphExtraSpacing::ImVec2
    GlyphOffset::ImVec2
    GlyphRanges::Ptr{ImWchar}
    GlyphMinAdvanceX::Cfloat
    GlyphMaxAdvanceX::Cfloat
    MergeMode::Cint
    FontBuilderFlags::Cuint
    RasterizerMultiply::Cfloat
    EllipsisChar::ImWchar
    Name::NTuple{40, Cchar}
    DstFont::Ptr{ImFont}
end

mutable struct ImFontBuilderIO
    bool::Cvoid
end

struct ImFontAtlas
    Flags::ImFontAtlasFlags
    TexID::ImTextureID
    TexDesiredWidth::Cint
    TexGlyphPadding::Cint
    Locked::Cint
    TexPixelsUseColors::Cint
    TexPixelsAlpha8::Ptr{Cuchar}
    TexPixelsRGBA32::Ptr{Cuint}
    TexWidth::Cint
    TexHeight::Cint
    TexUvScale::ImVec2
    TexUvWhitePixel::ImVec2
    Fonts::ImVector_ImFontPtr
    CustomRects::ImVector_ImFontAtlasCustomRect
    ConfigData::ImVector_ImFontConfig
    TexUvLines::NTuple{64, ImVec4}
    FontBuilderIO::Ptr{ImFontBuilderIO}
    FontBuilderFlags::Cuint
    PackIdMouseCursors::Cint
    PackIdLines::Cint
end

mutable struct ImDrawData
    Valid::Cint
    CmdListsCount::Cint
    TotalIdxCount::Cint
    TotalVtxCount::Cint
    CmdLists::Ptr{Ptr{ImDrawList}}
    DisplayPos::ImVec2
    DisplaySize::ImVec2
    FramebufferScale::ImVec2
end

const ImGuiCond = Cint

const ImGuiDataType = Cint

const ImGuiDir = Cint

const ImGuiKey = Cint

const ImGuiNavInput = Cint

const ImGuiMouseButton = Cint

const ImGuiMouseCursor = Cint

const ImGuiTableBgTarget = Cint

const ImDrawFlags = Cint

const ImFontAtlasFlags = Cint

const ImGuiBackendFlags = Cint

const ImGuiButtonFlags = Cint

const ImGuiColorEditFlags = Cint

const ImGuiConfigFlags = Cint

const ImGuiComboFlags = Cint

const ImGuiDragDropFlags = Cint

const ImGuiFocusedFlags = Cint

const ImGuiHoveredFlags = Cint

const ImGuiInputTextFlags = Cint

const ImGuiKeyModFlags = Cint

const ImGuiPopupFlags = Cint

const ImGuiSelectableFlags = Cint

const ImGuiSliderFlags = Cint

const ImGuiTabBarFlags = Cint

const ImGuiTabItemFlags = Cint

const ImGuiTableFlags = Cint

const ImGuiTableColumnFlags = Cint

const ImGuiTableRowFlags = Cint

const ImGuiTreeNodeFlags = Cint

const ImGuiWindowFlags = Cint

# typedef int ( * ImGuiInputTextCallback ) ( ImGuiInputTextCallbackData * data )
const ImGuiInputTextCallback = Ptr{Cvoid}

# typedef void ( * ImGuiSizeCallback ) ( ImGuiSizeCallbackData * data )
const ImGuiSizeCallback = Ptr{Cvoid}

# typedef void * ( * ImGuiMemAllocFunc ) ( size_t sz , void * user_data )
const ImGuiMemAllocFunc = Ptr{Cvoid}

# typedef void ( * ImGuiMemFreeFunc ) ( void * ptr , void * user_data )
const ImGuiMemFreeFunc = Ptr{Cvoid}

const ImWchar32 = Cuint

const ImU16 = Cushort

const ImS32 = Cint

const ImS64 = Cint

const ImU64 = Cint

const ImGuiLayoutType = Cint

const ImGuiItemFlags = Cint

const ImGuiNavHighlightFlags = Cint

const ImGuiNavDirSourceFlags = Cint

const ImGuiNavMoveFlags = Cint

const ImGuiNextItemDataFlags = Cint

const ImGuiNextWindowDataFlags = Cint

const ImGuiSeparatorFlags = Cint

const ImGuiTextFlags = Cint

const ImGuiTooltipFlags = Cint

# typedef void ( * ImGuiErrorLogCallback ) ( void * user_data , const char * fmt , ... )
const ImGuiErrorLogCallback = Ptr{Cvoid}

const ImFileHandle = Ptr{Cint}

const ImPoolIdx = Cint

const ImGuiTableDrawChannelIdx = ImU8

mutable struct ImVector
    Size::Cint
    Capacity::Cint
    Data::Ptr{Cvoid}
end

struct ImVector_ImGuiTableSettings
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiTableSettings}
end

mutable struct ImChunkStream_ImGuiTableSettings
    Buf::ImVector_ImGuiTableSettings
end

struct ImVector_ImGuiWindowSettings
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiWindowSettings}
end

mutable struct ImChunkStream_ImGuiWindowSettings
    Buf::ImVector_ImGuiWindowSettings
end

mutable struct ImSpan_ImGuiTableCellData
    Data::Ptr{ImGuiTableCellData}
    DataEnd::Ptr{ImGuiTableCellData}
end

mutable struct ImSpan_ImGuiTableColumn
    Data::Ptr{ImGuiTableColumn}
    DataEnd::Ptr{ImGuiTableColumn}
end

mutable struct ImSpan_ImGuiTableColumnIdx
    Data::Ptr{ImGuiTableColumnIdx}
    DataEnd::Ptr{ImGuiTableColumnIdx}
end

mutable struct ImVector_ImFontPtr
    Size::Cint
    Capacity::Cint
    Data::Ptr{Ptr{ImFont}}
end

mutable struct ImVector_ImFontAtlasCustomRect
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImFontAtlasCustomRect}
end

mutable struct ImVector_ImFontConfig
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImFontConfig}
end

mutable struct ImVector_ImFontGlyph
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImFontGlyph}
end

mutable struct ImVector_ImGuiColorMod
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiColorMod}
end

mutable struct ImVector_ImGuiContextHook
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiContextHook}
end

mutable struct ImVector_ImGuiGroupData
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiGroupData}
end

mutable struct ImVector_ImGuiID
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiID}
end

mutable struct ImVector_ImGuiItemFlags
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiItemFlags}
end

mutable struct ImVector_ImGuiOldColumnData
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiOldColumnData}
end

mutable struct ImVector_ImGuiOldColumns
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiOldColumns}
end

mutable struct ImVector_ImGuiPopupData
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiPopupData}
end

mutable struct ImVector_ImGuiPtrOrIndex
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiPtrOrIndex}
end

mutable struct ImVector_ImGuiSettingsHandler
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiSettingsHandler}
end

mutable struct ImVector_ImGuiShrinkWidthItem
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiShrinkWidthItem}
end

mutable struct ImVector_ImGuiStyleMod
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiStyleMod}
end

mutable struct ImVector_ImGuiTabItem
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiTabItem}
end

mutable struct ImVector_ImGuiTableColumnSortSpecs
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiTableColumnSortSpecs}
end

mutable struct ImVector_ImGuiViewportPPtr
    Size::Cint
    Capacity::Cint
    Data::Ptr{Ptr{ImGuiViewportP}}
end

mutable struct ImVector_ImGuiWindowPtr
    Size::Cint
    Capacity::Cint
    Data::Ptr{Ptr{ImGuiWindow}}
end

mutable struct ImVector_ImWchar
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImWchar}
end

mutable struct ImVector_float
    Size::Cint
    Capacity::Cint
    Data::Ptr{Cfloat}
end

mutable struct ImVector_unsigned_char
    Size::Cint
    Capacity::Cint
    Data::Ptr{Cuchar}
end

@cenum ImGuiWindowFlags_::UInt32 begin
    ImGuiWindowFlags_None = 0
    ImGuiWindowFlags_NoTitleBar = 1
    ImGuiWindowFlags_NoResize = 2
    ImGuiWindowFlags_NoMove = 4
    ImGuiWindowFlags_NoScrollbar = 8
    ImGuiWindowFlags_NoScrollWithMouse = 16
    ImGuiWindowFlags_NoCollapse = 32
    ImGuiWindowFlags_AlwaysAutoResize = 64
    ImGuiWindowFlags_NoBackground = 128
    ImGuiWindowFlags_NoSavedSettings = 256
    ImGuiWindowFlags_NoMouseInputs = 512
    ImGuiWindowFlags_MenuBar = 1024
    ImGuiWindowFlags_HorizontalScrollbar = 2048
    ImGuiWindowFlags_NoFocusOnAppearing = 4096
    ImGuiWindowFlags_NoBringToFrontOnFocus = 8192
    ImGuiWindowFlags_AlwaysVerticalScrollbar = 16384
    ImGuiWindowFlags_AlwaysHorizontalScrollbar = 32768
    ImGuiWindowFlags_AlwaysUseWindowPadding = 65536
    ImGuiWindowFlags_NoNavInputs = 262144
    ImGuiWindowFlags_NoNavFocus = 524288
    ImGuiWindowFlags_UnsavedDocument = 1048576
    ImGuiWindowFlags_NoNav = 786432
    ImGuiWindowFlags_NoDecoration = 43
    ImGuiWindowFlags_NoInputs = 786944
    ImGuiWindowFlags_NavFlattened = 8388608
    ImGuiWindowFlags_ChildWindow = 16777216
    ImGuiWindowFlags_Tooltip = 33554432
    ImGuiWindowFlags_Popup = 67108864
    ImGuiWindowFlags_Modal = 134217728
    ImGuiWindowFlags_ChildMenu = 268435456
end

@cenum ImGuiInputTextFlags_::UInt32 begin
    ImGuiInputTextFlags_None = 0
    ImGuiInputTextFlags_CharsDecimal = 1
    ImGuiInputTextFlags_CharsHexadecimal = 2
    ImGuiInputTextFlags_CharsUppercase = 4
    ImGuiInputTextFlags_CharsNoBlank = 8
    ImGuiInputTextFlags_AutoSelectAll = 16
    ImGuiInputTextFlags_EnterReturnsTrue = 32
    ImGuiInputTextFlags_CallbackCompletion = 64
    ImGuiInputTextFlags_CallbackHistory = 128
    ImGuiInputTextFlags_CallbackAlways = 256
    ImGuiInputTextFlags_CallbackCharFilter = 512
    ImGuiInputTextFlags_AllowTabInput = 1024
    ImGuiInputTextFlags_CtrlEnterForNewLine = 2048
    ImGuiInputTextFlags_NoHorizontalScroll = 4096
    ImGuiInputTextFlags_AlwaysOverwrite = 8192
    ImGuiInputTextFlags_ReadOnly = 16384
    ImGuiInputTextFlags_Password = 32768
    ImGuiInputTextFlags_NoUndoRedo = 65536
    ImGuiInputTextFlags_CharsScientific = 131072
    ImGuiInputTextFlags_CallbackResize = 262144
    ImGuiInputTextFlags_CallbackEdit = 524288
    ImGuiInputTextFlags_Multiline = 1048576
    ImGuiInputTextFlags_NoMarkEdited = 2097152
end

@cenum ImGuiTreeNodeFlags_::UInt32 begin
    ImGuiTreeNodeFlags_None = 0
    ImGuiTreeNodeFlags_Selected = 1
    ImGuiTreeNodeFlags_Framed = 2
    ImGuiTreeNodeFlags_AllowItemOverlap = 4
    ImGuiTreeNodeFlags_NoTreePushOnOpen = 8
    ImGuiTreeNodeFlags_NoAutoOpenOnLog = 16
    ImGuiTreeNodeFlags_DefaultOpen = 32
    ImGuiTreeNodeFlags_OpenOnDoubleClick = 64
    ImGuiTreeNodeFlags_OpenOnArrow = 128
    ImGuiTreeNodeFlags_Leaf = 256
    ImGuiTreeNodeFlags_Bullet = 512
    ImGuiTreeNodeFlags_FramePadding = 1024
    ImGuiTreeNodeFlags_SpanAvailWidth = 2048
    ImGuiTreeNodeFlags_SpanFullWidth = 4096
    ImGuiTreeNodeFlags_NavLeftJumpsBackHere = 8192
    ImGuiTreeNodeFlags_CollapsingHeader = 26
end

@cenum ImGuiPopupFlags_::UInt32 begin
    ImGuiPopupFlags_None = 0
    ImGuiPopupFlags_MouseButtonLeft = 0
    ImGuiPopupFlags_MouseButtonRight = 1
    ImGuiPopupFlags_MouseButtonMiddle = 2
    ImGuiPopupFlags_MouseButtonMask_ = 31
    ImGuiPopupFlags_MouseButtonDefault_ = 1
    ImGuiPopupFlags_NoOpenOverExistingPopup = 32
    ImGuiPopupFlags_NoOpenOverItems = 64
    ImGuiPopupFlags_AnyPopupId = 128
    ImGuiPopupFlags_AnyPopupLevel = 256
    ImGuiPopupFlags_AnyPopup = 384
end

@cenum ImGuiSelectableFlags_::UInt32 begin
    ImGuiSelectableFlags_None = 0
    ImGuiSelectableFlags_DontClosePopups = 1
    ImGuiSelectableFlags_SpanAllColumns = 2
    ImGuiSelectableFlags_AllowDoubleClick = 4
    ImGuiSelectableFlags_Disabled = 8
    ImGuiSelectableFlags_AllowItemOverlap = 16
end

@cenum ImGuiComboFlags_::UInt32 begin
    ImGuiComboFlags_None = 0
    ImGuiComboFlags_PopupAlignLeft = 1
    ImGuiComboFlags_HeightSmall = 2
    ImGuiComboFlags_HeightRegular = 4
    ImGuiComboFlags_HeightLarge = 8
    ImGuiComboFlags_HeightLargest = 16
    ImGuiComboFlags_NoArrowButton = 32
    ImGuiComboFlags_NoPreview = 64
    ImGuiComboFlags_HeightMask_ = 30
end

@cenum ImGuiTabBarFlags_::UInt32 begin
    ImGuiTabBarFlags_None = 0
    ImGuiTabBarFlags_Reorderable = 1
    ImGuiTabBarFlags_AutoSelectNewTabs = 2
    ImGuiTabBarFlags_TabListPopupButton = 4
    ImGuiTabBarFlags_NoCloseWithMiddleMouseButton = 8
    ImGuiTabBarFlags_NoTabListScrollingButtons = 16
    ImGuiTabBarFlags_NoTooltip = 32
    ImGuiTabBarFlags_FittingPolicyResizeDown = 64
    ImGuiTabBarFlags_FittingPolicyScroll = 128
    ImGuiTabBarFlags_FittingPolicyMask_ = 192
    ImGuiTabBarFlags_FittingPolicyDefault_ = 64
end

@cenum ImGuiTabItemFlags_::UInt32 begin
    ImGuiTabItemFlags_None = 0
    ImGuiTabItemFlags_UnsavedDocument = 1
    ImGuiTabItemFlags_SetSelected = 2
    ImGuiTabItemFlags_NoCloseWithMiddleMouseButton = 4
    ImGuiTabItemFlags_NoPushId = 8
    ImGuiTabItemFlags_NoTooltip = 16
    ImGuiTabItemFlags_NoReorder = 32
    ImGuiTabItemFlags_Leading = 64
    ImGuiTabItemFlags_Trailing = 128
end

@cenum ImGuiTableFlags_::UInt32 begin
    ImGuiTableFlags_None = 0
    ImGuiTableFlags_Resizable = 1
    ImGuiTableFlags_Reorderable = 2
    ImGuiTableFlags_Hideable = 4
    ImGuiTableFlags_Sortable = 8
    ImGuiTableFlags_NoSavedSettings = 16
    ImGuiTableFlags_ContextMenuInBody = 32
    ImGuiTableFlags_RowBg = 64
    ImGuiTableFlags_BordersInnerH = 128
    ImGuiTableFlags_BordersOuterH = 256
    ImGuiTableFlags_BordersInnerV = 512
    ImGuiTableFlags_BordersOuterV = 1024
    ImGuiTableFlags_BordersH = 384
    ImGuiTableFlags_BordersV = 1536
    ImGuiTableFlags_BordersInner = 640
    ImGuiTableFlags_BordersOuter = 1280
    ImGuiTableFlags_Borders = 1920
    ImGuiTableFlags_NoBordersInBody = 2048
    ImGuiTableFlags_NoBordersInBodyUntilResize = 4096
    ImGuiTableFlags_SizingFixedFit = 8192
    ImGuiTableFlags_SizingFixedSame = 16384
    ImGuiTableFlags_SizingStretchProp = 24576
    ImGuiTableFlags_SizingStretchSame = 32768
    ImGuiTableFlags_NoHostExtendX = 65536
    ImGuiTableFlags_NoHostExtendY = 131072
    ImGuiTableFlags_NoKeepColumnsVisible = 262144
    ImGuiTableFlags_PreciseWidths = 524288
    ImGuiTableFlags_NoClip = 1048576
    ImGuiTableFlags_PadOuterX = 2097152
    ImGuiTableFlags_NoPadOuterX = 4194304
    ImGuiTableFlags_NoPadInnerX = 8388608
    ImGuiTableFlags_ScrollX = 16777216
    ImGuiTableFlags_ScrollY = 33554432
    ImGuiTableFlags_SortMulti = 67108864
    ImGuiTableFlags_SortTristate = 134217728
    ImGuiTableFlags_SizingMask_ = 57344
end

@cenum ImGuiTableColumnFlags_::UInt32 begin
    ImGuiTableColumnFlags_None = 0
    ImGuiTableColumnFlags_DefaultHide = 1
    ImGuiTableColumnFlags_DefaultSort = 2
    ImGuiTableColumnFlags_WidthStretch = 4
    ImGuiTableColumnFlags_WidthFixed = 8
    ImGuiTableColumnFlags_NoResize = 16
    ImGuiTableColumnFlags_NoReorder = 32
    ImGuiTableColumnFlags_NoHide = 64
    ImGuiTableColumnFlags_NoClip = 128
    ImGuiTableColumnFlags_NoSort = 256
    ImGuiTableColumnFlags_NoSortAscending = 512
    ImGuiTableColumnFlags_NoSortDescending = 1024
    ImGuiTableColumnFlags_NoHeaderWidth = 2048
    ImGuiTableColumnFlags_PreferSortAscending = 4096
    ImGuiTableColumnFlags_PreferSortDescending = 8192
    ImGuiTableColumnFlags_IndentEnable = 16384
    ImGuiTableColumnFlags_IndentDisable = 32768
    ImGuiTableColumnFlags_IsEnabled = 1048576
    ImGuiTableColumnFlags_IsVisible = 2097152
    ImGuiTableColumnFlags_IsSorted = 4194304
    ImGuiTableColumnFlags_IsHovered = 8388608
    ImGuiTableColumnFlags_WidthMask_ = 12
    ImGuiTableColumnFlags_IndentMask_ = 49152
    ImGuiTableColumnFlags_StatusMask_ = 15728640
    ImGuiTableColumnFlags_NoDirectResize_ = 1073741824
end

@cenum ImGuiTableRowFlags_::UInt32 begin
    ImGuiTableRowFlags_None = 0
    ImGuiTableRowFlags_Headers = 1
end

@cenum ImGuiTableBgTarget_::UInt32 begin
    ImGuiTableBgTarget_None = 0
    ImGuiTableBgTarget_RowBg0 = 1
    ImGuiTableBgTarget_RowBg1 = 2
    ImGuiTableBgTarget_CellBg = 3
end

@cenum ImGuiFocusedFlags_::UInt32 begin
    ImGuiFocusedFlags_None = 0
    ImGuiFocusedFlags_ChildWindows = 1
    ImGuiFocusedFlags_RootWindow = 2
    ImGuiFocusedFlags_AnyWindow = 4
    ImGuiFocusedFlags_RootAndChildWindows = 3
end

@cenum ImGuiHoveredFlags_::UInt32 begin
    ImGuiHoveredFlags_None = 0
    ImGuiHoveredFlags_ChildWindows = 1
    ImGuiHoveredFlags_RootWindow = 2
    ImGuiHoveredFlags_AnyWindow = 4
    ImGuiHoveredFlags_AllowWhenBlockedByPopup = 8
    ImGuiHoveredFlags_AllowWhenBlockedByActiveItem = 32
    ImGuiHoveredFlags_AllowWhenOverlapped = 64
    ImGuiHoveredFlags_AllowWhenDisabled = 128
    ImGuiHoveredFlags_RectOnly = 104
    ImGuiHoveredFlags_RootAndChildWindows = 3
end

@cenum ImGuiDragDropFlags_::UInt32 begin
    ImGuiDragDropFlags_None = 0
    ImGuiDragDropFlags_SourceNoPreviewTooltip = 1
    ImGuiDragDropFlags_SourceNoDisableHover = 2
    ImGuiDragDropFlags_SourceNoHoldToOpenOthers = 4
    ImGuiDragDropFlags_SourceAllowNullID = 8
    ImGuiDragDropFlags_SourceExtern = 16
    ImGuiDragDropFlags_SourceAutoExpirePayload = 32
    ImGuiDragDropFlags_AcceptBeforeDelivery = 1024
    ImGuiDragDropFlags_AcceptNoDrawDefaultRect = 2048
    ImGuiDragDropFlags_AcceptNoPreviewTooltip = 4096
    ImGuiDragDropFlags_AcceptPeekOnly = 3072
end

@cenum ImGuiDataType_::UInt32 begin
    ImGuiDataType_S8 = 0
    ImGuiDataType_U8 = 1
    ImGuiDataType_S16 = 2
    ImGuiDataType_U16 = 3
    ImGuiDataType_S32 = 4
    ImGuiDataType_U32 = 5
    ImGuiDataType_S64 = 6
    ImGuiDataType_U64 = 7
    ImGuiDataType_Float = 8
    ImGuiDataType_Double = 9
    ImGuiDataType_COUNT = 10
end

@cenum ImGuiDir_::Int32 begin
    ImGuiDir_None = -1
    ImGuiDir_Left = 0
    ImGuiDir_Right = 1
    ImGuiDir_Up = 2
    ImGuiDir_Down = 3
    ImGuiDir_COUNT = 4
end

@cenum ImGuiSortDirection_::UInt32 begin
    ImGuiSortDirection_None = 0
    ImGuiSortDirection_Ascending = 1
    ImGuiSortDirection_Descending = 2
end

@cenum ImGuiKey_::UInt32 begin
    ImGuiKey_Tab = 0
    ImGuiKey_LeftArrow = 1
    ImGuiKey_RightArrow = 2
    ImGuiKey_UpArrow = 3
    ImGuiKey_DownArrow = 4
    ImGuiKey_PageUp = 5
    ImGuiKey_PageDown = 6
    ImGuiKey_Home = 7
    ImGuiKey_End = 8
    ImGuiKey_Insert = 9
    ImGuiKey_Delete = 10
    ImGuiKey_Backspace = 11
    ImGuiKey_Space = 12
    ImGuiKey_Enter = 13
    ImGuiKey_Escape = 14
    ImGuiKey_KeyPadEnter = 15
    ImGuiKey_A = 16
    ImGuiKey_C = 17
    ImGuiKey_V = 18
    ImGuiKey_X = 19
    ImGuiKey_Y = 20
    ImGuiKey_Z = 21
    ImGuiKey_COUNT = 22
end

@cenum ImGuiKeyModFlags_::UInt32 begin
    ImGuiKeyModFlags_None = 0
    ImGuiKeyModFlags_Ctrl = 1
    ImGuiKeyModFlags_Shift = 2
    ImGuiKeyModFlags_Alt = 4
    ImGuiKeyModFlags_Super = 8
end

@cenum ImGuiNavInput_::UInt32 begin
    ImGuiNavInput_Activate = 0
    ImGuiNavInput_Cancel = 1
    ImGuiNavInput_Input = 2
    ImGuiNavInput_Menu = 3
    ImGuiNavInput_DpadLeft = 4
    ImGuiNavInput_DpadRight = 5
    ImGuiNavInput_DpadUp = 6
    ImGuiNavInput_DpadDown = 7
    ImGuiNavInput_LStickLeft = 8
    ImGuiNavInput_LStickRight = 9
    ImGuiNavInput_LStickUp = 10
    ImGuiNavInput_LStickDown = 11
    ImGuiNavInput_FocusPrev = 12
    ImGuiNavInput_FocusNext = 13
    ImGuiNavInput_TweakSlow = 14
    ImGuiNavInput_TweakFast = 15
    ImGuiNavInput_KeyMenu_ = 16
    ImGuiNavInput_KeyLeft_ = 17
    ImGuiNavInput_KeyRight_ = 18
    ImGuiNavInput_KeyUp_ = 19
    ImGuiNavInput_KeyDown_ = 20
    ImGuiNavInput_COUNT = 21
    ImGuiNavInput_InternalStart_ = 16
end

@cenum ImGuiConfigFlags_::UInt32 begin
    ImGuiConfigFlags_None = 0
    ImGuiConfigFlags_NavEnableKeyboard = 1
    ImGuiConfigFlags_NavEnableGamepad = 2
    ImGuiConfigFlags_NavEnableSetMousePos = 4
    ImGuiConfigFlags_NavNoCaptureKeyboard = 8
    ImGuiConfigFlags_NoMouse = 16
    ImGuiConfigFlags_NoMouseCursorChange = 32
    ImGuiConfigFlags_IsSRGB = 1048576
    ImGuiConfigFlags_IsTouchScreen = 2097152
end

@cenum ImGuiBackendFlags_::UInt32 begin
    ImGuiBackendFlags_None = 0
    ImGuiBackendFlags_HasGamepad = 1
    ImGuiBackendFlags_HasMouseCursors = 2
    ImGuiBackendFlags_HasSetMousePos = 4
    ImGuiBackendFlags_RendererHasVtxOffset = 8
end

@cenum ImGuiCol_::UInt32 begin
    ImGuiCol_Text = 0
    ImGuiCol_TextDisabled = 1
    ImGuiCol_WindowBg = 2
    ImGuiCol_ChildBg = 3
    ImGuiCol_PopupBg = 4
    ImGuiCol_Border = 5
    ImGuiCol_BorderShadow = 6
    ImGuiCol_FrameBg = 7
    ImGuiCol_FrameBgHovered = 8
    ImGuiCol_FrameBgActive = 9
    ImGuiCol_TitleBg = 10
    ImGuiCol_TitleBgActive = 11
    ImGuiCol_TitleBgCollapsed = 12
    ImGuiCol_MenuBarBg = 13
    ImGuiCol_ScrollbarBg = 14
    ImGuiCol_ScrollbarGrab = 15
    ImGuiCol_ScrollbarGrabHovered = 16
    ImGuiCol_ScrollbarGrabActive = 17
    ImGuiCol_CheckMark = 18
    ImGuiCol_SliderGrab = 19
    ImGuiCol_SliderGrabActive = 20
    ImGuiCol_Button = 21
    ImGuiCol_ButtonHovered = 22
    ImGuiCol_ButtonActive = 23
    ImGuiCol_Header = 24
    ImGuiCol_HeaderHovered = 25
    ImGuiCol_HeaderActive = 26
    ImGuiCol_Separator = 27
    ImGuiCol_SeparatorHovered = 28
    ImGuiCol_SeparatorActive = 29
    ImGuiCol_ResizeGrip = 30
    ImGuiCol_ResizeGripHovered = 31
    ImGuiCol_ResizeGripActive = 32
    ImGuiCol_Tab = 33
    ImGuiCol_TabHovered = 34
    ImGuiCol_TabActive = 35
    ImGuiCol_TabUnfocused = 36
    ImGuiCol_TabUnfocusedActive = 37
    ImGuiCol_PlotLines = 38
    ImGuiCol_PlotLinesHovered = 39
    ImGuiCol_PlotHistogram = 40
    ImGuiCol_PlotHistogramHovered = 41
    ImGuiCol_TableHeaderBg = 42
    ImGuiCol_TableBorderStrong = 43
    ImGuiCol_TableBorderLight = 44
    ImGuiCol_TableRowBg = 45
    ImGuiCol_TableRowBgAlt = 46
    ImGuiCol_TextSelectedBg = 47
    ImGuiCol_DragDropTarget = 48
    ImGuiCol_NavHighlight = 49
    ImGuiCol_NavWindowingHighlight = 50
    ImGuiCol_NavWindowingDimBg = 51
    ImGuiCol_ModalWindowDimBg = 52
    ImGuiCol_COUNT = 53
end

@cenum ImGuiStyleVar_::UInt32 begin
    ImGuiStyleVar_Alpha = 0
    ImGuiStyleVar_WindowPadding = 1
    ImGuiStyleVar_WindowRounding = 2
    ImGuiStyleVar_WindowBorderSize = 3
    ImGuiStyleVar_WindowMinSize = 4
    ImGuiStyleVar_WindowTitleAlign = 5
    ImGuiStyleVar_ChildRounding = 6
    ImGuiStyleVar_ChildBorderSize = 7
    ImGuiStyleVar_PopupRounding = 8
    ImGuiStyleVar_PopupBorderSize = 9
    ImGuiStyleVar_FramePadding = 10
    ImGuiStyleVar_FrameRounding = 11
    ImGuiStyleVar_FrameBorderSize = 12
    ImGuiStyleVar_ItemSpacing = 13
    ImGuiStyleVar_ItemInnerSpacing = 14
    ImGuiStyleVar_IndentSpacing = 15
    ImGuiStyleVar_CellPadding = 16
    ImGuiStyleVar_ScrollbarSize = 17
    ImGuiStyleVar_ScrollbarRounding = 18
    ImGuiStyleVar_GrabMinSize = 19
    ImGuiStyleVar_GrabRounding = 20
    ImGuiStyleVar_TabRounding = 21
    ImGuiStyleVar_ButtonTextAlign = 22
    ImGuiStyleVar_SelectableTextAlign = 23
    ImGuiStyleVar_COUNT = 24
end

@cenum ImGuiButtonFlags_::UInt32 begin
    ImGuiButtonFlags_None = 0
    ImGuiButtonFlags_MouseButtonLeft = 1
    ImGuiButtonFlags_MouseButtonRight = 2
    ImGuiButtonFlags_MouseButtonMiddle = 4
    ImGuiButtonFlags_MouseButtonMask_ = 7
    ImGuiButtonFlags_MouseButtonDefault_ = 1
end

@cenum ImGuiColorEditFlags_::UInt32 begin
    ImGuiColorEditFlags_None = 0
    ImGuiColorEditFlags_NoAlpha = 2
    ImGuiColorEditFlags_NoPicker = 4
    ImGuiColorEditFlags_NoOptions = 8
    ImGuiColorEditFlags_NoSmallPreview = 16
    ImGuiColorEditFlags_NoInputs = 32
    ImGuiColorEditFlags_NoTooltip = 64
    ImGuiColorEditFlags_NoLabel = 128
    ImGuiColorEditFlags_NoSidePreview = 256
    ImGuiColorEditFlags_NoDragDrop = 512
    ImGuiColorEditFlags_NoBorder = 1024
    ImGuiColorEditFlags_AlphaBar = 65536
    ImGuiColorEditFlags_AlphaPreview = 131072
    ImGuiColorEditFlags_AlphaPreviewHalf = 262144
    ImGuiColorEditFlags_HDR = 524288
    ImGuiColorEditFlags_DisplayRGB = 1048576
    ImGuiColorEditFlags_DisplayHSV = 2097152
    ImGuiColorEditFlags_DisplayHex = 4194304
    ImGuiColorEditFlags_Uint8 = 8388608
    ImGuiColorEditFlags_Float = 16777216
    ImGuiColorEditFlags_PickerHueBar = 33554432
    ImGuiColorEditFlags_PickerHueWheel = 67108864
    ImGuiColorEditFlags_InputRGB = 134217728
    ImGuiColorEditFlags_InputHSV = 268435456
    ImGuiColorEditFlags__OptionsDefault = 177209344
    ImGuiColorEditFlags__DisplayMask = 7340032
    ImGuiColorEditFlags__DataTypeMask = 25165824
    ImGuiColorEditFlags__PickerMask = 100663296
    ImGuiColorEditFlags__InputMask = 402653184
end

@cenum ImGuiSliderFlags_::UInt32 begin
    ImGuiSliderFlags_None = 0
    ImGuiSliderFlags_AlwaysClamp = 16
    ImGuiSliderFlags_Logarithmic = 32
    ImGuiSliderFlags_NoRoundToFormat = 64
    ImGuiSliderFlags_NoInput = 128
    ImGuiSliderFlags_InvalidMask_ = 1879048207
end

@cenum ImGuiMouseButton_::UInt32 begin
    ImGuiMouseButton_Left = 0
    ImGuiMouseButton_Right = 1
    ImGuiMouseButton_Middle = 2
    ImGuiMouseButton_COUNT = 5
end

@cenum ImGuiMouseCursor_::Int32 begin
    ImGuiMouseCursor_None = -1
    ImGuiMouseCursor_Arrow = 0
    ImGuiMouseCursor_TextInput = 1
    ImGuiMouseCursor_ResizeAll = 2
    ImGuiMouseCursor_ResizeNS = 3
    ImGuiMouseCursor_ResizeEW = 4
    ImGuiMouseCursor_ResizeNESW = 5
    ImGuiMouseCursor_ResizeNWSE = 6
    ImGuiMouseCursor_Hand = 7
    ImGuiMouseCursor_NotAllowed = 8
    ImGuiMouseCursor_COUNT = 9
end

@cenum ImGuiCond_::UInt32 begin
    ImGuiCond_None = 0
    ImGuiCond_Always = 1
    ImGuiCond_Once = 2
    ImGuiCond_FirstUseEver = 4
    ImGuiCond_Appearing = 8
end

struct ImVector_ImGuiTabBar
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiTabBar}
end

mutable struct ImPool_ImGuiTabBar
    Buf::ImVector_ImGuiTabBar
    Map::ImGuiStorage
    FreeIdx::ImPoolIdx
end

struct ImVector_ImGuiTable
    Size::Cint
    Capacity::Cint
    Data::Ptr{ImGuiTable}
end

mutable struct ImPool_ImGuiTable
    Buf::ImVector_ImGuiTable
    Map::ImGuiStorage
    FreeIdx::ImPoolIdx
end

@cenum ImDrawFlags_::UInt32 begin
    ImDrawFlags_None = 0
    ImDrawFlags_Closed = 1
    ImDrawFlags_RoundCornersTopLeft = 16
    ImDrawFlags_RoundCornersTopRight = 32
    ImDrawFlags_RoundCornersBottomLeft = 64
    ImDrawFlags_RoundCornersBottomRight = 128
    ImDrawFlags_RoundCornersNone = 256
    ImDrawFlags_RoundCornersTop = 48
    ImDrawFlags_RoundCornersBottom = 192
    ImDrawFlags_RoundCornersLeft = 80
    ImDrawFlags_RoundCornersRight = 160
    ImDrawFlags_RoundCornersAll = 240
    ImDrawFlags_RoundCornersDefault_ = 240
    ImDrawFlags_RoundCornersMask_ = 496
end

@cenum ImDrawListFlags_::UInt32 begin
    ImDrawListFlags_None = 0
    ImDrawListFlags_AntiAliasedLines = 1
    ImDrawListFlags_AntiAliasedLinesUseTex = 2
    ImDrawListFlags_AntiAliasedFill = 4
    ImDrawListFlags_AllowVtxOffset = 8
end

@cenum ImFontAtlasFlags_::UInt32 begin
    ImFontAtlasFlags_None = 0
    ImFontAtlasFlags_NoPowerOfTwoHeight = 1
    ImFontAtlasFlags_NoMouseCursors = 2
    ImFontAtlasFlags_NoBakedLines = 4
end

@cenum ImGuiViewportFlags_::UInt32 begin
    ImGuiViewportFlags_None = 0
    ImGuiViewportFlags_IsPlatformWindow = 1
    ImGuiViewportFlags_IsPlatformMonitor = 2
    ImGuiViewportFlags_OwnedByApp = 4
end

@cenum ImGuiItemFlags_::UInt32 begin
    ImGuiItemFlags_None = 0
    ImGuiItemFlags_NoTabStop = 1
    ImGuiItemFlags_ButtonRepeat = 2
    ImGuiItemFlags_Disabled = 4
    ImGuiItemFlags_NoNav = 8
    ImGuiItemFlags_NoNavDefaultFocus = 16
    ImGuiItemFlags_SelectableDontClosePopup = 32
    ImGuiItemFlags_MixedValue = 64
    ImGuiItemFlags_ReadOnly = 128
    ImGuiItemFlags_Default_ = 0
end

@cenum ImGuiItemStatusFlags_::UInt32 begin
    ImGuiItemStatusFlags_None = 0
    ImGuiItemStatusFlags_HoveredRect = 1
    ImGuiItemStatusFlags_HasDisplayRect = 2
    ImGuiItemStatusFlags_Edited = 4
    ImGuiItemStatusFlags_ToggledSelection = 8
    ImGuiItemStatusFlags_ToggledOpen = 16
    ImGuiItemStatusFlags_HasDeactivated = 32
    ImGuiItemStatusFlags_Deactivated = 64
    ImGuiItemStatusFlags_HoveredWindow = 128
end

@cenum ImGuiButtonFlagsPrivate_::UInt32 begin
    ImGuiButtonFlags_PressedOnClick = 16
    ImGuiButtonFlags_PressedOnClickRelease = 32
    ImGuiButtonFlags_PressedOnClickReleaseAnywhere = 64
    ImGuiButtonFlags_PressedOnRelease = 128
    ImGuiButtonFlags_PressedOnDoubleClick = 256
    ImGuiButtonFlags_PressedOnDragDropHold = 512
    ImGuiButtonFlags_Repeat = 1024
    ImGuiButtonFlags_FlattenChildren = 2048
    ImGuiButtonFlags_AllowItemOverlap = 4096
    ImGuiButtonFlags_DontClosePopups = 8192
    ImGuiButtonFlags_Disabled = 16384
    ImGuiButtonFlags_AlignTextBaseLine = 32768
    ImGuiButtonFlags_NoKeyModifiers = 65536
    ImGuiButtonFlags_NoHoldingActiveId = 131072
    ImGuiButtonFlags_NoNavFocus = 262144
    ImGuiButtonFlags_NoHoveredOnFocus = 524288
    ImGuiButtonFlags_PressedOnMask_ = 1008
    ImGuiButtonFlags_PressedOnDefault_ = 32
end

@cenum ImGuiSliderFlagsPrivate_::UInt32 begin
    ImGuiSliderFlags_Vertical = 1048576
    ImGuiSliderFlags_ReadOnly = 2097152
end

@cenum ImGuiSelectableFlagsPrivate_::UInt32 begin
    ImGuiSelectableFlags_NoHoldingActiveID = 1048576
    ImGuiSelectableFlags_SelectOnClick = 2097152
    ImGuiSelectableFlags_SelectOnRelease = 4194304
    ImGuiSelectableFlags_SpanAvailWidth = 8388608
    ImGuiSelectableFlags_DrawHoveredWhenHeld = 16777216
    ImGuiSelectableFlags_SetNavIdOnHover = 33554432
    ImGuiSelectableFlags_NoPadWithHalfSpacing = 67108864
end

@cenum ImGuiTreeNodeFlagsPrivate_::UInt32 begin
    ImGuiTreeNodeFlags_ClipLabelForTrailingButton = 1048576
end

@cenum ImGuiSeparatorFlags_::UInt32 begin
    ImGuiSeparatorFlags_None = 0
    ImGuiSeparatorFlags_Horizontal = 1
    ImGuiSeparatorFlags_Vertical = 2
    ImGuiSeparatorFlags_SpanAllColumns = 4
end

@cenum ImGuiTextFlags_::UInt32 begin
    ImGuiTextFlags_None = 0
    ImGuiTextFlags_NoWidthForLargeClippedText = 1
end

@cenum ImGuiTooltipFlags_::UInt32 begin
    ImGuiTooltipFlags_None = 0
    ImGuiTooltipFlags_OverridePreviousTooltip = 1
end

@cenum ImGuiLayoutType_::UInt32 begin
    ImGuiLayoutType_Horizontal = 0
    ImGuiLayoutType_Vertical = 1
end

@cenum ImGuiLogType::UInt32 begin
    ImGuiLogType_None = 0
    ImGuiLogType_TTY = 1
    ImGuiLogType_File = 2
    ImGuiLogType_Buffer = 3
    ImGuiLogType_Clipboard = 4
end

@cenum ImGuiAxis::Int32 begin
    ImGuiAxis_None = -1
    ImGuiAxis_X = 0
    ImGuiAxis_Y = 1
end

@cenum ImGuiPlotType::UInt32 begin
    ImGuiPlotType_Lines = 0
    ImGuiPlotType_Histogram = 1
end

@cenum ImGuiInputSource::UInt32 begin
    ImGuiInputSource_None = 0
    ImGuiInputSource_Mouse = 1
    ImGuiInputSource_Keyboard = 2
    ImGuiInputSource_Gamepad = 3
    ImGuiInputSource_Nav = 4
    ImGuiInputSource_COUNT = 5
end

@cenum ImGuiInputReadMode::UInt32 begin
    ImGuiInputReadMode_Down = 0
    ImGuiInputReadMode_Pressed = 1
    ImGuiInputReadMode_Released = 2
    ImGuiInputReadMode_Repeat = 3
    ImGuiInputReadMode_RepeatSlow = 4
    ImGuiInputReadMode_RepeatFast = 5
end

@cenum ImGuiNavHighlightFlags_::UInt32 begin
    ImGuiNavHighlightFlags_None = 0
    ImGuiNavHighlightFlags_TypeDefault = 1
    ImGuiNavHighlightFlags_TypeThin = 2
    ImGuiNavHighlightFlags_AlwaysDraw = 4
    ImGuiNavHighlightFlags_NoRounding = 8
end

@cenum ImGuiNavDirSourceFlags_::UInt32 begin
    ImGuiNavDirSourceFlags_None = 0
    ImGuiNavDirSourceFlags_Keyboard = 1
    ImGuiNavDirSourceFlags_PadDPad = 2
    ImGuiNavDirSourceFlags_PadLStick = 4
end

@cenum ImGuiNavMoveFlags_::UInt32 begin
    ImGuiNavMoveFlags_None = 0
    ImGuiNavMoveFlags_LoopX = 1
    ImGuiNavMoveFlags_LoopY = 2
    ImGuiNavMoveFlags_WrapX = 4
    ImGuiNavMoveFlags_WrapY = 8
    ImGuiNavMoveFlags_AllowCurrentNavId = 16
    ImGuiNavMoveFlags_AlsoScoreVisibleSet = 32
    ImGuiNavMoveFlags_ScrollToEdge = 64
end

@cenum ImGuiNavForward::UInt32 begin
    ImGuiNavForward_None = 0
    ImGuiNavForward_ForwardQueued = 1
    ImGuiNavForward_ForwardActive = 2
end

@cenum ImGuiNavLayer::UInt32 begin
    ImGuiNavLayer_Main = 0
    ImGuiNavLayer_Menu = 1
    ImGuiNavLayer_COUNT = 2
end

@cenum ImGuiPopupPositionPolicy::UInt32 begin
    ImGuiPopupPositionPolicy_Default = 0
    ImGuiPopupPositionPolicy_ComboBox = 1
    ImGuiPopupPositionPolicy_Tooltip = 2
end

@cenum ImGuiDataTypePrivate_::UInt32 begin
    ImGuiDataType_String = 11
    ImGuiDataType_Pointer = 12
    ImGuiDataType_ID = 13
end

@cenum ImGuiNextWindowDataFlags_::UInt32 begin
    ImGuiNextWindowDataFlags_None = 0
    ImGuiNextWindowDataFlags_HasPos = 1
    ImGuiNextWindowDataFlags_HasSize = 2
    ImGuiNextWindowDataFlags_HasContentSize = 4
    ImGuiNextWindowDataFlags_HasCollapsed = 8
    ImGuiNextWindowDataFlags_HasSizeConstraint = 16
    ImGuiNextWindowDataFlags_HasFocus = 32
    ImGuiNextWindowDataFlags_HasBgAlpha = 64
    ImGuiNextWindowDataFlags_HasScroll = 128
end

@cenum ImGuiNextItemDataFlags_::UInt32 begin
    ImGuiNextItemDataFlags_None = 0
    ImGuiNextItemDataFlags_HasWidth = 1
    ImGuiNextItemDataFlags_HasOpen = 2
end

@cenum ImGuiOldColumnFlags_::UInt32 begin
    ImGuiOldColumnFlags_None = 0
    ImGuiOldColumnFlags_NoBorder = 1
    ImGuiOldColumnFlags_NoResize = 2
    ImGuiOldColumnFlags_NoPreserveWidths = 4
    ImGuiOldColumnFlags_NoForceWithinWindow = 8
    ImGuiOldColumnFlags_GrowParentContentsSize = 16
end

@cenum ImGuiTabBarFlagsPrivate_::UInt32 begin
    ImGuiTabBarFlags_DockNode = 1048576
    ImGuiTabBarFlags_IsFocused = 2097152
    ImGuiTabBarFlags_SaveSettings = 4194304
end

@cenum ImGuiTabItemFlagsPrivate_::UInt32 begin
    ImGuiTabItemFlags_NoCloseButton = 1048576
    ImGuiTabItemFlags_Button = 2097152
end

function ImVec2_ImVec2Nil()
    ccall((:ImVec2_ImVec2Nil, libcimplot), Ptr{ImVec2}, ())
end

function ImVec2_destroy(self)
    ccall((:ImVec2_destroy, libcimplot), Cvoid, (Ptr{ImVec2},), self)
end

function ImVec2_ImVec2Float(_x, _y)
    ccall((:ImVec2_ImVec2Float, libcimplot), Ptr{ImVec2}, (Cfloat, Cfloat), _x, _y)
end

function ImVec4_ImVec4Nil()
    ccall((:ImVec4_ImVec4Nil, libcimplot), Ptr{ImVec4}, ())
end

function ImVec4_destroy(self)
    ccall((:ImVec4_destroy, libcimplot), Cvoid, (Ptr{ImVec4},), self)
end

function ImVec4_ImVec4Float(_x, _y, _z, _w)
    ccall((:ImVec4_ImVec4Float, libcimplot), Ptr{ImVec4}, (Cfloat, Cfloat, Cfloat, Cfloat), _x, _y, _z, _w)
end

function igCreateContext(shared_font_atlas)
    ccall((:igCreateContext, libcimplot), Ptr{ImGuiContext}, (Ptr{ImFontAtlas},), shared_font_atlas)
end

function igDestroyContext(ctx)
    ccall((:igDestroyContext, libcimplot), Cvoid, (Ptr{ImGuiContext},), ctx)
end

function igGetCurrentContext()
    ccall((:igGetCurrentContext, libcimplot), Ptr{ImGuiContext}, ())
end

function igSetCurrentContext(ctx)
    ccall((:igSetCurrentContext, libcimplot), Cvoid, (Ptr{ImGuiContext},), ctx)
end

function igGetIO()
    ccall((:igGetIO, libcimplot), Ptr{ImGuiIO}, ())
end

function igGetStyle()
    ccall((:igGetStyle, libcimplot), Ptr{ImGuiStyle}, ())
end

function igNewFrame()
    ccall((:igNewFrame, libcimplot), Cvoid, ())
end

function igEndFrame()
    ccall((:igEndFrame, libcimplot), Cvoid, ())
end

function igRender()
    ccall((:igRender, libcimplot), Cvoid, ())
end

function igGetDrawData()
    ccall((:igGetDrawData, libcimplot), Ptr{ImDrawData}, ())
end

function igShowDemoWindow(p_open)
    ccall((:igShowDemoWindow, libcimplot), Cvoid, (Ptr{Cint},), p_open)
end

function igShowMetricsWindow(p_open)
    ccall((:igShowMetricsWindow, libcimplot), Cvoid, (Ptr{Cint},), p_open)
end

function igShowAboutWindow(p_open)
    ccall((:igShowAboutWindow, libcimplot), Cvoid, (Ptr{Cint},), p_open)
end

function igShowStyleEditor(ref)
    ccall((:igShowStyleEditor, libcimplot), Cvoid, (Ptr{ImGuiStyle},), ref)
end

function igShowStyleSelector()
    ccall((:igShowStyleSelector, libcimplot), Cint, ())
end

function igShowFontSelector(label)
    ccall((:igShowFontSelector, libcimplot), Cvoid, (Cstring,), label)
end

function igShowUserGuide()
    ccall((:igShowUserGuide, libcimplot), Cvoid, ())
end

function igGetVersion()
    ccall((:igGetVersion, libcimplot), Cstring, ())
end

function igStyleColorsDark(dst)
    ccall((:igStyleColorsDark, libcimplot), Cvoid, (Ptr{ImGuiStyle},), dst)
end

function igStyleColorsLight(dst)
    ccall((:igStyleColorsLight, libcimplot), Cvoid, (Ptr{ImGuiStyle},), dst)
end

function igStyleColorsClassic(dst)
    ccall((:igStyleColorsClassic, libcimplot), Cvoid, (Ptr{ImGuiStyle},), dst)
end

function igBegin()
    ccall((:igBegin, libcimplot), Cint, ())
end

function igEnd()
    ccall((:igEnd, libcimplot), Cvoid, ())
end

function igBeginChildStr()
    ccall((:igBeginChildStr, libcimplot), Cint, ())
end

function igBeginChildID()
    ccall((:igBeginChildID, libcimplot), Cint, ())
end

function igEndChild()
    ccall((:igEndChild, libcimplot), Cvoid, ())
end

function igIsWindowAppearing()
    ccall((:igIsWindowAppearing, libcimplot), Cint, ())
end

function igIsWindowCollapsed()
    ccall((:igIsWindowCollapsed, libcimplot), Cint, ())
end

function igIsWindowFocused()
    ccall((:igIsWindowFocused, libcimplot), Cint, ())
end

function igIsWindowHovered()
    ccall((:igIsWindowHovered, libcimplot), Cint, ())
end

function igGetWindowDrawList()
    ccall((:igGetWindowDrawList, libcimplot), Ptr{ImDrawList}, ())
end

function igGetWindowPos(pOut)
    ccall((:igGetWindowPos, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetWindowSize(pOut)
    ccall((:igGetWindowSize, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetWindowWidth()
    ccall((:igGetWindowWidth, libcimplot), Cfloat, ())
end

function igGetWindowHeight()
    ccall((:igGetWindowHeight, libcimplot), Cfloat, ())
end

function igSetNextWindowPos(pos, cond, pivot)
    ccall((:igSetNextWindowPos, libcimplot), Cvoid, (ImVec2, ImGuiCond, ImVec2), pos, cond, pivot)
end

function igSetNextWindowSize(size, cond)
    ccall((:igSetNextWindowSize, libcimplot), Cvoid, (ImVec2, ImGuiCond), size, cond)
end

function igSetNextWindowSizeConstraints(size_min, size_max, custom_callback, custom_callback_data)
    ccall((:igSetNextWindowSizeConstraints, libcimplot), Cvoid, (ImVec2, ImVec2, ImGuiSizeCallback, Ptr{Cvoid}), size_min, size_max, custom_callback, custom_callback_data)
end

function igSetNextWindowContentSize(size)
    ccall((:igSetNextWindowContentSize, libcimplot), Cvoid, (ImVec2,), size)
end

function igSetNextWindowCollapsed(collapsed, cond)
    ccall((:igSetNextWindowCollapsed, libcimplot), Cvoid, (Cint, ImGuiCond), collapsed, cond)
end

function igSetNextWindowFocus()
    ccall((:igSetNextWindowFocus, libcimplot), Cvoid, ())
end

function igSetNextWindowBgAlpha(alpha)
    ccall((:igSetNextWindowBgAlpha, libcimplot), Cvoid, (Cfloat,), alpha)
end

function igSetWindowPosVec2(pos, cond)
    ccall((:igSetWindowPosVec2, libcimplot), Cvoid, (ImVec2, ImGuiCond), pos, cond)
end

function igSetWindowSizeVec2(size, cond)
    ccall((:igSetWindowSizeVec2, libcimplot), Cvoid, (ImVec2, ImGuiCond), size, cond)
end

function igSetWindowCollapsedBool(collapsed, cond)
    ccall((:igSetWindowCollapsedBool, libcimplot), Cvoid, (Cint, ImGuiCond), collapsed, cond)
end

function igSetWindowFocusNil()
    ccall((:igSetWindowFocusNil, libcimplot), Cvoid, ())
end

function igSetWindowFontScale(scale)
    ccall((:igSetWindowFontScale, libcimplot), Cvoid, (Cfloat,), scale)
end

function igSetWindowPosStr(name, pos, cond)
    ccall((:igSetWindowPosStr, libcimplot), Cvoid, (Cstring, ImVec2, ImGuiCond), name, pos, cond)
end

function igSetWindowSizeStr(name, size, cond)
    ccall((:igSetWindowSizeStr, libcimplot), Cvoid, (Cstring, ImVec2, ImGuiCond), name, size, cond)
end

function igSetWindowCollapsedStr(name, collapsed, cond)
    ccall((:igSetWindowCollapsedStr, libcimplot), Cvoid, (Cstring, Cint, ImGuiCond), name, collapsed, cond)
end

function igSetWindowFocusStr(name)
    ccall((:igSetWindowFocusStr, libcimplot), Cvoid, (Cstring,), name)
end

function igGetContentRegionAvail(pOut)
    ccall((:igGetContentRegionAvail, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetContentRegionMax(pOut)
    ccall((:igGetContentRegionMax, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetWindowContentRegionMin(pOut)
    ccall((:igGetWindowContentRegionMin, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetWindowContentRegionMax(pOut)
    ccall((:igGetWindowContentRegionMax, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetWindowContentRegionWidth()
    ccall((:igGetWindowContentRegionWidth, libcimplot), Cfloat, ())
end

function igGetScrollX()
    ccall((:igGetScrollX, libcimplot), Cfloat, ())
end

function igGetScrollY()
    ccall((:igGetScrollY, libcimplot), Cfloat, ())
end

function igSetScrollXFloat(scroll_x)
    ccall((:igSetScrollXFloat, libcimplot), Cvoid, (Cfloat,), scroll_x)
end

function igSetScrollYFloat(scroll_y)
    ccall((:igSetScrollYFloat, libcimplot), Cvoid, (Cfloat,), scroll_y)
end

function igGetScrollMaxX()
    ccall((:igGetScrollMaxX, libcimplot), Cfloat, ())
end

function igGetScrollMaxY()
    ccall((:igGetScrollMaxY, libcimplot), Cfloat, ())
end

function igSetScrollHereX(center_x_ratio)
    ccall((:igSetScrollHereX, libcimplot), Cvoid, (Cfloat,), center_x_ratio)
end

function igSetScrollHereY(center_y_ratio)
    ccall((:igSetScrollHereY, libcimplot), Cvoid, (Cfloat,), center_y_ratio)
end

function igSetScrollFromPosXFloat(local_x, center_x_ratio)
    ccall((:igSetScrollFromPosXFloat, libcimplot), Cvoid, (Cfloat, Cfloat), local_x, center_x_ratio)
end

function igSetScrollFromPosYFloat(local_y, center_y_ratio)
    ccall((:igSetScrollFromPosYFloat, libcimplot), Cvoid, (Cfloat, Cfloat), local_y, center_y_ratio)
end

function igPushFont(font)
    ccall((:igPushFont, libcimplot), Cvoid, (Ptr{ImFont},), font)
end

function igPopFont()
    ccall((:igPopFont, libcimplot), Cvoid, ())
end

function igPushStyleColorU32(idx, col)
    ccall((:igPushStyleColorU32, libcimplot), Cvoid, (ImGuiCol, ImU32), idx, col)
end

function igPushStyleColorVec4(idx, col)
    ccall((:igPushStyleColorVec4, libcimplot), Cvoid, (ImGuiCol, ImVec4), idx, col)
end

function igPopStyleColor(count)
    ccall((:igPopStyleColor, libcimplot), Cvoid, (Cint,), count)
end

function igPushStyleVarFloat(idx, val)
    ccall((:igPushStyleVarFloat, libcimplot), Cvoid, (ImGuiStyleVar, Cfloat), idx, val)
end

function igPushStyleVarVec2(idx, val)
    ccall((:igPushStyleVarVec2, libcimplot), Cvoid, (ImGuiStyleVar, ImVec2), idx, val)
end

function igPopStyleVar(count)
    ccall((:igPopStyleVar, libcimplot), Cvoid, (Cint,), count)
end

function igPushAllowKeyboardFocus(allow_keyboard_focus)
    ccall((:igPushAllowKeyboardFocus, libcimplot), Cvoid, (Cint,), allow_keyboard_focus)
end

function igPopAllowKeyboardFocus()
    ccall((:igPopAllowKeyboardFocus, libcimplot), Cvoid, ())
end

function igPushButtonRepeat(repeat)
    ccall((:igPushButtonRepeat, libcimplot), Cvoid, (Cint,), repeat)
end

function igPopButtonRepeat()
    ccall((:igPopButtonRepeat, libcimplot), Cvoid, ())
end

function igPushItemWidth(item_width)
    ccall((:igPushItemWidth, libcimplot), Cvoid, (Cfloat,), item_width)
end

function igPopItemWidth()
    ccall((:igPopItemWidth, libcimplot), Cvoid, ())
end

function igSetNextItemWidth(item_width)
    ccall((:igSetNextItemWidth, libcimplot), Cvoid, (Cfloat,), item_width)
end

function igCalcItemWidth()
    ccall((:igCalcItemWidth, libcimplot), Cfloat, ())
end

function igPushTextWrapPos(wrap_local_pos_x)
    ccall((:igPushTextWrapPos, libcimplot), Cvoid, (Cfloat,), wrap_local_pos_x)
end

function igPopTextWrapPos()
    ccall((:igPopTextWrapPos, libcimplot), Cvoid, ())
end

function igGetFont()
    ccall((:igGetFont, libcimplot), Ptr{ImFont}, ())
end

function igGetFontSize()
    ccall((:igGetFontSize, libcimplot), Cfloat, ())
end

function igGetFontTexUvWhitePixel(pOut)
    ccall((:igGetFontTexUvWhitePixel, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetColorU32Col(idx, alpha_mul)
    ccall((:igGetColorU32Col, libcimplot), ImU32, (ImGuiCol, Cfloat), idx, alpha_mul)
end

function igGetColorU32Vec4(col)
    ccall((:igGetColorU32Vec4, libcimplot), ImU32, (ImVec4,), col)
end

function igGetColorU32U32(col)
    ccall((:igGetColorU32U32, libcimplot), ImU32, (ImU32,), col)
end

function igGetStyleColorVec4(idx)
    ccall((:igGetStyleColorVec4, libcimplot), Ptr{ImVec4}, (ImGuiCol,), idx)
end

function igSeparator()
    ccall((:igSeparator, libcimplot), Cvoid, ())
end

function igSameLine(offset_from_start_x, spacing)
    ccall((:igSameLine, libcimplot), Cvoid, (Cfloat, Cfloat), offset_from_start_x, spacing)
end

function igNewLine()
    ccall((:igNewLine, libcimplot), Cvoid, ())
end

function igSpacing()
    ccall((:igSpacing, libcimplot), Cvoid, ())
end

function igDummy(size)
    ccall((:igDummy, libcimplot), Cvoid, (ImVec2,), size)
end

function igIndent(indent_w)
    ccall((:igIndent, libcimplot), Cvoid, (Cfloat,), indent_w)
end

function igUnindent(indent_w)
    ccall((:igUnindent, libcimplot), Cvoid, (Cfloat,), indent_w)
end

function igBeginGroup()
    ccall((:igBeginGroup, libcimplot), Cvoid, ())
end

function igEndGroup()
    ccall((:igEndGroup, libcimplot), Cvoid, ())
end

function igGetCursorPos(pOut)
    ccall((:igGetCursorPos, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetCursorPosX()
    ccall((:igGetCursorPosX, libcimplot), Cfloat, ())
end

function igGetCursorPosY()
    ccall((:igGetCursorPosY, libcimplot), Cfloat, ())
end

function igSetCursorPos(local_pos)
    ccall((:igSetCursorPos, libcimplot), Cvoid, (ImVec2,), local_pos)
end

function igSetCursorPosX(local_x)
    ccall((:igSetCursorPosX, libcimplot), Cvoid, (Cfloat,), local_x)
end

function igSetCursorPosY(local_y)
    ccall((:igSetCursorPosY, libcimplot), Cvoid, (Cfloat,), local_y)
end

function igGetCursorStartPos(pOut)
    ccall((:igGetCursorStartPos, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetCursorScreenPos(pOut)
    ccall((:igGetCursorScreenPos, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igSetCursorScreenPos(pos)
    ccall((:igSetCursorScreenPos, libcimplot), Cvoid, (ImVec2,), pos)
end

function igAlignTextToFramePadding()
    ccall((:igAlignTextToFramePadding, libcimplot), Cvoid, ())
end

function igGetTextLineHeight()
    ccall((:igGetTextLineHeight, libcimplot), Cfloat, ())
end

function igGetTextLineHeightWithSpacing()
    ccall((:igGetTextLineHeightWithSpacing, libcimplot), Cfloat, ())
end

function igGetFrameHeight()
    ccall((:igGetFrameHeight, libcimplot), Cfloat, ())
end

function igGetFrameHeightWithSpacing()
    ccall((:igGetFrameHeightWithSpacing, libcimplot), Cfloat, ())
end

function igPushIDStr(str_id)
    ccall((:igPushIDStr, libcimplot), Cvoid, (Cstring,), str_id)
end

function igPushIDStrStr(str_id_begin, str_id_end)
    ccall((:igPushIDStrStr, libcimplot), Cvoid, (Cstring, Cstring), str_id_begin, str_id_end)
end

function igPushIDPtr(ptr_id)
    ccall((:igPushIDPtr, libcimplot), Cvoid, (Ptr{Cvoid},), ptr_id)
end

function igPushIDInt(int_id)
    ccall((:igPushIDInt, libcimplot), Cvoid, (Cint,), int_id)
end

function igPopID()
    ccall((:igPopID, libcimplot), Cvoid, ())
end

function igGetIDStr(str_id)
    ccall((:igGetIDStr, libcimplot), ImGuiID, (Cstring,), str_id)
end

function igGetIDStrStr(str_id_begin, str_id_end)
    ccall((:igGetIDStrStr, libcimplot), ImGuiID, (Cstring, Cstring), str_id_begin, str_id_end)
end

function igGetIDPtr(ptr_id)
    ccall((:igGetIDPtr, libcimplot), ImGuiID, (Ptr{Cvoid},), ptr_id)
end

function igTextUnformatted(text, text_end)
    ccall((:igTextUnformatted, libcimplot), Cvoid, (Cstring, Cstring), text, text_end)
end

function igTextV(fmt, args)
    ccall((:igTextV, libcimplot), Cvoid, (Cstring, Cint), fmt, args)
end

function igTextColoredV(col, fmt, args)
    ccall((:igTextColoredV, libcimplot), Cvoid, (ImVec4, Cstring, Cint), col, fmt, args)
end

function igTextDisabledV(fmt, args)
    ccall((:igTextDisabledV, libcimplot), Cvoid, (Cstring, Cint), fmt, args)
end

function igTextWrappedV(fmt, args)
    ccall((:igTextWrappedV, libcimplot), Cvoid, (Cstring, Cint), fmt, args)
end

function igLabelTextV(label, fmt, args)
    ccall((:igLabelTextV, libcimplot), Cvoid, (Cstring, Cstring, Cint), label, fmt, args)
end

function igBulletTextV(fmt, args)
    ccall((:igBulletTextV, libcimplot), Cvoid, (Cstring, Cint), fmt, args)
end

function igButton()
    ccall((:igButton, libcimplot), Cint, ())
end

function igSmallButton()
    ccall((:igSmallButton, libcimplot), Cint, ())
end

function igInvisibleButton()
    ccall((:igInvisibleButton, libcimplot), Cint, ())
end

function igArrowButton()
    ccall((:igArrowButton, libcimplot), Cint, ())
end

function igImage(user_texture_id, size, uv0, uv1, tint_col, border_col)
    ccall((:igImage, libcimplot), Cvoid, (ImTextureID, ImVec2, ImVec2, ImVec2, ImVec4, ImVec4), user_texture_id, size, uv0, uv1, tint_col, border_col)
end

function igImageButton()
    ccall((:igImageButton, libcimplot), Cint, ())
end

function igCheckbox()
    ccall((:igCheckbox, libcimplot), Cint, ())
end

function igCheckboxFlagsIntPtr()
    ccall((:igCheckboxFlagsIntPtr, libcimplot), Cint, ())
end

function igCheckboxFlagsUintPtr()
    ccall((:igCheckboxFlagsUintPtr, libcimplot), Cint, ())
end

function igRadioButtonBool()
    ccall((:igRadioButtonBool, libcimplot), Cint, ())
end

function igRadioButtonIntPtr()
    ccall((:igRadioButtonIntPtr, libcimplot), Cint, ())
end

function igProgressBar(fraction, size_arg, overlay)
    ccall((:igProgressBar, libcimplot), Cvoid, (Cfloat, ImVec2, Cstring), fraction, size_arg, overlay)
end

function igBullet()
    ccall((:igBullet, libcimplot), Cvoid, ())
end

function igBeginCombo()
    ccall((:igBeginCombo, libcimplot), Cint, ())
end

function igEndCombo()
    ccall((:igEndCombo, libcimplot), Cvoid, ())
end

function igComboStr_arr()
    ccall((:igComboStr_arr, libcimplot), Cint, ())
end

function igComboStr()
    ccall((:igComboStr, libcimplot), Cint, ())
end

function igComboFnBoolPtr()
    ccall((:igComboFnBoolPtr, libcimplot), Cint, ())
end

function igDragFloat()
    ccall((:igDragFloat, libcimplot), Cint, ())
end

function igDragFloat2()
    ccall((:igDragFloat2, libcimplot), Cint, ())
end

function igDragFloat3()
    ccall((:igDragFloat3, libcimplot), Cint, ())
end

function igDragFloat4()
    ccall((:igDragFloat4, libcimplot), Cint, ())
end

function igDragFloatRange2()
    ccall((:igDragFloatRange2, libcimplot), Cint, ())
end

function igDragInt()
    ccall((:igDragInt, libcimplot), Cint, ())
end

function igDragInt2()
    ccall((:igDragInt2, libcimplot), Cint, ())
end

function igDragInt3()
    ccall((:igDragInt3, libcimplot), Cint, ())
end

function igDragInt4()
    ccall((:igDragInt4, libcimplot), Cint, ())
end

function igDragIntRange2()
    ccall((:igDragIntRange2, libcimplot), Cint, ())
end

function igDragScalar()
    ccall((:igDragScalar, libcimplot), Cint, ())
end

function igDragScalarN()
    ccall((:igDragScalarN, libcimplot), Cint, ())
end

function igSliderFloat()
    ccall((:igSliderFloat, libcimplot), Cint, ())
end

function igSliderFloat2()
    ccall((:igSliderFloat2, libcimplot), Cint, ())
end

function igSliderFloat3()
    ccall((:igSliderFloat3, libcimplot), Cint, ())
end

function igSliderFloat4()
    ccall((:igSliderFloat4, libcimplot), Cint, ())
end

function igSliderAngle()
    ccall((:igSliderAngle, libcimplot), Cint, ())
end

function igSliderInt()
    ccall((:igSliderInt, libcimplot), Cint, ())
end

function igSliderInt2()
    ccall((:igSliderInt2, libcimplot), Cint, ())
end

function igSliderInt3()
    ccall((:igSliderInt3, libcimplot), Cint, ())
end

function igSliderInt4()
    ccall((:igSliderInt4, libcimplot), Cint, ())
end

function igSliderScalar()
    ccall((:igSliderScalar, libcimplot), Cint, ())
end

function igSliderScalarN()
    ccall((:igSliderScalarN, libcimplot), Cint, ())
end

function igVSliderFloat()
    ccall((:igVSliderFloat, libcimplot), Cint, ())
end

function igVSliderInt()
    ccall((:igVSliderInt, libcimplot), Cint, ())
end

function igVSliderScalar()
    ccall((:igVSliderScalar, libcimplot), Cint, ())
end

function igInputText()
    ccall((:igInputText, libcimplot), Cint, ())
end

function igInputTextMultiline()
    ccall((:igInputTextMultiline, libcimplot), Cint, ())
end

function igInputTextWithHint()
    ccall((:igInputTextWithHint, libcimplot), Cint, ())
end

function igInputFloat()
    ccall((:igInputFloat, libcimplot), Cint, ())
end

function igInputFloat2()
    ccall((:igInputFloat2, libcimplot), Cint, ())
end

function igInputFloat3()
    ccall((:igInputFloat3, libcimplot), Cint, ())
end

function igInputFloat4()
    ccall((:igInputFloat4, libcimplot), Cint, ())
end

function igInputInt()
    ccall((:igInputInt, libcimplot), Cint, ())
end

function igInputInt2()
    ccall((:igInputInt2, libcimplot), Cint, ())
end

function igInputInt3()
    ccall((:igInputInt3, libcimplot), Cint, ())
end

function igInputInt4()
    ccall((:igInputInt4, libcimplot), Cint, ())
end

function igInputDouble()
    ccall((:igInputDouble, libcimplot), Cint, ())
end

function igInputScalar()
    ccall((:igInputScalar, libcimplot), Cint, ())
end

function igInputScalarN()
    ccall((:igInputScalarN, libcimplot), Cint, ())
end

function igColorEdit3()
    ccall((:igColorEdit3, libcimplot), Cint, ())
end

function igColorEdit4()
    ccall((:igColorEdit4, libcimplot), Cint, ())
end

function igColorPicker3()
    ccall((:igColorPicker3, libcimplot), Cint, ())
end

function igColorPicker4()
    ccall((:igColorPicker4, libcimplot), Cint, ())
end

function igColorButton()
    ccall((:igColorButton, libcimplot), Cint, ())
end

function igSetColorEditOptions(flags)
    ccall((:igSetColorEditOptions, libcimplot), Cvoid, (ImGuiColorEditFlags,), flags)
end

function igTreeNodeStr()
    ccall((:igTreeNodeStr, libcimplot), Cint, ())
end

function igTreeNodeVStr()
    ccall((:igTreeNodeVStr, libcimplot), Cint, ())
end

function igTreeNodeVPtr()
    ccall((:igTreeNodeVPtr, libcimplot), Cint, ())
end

function igTreeNodeExStr()
    ccall((:igTreeNodeExStr, libcimplot), Cint, ())
end

function igTreeNodeExVStr()
    ccall((:igTreeNodeExVStr, libcimplot), Cint, ())
end

function igTreeNodeExVPtr()
    ccall((:igTreeNodeExVPtr, libcimplot), Cint, ())
end

function igTreePushStr(str_id)
    ccall((:igTreePushStr, libcimplot), Cvoid, (Cstring,), str_id)
end

function igTreePushPtr(ptr_id)
    ccall((:igTreePushPtr, libcimplot), Cvoid, (Ptr{Cvoid},), ptr_id)
end

function igTreePop()
    ccall((:igTreePop, libcimplot), Cvoid, ())
end

function igGetTreeNodeToLabelSpacing()
    ccall((:igGetTreeNodeToLabelSpacing, libcimplot), Cfloat, ())
end

function igCollapsingHeaderTreeNodeFlags()
    ccall((:igCollapsingHeaderTreeNodeFlags, libcimplot), Cint, ())
end

function igCollapsingHeaderBoolPtr()
    ccall((:igCollapsingHeaderBoolPtr, libcimplot), Cint, ())
end

function igSetNextItemOpen(is_open, cond)
    ccall((:igSetNextItemOpen, libcimplot), Cvoid, (Cint, ImGuiCond), is_open, cond)
end

function igSelectableBool()
    ccall((:igSelectableBool, libcimplot), Cint, ())
end

function igSelectableBoolPtr()
    ccall((:igSelectableBoolPtr, libcimplot), Cint, ())
end

function igBeginListBox()
    ccall((:igBeginListBox, libcimplot), Cint, ())
end

function igEndListBox()
    ccall((:igEndListBox, libcimplot), Cvoid, ())
end

function igListBoxStr_arr()
    ccall((:igListBoxStr_arr, libcimplot), Cint, ())
end

function igListBoxFnBoolPtr()
    ccall((:igListBoxFnBoolPtr, libcimplot), Cint, ())
end

function igPlotLinesFloatPtr(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride)
    ccall((:igPlotLinesFloatPtr, libcimplot), Cvoid, (Cstring, Ptr{Cfloat}, Cint, Cint, Cstring, Cfloat, Cfloat, ImVec2, Cint), label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride)
end

function igPlotLinesFnFloatPtr(label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size)
    ccall((:igPlotLinesFnFloatPtr, libcimplot), Cvoid, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Cint, Cint, Cstring, Cfloat, Cfloat, ImVec2), label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size)
end

function igPlotHistogramFloatPtr(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride)
    ccall((:igPlotHistogramFloatPtr, libcimplot), Cvoid, (Cstring, Ptr{Cfloat}, Cint, Cint, Cstring, Cfloat, Cfloat, ImVec2, Cint), label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride)
end

function igPlotHistogramFnFloatPtr(label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size)
    ccall((:igPlotHistogramFnFloatPtr, libcimplot), Cvoid, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Cint, Cint, Cstring, Cfloat, Cfloat, ImVec2), label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size)
end

function igValueBool(prefix, b)
    ccall((:igValueBool, libcimplot), Cvoid, (Cstring, Cint), prefix, b)
end

function igValueInt(prefix, v)
    ccall((:igValueInt, libcimplot), Cvoid, (Cstring, Cint), prefix, v)
end

function igValueUint(prefix, v)
    ccall((:igValueUint, libcimplot), Cvoid, (Cstring, Cuint), prefix, v)
end

function igValueFloat(prefix, v, float_format)
    ccall((:igValueFloat, libcimplot), Cvoid, (Cstring, Cfloat, Cstring), prefix, v, float_format)
end

function igBeginMenuBar()
    ccall((:igBeginMenuBar, libcimplot), Cint, ())
end

function igEndMenuBar()
    ccall((:igEndMenuBar, libcimplot), Cvoid, ())
end

function igBeginMainMenuBar()
    ccall((:igBeginMainMenuBar, libcimplot), Cint, ())
end

function igEndMainMenuBar()
    ccall((:igEndMainMenuBar, libcimplot), Cvoid, ())
end

function igBeginMenu()
    ccall((:igBeginMenu, libcimplot), Cint, ())
end

function igEndMenu()
    ccall((:igEndMenu, libcimplot), Cvoid, ())
end

function igMenuItemBool()
    ccall((:igMenuItemBool, libcimplot), Cint, ())
end

function igMenuItemBoolPtr()
    ccall((:igMenuItemBoolPtr, libcimplot), Cint, ())
end

function igBeginTooltip()
    ccall((:igBeginTooltip, libcimplot), Cvoid, ())
end

function igEndTooltip()
    ccall((:igEndTooltip, libcimplot), Cvoid, ())
end

function igSetTooltipV(fmt, args)
    ccall((:igSetTooltipV, libcimplot), Cvoid, (Cstring, Cint), fmt, args)
end

function igBeginPopup()
    ccall((:igBeginPopup, libcimplot), Cint, ())
end

function igBeginPopupModal()
    ccall((:igBeginPopupModal, libcimplot), Cint, ())
end

function igEndPopup()
    ccall((:igEndPopup, libcimplot), Cvoid, ())
end

function igOpenPopup(str_id, popup_flags)
    ccall((:igOpenPopup, libcimplot), Cvoid, (Cstring, ImGuiPopupFlags), str_id, popup_flags)
end

function igOpenPopupOnItemClick(str_id, popup_flags)
    ccall((:igOpenPopupOnItemClick, libcimplot), Cvoid, (Cstring, ImGuiPopupFlags), str_id, popup_flags)
end

function igCloseCurrentPopup()
    ccall((:igCloseCurrentPopup, libcimplot), Cvoid, ())
end

function igBeginPopupContextItem()
    ccall((:igBeginPopupContextItem, libcimplot), Cint, ())
end

function igBeginPopupContextWindow()
    ccall((:igBeginPopupContextWindow, libcimplot), Cint, ())
end

function igBeginPopupContextVoid()
    ccall((:igBeginPopupContextVoid, libcimplot), Cint, ())
end

function igIsPopupOpenStr()
    ccall((:igIsPopupOpenStr, libcimplot), Cint, ())
end

function igBeginTable()
    ccall((:igBeginTable, libcimplot), Cint, ())
end

function igEndTable()
    ccall((:igEndTable, libcimplot), Cvoid, ())
end

function igTableNextRow(row_flags, min_row_height)
    ccall((:igTableNextRow, libcimplot), Cvoid, (ImGuiTableRowFlags, Cfloat), row_flags, min_row_height)
end

function igTableNextColumn()
    ccall((:igTableNextColumn, libcimplot), Cint, ())
end

function igTableSetColumnIndex()
    ccall((:igTableSetColumnIndex, libcimplot), Cint, ())
end

function igTableSetupColumn(label, flags, init_width_or_weight, user_id)
    ccall((:igTableSetupColumn, libcimplot), Cvoid, (Cstring, ImGuiTableColumnFlags, Cfloat, ImGuiID), label, flags, init_width_or_weight, user_id)
end

function igTableSetupScrollFreeze(cols, rows)
    ccall((:igTableSetupScrollFreeze, libcimplot), Cvoid, (Cint, Cint), cols, rows)
end

function igTableHeadersRow()
    ccall((:igTableHeadersRow, libcimplot), Cvoid, ())
end

function igTableHeader(label)
    ccall((:igTableHeader, libcimplot), Cvoid, (Cstring,), label)
end

function igTableGetSortSpecs()
    ccall((:igTableGetSortSpecs, libcimplot), Ptr{ImGuiTableSortSpecs}, ())
end

function igTableGetColumnCount()
    ccall((:igTableGetColumnCount, libcimplot), Cint, ())
end

function igTableGetColumnIndex()
    ccall((:igTableGetColumnIndex, libcimplot), Cint, ())
end

function igTableGetRowIndex()
    ccall((:igTableGetRowIndex, libcimplot), Cint, ())
end

function igTableGetColumnNameInt(column_n)
    ccall((:igTableGetColumnNameInt, libcimplot), Cstring, (Cint,), column_n)
end

function igTableGetColumnFlags(column_n)
    ccall((:igTableGetColumnFlags, libcimplot), ImGuiTableColumnFlags, (Cint,), column_n)
end

function igTableSetBgColor(target, color, column_n)
    ccall((:igTableSetBgColor, libcimplot), Cvoid, (ImGuiTableBgTarget, ImU32, Cint), target, color, column_n)
end

function igColumns(count, id, border)
    ccall((:igColumns, libcimplot), Cvoid, (Cint, Cstring, Cint), count, id, border)
end

function igNextColumn()
    ccall((:igNextColumn, libcimplot), Cvoid, ())
end

function igGetColumnIndex()
    ccall((:igGetColumnIndex, libcimplot), Cint, ())
end

function igGetColumnWidth(column_index)
    ccall((:igGetColumnWidth, libcimplot), Cfloat, (Cint,), column_index)
end

function igSetColumnWidth(column_index, width)
    ccall((:igSetColumnWidth, libcimplot), Cvoid, (Cint, Cfloat), column_index, width)
end

function igGetColumnOffset(column_index)
    ccall((:igGetColumnOffset, libcimplot), Cfloat, (Cint,), column_index)
end

function igSetColumnOffset(column_index, offset_x)
    ccall((:igSetColumnOffset, libcimplot), Cvoid, (Cint, Cfloat), column_index, offset_x)
end

function igGetColumnsCount()
    ccall((:igGetColumnsCount, libcimplot), Cint, ())
end

function igBeginTabBar()
    ccall((:igBeginTabBar, libcimplot), Cint, ())
end

function igEndTabBar()
    ccall((:igEndTabBar, libcimplot), Cvoid, ())
end

function igBeginTabItem()
    ccall((:igBeginTabItem, libcimplot), Cint, ())
end

function igEndTabItem()
    ccall((:igEndTabItem, libcimplot), Cvoid, ())
end

function igTabItemButton()
    ccall((:igTabItemButton, libcimplot), Cint, ())
end

function igSetTabItemClosed(tab_or_docked_window_label)
    ccall((:igSetTabItemClosed, libcimplot), Cvoid, (Cstring,), tab_or_docked_window_label)
end

function igLogToTTY(auto_open_depth)
    ccall((:igLogToTTY, libcimplot), Cvoid, (Cint,), auto_open_depth)
end

function igLogToFile(auto_open_depth, filename)
    ccall((:igLogToFile, libcimplot), Cvoid, (Cint, Cstring), auto_open_depth, filename)
end

function igLogToClipboard(auto_open_depth)
    ccall((:igLogToClipboard, libcimplot), Cvoid, (Cint,), auto_open_depth)
end

function igLogFinish()
    ccall((:igLogFinish, libcimplot), Cvoid, ())
end

function igLogButtons()
    ccall((:igLogButtons, libcimplot), Cvoid, ())
end

function igLogTextV(fmt, args)
    ccall((:igLogTextV, libcimplot), Cvoid, (Cstring, Cint), fmt, args)
end

function igBeginDragDropSource()
    ccall((:igBeginDragDropSource, libcimplot), Cint, ())
end

function igSetDragDropPayload()
    ccall((:igSetDragDropPayload, libcimplot), Cint, ())
end

function igEndDragDropSource()
    ccall((:igEndDragDropSource, libcimplot), Cvoid, ())
end

function igBeginDragDropTarget()
    ccall((:igBeginDragDropTarget, libcimplot), Cint, ())
end

function igAcceptDragDropPayload(type, flags)
    ccall((:igAcceptDragDropPayload, libcimplot), Ptr{ImGuiPayload}, (Cstring, ImGuiDragDropFlags), type, flags)
end

function igEndDragDropTarget()
    ccall((:igEndDragDropTarget, libcimplot), Cvoid, ())
end

function igGetDragDropPayload()
    ccall((:igGetDragDropPayload, libcimplot), Ptr{ImGuiPayload}, ())
end

function igPushClipRect(clip_rect_min, clip_rect_max, intersect_with_current_clip_rect)
    ccall((:igPushClipRect, libcimplot), Cvoid, (ImVec2, ImVec2, Cint), clip_rect_min, clip_rect_max, intersect_with_current_clip_rect)
end

function igPopClipRect()
    ccall((:igPopClipRect, libcimplot), Cvoid, ())
end

function igSetItemDefaultFocus()
    ccall((:igSetItemDefaultFocus, libcimplot), Cvoid, ())
end

function igSetKeyboardFocusHere(offset)
    ccall((:igSetKeyboardFocusHere, libcimplot), Cvoid, (Cint,), offset)
end

function igIsItemHovered()
    ccall((:igIsItemHovered, libcimplot), Cint, ())
end

function igIsItemActive()
    ccall((:igIsItemActive, libcimplot), Cint, ())
end

function igIsItemFocused()
    ccall((:igIsItemFocused, libcimplot), Cint, ())
end

function igIsItemClicked()
    ccall((:igIsItemClicked, libcimplot), Cint, ())
end

function igIsItemVisible()
    ccall((:igIsItemVisible, libcimplot), Cint, ())
end

function igIsItemEdited()
    ccall((:igIsItemEdited, libcimplot), Cint, ())
end

function igIsItemActivated()
    ccall((:igIsItemActivated, libcimplot), Cint, ())
end

function igIsItemDeactivated()
    ccall((:igIsItemDeactivated, libcimplot), Cint, ())
end

function igIsItemDeactivatedAfterEdit()
    ccall((:igIsItemDeactivatedAfterEdit, libcimplot), Cint, ())
end

function igIsItemToggledOpen()
    ccall((:igIsItemToggledOpen, libcimplot), Cint, ())
end

function igIsAnyItemHovered()
    ccall((:igIsAnyItemHovered, libcimplot), Cint, ())
end

function igIsAnyItemActive()
    ccall((:igIsAnyItemActive, libcimplot), Cint, ())
end

function igIsAnyItemFocused()
    ccall((:igIsAnyItemFocused, libcimplot), Cint, ())
end

function igGetItemRectMin(pOut)
    ccall((:igGetItemRectMin, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetItemRectMax(pOut)
    ccall((:igGetItemRectMax, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetItemRectSize(pOut)
    ccall((:igGetItemRectSize, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igSetItemAllowOverlap()
    ccall((:igSetItemAllowOverlap, libcimplot), Cvoid, ())
end

function igGetMainViewport()
    ccall((:igGetMainViewport, libcimplot), Ptr{ImGuiViewport}, ())
end

function igIsRectVisibleNil()
    ccall((:igIsRectVisibleNil, libcimplot), Cint, ())
end

function igIsRectVisibleVec2()
    ccall((:igIsRectVisibleVec2, libcimplot), Cint, ())
end

function igGetTime()
    ccall((:igGetTime, libcimplot), Cdouble, ())
end

function igGetFrameCount()
    ccall((:igGetFrameCount, libcimplot), Cint, ())
end

function igGetBackgroundDrawListNil()
    ccall((:igGetBackgroundDrawListNil, libcimplot), Ptr{ImDrawList}, ())
end

function igGetForegroundDrawListNil()
    ccall((:igGetForegroundDrawListNil, libcimplot), Ptr{ImDrawList}, ())
end

function igGetDrawListSharedData()
    ccall((:igGetDrawListSharedData, libcimplot), Ptr{ImDrawListSharedData}, ())
end

function igGetStyleColorName(idx)
    ccall((:igGetStyleColorName, libcimplot), Cstring, (ImGuiCol,), idx)
end

function igSetStateStorage(storage)
    ccall((:igSetStateStorage, libcimplot), Cvoid, (Ptr{ImGuiStorage},), storage)
end

function igGetStateStorage()
    ccall((:igGetStateStorage, libcimplot), Ptr{ImGuiStorage}, ())
end

function igCalcListClipping(items_count, items_height, out_items_display_start, out_items_display_end)
    ccall((:igCalcListClipping, libcimplot), Cvoid, (Cint, Cfloat, Ptr{Cint}, Ptr{Cint}), items_count, items_height, out_items_display_start, out_items_display_end)
end

function igBeginChildFrame()
    ccall((:igBeginChildFrame, libcimplot), Cint, ())
end

function igEndChildFrame()
    ccall((:igEndChildFrame, libcimplot), Cvoid, ())
end

function igCalcTextSize(pOut, text, text_end, hide_text_after_double_hash, wrap_width)
    ccall((:igCalcTextSize, libcimplot), Cvoid, (Ptr{ImVec2}, Cstring, Cstring, Cint, Cfloat), pOut, text, text_end, hide_text_after_double_hash, wrap_width)
end

function igColorConvertU32ToFloat4(pOut, in)
    ccall((:igColorConvertU32ToFloat4, libcimplot), Cvoid, (Ptr{ImVec4}, ImU32), pOut, in)
end

function igColorConvertFloat4ToU32(in)
    ccall((:igColorConvertFloat4ToU32, libcimplot), ImU32, (ImVec4,), in)
end

function igColorConvertRGBtoHSV(r, g, b, out_h, out_s, out_v)
    ccall((:igColorConvertRGBtoHSV, libcimplot), Cvoid, (Cfloat, Cfloat, Cfloat, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Cfloat}), r, g, b, out_h, out_s, out_v)
end

function igColorConvertHSVtoRGB(h, s, v, out_r, out_g, out_b)
    ccall((:igColorConvertHSVtoRGB, libcimplot), Cvoid, (Cfloat, Cfloat, Cfloat, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Cfloat}), h, s, v, out_r, out_g, out_b)
end

function igGetKeyIndex(imgui_key)
    ccall((:igGetKeyIndex, libcimplot), Cint, (ImGuiKey,), imgui_key)
end

function igIsKeyDown()
    ccall((:igIsKeyDown, libcimplot), Cint, ())
end

function igIsKeyPressed()
    ccall((:igIsKeyPressed, libcimplot), Cint, ())
end

function igIsKeyReleased()
    ccall((:igIsKeyReleased, libcimplot), Cint, ())
end

function igGetKeyPressedAmount(key_index, repeat_delay, rate)
    ccall((:igGetKeyPressedAmount, libcimplot), Cint, (Cint, Cfloat, Cfloat), key_index, repeat_delay, rate)
end

function igCaptureKeyboardFromApp(want_capture_keyboard_value)
    ccall((:igCaptureKeyboardFromApp, libcimplot), Cvoid, (Cint,), want_capture_keyboard_value)
end

function igIsMouseDown()
    ccall((:igIsMouseDown, libcimplot), Cint, ())
end

function igIsMouseClicked()
    ccall((:igIsMouseClicked, libcimplot), Cint, ())
end

function igIsMouseReleased()
    ccall((:igIsMouseReleased, libcimplot), Cint, ())
end

function igIsMouseDoubleClicked()
    ccall((:igIsMouseDoubleClicked, libcimplot), Cint, ())
end

function igIsMouseHoveringRect()
    ccall((:igIsMouseHoveringRect, libcimplot), Cint, ())
end

function igIsMousePosValid()
    ccall((:igIsMousePosValid, libcimplot), Cint, ())
end

function igIsAnyMouseDown()
    ccall((:igIsAnyMouseDown, libcimplot), Cint, ())
end

function igGetMousePos(pOut)
    ccall((:igGetMousePos, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igGetMousePosOnOpeningCurrentPopup(pOut)
    ccall((:igGetMousePosOnOpeningCurrentPopup, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igIsMouseDragging()
    ccall((:igIsMouseDragging, libcimplot), Cint, ())
end

function igGetMouseDragDelta(pOut, button, lock_threshold)
    ccall((:igGetMouseDragDelta, libcimplot), Cvoid, (Ptr{ImVec2}, ImGuiMouseButton, Cfloat), pOut, button, lock_threshold)
end

function igResetMouseDragDelta(button)
    ccall((:igResetMouseDragDelta, libcimplot), Cvoid, (ImGuiMouseButton,), button)
end

function igGetMouseCursor()
    ccall((:igGetMouseCursor, libcimplot), ImGuiMouseCursor, ())
end

function igSetMouseCursor(cursor_type)
    ccall((:igSetMouseCursor, libcimplot), Cvoid, (ImGuiMouseCursor,), cursor_type)
end

function igCaptureMouseFromApp(want_capture_mouse_value)
    ccall((:igCaptureMouseFromApp, libcimplot), Cvoid, (Cint,), want_capture_mouse_value)
end

function igGetClipboardText()
    ccall((:igGetClipboardText, libcimplot), Cstring, ())
end

function igSetClipboardText(text)
    ccall((:igSetClipboardText, libcimplot), Cvoid, (Cstring,), text)
end

function igLoadIniSettingsFromDisk(ini_filename)
    ccall((:igLoadIniSettingsFromDisk, libcimplot), Cvoid, (Cstring,), ini_filename)
end

function igLoadIniSettingsFromMemory(ini_data, ini_size)
    ccall((:igLoadIniSettingsFromMemory, libcimplot), Cvoid, (Cstring, Cint), ini_data, ini_size)
end

function igSaveIniSettingsToDisk(ini_filename)
    ccall((:igSaveIniSettingsToDisk, libcimplot), Cvoid, (Cstring,), ini_filename)
end

function igSaveIniSettingsToMemory(out_ini_size)
    ccall((:igSaveIniSettingsToMemory, libcimplot), Cstring, (Ptr{Cint},), out_ini_size)
end

function igDebugCheckVersionAndDataLayout()
    ccall((:igDebugCheckVersionAndDataLayout, libcimplot), Cint, ())
end

function igSetAllocatorFunctions(alloc_func, free_func, user_data)
    ccall((:igSetAllocatorFunctions, libcimplot), Cvoid, (ImGuiMemAllocFunc, ImGuiMemFreeFunc, Ptr{Cvoid}), alloc_func, free_func, user_data)
end

function igGetAllocatorFunctions(p_alloc_func, p_free_func, p_user_data)
    ccall((:igGetAllocatorFunctions, libcimplot), Cvoid, (Ptr{ImGuiMemAllocFunc}, Ptr{ImGuiMemFreeFunc}, Ptr{Ptr{Cvoid}}), p_alloc_func, p_free_func, p_user_data)
end

function igMemAlloc(size)
    ccall((:igMemAlloc, libcimplot), Ptr{Cvoid}, (Cint,), size)
end

function igMemFree(ptr)
    ccall((:igMemFree, libcimplot), Cvoid, (Ptr{Cvoid},), ptr)
end

function ImGuiStyle_ImGuiStyle()
    ccall((:ImGuiStyle_ImGuiStyle, libcimplot), Ptr{ImGuiStyle}, ())
end

function ImGuiStyle_destroy(self)
    ccall((:ImGuiStyle_destroy, libcimplot), Cvoid, (Ptr{ImGuiStyle},), self)
end

function ImGuiStyle_ScaleAllSizes(self, scale_factor)
    ccall((:ImGuiStyle_ScaleAllSizes, libcimplot), Cvoid, (Ptr{ImGuiStyle}, Cfloat), self, scale_factor)
end

function ImGuiIO_AddInputCharacter(self, c)
    ccall((:ImGuiIO_AddInputCharacter, libcimplot), Cvoid, (Ptr{ImGuiIO}, Cuint), self, c)
end

function ImGuiIO_AddInputCharacterUTF16(self, c)
    ccall((:ImGuiIO_AddInputCharacterUTF16, libcimplot), Cvoid, (Ptr{ImGuiIO}, ImWchar16), self, c)
end

function ImGuiIO_AddInputCharactersUTF8(self, str)
    ccall((:ImGuiIO_AddInputCharactersUTF8, libcimplot), Cvoid, (Ptr{ImGuiIO}, Cstring), self, str)
end

function ImGuiIO_ClearInputCharacters(self)
    ccall((:ImGuiIO_ClearInputCharacters, libcimplot), Cvoid, (Ptr{ImGuiIO},), self)
end

function ImGuiIO_ImGuiIO()
    ccall((:ImGuiIO_ImGuiIO, libcimplot), Ptr{ImGuiIO}, ())
end

function ImGuiIO_destroy(self)
    ccall((:ImGuiIO_destroy, libcimplot), Cvoid, (Ptr{ImGuiIO},), self)
end

function ImGuiInputTextCallbackData_ImGuiInputTextCallbackData()
    ccall((:ImGuiInputTextCallbackData_ImGuiInputTextCallbackData, libcimplot), Ptr{ImGuiInputTextCallbackData}, ())
end

function ImGuiInputTextCallbackData_destroy(self)
    ccall((:ImGuiInputTextCallbackData_destroy, libcimplot), Cvoid, (Ptr{ImGuiInputTextCallbackData},), self)
end

function ImGuiInputTextCallbackData_DeleteChars(self, pos, bytes_count)
    ccall((:ImGuiInputTextCallbackData_DeleteChars, libcimplot), Cvoid, (Ptr{ImGuiInputTextCallbackData}, Cint, Cint), self, pos, bytes_count)
end

function ImGuiInputTextCallbackData_InsertChars(self, pos, text, text_end)
    ccall((:ImGuiInputTextCallbackData_InsertChars, libcimplot), Cvoid, (Ptr{ImGuiInputTextCallbackData}, Cint, Cstring, Cstring), self, pos, text, text_end)
end

function ImGuiInputTextCallbackData_SelectAll(self)
    ccall((:ImGuiInputTextCallbackData_SelectAll, libcimplot), Cvoid, (Ptr{ImGuiInputTextCallbackData},), self)
end

function ImGuiInputTextCallbackData_ClearSelection(self)
    ccall((:ImGuiInputTextCallbackData_ClearSelection, libcimplot), Cvoid, (Ptr{ImGuiInputTextCallbackData},), self)
end

function ImGuiInputTextCallbackData_HasSelection()
    ccall((:ImGuiInputTextCallbackData_HasSelection, libcimplot), Cint, ())
end

function ImGuiPayload_ImGuiPayload()
    ccall((:ImGuiPayload_ImGuiPayload, libcimplot), Ptr{ImGuiPayload}, ())
end

function ImGuiPayload_destroy(self)
    ccall((:ImGuiPayload_destroy, libcimplot), Cvoid, (Ptr{ImGuiPayload},), self)
end

function ImGuiPayload_Clear(self)
    ccall((:ImGuiPayload_Clear, libcimplot), Cvoid, (Ptr{ImGuiPayload},), self)
end

function ImGuiPayload_IsDataType()
    ccall((:ImGuiPayload_IsDataType, libcimplot), Cint, ())
end

function ImGuiPayload_IsPreview()
    ccall((:ImGuiPayload_IsPreview, libcimplot), Cint, ())
end

function ImGuiPayload_IsDelivery()
    ccall((:ImGuiPayload_IsDelivery, libcimplot), Cint, ())
end

function ImGuiTableColumnSortSpecs_ImGuiTableColumnSortSpecs()
    ccall((:ImGuiTableColumnSortSpecs_ImGuiTableColumnSortSpecs, libcimplot), Ptr{ImGuiTableColumnSortSpecs}, ())
end

function ImGuiTableColumnSortSpecs_destroy(self)
    ccall((:ImGuiTableColumnSortSpecs_destroy, libcimplot), Cvoid, (Ptr{ImGuiTableColumnSortSpecs},), self)
end

function ImGuiTableSortSpecs_ImGuiTableSortSpecs()
    ccall((:ImGuiTableSortSpecs_ImGuiTableSortSpecs, libcimplot), Ptr{ImGuiTableSortSpecs}, ())
end

function ImGuiTableSortSpecs_destroy(self)
    ccall((:ImGuiTableSortSpecs_destroy, libcimplot), Cvoid, (Ptr{ImGuiTableSortSpecs},), self)
end

function ImGuiOnceUponAFrame_ImGuiOnceUponAFrame()
    ccall((:ImGuiOnceUponAFrame_ImGuiOnceUponAFrame, libcimplot), Ptr{ImGuiOnceUponAFrame}, ())
end

function ImGuiOnceUponAFrame_destroy(self)
    ccall((:ImGuiOnceUponAFrame_destroy, libcimplot), Cvoid, (Ptr{ImGuiOnceUponAFrame},), self)
end

function ImGuiTextFilter_ImGuiTextFilter(default_filter)
    ccall((:ImGuiTextFilter_ImGuiTextFilter, libcimplot), Ptr{ImGuiTextFilter}, (Cstring,), default_filter)
end

function ImGuiTextFilter_destroy(self)
    ccall((:ImGuiTextFilter_destroy, libcimplot), Cvoid, (Ptr{ImGuiTextFilter},), self)
end

function ImGuiTextFilter_Draw()
    ccall((:ImGuiTextFilter_Draw, libcimplot), Cint, ())
end

function ImGuiTextFilter_PassFilter()
    ccall((:ImGuiTextFilter_PassFilter, libcimplot), Cint, ())
end

function ImGuiTextFilter_Build(self)
    ccall((:ImGuiTextFilter_Build, libcimplot), Cvoid, (Ptr{ImGuiTextFilter},), self)
end

function ImGuiTextFilter_Clear(self)
    ccall((:ImGuiTextFilter_Clear, libcimplot), Cvoid, (Ptr{ImGuiTextFilter},), self)
end

function ImGuiTextFilter_IsActive()
    ccall((:ImGuiTextFilter_IsActive, libcimplot), Cint, ())
end

function ImGuiTextRange_ImGuiTextRangeNil()
    ccall((:ImGuiTextRange_ImGuiTextRangeNil, libcimplot), Ptr{ImGuiTextRange}, ())
end

function ImGuiTextRange_destroy(self)
    ccall((:ImGuiTextRange_destroy, libcimplot), Cvoid, (Ptr{ImGuiTextRange},), self)
end

function ImGuiTextRange_ImGuiTextRangeStr(_b, _e)
    ccall((:ImGuiTextRange_ImGuiTextRangeStr, libcimplot), Ptr{ImGuiTextRange}, (Cstring, Cstring), _b, _e)
end

function ImGuiTextRange_empty()
    ccall((:ImGuiTextRange_empty, libcimplot), Cint, ())
end

function ImGuiTextRange_split(self, separator, out)
    ccall((:ImGuiTextRange_split, libcimplot), Cvoid, (Ptr{ImGuiTextRange}, Cchar, Ptr{ImVector_ImGuiTextRange}), self, separator, out)
end

function ImGuiTextBuffer_ImGuiTextBuffer()
    ccall((:ImGuiTextBuffer_ImGuiTextBuffer, libcimplot), Ptr{ImGuiTextBuffer}, ())
end

function ImGuiTextBuffer_destroy(self)
    ccall((:ImGuiTextBuffer_destroy, libcimplot), Cvoid, (Ptr{ImGuiTextBuffer},), self)
end

function ImGuiTextBuffer_begin(self)
    ccall((:ImGuiTextBuffer_begin, libcimplot), Cstring, (Ptr{ImGuiTextBuffer},), self)
end

function ImGuiTextBuffer_end(self)
    ccall((:ImGuiTextBuffer_end, libcimplot), Cstring, (Ptr{ImGuiTextBuffer},), self)
end

function ImGuiTextBuffer_size(self)
    ccall((:ImGuiTextBuffer_size, libcimplot), Cint, (Ptr{ImGuiTextBuffer},), self)
end

function ImGuiTextBuffer_empty()
    ccall((:ImGuiTextBuffer_empty, libcimplot), Cint, ())
end

function ImGuiTextBuffer_clear(self)
    ccall((:ImGuiTextBuffer_clear, libcimplot), Cvoid, (Ptr{ImGuiTextBuffer},), self)
end

function ImGuiTextBuffer_reserve(self, capacity)
    ccall((:ImGuiTextBuffer_reserve, libcimplot), Cvoid, (Ptr{ImGuiTextBuffer}, Cint), self, capacity)
end

function ImGuiTextBuffer_c_str(self)
    ccall((:ImGuiTextBuffer_c_str, libcimplot), Cstring, (Ptr{ImGuiTextBuffer},), self)
end

function ImGuiTextBuffer_append(self, str, str_end)
    ccall((:ImGuiTextBuffer_append, libcimplot), Cvoid, (Ptr{ImGuiTextBuffer}, Cstring, Cstring), self, str, str_end)
end

function ImGuiTextBuffer_appendfv(self, fmt, args)
    ccall((:ImGuiTextBuffer_appendfv, libcimplot), Cvoid, (Ptr{ImGuiTextBuffer}, Cstring, Cint), self, fmt, args)
end

function ImGuiStoragePair_ImGuiStoragePairInt(_key, _val_i)
    ccall((:ImGuiStoragePair_ImGuiStoragePairInt, libcimplot), Ptr{ImGuiStoragePair}, (ImGuiID, Cint), _key, _val_i)
end

function ImGuiStoragePair_destroy(self)
    ccall((:ImGuiStoragePair_destroy, libcimplot), Cvoid, (Ptr{ImGuiStoragePair},), self)
end

function ImGuiStoragePair_ImGuiStoragePairFloat(_key, _val_f)
    ccall((:ImGuiStoragePair_ImGuiStoragePairFloat, libcimplot), Ptr{ImGuiStoragePair}, (ImGuiID, Cfloat), _key, _val_f)
end

function ImGuiStoragePair_ImGuiStoragePairPtr(_key, _val_p)
    ccall((:ImGuiStoragePair_ImGuiStoragePairPtr, libcimplot), Ptr{ImGuiStoragePair}, (ImGuiID, Ptr{Cvoid}), _key, _val_p)
end

function ImGuiStorage_Clear(self)
    ccall((:ImGuiStorage_Clear, libcimplot), Cvoid, (Ptr{ImGuiStorage},), self)
end

function ImGuiStorage_GetInt(self, key, default_val)
    ccall((:ImGuiStorage_GetInt, libcimplot), Cint, (Ptr{ImGuiStorage}, ImGuiID, Cint), self, key, default_val)
end

function ImGuiStorage_SetInt(self, key, val)
    ccall((:ImGuiStorage_SetInt, libcimplot), Cvoid, (Ptr{ImGuiStorage}, ImGuiID, Cint), self, key, val)
end

function ImGuiStorage_GetBool()
    ccall((:ImGuiStorage_GetBool, libcimplot), Cint, ())
end

function ImGuiStorage_SetBool(self, key, val)
    ccall((:ImGuiStorage_SetBool, libcimplot), Cvoid, (Ptr{ImGuiStorage}, ImGuiID, Cint), self, key, val)
end

function ImGuiStorage_GetFloat(self, key, default_val)
    ccall((:ImGuiStorage_GetFloat, libcimplot), Cfloat, (Ptr{ImGuiStorage}, ImGuiID, Cfloat), self, key, default_val)
end

function ImGuiStorage_SetFloat(self, key, val)
    ccall((:ImGuiStorage_SetFloat, libcimplot), Cvoid, (Ptr{ImGuiStorage}, ImGuiID, Cfloat), self, key, val)
end

function ImGuiStorage_GetVoidPtr(self, key)
    ccall((:ImGuiStorage_GetVoidPtr, libcimplot), Ptr{Cvoid}, (Ptr{ImGuiStorage}, ImGuiID), self, key)
end

function ImGuiStorage_SetVoidPtr(self, key, val)
    ccall((:ImGuiStorage_SetVoidPtr, libcimplot), Cvoid, (Ptr{ImGuiStorage}, ImGuiID, Ptr{Cvoid}), self, key, val)
end

function ImGuiStorage_GetIntRef(self, key, default_val)
    ccall((:ImGuiStorage_GetIntRef, libcimplot), Ptr{Cint}, (Ptr{ImGuiStorage}, ImGuiID, Cint), self, key, default_val)
end

function ImGuiStorage_GetBoolRef()
    ccall((:ImGuiStorage_GetBoolRef, libcimplot), Ptr{Cint}, ())
end

function ImGuiStorage_GetFloatRef(self, key, default_val)
    ccall((:ImGuiStorage_GetFloatRef, libcimplot), Ptr{Cfloat}, (Ptr{ImGuiStorage}, ImGuiID, Cfloat), self, key, default_val)
end

function ImGuiStorage_GetVoidPtrRef(self, key, default_val)
    ccall((:ImGuiStorage_GetVoidPtrRef, libcimplot), Ptr{Ptr{Cvoid}}, (Ptr{ImGuiStorage}, ImGuiID, Ptr{Cvoid}), self, key, default_val)
end

function ImGuiStorage_SetAllInt(self, val)
    ccall((:ImGuiStorage_SetAllInt, libcimplot), Cvoid, (Ptr{ImGuiStorage}, Cint), self, val)
end

function ImGuiStorage_BuildSortByKey(self)
    ccall((:ImGuiStorage_BuildSortByKey, libcimplot), Cvoid, (Ptr{ImGuiStorage},), self)
end

function ImGuiListClipper_ImGuiListClipper()
    ccall((:ImGuiListClipper_ImGuiListClipper, libcimplot), Ptr{ImGuiListClipper}, ())
end

function ImGuiListClipper_destroy(self)
    ccall((:ImGuiListClipper_destroy, libcimplot), Cvoid, (Ptr{ImGuiListClipper},), self)
end

function ImGuiListClipper_Begin(self, items_count, items_height)
    ccall((:ImGuiListClipper_Begin, libcimplot), Cvoid, (Ptr{ImGuiListClipper}, Cint, Cfloat), self, items_count, items_height)
end

function ImGuiListClipper_End(self)
    ccall((:ImGuiListClipper_End, libcimplot), Cvoid, (Ptr{ImGuiListClipper},), self)
end

function ImGuiListClipper_Step()
    ccall((:ImGuiListClipper_Step, libcimplot), Cint, ())
end

function ImColor_ImColorNil()
    ccall((:ImColor_ImColorNil, libcimplot), Ptr{ImColor}, ())
end

function ImColor_destroy(self)
    ccall((:ImColor_destroy, libcimplot), Cvoid, (Ptr{ImColor},), self)
end

function ImColor_ImColorInt(r, g, b, a)
    ccall((:ImColor_ImColorInt, libcimplot), Ptr{ImColor}, (Cint, Cint, Cint, Cint), r, g, b, a)
end

function ImColor_ImColorU32(rgba)
    ccall((:ImColor_ImColorU32, libcimplot), Ptr{ImColor}, (ImU32,), rgba)
end

function ImColor_ImColorFloat(r, g, b, a)
    ccall((:ImColor_ImColorFloat, libcimplot), Ptr{ImColor}, (Cfloat, Cfloat, Cfloat, Cfloat), r, g, b, a)
end

function ImColor_ImColorVec4(col)
    ccall((:ImColor_ImColorVec4, libcimplot), Ptr{ImColor}, (ImVec4,), col)
end

function ImColor_SetHSV(self, h, s, v, a)
    ccall((:ImColor_SetHSV, libcimplot), Cvoid, (Ptr{ImColor}, Cfloat, Cfloat, Cfloat, Cfloat), self, h, s, v, a)
end

function ImColor_HSV(pOut, h, s, v, a)
    ccall((:ImColor_HSV, libcimplot), Cvoid, (Ptr{ImColor}, Cfloat, Cfloat, Cfloat, Cfloat), pOut, h, s, v, a)
end

function ImDrawCmd_ImDrawCmd()
    ccall((:ImDrawCmd_ImDrawCmd, libcimplot), Ptr{ImDrawCmd}, ())
end

function ImDrawCmd_destroy(self)
    ccall((:ImDrawCmd_destroy, libcimplot), Cvoid, (Ptr{ImDrawCmd},), self)
end

function ImDrawListSplitter_ImDrawListSplitter()
    ccall((:ImDrawListSplitter_ImDrawListSplitter, libcimplot), Ptr{ImDrawListSplitter}, ())
end

function ImDrawListSplitter_destroy(self)
    ccall((:ImDrawListSplitter_destroy, libcimplot), Cvoid, (Ptr{ImDrawListSplitter},), self)
end

function ImDrawListSplitter_Clear(self)
    ccall((:ImDrawListSplitter_Clear, libcimplot), Cvoid, (Ptr{ImDrawListSplitter},), self)
end

function ImDrawListSplitter_ClearFreeMemory(self)
    ccall((:ImDrawListSplitter_ClearFreeMemory, libcimplot), Cvoid, (Ptr{ImDrawListSplitter},), self)
end

function ImDrawListSplitter_Split(self, draw_list, count)
    ccall((:ImDrawListSplitter_Split, libcimplot), Cvoid, (Ptr{ImDrawListSplitter}, Ptr{ImDrawList}, Cint), self, draw_list, count)
end

function ImDrawListSplitter_Merge(self, draw_list)
    ccall((:ImDrawListSplitter_Merge, libcimplot), Cvoid, (Ptr{ImDrawListSplitter}, Ptr{ImDrawList}), self, draw_list)
end

function ImDrawListSplitter_SetCurrentChannel(self, draw_list, channel_idx)
    ccall((:ImDrawListSplitter_SetCurrentChannel, libcimplot), Cvoid, (Ptr{ImDrawListSplitter}, Ptr{ImDrawList}, Cint), self, draw_list, channel_idx)
end

function ImDrawList_ImDrawList(shared_data)
    ccall((:ImDrawList_ImDrawList, libcimplot), Ptr{ImDrawList}, (Ptr{ImDrawListSharedData},), shared_data)
end

function ImDrawList_destroy(self)
    ccall((:ImDrawList_destroy, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList_PushClipRect(self, clip_rect_min, clip_rect_max, intersect_with_current_clip_rect)
    ccall((:ImDrawList_PushClipRect, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, Cint), self, clip_rect_min, clip_rect_max, intersect_with_current_clip_rect)
end

function ImDrawList_PushClipRectFullScreen(self)
    ccall((:ImDrawList_PushClipRectFullScreen, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList_PopClipRect(self)
    ccall((:ImDrawList_PopClipRect, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList_PushTextureID(self, texture_id)
    ccall((:ImDrawList_PushTextureID, libcimplot), Cvoid, (Ptr{ImDrawList}, ImTextureID), self, texture_id)
end

function ImDrawList_PopTextureID(self)
    ccall((:ImDrawList_PopTextureID, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList_GetClipRectMin(pOut, self)
    ccall((:ImDrawList_GetClipRectMin, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImDrawList}), pOut, self)
end

function ImDrawList_GetClipRectMax(pOut, self)
    ccall((:ImDrawList_GetClipRectMax, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImDrawList}), pOut, self)
end

function ImDrawList_AddLine(self, p1, p2, col, thickness)
    ccall((:ImDrawList_AddLine, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImU32, Cfloat), self, p1, p2, col, thickness)
end

function ImDrawList_AddRect(self, p_min, p_max, col, rounding, flags, thickness)
    ccall((:ImDrawList_AddRect, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImU32, Cfloat, ImDrawFlags, Cfloat), self, p_min, p_max, col, rounding, flags, thickness)
end

function ImDrawList_AddRectFilled(self, p_min, p_max, col, rounding, flags)
    ccall((:ImDrawList_AddRectFilled, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImU32, Cfloat, ImDrawFlags), self, p_min, p_max, col, rounding, flags)
end

function ImDrawList_AddRectFilledMultiColor(self, p_min, p_max, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
    ccall((:ImDrawList_AddRectFilledMultiColor, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImU32, ImU32, ImU32, ImU32), self, p_min, p_max, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
end

function ImDrawList_AddQuad(self, p1, p2, p3, p4, col, thickness)
    ccall((:ImDrawList_AddQuad, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImVec2, ImVec2, ImU32, Cfloat), self, p1, p2, p3, p4, col, thickness)
end

function ImDrawList_AddQuadFilled(self, p1, p2, p3, p4, col)
    ccall((:ImDrawList_AddQuadFilled, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImVec2, ImVec2, ImU32), self, p1, p2, p3, p4, col)
end

function ImDrawList_AddTriangle(self, p1, p2, p3, col, thickness)
    ccall((:ImDrawList_AddTriangle, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImVec2, ImU32, Cfloat), self, p1, p2, p3, col, thickness)
end

function ImDrawList_AddTriangleFilled(self, p1, p2, p3, col)
    ccall((:ImDrawList_AddTriangleFilled, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImVec2, ImU32), self, p1, p2, p3, col)
end

function ImDrawList_AddCircle(self, center, radius, col, num_segments, thickness)
    ccall((:ImDrawList_AddCircle, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, Cfloat, ImU32, Cint, Cfloat), self, center, radius, col, num_segments, thickness)
end

function ImDrawList_AddCircleFilled(self, center, radius, col, num_segments)
    ccall((:ImDrawList_AddCircleFilled, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, Cfloat, ImU32, Cint), self, center, radius, col, num_segments)
end

function ImDrawList_AddNgon(self, center, radius, col, num_segments, thickness)
    ccall((:ImDrawList_AddNgon, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, Cfloat, ImU32, Cint, Cfloat), self, center, radius, col, num_segments, thickness)
end

function ImDrawList_AddNgonFilled(self, center, radius, col, num_segments)
    ccall((:ImDrawList_AddNgonFilled, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, Cfloat, ImU32, Cint), self, center, radius, col, num_segments)
end

function ImDrawList_AddTextVec2(self, pos, col, text_begin, text_end)
    ccall((:ImDrawList_AddTextVec2, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImU32, Cstring, Cstring), self, pos, col, text_begin, text_end)
end

function ImDrawList_AddTextFontPtr(self, font, font_size, pos, col, text_begin, text_end, wrap_width, cpu_fine_clip_rect)
    ccall((:ImDrawList_AddTextFontPtr, libcimplot), Cvoid, (Ptr{ImDrawList}, Ptr{ImFont}, Cfloat, ImVec2, ImU32, Cstring, Cstring, Cfloat, Ptr{ImVec4}), self, font, font_size, pos, col, text_begin, text_end, wrap_width, cpu_fine_clip_rect)
end

function ImDrawList_AddPolyline(self, points, num_points, col, flags, thickness)
    ccall((:ImDrawList_AddPolyline, libcimplot), Cvoid, (Ptr{ImDrawList}, Ptr{ImVec2}, Cint, ImU32, ImDrawFlags, Cfloat), self, points, num_points, col, flags, thickness)
end

function ImDrawList_AddConvexPolyFilled(self, points, num_points, col)
    ccall((:ImDrawList_AddConvexPolyFilled, libcimplot), Cvoid, (Ptr{ImDrawList}, Ptr{ImVec2}, Cint, ImU32), self, points, num_points, col)
end

function ImDrawList_AddBezierCubic(self, p1, p2, p3, p4, col, thickness, num_segments)
    ccall((:ImDrawList_AddBezierCubic, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImVec2, ImVec2, ImU32, Cfloat, Cint), self, p1, p2, p3, p4, col, thickness, num_segments)
end

function ImDrawList_AddBezierQuadratic(self, p1, p2, p3, col, thickness, num_segments)
    ccall((:ImDrawList_AddBezierQuadratic, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImVec2, ImU32, Cfloat, Cint), self, p1, p2, p3, col, thickness, num_segments)
end

function ImDrawList_AddImage(self, user_texture_id, p_min, p_max, uv_min, uv_max, col)
    ccall((:ImDrawList_AddImage, libcimplot), Cvoid, (Ptr{ImDrawList}, ImTextureID, ImVec2, ImVec2, ImVec2, ImVec2, ImU32), self, user_texture_id, p_min, p_max, uv_min, uv_max, col)
end

function ImDrawList_AddImageQuad(self, user_texture_id, p1, p2, p3, p4, uv1, uv2, uv3, uv4, col)
    ccall((:ImDrawList_AddImageQuad, libcimplot), Cvoid, (Ptr{ImDrawList}, ImTextureID, ImVec2, ImVec2, ImVec2, ImVec2, ImVec2, ImVec2, ImVec2, ImVec2, ImU32), self, user_texture_id, p1, p2, p3, p4, uv1, uv2, uv3, uv4, col)
end

function ImDrawList_AddImageRounded(self, user_texture_id, p_min, p_max, uv_min, uv_max, col, rounding, flags)
    ccall((:ImDrawList_AddImageRounded, libcimplot), Cvoid, (Ptr{ImDrawList}, ImTextureID, ImVec2, ImVec2, ImVec2, ImVec2, ImU32, Cfloat, ImDrawFlags), self, user_texture_id, p_min, p_max, uv_min, uv_max, col, rounding, flags)
end

function ImDrawList_PathClear(self)
    ccall((:ImDrawList_PathClear, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList_PathLineTo(self, pos)
    ccall((:ImDrawList_PathLineTo, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2), self, pos)
end

function ImDrawList_PathLineToMergeDuplicate(self, pos)
    ccall((:ImDrawList_PathLineToMergeDuplicate, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2), self, pos)
end

function ImDrawList_PathFillConvex(self, col)
    ccall((:ImDrawList_PathFillConvex, libcimplot), Cvoid, (Ptr{ImDrawList}, ImU32), self, col)
end

function ImDrawList_PathStroke(self, col, flags, thickness)
    ccall((:ImDrawList_PathStroke, libcimplot), Cvoid, (Ptr{ImDrawList}, ImU32, ImDrawFlags, Cfloat), self, col, flags, thickness)
end

function ImDrawList_PathArcTo(self, center, radius, a_min, a_max, num_segments)
    ccall((:ImDrawList_PathArcTo, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, Cfloat, Cfloat, Cfloat, Cint), self, center, radius, a_min, a_max, num_segments)
end

function ImDrawList_PathArcToFast(self, center, radius, a_min_of_12, a_max_of_12)
    ccall((:ImDrawList_PathArcToFast, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, Cfloat, Cint, Cint), self, center, radius, a_min_of_12, a_max_of_12)
end

function ImDrawList_PathBezierCubicCurveTo(self, p2, p3, p4, num_segments)
    ccall((:ImDrawList_PathBezierCubicCurveTo, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImVec2, Cint), self, p2, p3, p4, num_segments)
end

function ImDrawList_PathBezierQuadraticCurveTo(self, p2, p3, num_segments)
    ccall((:ImDrawList_PathBezierQuadraticCurveTo, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, Cint), self, p2, p3, num_segments)
end

function ImDrawList_PathRect(self, rect_min, rect_max, rounding, flags)
    ccall((:ImDrawList_PathRect, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, Cfloat, ImDrawFlags), self, rect_min, rect_max, rounding, flags)
end

function ImDrawList_AddCallback(self, callback, callback_data)
    ccall((:ImDrawList_AddCallback, libcimplot), Cvoid, (Ptr{ImDrawList}, ImDrawCallback, Ptr{Cvoid}), self, callback, callback_data)
end

function ImDrawList_AddDrawCmd(self)
    ccall((:ImDrawList_AddDrawCmd, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList_CloneOutput(self)
    ccall((:ImDrawList_CloneOutput, libcimplot), Ptr{ImDrawList}, (Ptr{ImDrawList},), self)
end

function ImDrawList_ChannelsSplit(self, count)
    ccall((:ImDrawList_ChannelsSplit, libcimplot), Cvoid, (Ptr{ImDrawList}, Cint), self, count)
end

function ImDrawList_ChannelsMerge(self)
    ccall((:ImDrawList_ChannelsMerge, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList_ChannelsSetCurrent(self, n)
    ccall((:ImDrawList_ChannelsSetCurrent, libcimplot), Cvoid, (Ptr{ImDrawList}, Cint), self, n)
end

function ImDrawList_PrimReserve(self, idx_count, vtx_count)
    ccall((:ImDrawList_PrimReserve, libcimplot), Cvoid, (Ptr{ImDrawList}, Cint, Cint), self, idx_count, vtx_count)
end

function ImDrawList_PrimUnreserve(self, idx_count, vtx_count)
    ccall((:ImDrawList_PrimUnreserve, libcimplot), Cvoid, (Ptr{ImDrawList}, Cint, Cint), self, idx_count, vtx_count)
end

function ImDrawList_PrimRect(self, a, b, col)
    ccall((:ImDrawList_PrimRect, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImU32), self, a, b, col)
end

function ImDrawList_PrimRectUV(self, a, b, uv_a, uv_b, col)
    ccall((:ImDrawList_PrimRectUV, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImVec2, ImVec2, ImU32), self, a, b, uv_a, uv_b, col)
end

function ImDrawList_PrimQuadUV(self, a, b, c, d, uv_a, uv_b, uv_c, uv_d, col)
    ccall((:ImDrawList_PrimQuadUV, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImVec2, ImVec2, ImVec2, ImVec2, ImVec2, ImVec2, ImU32), self, a, b, c, d, uv_a, uv_b, uv_c, uv_d, col)
end

function ImDrawList_PrimWriteVtx(self, pos, uv, col)
    ccall((:ImDrawList_PrimWriteVtx, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImU32), self, pos, uv, col)
end

function ImDrawList_PrimWriteIdx(self, idx)
    ccall((:ImDrawList_PrimWriteIdx, libcimplot), Cvoid, (Ptr{ImDrawList}, ImDrawIdx), self, idx)
end

function ImDrawList_PrimVtx(self, pos, uv, col)
    ccall((:ImDrawList_PrimVtx, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImU32), self, pos, uv, col)
end

function ImDrawList__ResetForNewFrame(self)
    ccall((:ImDrawList__ResetForNewFrame, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList__ClearFreeMemory(self)
    ccall((:ImDrawList__ClearFreeMemory, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList__PopUnusedDrawCmd(self)
    ccall((:ImDrawList__PopUnusedDrawCmd, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList__OnChangedClipRect(self)
    ccall((:ImDrawList__OnChangedClipRect, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList__OnChangedTextureID(self)
    ccall((:ImDrawList__OnChangedTextureID, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList__OnChangedVtxOffset(self)
    ccall((:ImDrawList__OnChangedVtxOffset, libcimplot), Cvoid, (Ptr{ImDrawList},), self)
end

function ImDrawList__CalcCircleAutoSegmentCount(self, radius)
    ccall((:ImDrawList__CalcCircleAutoSegmentCount, libcimplot), Cint, (Ptr{ImDrawList}, Cfloat), self, radius)
end

function ImDrawList__PathArcToFastEx(self, center, radius, a_min_sample, a_max_sample, a_step)
    ccall((:ImDrawList__PathArcToFastEx, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, Cfloat, Cint, Cint, Cint), self, center, radius, a_min_sample, a_max_sample, a_step)
end

function ImDrawList__PathArcToN(self, center, radius, a_min, a_max, num_segments)
    ccall((:ImDrawList__PathArcToN, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, Cfloat, Cfloat, Cfloat, Cint), self, center, radius, a_min, a_max, num_segments)
end

function ImDrawData_ImDrawData()
    ccall((:ImDrawData_ImDrawData, libcimplot), Ptr{ImDrawData}, ())
end

function ImDrawData_destroy(self)
    ccall((:ImDrawData_destroy, libcimplot), Cvoid, (Ptr{ImDrawData},), self)
end

function ImDrawData_Clear(self)
    ccall((:ImDrawData_Clear, libcimplot), Cvoid, (Ptr{ImDrawData},), self)
end

function ImDrawData_DeIndexAllBuffers(self)
    ccall((:ImDrawData_DeIndexAllBuffers, libcimplot), Cvoid, (Ptr{ImDrawData},), self)
end

function ImDrawData_ScaleClipRects(self, fb_scale)
    ccall((:ImDrawData_ScaleClipRects, libcimplot), Cvoid, (Ptr{ImDrawData}, ImVec2), self, fb_scale)
end

function ImFontConfig_ImFontConfig()
    ccall((:ImFontConfig_ImFontConfig, libcimplot), Ptr{ImFontConfig}, ())
end

function ImFontConfig_destroy(self)
    ccall((:ImFontConfig_destroy, libcimplot), Cvoid, (Ptr{ImFontConfig},), self)
end

function ImFontGlyphRangesBuilder_ImFontGlyphRangesBuilder()
    ccall((:ImFontGlyphRangesBuilder_ImFontGlyphRangesBuilder, libcimplot), Ptr{ImFontGlyphRangesBuilder}, ())
end

function ImFontGlyphRangesBuilder_destroy(self)
    ccall((:ImFontGlyphRangesBuilder_destroy, libcimplot), Cvoid, (Ptr{ImFontGlyphRangesBuilder},), self)
end

function ImFontGlyphRangesBuilder_Clear(self)
    ccall((:ImFontGlyphRangesBuilder_Clear, libcimplot), Cvoid, (Ptr{ImFontGlyphRangesBuilder},), self)
end

function ImFontGlyphRangesBuilder_GetBit()
    ccall((:ImFontGlyphRangesBuilder_GetBit, libcimplot), Cint, ())
end

function ImFontGlyphRangesBuilder_SetBit(self, n)
    ccall((:ImFontGlyphRangesBuilder_SetBit, libcimplot), Cvoid, (Ptr{ImFontGlyphRangesBuilder}, Cint), self, n)
end

function ImFontGlyphRangesBuilder_AddChar(self, c)
    ccall((:ImFontGlyphRangesBuilder_AddChar, libcimplot), Cvoid, (Ptr{ImFontGlyphRangesBuilder}, ImWchar), self, c)
end

function ImFontGlyphRangesBuilder_AddText(self, text, text_end)
    ccall((:ImFontGlyphRangesBuilder_AddText, libcimplot), Cvoid, (Ptr{ImFontGlyphRangesBuilder}, Cstring, Cstring), self, text, text_end)
end

function ImFontGlyphRangesBuilder_AddRanges(self, ranges)
    ccall((:ImFontGlyphRangesBuilder_AddRanges, libcimplot), Cvoid, (Ptr{ImFontGlyphRangesBuilder}, Ptr{ImWchar}), self, ranges)
end

function ImFontGlyphRangesBuilder_BuildRanges(self, out_ranges)
    ccall((:ImFontGlyphRangesBuilder_BuildRanges, libcimplot), Cvoid, (Ptr{ImFontGlyphRangesBuilder}, Ptr{ImVector_ImWchar}), self, out_ranges)
end

function ImFontAtlasCustomRect_ImFontAtlasCustomRect()
    ccall((:ImFontAtlasCustomRect_ImFontAtlasCustomRect, libcimplot), Ptr{ImFontAtlasCustomRect}, ())
end

function ImFontAtlasCustomRect_destroy(self)
    ccall((:ImFontAtlasCustomRect_destroy, libcimplot), Cvoid, (Ptr{ImFontAtlasCustomRect},), self)
end

function ImFontAtlasCustomRect_IsPacked()
    ccall((:ImFontAtlasCustomRect_IsPacked, libcimplot), Cint, ())
end

function ImFontAtlas_ImFontAtlas()
    ccall((:ImFontAtlas_ImFontAtlas, libcimplot), Ptr{ImFontAtlas}, ())
end

function ImFontAtlas_destroy(self)
    ccall((:ImFontAtlas_destroy, libcimplot), Cvoid, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_AddFont(self, font_cfg)
    ccall((:ImFontAtlas_AddFont, libcimplot), Ptr{ImFont}, (Ptr{ImFontAtlas}, Ptr{ImFontConfig}), self, font_cfg)
end

function ImFontAtlas_AddFontDefault(self, font_cfg)
    ccall((:ImFontAtlas_AddFontDefault, libcimplot), Ptr{ImFont}, (Ptr{ImFontAtlas}, Ptr{ImFontConfig}), self, font_cfg)
end

function ImFontAtlas_AddFontFromFileTTF(self, filename, size_pixels, font_cfg, glyph_ranges)
    ccall((:ImFontAtlas_AddFontFromFileTTF, libcimplot), Ptr{ImFont}, (Ptr{ImFontAtlas}, Cstring, Cfloat, Ptr{ImFontConfig}, Ptr{ImWchar}), self, filename, size_pixels, font_cfg, glyph_ranges)
end

function ImFontAtlas_AddFontFromMemoryTTF(self, font_data, font_size, size_pixels, font_cfg, glyph_ranges)
    ccall((:ImFontAtlas_AddFontFromMemoryTTF, libcimplot), Ptr{ImFont}, (Ptr{ImFontAtlas}, Ptr{Cvoid}, Cint, Cfloat, Ptr{ImFontConfig}, Ptr{ImWchar}), self, font_data, font_size, size_pixels, font_cfg, glyph_ranges)
end

function ImFontAtlas_AddFontFromMemoryCompressedTTF(self, compressed_font_data, compressed_font_size, size_pixels, font_cfg, glyph_ranges)
    ccall((:ImFontAtlas_AddFontFromMemoryCompressedTTF, libcimplot), Ptr{ImFont}, (Ptr{ImFontAtlas}, Ptr{Cvoid}, Cint, Cfloat, Ptr{ImFontConfig}, Ptr{ImWchar}), self, compressed_font_data, compressed_font_size, size_pixels, font_cfg, glyph_ranges)
end

function ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(self, compressed_font_data_base85, size_pixels, font_cfg, glyph_ranges)
    ccall((:ImFontAtlas_AddFontFromMemoryCompressedBase85TTF, libcimplot), Ptr{ImFont}, (Ptr{ImFontAtlas}, Cstring, Cfloat, Ptr{ImFontConfig}, Ptr{ImWchar}), self, compressed_font_data_base85, size_pixels, font_cfg, glyph_ranges)
end

function ImFontAtlas_ClearInputData(self)
    ccall((:ImFontAtlas_ClearInputData, libcimplot), Cvoid, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_ClearTexData(self)
    ccall((:ImFontAtlas_ClearTexData, libcimplot), Cvoid, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_ClearFonts(self)
    ccall((:ImFontAtlas_ClearFonts, libcimplot), Cvoid, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_Clear(self)
    ccall((:ImFontAtlas_Clear, libcimplot), Cvoid, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_Build()
    ccall((:ImFontAtlas_Build, libcimplot), Cint, ())
end

function ImFontAtlas_GetTexDataAsAlpha8(self, out_pixels, out_width, out_height, out_bytes_per_pixel)
    ccall((:ImFontAtlas_GetTexDataAsAlpha8, libcimplot), Cvoid, (Ptr{ImFontAtlas}, Ptr{Ptr{Cuchar}}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), self, out_pixels, out_width, out_height, out_bytes_per_pixel)
end

function ImFontAtlas_GetTexDataAsRGBA32(self, out_pixels, out_width, out_height, out_bytes_per_pixel)
    ccall((:ImFontAtlas_GetTexDataAsRGBA32, libcimplot), Cvoid, (Ptr{ImFontAtlas}, Ptr{Ptr{Cuchar}}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), self, out_pixels, out_width, out_height, out_bytes_per_pixel)
end

function ImFontAtlas_IsBuilt()
    ccall((:ImFontAtlas_IsBuilt, libcimplot), Cint, ())
end

function ImFontAtlas_SetTexID(self, id)
    ccall((:ImFontAtlas_SetTexID, libcimplot), Cvoid, (Ptr{ImFontAtlas}, ImTextureID), self, id)
end

function ImFontAtlas_GetGlyphRangesDefault(self)
    ccall((:ImFontAtlas_GetGlyphRangesDefault, libcimplot), Ptr{ImWchar}, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_GetGlyphRangesKorean(self)
    ccall((:ImFontAtlas_GetGlyphRangesKorean, libcimplot), Ptr{ImWchar}, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_GetGlyphRangesJapanese(self)
    ccall((:ImFontAtlas_GetGlyphRangesJapanese, libcimplot), Ptr{ImWchar}, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_GetGlyphRangesChineseFull(self)
    ccall((:ImFontAtlas_GetGlyphRangesChineseFull, libcimplot), Ptr{ImWchar}, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon(self)
    ccall((:ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon, libcimplot), Ptr{ImWchar}, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_GetGlyphRangesCyrillic(self)
    ccall((:ImFontAtlas_GetGlyphRangesCyrillic, libcimplot), Ptr{ImWchar}, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_GetGlyphRangesThai(self)
    ccall((:ImFontAtlas_GetGlyphRangesThai, libcimplot), Ptr{ImWchar}, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_GetGlyphRangesVietnamese(self)
    ccall((:ImFontAtlas_GetGlyphRangesVietnamese, libcimplot), Ptr{ImWchar}, (Ptr{ImFontAtlas},), self)
end

function ImFontAtlas_AddCustomRectRegular(self, width, height)
    ccall((:ImFontAtlas_AddCustomRectRegular, libcimplot), Cint, (Ptr{ImFontAtlas}, Cint, Cint), self, width, height)
end

function ImFontAtlas_AddCustomRectFontGlyph(self, font, id, width, height, advance_x, offset)
    ccall((:ImFontAtlas_AddCustomRectFontGlyph, libcimplot), Cint, (Ptr{ImFontAtlas}, Ptr{ImFont}, ImWchar, Cint, Cint, Cfloat, ImVec2), self, font, id, width, height, advance_x, offset)
end

function ImFontAtlas_GetCustomRectByIndex(self, index)
    ccall((:ImFontAtlas_GetCustomRectByIndex, libcimplot), Ptr{ImFontAtlasCustomRect}, (Ptr{ImFontAtlas}, Cint), self, index)
end

function ImFontAtlas_CalcCustomRectUV(self, rect, out_uv_min, out_uv_max)
    ccall((:ImFontAtlas_CalcCustomRectUV, libcimplot), Cvoid, (Ptr{ImFontAtlas}, Ptr{ImFontAtlasCustomRect}, Ptr{ImVec2}, Ptr{ImVec2}), self, rect, out_uv_min, out_uv_max)
end

function ImFontAtlas_GetMouseCursorTexData()
    ccall((:ImFontAtlas_GetMouseCursorTexData, libcimplot), Cint, ())
end

function ImFont_ImFont()
    ccall((:ImFont_ImFont, libcimplot), Ptr{ImFont}, ())
end

function ImFont_destroy(self)
    ccall((:ImFont_destroy, libcimplot), Cvoid, (Ptr{ImFont},), self)
end

function ImFont_FindGlyph(self, c)
    ccall((:ImFont_FindGlyph, libcimplot), Ptr{ImFontGlyph}, (Ptr{ImFont}, ImWchar), self, c)
end

function ImFont_FindGlyphNoFallback(self, c)
    ccall((:ImFont_FindGlyphNoFallback, libcimplot), Ptr{ImFontGlyph}, (Ptr{ImFont}, ImWchar), self, c)
end

function ImFont_GetCharAdvance(self, c)
    ccall((:ImFont_GetCharAdvance, libcimplot), Cfloat, (Ptr{ImFont}, ImWchar), self, c)
end

function ImFont_IsLoaded()
    ccall((:ImFont_IsLoaded, libcimplot), Cint, ())
end

function ImFont_GetDebugName(self)
    ccall((:ImFont_GetDebugName, libcimplot), Cstring, (Ptr{ImFont},), self)
end

function ImFont_CalcTextSizeA(pOut, self, size, max_width, wrap_width, text_begin, text_end, remaining)
    ccall((:ImFont_CalcTextSizeA, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImFont}, Cfloat, Cfloat, Cfloat, Cstring, Cstring, Ptr{Cstring}), pOut, self, size, max_width, wrap_width, text_begin, text_end, remaining)
end

function ImFont_CalcWordWrapPositionA(self, scale, text, text_end, wrap_width)
    ccall((:ImFont_CalcWordWrapPositionA, libcimplot), Cstring, (Ptr{ImFont}, Cfloat, Cstring, Cstring, Cfloat), self, scale, text, text_end, wrap_width)
end

function ImFont_RenderChar(self, draw_list, size, pos, col, c)
    ccall((:ImFont_RenderChar, libcimplot), Cvoid, (Ptr{ImFont}, Ptr{ImDrawList}, Cfloat, ImVec2, ImU32, ImWchar), self, draw_list, size, pos, col, c)
end

function ImFont_RenderText(self, draw_list, size, pos, col, clip_rect, text_begin, text_end, wrap_width, cpu_fine_clip)
    ccall((:ImFont_RenderText, libcimplot), Cvoid, (Ptr{ImFont}, Ptr{ImDrawList}, Cfloat, ImVec2, ImU32, ImVec4, Cstring, Cstring, Cfloat, Cint), self, draw_list, size, pos, col, clip_rect, text_begin, text_end, wrap_width, cpu_fine_clip)
end

function ImFont_BuildLookupTable(self)
    ccall((:ImFont_BuildLookupTable, libcimplot), Cvoid, (Ptr{ImFont},), self)
end

function ImFont_ClearOutputData(self)
    ccall((:ImFont_ClearOutputData, libcimplot), Cvoid, (Ptr{ImFont},), self)
end

function ImFont_GrowIndex(self, new_size)
    ccall((:ImFont_GrowIndex, libcimplot), Cvoid, (Ptr{ImFont}, Cint), self, new_size)
end

function ImFont_AddGlyph(self, src_cfg, c, x0, y0, x1, y1, u0, v0, u1, v1, advance_x)
    ccall((:ImFont_AddGlyph, libcimplot), Cvoid, (Ptr{ImFont}, Ptr{ImFontConfig}, ImWchar, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat), self, src_cfg, c, x0, y0, x1, y1, u0, v0, u1, v1, advance_x)
end

function ImFont_AddRemapChar(self, dst, src, overwrite_dst)
    ccall((:ImFont_AddRemapChar, libcimplot), Cvoid, (Ptr{ImFont}, ImWchar, ImWchar, Cint), self, dst, src, overwrite_dst)
end

function ImFont_SetGlyphVisible(self, c, visible)
    ccall((:ImFont_SetGlyphVisible, libcimplot), Cvoid, (Ptr{ImFont}, ImWchar, Cint), self, c, visible)
end

function ImFont_SetFallbackChar(self, c)
    ccall((:ImFont_SetFallbackChar, libcimplot), Cvoid, (Ptr{ImFont}, ImWchar), self, c)
end

function ImFont_IsGlyphRangeUnused()
    ccall((:ImFont_IsGlyphRangeUnused, libcimplot), Cint, ())
end

function ImGuiViewport_ImGuiViewport()
    ccall((:ImGuiViewport_ImGuiViewport, libcimplot), Ptr{ImGuiViewport}, ())
end

function ImGuiViewport_destroy(self)
    ccall((:ImGuiViewport_destroy, libcimplot), Cvoid, (Ptr{ImGuiViewport},), self)
end

function ImGuiViewport_GetCenter(pOut, self)
    ccall((:ImGuiViewport_GetCenter, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImGuiViewport}), pOut, self)
end

function ImGuiViewport_GetWorkCenter(pOut, self)
    ccall((:ImGuiViewport_GetWorkCenter, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImGuiViewport}), pOut, self)
end

function igImHashData(data, data_size, seed)
    ccall((:igImHashData, libcimplot), ImGuiID, (Ptr{Cvoid}, Cint, ImU32), data, data_size, seed)
end

function igImHashStr(data, data_size, seed)
    ccall((:igImHashStr, libcimplot), ImGuiID, (Cstring, Cint, ImU32), data, data_size, seed)
end

function igImAlphaBlendColors(col_a, col_b)
    ccall((:igImAlphaBlendColors, libcimplot), ImU32, (ImU32, ImU32), col_a, col_b)
end

function igImIsPowerOfTwoInt()
    ccall((:igImIsPowerOfTwoInt, libcimplot), Cint, ())
end

function igImIsPowerOfTwoU64()
    ccall((:igImIsPowerOfTwoU64, libcimplot), Cint, ())
end

function igImUpperPowerOfTwo(v)
    ccall((:igImUpperPowerOfTwo, libcimplot), Cint, (Cint,), v)
end

function igImStricmp(str1, str2)
    ccall((:igImStricmp, libcimplot), Cint, (Cstring, Cstring), str1, str2)
end

function igImStrnicmp(str1, str2, count)
    ccall((:igImStrnicmp, libcimplot), Cint, (Cstring, Cstring, Cint), str1, str2, count)
end

function igImStrncpy(dst, src, count)
    ccall((:igImStrncpy, libcimplot), Cvoid, (Cstring, Cstring, Cint), dst, src, count)
end

function igImStrdup(str)
    ccall((:igImStrdup, libcimplot), Cstring, (Cstring,), str)
end

function igImStrdupcpy(dst, p_dst_size, str)
    ccall((:igImStrdupcpy, libcimplot), Cstring, (Cstring, Ptr{Cint}, Cstring), dst, p_dst_size, str)
end

function igImStrchrRange(str_begin, str_end, c)
    ccall((:igImStrchrRange, libcimplot), Cstring, (Cstring, Cstring, Cchar), str_begin, str_end, c)
end

function igImStrlenW(str)
    ccall((:igImStrlenW, libcimplot), Cint, (Ptr{ImWchar},), str)
end

function igImStreolRange(str, str_end)
    ccall((:igImStreolRange, libcimplot), Cstring, (Cstring, Cstring), str, str_end)
end

function igImStrbolW(buf_mid_line, buf_begin)
    ccall((:igImStrbolW, libcimplot), Ptr{ImWchar}, (Ptr{ImWchar}, Ptr{ImWchar}), buf_mid_line, buf_begin)
end

function igImStristr(haystack, haystack_end, needle, needle_end)
    ccall((:igImStristr, libcimplot), Cstring, (Cstring, Cstring, Cstring, Cstring), haystack, haystack_end, needle, needle_end)
end

function igImStrTrimBlanks(str)
    ccall((:igImStrTrimBlanks, libcimplot), Cvoid, (Cstring,), str)
end

function igImStrSkipBlank(str)
    ccall((:igImStrSkipBlank, libcimplot), Cstring, (Cstring,), str)
end

function igImFormatStringV(buf, buf_size, fmt, args)
    ccall((:igImFormatStringV, libcimplot), Cint, (Cstring, Cint, Cstring, Cint), buf, buf_size, fmt, args)
end

function igImParseFormatFindStart(format)
    ccall((:igImParseFormatFindStart, libcimplot), Cstring, (Cstring,), format)
end

function igImParseFormatFindEnd(format)
    ccall((:igImParseFormatFindEnd, libcimplot), Cstring, (Cstring,), format)
end

function igImParseFormatTrimDecorations(format, buf, buf_size)
    ccall((:igImParseFormatTrimDecorations, libcimplot), Cstring, (Cstring, Cstring, Cint), format, buf, buf_size)
end

function igImParseFormatPrecision(format, default_value)
    ccall((:igImParseFormatPrecision, libcimplot), Cint, (Cstring, Cint), format, default_value)
end

function igImCharIsBlankA()
    ccall((:igImCharIsBlankA, libcimplot), Cint, ())
end

function igImCharIsBlankW()
    ccall((:igImCharIsBlankW, libcimplot), Cint, ())
end

function igImTextStrToUtf8(buf, buf_size, in_text, in_text_end)
    ccall((:igImTextStrToUtf8, libcimplot), Cint, (Cstring, Cint, Ptr{ImWchar}, Ptr{ImWchar}), buf, buf_size, in_text, in_text_end)
end

function igImTextCharFromUtf8(out_char, in_text, in_text_end)
    ccall((:igImTextCharFromUtf8, libcimplot), Cint, (Ptr{Cuint}, Cstring, Cstring), out_char, in_text, in_text_end)
end

function igImTextStrFromUtf8(buf, buf_size, in_text, in_text_end, in_remaining)
    ccall((:igImTextStrFromUtf8, libcimplot), Cint, (Ptr{ImWchar}, Cint, Cstring, Cstring, Ptr{Cstring}), buf, buf_size, in_text, in_text_end, in_remaining)
end

function igImTextCountCharsFromUtf8(in_text, in_text_end)
    ccall((:igImTextCountCharsFromUtf8, libcimplot), Cint, (Cstring, Cstring), in_text, in_text_end)
end

function igImTextCountUtf8BytesFromChar(in_text, in_text_end)
    ccall((:igImTextCountUtf8BytesFromChar, libcimplot), Cint, (Cstring, Cstring), in_text, in_text_end)
end

function igImTextCountUtf8BytesFromStr(in_text, in_text_end)
    ccall((:igImTextCountUtf8BytesFromStr, libcimplot), Cint, (Ptr{ImWchar}, Ptr{ImWchar}), in_text, in_text_end)
end

function igImFileOpen(filename, mode)
    ccall((:igImFileOpen, libcimplot), ImFileHandle, (Cstring, Cstring), filename, mode)
end

function igImFileClose()
    ccall((:igImFileClose, libcimplot), Cint, ())
end

function igImFileGetSize(file)
    ccall((:igImFileGetSize, libcimplot), ImU64, (ImFileHandle,), file)
end

function igImFileRead(data, size, count, file)
    ccall((:igImFileRead, libcimplot), ImU64, (Ptr{Cvoid}, ImU64, ImU64, ImFileHandle), data, size, count, file)
end

function igImFileWrite(data, size, count, file)
    ccall((:igImFileWrite, libcimplot), ImU64, (Ptr{Cvoid}, ImU64, ImU64, ImFileHandle), data, size, count, file)
end

function igImFileLoadToMemory(filename, mode, out_file_size, padding_bytes)
    ccall((:igImFileLoadToMemory, libcimplot), Ptr{Cvoid}, (Cstring, Cstring, Ptr{Cint}, Cint), filename, mode, out_file_size, padding_bytes)
end

function igImPowFloat(x, y)
    ccall((:igImPowFloat, libcimplot), Cfloat, (Cfloat, Cfloat), x, y)
end

function igImPowdouble(x, y)
    ccall((:igImPowdouble, libcimplot), Cdouble, (Cdouble, Cdouble), x, y)
end

function igImLogFloat(x)
    ccall((:igImLogFloat, libcimplot), Cfloat, (Cfloat,), x)
end

function igImLogdouble(x)
    ccall((:igImLogdouble, libcimplot), Cdouble, (Cdouble,), x)
end

function igImAbsFloat(x)
    ccall((:igImAbsFloat, libcimplot), Cfloat, (Cfloat,), x)
end

function igImAbsdouble(x)
    ccall((:igImAbsdouble, libcimplot), Cdouble, (Cdouble,), x)
end

function igImSignFloat(x)
    ccall((:igImSignFloat, libcimplot), Cfloat, (Cfloat,), x)
end

function igImSigndouble(x)
    ccall((:igImSigndouble, libcimplot), Cdouble, (Cdouble,), x)
end

function igImMin(pOut, lhs, rhs)
    ccall((:igImMin, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2), pOut, lhs, rhs)
end

function igImMax(pOut, lhs, rhs)
    ccall((:igImMax, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2), pOut, lhs, rhs)
end

function igImClamp(pOut, v, mn, mx)
    ccall((:igImClamp, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2, ImVec2), pOut, v, mn, mx)
end

function igImLerpVec2Float(pOut, a, b, t)
    ccall((:igImLerpVec2Float, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2, Cfloat), pOut, a, b, t)
end

function igImLerpVec2Vec2(pOut, a, b, t)
    ccall((:igImLerpVec2Vec2, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2, ImVec2), pOut, a, b, t)
end

function igImLerpVec4(pOut, a, b, t)
    ccall((:igImLerpVec4, libcimplot), Cvoid, (Ptr{ImVec4}, ImVec4, ImVec4, Cfloat), pOut, a, b, t)
end

function igImSaturate(f)
    ccall((:igImSaturate, libcimplot), Cfloat, (Cfloat,), f)
end

function igImLengthSqrVec2(lhs)
    ccall((:igImLengthSqrVec2, libcimplot), Cfloat, (ImVec2,), lhs)
end

function igImLengthSqrVec4(lhs)
    ccall((:igImLengthSqrVec4, libcimplot), Cfloat, (ImVec4,), lhs)
end

function igImInvLength(lhs, fail_value)
    ccall((:igImInvLength, libcimplot), Cfloat, (ImVec2, Cfloat), lhs, fail_value)
end

function igImFloorFloat(f)
    ccall((:igImFloorFloat, libcimplot), Cfloat, (Cfloat,), f)
end

function igImFloorVec2(pOut, v)
    ccall((:igImFloorVec2, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2), pOut, v)
end

function igImModPositive(a, b)
    ccall((:igImModPositive, libcimplot), Cint, (Cint, Cint), a, b)
end

function igImDot(a, b)
    ccall((:igImDot, libcimplot), Cfloat, (ImVec2, ImVec2), a, b)
end

function igImRotate(pOut, v, cos_a, sin_a)
    ccall((:igImRotate, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, Cfloat, Cfloat), pOut, v, cos_a, sin_a)
end

function igImLinearSweep(current, target, speed)
    ccall((:igImLinearSweep, libcimplot), Cfloat, (Cfloat, Cfloat, Cfloat), current, target, speed)
end

function igImMul(pOut, lhs, rhs)
    ccall((:igImMul, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2), pOut, lhs, rhs)
end

function igImBezierCubicCalc(pOut, p1, p2, p3, p4, t)
    ccall((:igImBezierCubicCalc, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2, ImVec2, ImVec2, Cfloat), pOut, p1, p2, p3, p4, t)
end

function igImBezierCubicClosestPoint(pOut, p1, p2, p3, p4, p, num_segments)
    ccall((:igImBezierCubicClosestPoint, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2, ImVec2, ImVec2, ImVec2, Cint), pOut, p1, p2, p3, p4, p, num_segments)
end

function igImBezierCubicClosestPointCasteljau(pOut, p1, p2, p3, p4, p, tess_tol)
    ccall((:igImBezierCubicClosestPointCasteljau, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2, ImVec2, ImVec2, ImVec2, Cfloat), pOut, p1, p2, p3, p4, p, tess_tol)
end

function igImBezierQuadraticCalc(pOut, p1, p2, p3, t)
    ccall((:igImBezierQuadraticCalc, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2, ImVec2, Cfloat), pOut, p1, p2, p3, t)
end

function igImLineClosestPoint(pOut, a, b, p)
    ccall((:igImLineClosestPoint, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2, ImVec2), pOut, a, b, p)
end

function igImTriangleContainsPoint()
    ccall((:igImTriangleContainsPoint, libcimplot), Cint, ())
end

function igImTriangleClosestPoint(pOut, a, b, c, p)
    ccall((:igImTriangleClosestPoint, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2, ImVec2, ImVec2), pOut, a, b, c, p)
end

function igImTriangleBarycentricCoords(a, b, c, p, out_u, out_v, out_w)
    ccall((:igImTriangleBarycentricCoords, libcimplot), Cvoid, (ImVec2, ImVec2, ImVec2, ImVec2, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Cfloat}), a, b, c, p, out_u, out_v, out_w)
end

function igImTriangleArea(a, b, c)
    ccall((:igImTriangleArea, libcimplot), Cfloat, (ImVec2, ImVec2, ImVec2), a, b, c)
end

function igImGetDirQuadrantFromDelta(dx, dy)
    ccall((:igImGetDirQuadrantFromDelta, libcimplot), ImGuiDir, (Cfloat, Cfloat), dx, dy)
end

function ImVec1_ImVec1Nil()
    ccall((:ImVec1_ImVec1Nil, libcimplot), Ptr{ImVec1}, ())
end

function ImVec1_destroy(self)
    ccall((:ImVec1_destroy, libcimplot), Cvoid, (Ptr{ImVec1},), self)
end

function ImVec1_ImVec1Float(_x)
    ccall((:ImVec1_ImVec1Float, libcimplot), Ptr{ImVec1}, (Cfloat,), _x)
end

function ImVec2ih_ImVec2ihNil()
    ccall((:ImVec2ih_ImVec2ihNil, libcimplot), Ptr{ImVec2ih}, ())
end

function ImVec2ih_destroy(self)
    ccall((:ImVec2ih_destroy, libcimplot), Cvoid, (Ptr{ImVec2ih},), self)
end

function ImVec2ih_ImVec2ihshort(_x, _y)
    ccall((:ImVec2ih_ImVec2ihshort, libcimplot), Ptr{ImVec2ih}, (Cshort, Cshort), _x, _y)
end

function ImVec2ih_ImVec2ihVec2(rhs)
    ccall((:ImVec2ih_ImVec2ihVec2, libcimplot), Ptr{ImVec2ih}, (ImVec2,), rhs)
end

function ImRect_ImRectNil()
    ccall((:ImRect_ImRectNil, libcimplot), Ptr{ImRect}, ())
end

function ImRect_destroy(self)
    ccall((:ImRect_destroy, libcimplot), Cvoid, (Ptr{ImRect},), self)
end

function ImRect_ImRectVec2(min, max)
    ccall((:ImRect_ImRectVec2, libcimplot), Ptr{ImRect}, (ImVec2, ImVec2), min, max)
end

function ImRect_ImRectVec4(v)
    ccall((:ImRect_ImRectVec4, libcimplot), Ptr{ImRect}, (ImVec4,), v)
end

function ImRect_ImRectFloat(x1, y1, x2, y2)
    ccall((:ImRect_ImRectFloat, libcimplot), Ptr{ImRect}, (Cfloat, Cfloat, Cfloat, Cfloat), x1, y1, x2, y2)
end

function ImRect_GetCenter(pOut, self)
    ccall((:ImRect_GetCenter, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImRect}), pOut, self)
end

function ImRect_GetSize(pOut, self)
    ccall((:ImRect_GetSize, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImRect}), pOut, self)
end

function ImRect_GetWidth(self)
    ccall((:ImRect_GetWidth, libcimplot), Cfloat, (Ptr{ImRect},), self)
end

function ImRect_GetHeight(self)
    ccall((:ImRect_GetHeight, libcimplot), Cfloat, (Ptr{ImRect},), self)
end

function ImRect_GetArea(self)
    ccall((:ImRect_GetArea, libcimplot), Cfloat, (Ptr{ImRect},), self)
end

function ImRect_GetTL(pOut, self)
    ccall((:ImRect_GetTL, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImRect}), pOut, self)
end

function ImRect_GetTR(pOut, self)
    ccall((:ImRect_GetTR, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImRect}), pOut, self)
end

function ImRect_GetBL(pOut, self)
    ccall((:ImRect_GetBL, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImRect}), pOut, self)
end

function ImRect_GetBR(pOut, self)
    ccall((:ImRect_GetBR, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImRect}), pOut, self)
end

function ImRect_ContainsVec2()
    ccall((:ImRect_ContainsVec2, libcimplot), Cint, ())
end

function ImRect_ContainsRect()
    ccall((:ImRect_ContainsRect, libcimplot), Cint, ())
end

function ImRect_Overlaps()
    ccall((:ImRect_Overlaps, libcimplot), Cint, ())
end

function ImRect_AddVec2(self, p)
    ccall((:ImRect_AddVec2, libcimplot), Cvoid, (Ptr{ImRect}, ImVec2), self, p)
end

function ImRect_AddRect(self, r)
    ccall((:ImRect_AddRect, libcimplot), Cvoid, (Ptr{ImRect}, ImRect), self, r)
end

function ImRect_ExpandFloat(self, amount)
    ccall((:ImRect_ExpandFloat, libcimplot), Cvoid, (Ptr{ImRect}, Cfloat), self, amount)
end

function ImRect_ExpandVec2(self, amount)
    ccall((:ImRect_ExpandVec2, libcimplot), Cvoid, (Ptr{ImRect}, ImVec2), self, amount)
end

function ImRect_Translate(self, d)
    ccall((:ImRect_Translate, libcimplot), Cvoid, (Ptr{ImRect}, ImVec2), self, d)
end

function ImRect_TranslateX(self, dx)
    ccall((:ImRect_TranslateX, libcimplot), Cvoid, (Ptr{ImRect}, Cfloat), self, dx)
end

function ImRect_TranslateY(self, dy)
    ccall((:ImRect_TranslateY, libcimplot), Cvoid, (Ptr{ImRect}, Cfloat), self, dy)
end

function ImRect_ClipWith(self, r)
    ccall((:ImRect_ClipWith, libcimplot), Cvoid, (Ptr{ImRect}, ImRect), self, r)
end

function ImRect_ClipWithFull(self, r)
    ccall((:ImRect_ClipWithFull, libcimplot), Cvoid, (Ptr{ImRect}, ImRect), self, r)
end

function ImRect_Floor(self)
    ccall((:ImRect_Floor, libcimplot), Cvoid, (Ptr{ImRect},), self)
end

function ImRect_IsInverted()
    ccall((:ImRect_IsInverted, libcimplot), Cint, ())
end

function ImRect_ToVec4(pOut, self)
    ccall((:ImRect_ToVec4, libcimplot), Cvoid, (Ptr{ImVec4}, Ptr{ImRect}), pOut, self)
end

function igImBitArrayTestBit()
    ccall((:igImBitArrayTestBit, libcimplot), Cint, ())
end

function igImBitArrayClearBit(arr, n)
    ccall((:igImBitArrayClearBit, libcimplot), Cvoid, (Ptr{ImU32}, Cint), arr, n)
end

function igImBitArraySetBit(arr, n)
    ccall((:igImBitArraySetBit, libcimplot), Cvoid, (Ptr{ImU32}, Cint), arr, n)
end

function igImBitArraySetBitRange(arr, n, n2)
    ccall((:igImBitArraySetBitRange, libcimplot), Cvoid, (Ptr{ImU32}, Cint, Cint), arr, n, n2)
end

function ImBitVector_Create(self, sz)
    ccall((:ImBitVector_Create, libcimplot), Cvoid, (Ptr{ImBitVector}, Cint), self, sz)
end

function ImBitVector_Clear(self)
    ccall((:ImBitVector_Clear, libcimplot), Cvoid, (Ptr{ImBitVector},), self)
end

function ImBitVector_TestBit()
    ccall((:ImBitVector_TestBit, libcimplot), Cint, ())
end

function ImBitVector_SetBit(self, n)
    ccall((:ImBitVector_SetBit, libcimplot), Cvoid, (Ptr{ImBitVector}, Cint), self, n)
end

function ImBitVector_ClearBit(self, n)
    ccall((:ImBitVector_ClearBit, libcimplot), Cvoid, (Ptr{ImBitVector}, Cint), self, n)
end

function ImDrawListSharedData_ImDrawListSharedData()
    ccall((:ImDrawListSharedData_ImDrawListSharedData, libcimplot), Ptr{ImDrawListSharedData}, ())
end

function ImDrawListSharedData_destroy(self)
    ccall((:ImDrawListSharedData_destroy, libcimplot), Cvoid, (Ptr{ImDrawListSharedData},), self)
end

function ImDrawListSharedData_SetCircleTessellationMaxError(self, max_error)
    ccall((:ImDrawListSharedData_SetCircleTessellationMaxError, libcimplot), Cvoid, (Ptr{ImDrawListSharedData}, Cfloat), self, max_error)
end

function ImDrawDataBuilder_Clear(self)
    ccall((:ImDrawDataBuilder_Clear, libcimplot), Cvoid, (Ptr{ImDrawDataBuilder},), self)
end

function ImDrawDataBuilder_ClearFreeMemory(self)
    ccall((:ImDrawDataBuilder_ClearFreeMemory, libcimplot), Cvoid, (Ptr{ImDrawDataBuilder},), self)
end

function ImDrawDataBuilder_GetDrawListCount(self)
    ccall((:ImDrawDataBuilder_GetDrawListCount, libcimplot), Cint, (Ptr{ImDrawDataBuilder},), self)
end

function ImDrawDataBuilder_FlattenIntoSingleLayer(self)
    ccall((:ImDrawDataBuilder_FlattenIntoSingleLayer, libcimplot), Cvoid, (Ptr{ImDrawDataBuilder},), self)
end

function ImGuiStyleMod_ImGuiStyleModInt(idx, v)
    ccall((:ImGuiStyleMod_ImGuiStyleModInt, libcimplot), Ptr{ImGuiStyleMod}, (ImGuiStyleVar, Cint), idx, v)
end

function ImGuiStyleMod_destroy(self)
    ccall((:ImGuiStyleMod_destroy, libcimplot), Cvoid, (Ptr{ImGuiStyleMod},), self)
end

function ImGuiStyleMod_ImGuiStyleModFloat(idx, v)
    ccall((:ImGuiStyleMod_ImGuiStyleModFloat, libcimplot), Ptr{ImGuiStyleMod}, (ImGuiStyleVar, Cfloat), idx, v)
end

function ImGuiStyleMod_ImGuiStyleModVec2(idx, v)
    ccall((:ImGuiStyleMod_ImGuiStyleModVec2, libcimplot), Ptr{ImGuiStyleMod}, (ImGuiStyleVar, ImVec2), idx, v)
end

function ImGuiMenuColumns_ImGuiMenuColumns()
    ccall((:ImGuiMenuColumns_ImGuiMenuColumns, libcimplot), Ptr{ImGuiMenuColumns}, ())
end

function ImGuiMenuColumns_destroy(self)
    ccall((:ImGuiMenuColumns_destroy, libcimplot), Cvoid, (Ptr{ImGuiMenuColumns},), self)
end

function ImGuiMenuColumns_Update(self, count, spacing, clear)
    ccall((:ImGuiMenuColumns_Update, libcimplot), Cvoid, (Ptr{ImGuiMenuColumns}, Cint, Cfloat, Cint), self, count, spacing, clear)
end

function ImGuiMenuColumns_DeclColumns(self, w0, w1, w2)
    ccall((:ImGuiMenuColumns_DeclColumns, libcimplot), Cfloat, (Ptr{ImGuiMenuColumns}, Cfloat, Cfloat, Cfloat), self, w0, w1, w2)
end

function ImGuiMenuColumns_CalcExtraSpace(self, avail_w)
    ccall((:ImGuiMenuColumns_CalcExtraSpace, libcimplot), Cfloat, (Ptr{ImGuiMenuColumns}, Cfloat), self, avail_w)
end

function ImGuiInputTextState_ImGuiInputTextState()
    ccall((:ImGuiInputTextState_ImGuiInputTextState, libcimplot), Ptr{ImGuiInputTextState}, ())
end

function ImGuiInputTextState_destroy(self)
    ccall((:ImGuiInputTextState_destroy, libcimplot), Cvoid, (Ptr{ImGuiInputTextState},), self)
end

function ImGuiInputTextState_ClearText(self)
    ccall((:ImGuiInputTextState_ClearText, libcimplot), Cvoid, (Ptr{ImGuiInputTextState},), self)
end

function ImGuiInputTextState_ClearFreeMemory(self)
    ccall((:ImGuiInputTextState_ClearFreeMemory, libcimplot), Cvoid, (Ptr{ImGuiInputTextState},), self)
end

function ImGuiInputTextState_GetUndoAvailCount(self)
    ccall((:ImGuiInputTextState_GetUndoAvailCount, libcimplot), Cint, (Ptr{ImGuiInputTextState},), self)
end

function ImGuiInputTextState_GetRedoAvailCount(self)
    ccall((:ImGuiInputTextState_GetRedoAvailCount, libcimplot), Cint, (Ptr{ImGuiInputTextState},), self)
end

function ImGuiInputTextState_OnKeyPressed(self, key)
    ccall((:ImGuiInputTextState_OnKeyPressed, libcimplot), Cvoid, (Ptr{ImGuiInputTextState}, Cint), self, key)
end

function ImGuiInputTextState_CursorAnimReset(self)
    ccall((:ImGuiInputTextState_CursorAnimReset, libcimplot), Cvoid, (Ptr{ImGuiInputTextState},), self)
end

function ImGuiInputTextState_CursorClamp(self)
    ccall((:ImGuiInputTextState_CursorClamp, libcimplot), Cvoid, (Ptr{ImGuiInputTextState},), self)
end

function ImGuiInputTextState_HasSelection()
    ccall((:ImGuiInputTextState_HasSelection, libcimplot), Cint, ())
end

function ImGuiInputTextState_ClearSelection(self)
    ccall((:ImGuiInputTextState_ClearSelection, libcimplot), Cvoid, (Ptr{ImGuiInputTextState},), self)
end

function ImGuiInputTextState_SelectAll(self)
    ccall((:ImGuiInputTextState_SelectAll, libcimplot), Cvoid, (Ptr{ImGuiInputTextState},), self)
end

function ImGuiPopupData_ImGuiPopupData()
    ccall((:ImGuiPopupData_ImGuiPopupData, libcimplot), Ptr{ImGuiPopupData}, ())
end

function ImGuiPopupData_destroy(self)
    ccall((:ImGuiPopupData_destroy, libcimplot), Cvoid, (Ptr{ImGuiPopupData},), self)
end

function ImGuiNavMoveResult_ImGuiNavMoveResult()
    ccall((:ImGuiNavMoveResult_ImGuiNavMoveResult, libcimplot), Ptr{ImGuiNavMoveResult}, ())
end

function ImGuiNavMoveResult_destroy(self)
    ccall((:ImGuiNavMoveResult_destroy, libcimplot), Cvoid, (Ptr{ImGuiNavMoveResult},), self)
end

function ImGuiNavMoveResult_Clear(self)
    ccall((:ImGuiNavMoveResult_Clear, libcimplot), Cvoid, (Ptr{ImGuiNavMoveResult},), self)
end

function ImGuiNextWindowData_ImGuiNextWindowData()
    ccall((:ImGuiNextWindowData_ImGuiNextWindowData, libcimplot), Ptr{ImGuiNextWindowData}, ())
end

function ImGuiNextWindowData_destroy(self)
    ccall((:ImGuiNextWindowData_destroy, libcimplot), Cvoid, (Ptr{ImGuiNextWindowData},), self)
end

function ImGuiNextWindowData_ClearFlags(self)
    ccall((:ImGuiNextWindowData_ClearFlags, libcimplot), Cvoid, (Ptr{ImGuiNextWindowData},), self)
end

function ImGuiNextItemData_ImGuiNextItemData()
    ccall((:ImGuiNextItemData_ImGuiNextItemData, libcimplot), Ptr{ImGuiNextItemData}, ())
end

function ImGuiNextItemData_destroy(self)
    ccall((:ImGuiNextItemData_destroy, libcimplot), Cvoid, (Ptr{ImGuiNextItemData},), self)
end

function ImGuiNextItemData_ClearFlags(self)
    ccall((:ImGuiNextItemData_ClearFlags, libcimplot), Cvoid, (Ptr{ImGuiNextItemData},), self)
end

function ImGuiPtrOrIndex_ImGuiPtrOrIndexPtr(ptr)
    ccall((:ImGuiPtrOrIndex_ImGuiPtrOrIndexPtr, libcimplot), Ptr{ImGuiPtrOrIndex}, (Ptr{Cvoid},), ptr)
end

function ImGuiPtrOrIndex_destroy(self)
    ccall((:ImGuiPtrOrIndex_destroy, libcimplot), Cvoid, (Ptr{ImGuiPtrOrIndex},), self)
end

function ImGuiPtrOrIndex_ImGuiPtrOrIndexInt(index)
    ccall((:ImGuiPtrOrIndex_ImGuiPtrOrIndexInt, libcimplot), Ptr{ImGuiPtrOrIndex}, (Cint,), index)
end

function ImGuiOldColumnData_ImGuiOldColumnData()
    ccall((:ImGuiOldColumnData_ImGuiOldColumnData, libcimplot), Ptr{ImGuiOldColumnData}, ())
end

function ImGuiOldColumnData_destroy(self)
    ccall((:ImGuiOldColumnData_destroy, libcimplot), Cvoid, (Ptr{ImGuiOldColumnData},), self)
end

function ImGuiOldColumns_ImGuiOldColumns()
    ccall((:ImGuiOldColumns_ImGuiOldColumns, libcimplot), Ptr{ImGuiOldColumns}, ())
end

function ImGuiOldColumns_destroy(self)
    ccall((:ImGuiOldColumns_destroy, libcimplot), Cvoid, (Ptr{ImGuiOldColumns},), self)
end

function ImGuiViewportP_ImGuiViewportP()
    ccall((:ImGuiViewportP_ImGuiViewportP, libcimplot), Ptr{ImGuiViewportP}, ())
end

function ImGuiViewportP_destroy(self)
    ccall((:ImGuiViewportP_destroy, libcimplot), Cvoid, (Ptr{ImGuiViewportP},), self)
end

function ImGuiViewportP_GetMainRect(pOut, self)
    ccall((:ImGuiViewportP_GetMainRect, libcimplot), Cvoid, (Ptr{ImRect}, Ptr{ImGuiViewportP}), pOut, self)
end

function ImGuiViewportP_GetWorkRect(pOut, self)
    ccall((:ImGuiViewportP_GetWorkRect, libcimplot), Cvoid, (Ptr{ImRect}, Ptr{ImGuiViewportP}), pOut, self)
end

function ImGuiViewportP_UpdateWorkRect(self)
    ccall((:ImGuiViewportP_UpdateWorkRect, libcimplot), Cvoid, (Ptr{ImGuiViewportP},), self)
end

function ImGuiWindowSettings_ImGuiWindowSettings()
    ccall((:ImGuiWindowSettings_ImGuiWindowSettings, libcimplot), Ptr{ImGuiWindowSettings}, ())
end

function ImGuiWindowSettings_destroy(self)
    ccall((:ImGuiWindowSettings_destroy, libcimplot), Cvoid, (Ptr{ImGuiWindowSettings},), self)
end

function ImGuiWindowSettings_GetName(self)
    ccall((:ImGuiWindowSettings_GetName, libcimplot), Cstring, (Ptr{ImGuiWindowSettings},), self)
end

function ImGuiSettingsHandler_ImGuiSettingsHandler()
    ccall((:ImGuiSettingsHandler_ImGuiSettingsHandler, libcimplot), Ptr{ImGuiSettingsHandler}, ())
end

function ImGuiSettingsHandler_destroy(self)
    ccall((:ImGuiSettingsHandler_destroy, libcimplot), Cvoid, (Ptr{ImGuiSettingsHandler},), self)
end

function ImGuiMetricsConfig_ImGuiMetricsConfig()
    ccall((:ImGuiMetricsConfig_ImGuiMetricsConfig, libcimplot), Ptr{ImGuiMetricsConfig}, ())
end

function ImGuiMetricsConfig_destroy(self)
    ccall((:ImGuiMetricsConfig_destroy, libcimplot), Cvoid, (Ptr{ImGuiMetricsConfig},), self)
end

function ImGuiStackSizes_ImGuiStackSizes()
    ccall((:ImGuiStackSizes_ImGuiStackSizes, libcimplot), Ptr{ImGuiStackSizes}, ())
end

function ImGuiStackSizes_destroy(self)
    ccall((:ImGuiStackSizes_destroy, libcimplot), Cvoid, (Ptr{ImGuiStackSizes},), self)
end

function ImGuiStackSizes_SetToCurrentState(self)
    ccall((:ImGuiStackSizes_SetToCurrentState, libcimplot), Cvoid, (Ptr{ImGuiStackSizes},), self)
end

function ImGuiStackSizes_CompareWithCurrentState(self)
    ccall((:ImGuiStackSizes_CompareWithCurrentState, libcimplot), Cvoid, (Ptr{ImGuiStackSizes},), self)
end

function ImGuiContextHook_ImGuiContextHook()
    ccall((:ImGuiContextHook_ImGuiContextHook, libcimplot), Ptr{ImGuiContextHook}, ())
end

function ImGuiContextHook_destroy(self)
    ccall((:ImGuiContextHook_destroy, libcimplot), Cvoid, (Ptr{ImGuiContextHook},), self)
end

function ImGuiContext_ImGuiContext(shared_font_atlas)
    ccall((:ImGuiContext_ImGuiContext, libcimplot), Ptr{ImGuiContext}, (Ptr{ImFontAtlas},), shared_font_atlas)
end

function ImGuiContext_destroy(self)
    ccall((:ImGuiContext_destroy, libcimplot), Cvoid, (Ptr{ImGuiContext},), self)
end

function ImGuiWindow_ImGuiWindow(context, name)
    ccall((:ImGuiWindow_ImGuiWindow, libcimplot), Ptr{ImGuiWindow}, (Ptr{ImGuiContext}, Cstring), context, name)
end

function ImGuiWindow_destroy(self)
    ccall((:ImGuiWindow_destroy, libcimplot), Cvoid, (Ptr{ImGuiWindow},), self)
end

function ImGuiWindow_GetIDStr(self, str, str_end)
    ccall((:ImGuiWindow_GetIDStr, libcimplot), ImGuiID, (Ptr{ImGuiWindow}, Cstring, Cstring), self, str, str_end)
end

function ImGuiWindow_GetIDPtr(self, ptr)
    ccall((:ImGuiWindow_GetIDPtr, libcimplot), ImGuiID, (Ptr{ImGuiWindow}, Ptr{Cvoid}), self, ptr)
end

function ImGuiWindow_GetIDInt(self, n)
    ccall((:ImGuiWindow_GetIDInt, libcimplot), ImGuiID, (Ptr{ImGuiWindow}, Cint), self, n)
end

function ImGuiWindow_GetIDNoKeepAliveStr(self, str, str_end)
    ccall((:ImGuiWindow_GetIDNoKeepAliveStr, libcimplot), ImGuiID, (Ptr{ImGuiWindow}, Cstring, Cstring), self, str, str_end)
end

function ImGuiWindow_GetIDNoKeepAlivePtr(self, ptr)
    ccall((:ImGuiWindow_GetIDNoKeepAlivePtr, libcimplot), ImGuiID, (Ptr{ImGuiWindow}, Ptr{Cvoid}), self, ptr)
end

function ImGuiWindow_GetIDNoKeepAliveInt(self, n)
    ccall((:ImGuiWindow_GetIDNoKeepAliveInt, libcimplot), ImGuiID, (Ptr{ImGuiWindow}, Cint), self, n)
end

function ImGuiWindow_GetIDFromRectangle(self, r_abs)
    ccall((:ImGuiWindow_GetIDFromRectangle, libcimplot), ImGuiID, (Ptr{ImGuiWindow}, ImRect), self, r_abs)
end

function ImGuiWindow_Rect(pOut, self)
    ccall((:ImGuiWindow_Rect, libcimplot), Cvoid, (Ptr{ImRect}, Ptr{ImGuiWindow}), pOut, self)
end

function ImGuiWindow_CalcFontSize(self)
    ccall((:ImGuiWindow_CalcFontSize, libcimplot), Cfloat, (Ptr{ImGuiWindow},), self)
end

function ImGuiWindow_TitleBarHeight(self)
    ccall((:ImGuiWindow_TitleBarHeight, libcimplot), Cfloat, (Ptr{ImGuiWindow},), self)
end

function ImGuiWindow_TitleBarRect(pOut, self)
    ccall((:ImGuiWindow_TitleBarRect, libcimplot), Cvoid, (Ptr{ImRect}, Ptr{ImGuiWindow}), pOut, self)
end

function ImGuiWindow_MenuBarHeight(self)
    ccall((:ImGuiWindow_MenuBarHeight, libcimplot), Cfloat, (Ptr{ImGuiWindow},), self)
end

function ImGuiWindow_MenuBarRect(pOut, self)
    ccall((:ImGuiWindow_MenuBarRect, libcimplot), Cvoid, (Ptr{ImRect}, Ptr{ImGuiWindow}), pOut, self)
end

function ImGuiLastItemDataBackup_ImGuiLastItemDataBackup()
    ccall((:ImGuiLastItemDataBackup_ImGuiLastItemDataBackup, libcimplot), Ptr{ImGuiLastItemDataBackup}, ())
end

function ImGuiLastItemDataBackup_destroy(self)
    ccall((:ImGuiLastItemDataBackup_destroy, libcimplot), Cvoid, (Ptr{ImGuiLastItemDataBackup},), self)
end

function ImGuiLastItemDataBackup_Backup(self)
    ccall((:ImGuiLastItemDataBackup_Backup, libcimplot), Cvoid, (Ptr{ImGuiLastItemDataBackup},), self)
end

function ImGuiLastItemDataBackup_Restore(self)
    ccall((:ImGuiLastItemDataBackup_Restore, libcimplot), Cvoid, (Ptr{ImGuiLastItemDataBackup},), self)
end

function ImGuiTabItem_ImGuiTabItem()
    ccall((:ImGuiTabItem_ImGuiTabItem, libcimplot), Ptr{ImGuiTabItem}, ())
end

function ImGuiTabItem_destroy(self)
    ccall((:ImGuiTabItem_destroy, libcimplot), Cvoid, (Ptr{ImGuiTabItem},), self)
end

function ImGuiTabBar_ImGuiTabBar()
    ccall((:ImGuiTabBar_ImGuiTabBar, libcimplot), Ptr{ImGuiTabBar}, ())
end

function ImGuiTabBar_destroy(self)
    ccall((:ImGuiTabBar_destroy, libcimplot), Cvoid, (Ptr{ImGuiTabBar},), self)
end

function ImGuiTabBar_GetTabOrder(self, tab)
    ccall((:ImGuiTabBar_GetTabOrder, libcimplot), Cint, (Ptr{ImGuiTabBar}, Ptr{ImGuiTabItem}), self, tab)
end

function ImGuiTabBar_GetTabName(self, tab)
    ccall((:ImGuiTabBar_GetTabName, libcimplot), Cstring, (Ptr{ImGuiTabBar}, Ptr{ImGuiTabItem}), self, tab)
end

function ImGuiTableColumn_ImGuiTableColumn()
    ccall((:ImGuiTableColumn_ImGuiTableColumn, libcimplot), Ptr{ImGuiTableColumn}, ())
end

function ImGuiTableColumn_destroy(self)
    ccall((:ImGuiTableColumn_destroy, libcimplot), Cvoid, (Ptr{ImGuiTableColumn},), self)
end

function ImGuiTable_ImGuiTable()
    ccall((:ImGuiTable_ImGuiTable, libcimplot), Ptr{ImGuiTable}, ())
end

function ImGuiTable_destroy(self)
    ccall((:ImGuiTable_destroy, libcimplot), Cvoid, (Ptr{ImGuiTable},), self)
end

function ImGuiTableColumnSettings_ImGuiTableColumnSettings()
    ccall((:ImGuiTableColumnSettings_ImGuiTableColumnSettings, libcimplot), Ptr{ImGuiTableColumnSettings}, ())
end

function ImGuiTableColumnSettings_destroy(self)
    ccall((:ImGuiTableColumnSettings_destroy, libcimplot), Cvoid, (Ptr{ImGuiTableColumnSettings},), self)
end

function ImGuiTableSettings_ImGuiTableSettings()
    ccall((:ImGuiTableSettings_ImGuiTableSettings, libcimplot), Ptr{ImGuiTableSettings}, ())
end

function ImGuiTableSettings_destroy(self)
    ccall((:ImGuiTableSettings_destroy, libcimplot), Cvoid, (Ptr{ImGuiTableSettings},), self)
end

function ImGuiTableSettings_GetColumnSettings(self)
    ccall((:ImGuiTableSettings_GetColumnSettings, libcimplot), Ptr{ImGuiTableColumnSettings}, (Ptr{ImGuiTableSettings},), self)
end

function igGetCurrentWindowRead()
    ccall((:igGetCurrentWindowRead, libcimplot), Ptr{ImGuiWindow}, ())
end

function igGetCurrentWindow()
    ccall((:igGetCurrentWindow, libcimplot), Ptr{ImGuiWindow}, ())
end

function igFindWindowByID(id)
    ccall((:igFindWindowByID, libcimplot), Ptr{ImGuiWindow}, (ImGuiID,), id)
end

function igFindWindowByName(name)
    ccall((:igFindWindowByName, libcimplot), Ptr{ImGuiWindow}, (Cstring,), name)
end

function igUpdateWindowParentAndRootLinks(window, flags, parent_window)
    ccall((:igUpdateWindowParentAndRootLinks, libcimplot), Cvoid, (Ptr{ImGuiWindow}, ImGuiWindowFlags, Ptr{ImGuiWindow}), window, flags, parent_window)
end

function igCalcWindowNextAutoFitSize(pOut, window)
    ccall((:igCalcWindowNextAutoFitSize, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImGuiWindow}), pOut, window)
end

function igIsWindowChildOf()
    ccall((:igIsWindowChildOf, libcimplot), Cint, ())
end

function igIsWindowAbove()
    ccall((:igIsWindowAbove, libcimplot), Cint, ())
end

function igIsWindowNavFocusable()
    ccall((:igIsWindowNavFocusable, libcimplot), Cint, ())
end

function igGetWindowAllowedExtentRect(pOut, window)
    ccall((:igGetWindowAllowedExtentRect, libcimplot), Cvoid, (Ptr{ImRect}, Ptr{ImGuiWindow}), pOut, window)
end

function igSetWindowPosWindowPtr(window, pos, cond)
    ccall((:igSetWindowPosWindowPtr, libcimplot), Cvoid, (Ptr{ImGuiWindow}, ImVec2, ImGuiCond), window, pos, cond)
end

function igSetWindowSizeWindowPtr(window, size, cond)
    ccall((:igSetWindowSizeWindowPtr, libcimplot), Cvoid, (Ptr{ImGuiWindow}, ImVec2, ImGuiCond), window, size, cond)
end

function igSetWindowCollapsedWindowPtr(window, collapsed, cond)
    ccall((:igSetWindowCollapsedWindowPtr, libcimplot), Cvoid, (Ptr{ImGuiWindow}, Cint, ImGuiCond), window, collapsed, cond)
end

function igSetWindowHitTestHole(window, pos, size)
    ccall((:igSetWindowHitTestHole, libcimplot), Cvoid, (Ptr{ImGuiWindow}, ImVec2, ImVec2), window, pos, size)
end

function igFocusWindow(window)
    ccall((:igFocusWindow, libcimplot), Cvoid, (Ptr{ImGuiWindow},), window)
end

function igFocusTopMostWindowUnderOne(under_this_window, ignore_window)
    ccall((:igFocusTopMostWindowUnderOne, libcimplot), Cvoid, (Ptr{ImGuiWindow}, Ptr{ImGuiWindow}), under_this_window, ignore_window)
end

function igBringWindowToFocusFront(window)
    ccall((:igBringWindowToFocusFront, libcimplot), Cvoid, (Ptr{ImGuiWindow},), window)
end

function igBringWindowToDisplayFront(window)
    ccall((:igBringWindowToDisplayFront, libcimplot), Cvoid, (Ptr{ImGuiWindow},), window)
end

function igBringWindowToDisplayBack(window)
    ccall((:igBringWindowToDisplayBack, libcimplot), Cvoid, (Ptr{ImGuiWindow},), window)
end

function igSetCurrentFont(font)
    ccall((:igSetCurrentFont, libcimplot), Cvoid, (Ptr{ImFont},), font)
end

function igGetDefaultFont()
    ccall((:igGetDefaultFont, libcimplot), Ptr{ImFont}, ())
end

function igGetForegroundDrawListWindowPtr(window)
    ccall((:igGetForegroundDrawListWindowPtr, libcimplot), Ptr{ImDrawList}, (Ptr{ImGuiWindow},), window)
end

function igGetBackgroundDrawListViewportPtr(viewport)
    ccall((:igGetBackgroundDrawListViewportPtr, libcimplot), Ptr{ImDrawList}, (Ptr{ImGuiViewport},), viewport)
end

function igGetForegroundDrawListViewportPtr(viewport)
    ccall((:igGetForegroundDrawListViewportPtr, libcimplot), Ptr{ImDrawList}, (Ptr{ImGuiViewport},), viewport)
end

function igInitialize(context)
    ccall((:igInitialize, libcimplot), Cvoid, (Ptr{ImGuiContext},), context)
end

function igShutdown(context)
    ccall((:igShutdown, libcimplot), Cvoid, (Ptr{ImGuiContext},), context)
end

function igUpdateHoveredWindowAndCaptureFlags()
    ccall((:igUpdateHoveredWindowAndCaptureFlags, libcimplot), Cvoid, ())
end

function igStartMouseMovingWindow(window)
    ccall((:igStartMouseMovingWindow, libcimplot), Cvoid, (Ptr{ImGuiWindow},), window)
end

function igUpdateMouseMovingWindowNewFrame()
    ccall((:igUpdateMouseMovingWindowNewFrame, libcimplot), Cvoid, ())
end

function igUpdateMouseMovingWindowEndFrame()
    ccall((:igUpdateMouseMovingWindowEndFrame, libcimplot), Cvoid, ())
end

function igAddContextHook(context, hook)
    ccall((:igAddContextHook, libcimplot), ImGuiID, (Ptr{ImGuiContext}, Ptr{ImGuiContextHook}), context, hook)
end

function igRemoveContextHook(context, hook_to_remove)
    ccall((:igRemoveContextHook, libcimplot), Cvoid, (Ptr{ImGuiContext}, ImGuiID), context, hook_to_remove)
end

function igCallContextHooks(context, type)
    ccall((:igCallContextHooks, libcimplot), Cvoid, (Ptr{ImGuiContext}, ImGuiContextHookType), context, type)
end

function igMarkIniSettingsDirtyNil()
    ccall((:igMarkIniSettingsDirtyNil, libcimplot), Cvoid, ())
end

function igMarkIniSettingsDirtyWindowPtr(window)
    ccall((:igMarkIniSettingsDirtyWindowPtr, libcimplot), Cvoid, (Ptr{ImGuiWindow},), window)
end

function igClearIniSettings()
    ccall((:igClearIniSettings, libcimplot), Cvoid, ())
end

function igCreateNewWindowSettings(name)
    ccall((:igCreateNewWindowSettings, libcimplot), Ptr{ImGuiWindowSettings}, (Cstring,), name)
end

function igFindWindowSettings(id)
    ccall((:igFindWindowSettings, libcimplot), Ptr{ImGuiWindowSettings}, (ImGuiID,), id)
end

function igFindOrCreateWindowSettings(name)
    ccall((:igFindOrCreateWindowSettings, libcimplot), Ptr{ImGuiWindowSettings}, (Cstring,), name)
end

function igFindSettingsHandler(type_name)
    ccall((:igFindSettingsHandler, libcimplot), Ptr{ImGuiSettingsHandler}, (Cstring,), type_name)
end

function igSetNextWindowScroll(scroll)
    ccall((:igSetNextWindowScroll, libcimplot), Cvoid, (ImVec2,), scroll)
end

function igSetScrollXWindowPtr(window, scroll_x)
    ccall((:igSetScrollXWindowPtr, libcimplot), Cvoid, (Ptr{ImGuiWindow}, Cfloat), window, scroll_x)
end

function igSetScrollYWindowPtr(window, scroll_y)
    ccall((:igSetScrollYWindowPtr, libcimplot), Cvoid, (Ptr{ImGuiWindow}, Cfloat), window, scroll_y)
end

function igSetScrollFromPosXWindowPtr(window, local_x, center_x_ratio)
    ccall((:igSetScrollFromPosXWindowPtr, libcimplot), Cvoid, (Ptr{ImGuiWindow}, Cfloat, Cfloat), window, local_x, center_x_ratio)
end

function igSetScrollFromPosYWindowPtr(window, local_y, center_y_ratio)
    ccall((:igSetScrollFromPosYWindowPtr, libcimplot), Cvoid, (Ptr{ImGuiWindow}, Cfloat, Cfloat), window, local_y, center_y_ratio)
end

function igScrollToBringRectIntoView(pOut, window, item_rect)
    ccall((:igScrollToBringRectIntoView, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImGuiWindow}, ImRect), pOut, window, item_rect)
end

function igGetItemID()
    ccall((:igGetItemID, libcimplot), ImGuiID, ())
end

function igGetItemStatusFlags()
    ccall((:igGetItemStatusFlags, libcimplot), ImGuiItemStatusFlags, ())
end

function igGetActiveID()
    ccall((:igGetActiveID, libcimplot), ImGuiID, ())
end

function igGetFocusID()
    ccall((:igGetFocusID, libcimplot), ImGuiID, ())
end

function igGetItemsFlags()
    ccall((:igGetItemsFlags, libcimplot), ImGuiItemFlags, ())
end

function igSetActiveID(id, window)
    ccall((:igSetActiveID, libcimplot), Cvoid, (ImGuiID, Ptr{ImGuiWindow}), id, window)
end

function igSetFocusID(id, window)
    ccall((:igSetFocusID, libcimplot), Cvoid, (ImGuiID, Ptr{ImGuiWindow}), id, window)
end

function igClearActiveID()
    ccall((:igClearActiveID, libcimplot), Cvoid, ())
end

function igGetHoveredID()
    ccall((:igGetHoveredID, libcimplot), ImGuiID, ())
end

function igSetHoveredID(id)
    ccall((:igSetHoveredID, libcimplot), Cvoid, (ImGuiID,), id)
end

function igKeepAliveID(id)
    ccall((:igKeepAliveID, libcimplot), Cvoid, (ImGuiID,), id)
end

function igMarkItemEdited(id)
    ccall((:igMarkItemEdited, libcimplot), Cvoid, (ImGuiID,), id)
end

function igPushOverrideID(id)
    ccall((:igPushOverrideID, libcimplot), Cvoid, (ImGuiID,), id)
end

function igGetIDWithSeed(str_id_begin, str_id_end, seed)
    ccall((:igGetIDWithSeed, libcimplot), ImGuiID, (Cstring, Cstring, ImGuiID), str_id_begin, str_id_end, seed)
end

function igItemSizeVec2(size, text_baseline_y)
    ccall((:igItemSizeVec2, libcimplot), Cvoid, (ImVec2, Cfloat), size, text_baseline_y)
end

function igItemSizeRect(bb, text_baseline_y)
    ccall((:igItemSizeRect, libcimplot), Cvoid, (ImRect, Cfloat), bb, text_baseline_y)
end

function igItemAdd()
    ccall((:igItemAdd, libcimplot), Cint, ())
end

function igItemHoverable()
    ccall((:igItemHoverable, libcimplot), Cint, ())
end

function igIsClippedEx()
    ccall((:igIsClippedEx, libcimplot), Cint, ())
end

function igSetLastItemData(window, item_id, status_flags, item_rect)
    ccall((:igSetLastItemData, libcimplot), Cvoid, (Ptr{ImGuiWindow}, ImGuiID, ImGuiItemStatusFlags, ImRect), window, item_id, status_flags, item_rect)
end

function igFocusableItemRegister()
    ccall((:igFocusableItemRegister, libcimplot), Cint, ())
end

function igFocusableItemUnregister(window)
    ccall((:igFocusableItemUnregister, libcimplot), Cvoid, (Ptr{ImGuiWindow},), window)
end

function igCalcItemSize(pOut, size, default_w, default_h)
    ccall((:igCalcItemSize, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, Cfloat, Cfloat), pOut, size, default_w, default_h)
end

function igCalcWrapWidthForPos(pos, wrap_pos_x)
    ccall((:igCalcWrapWidthForPos, libcimplot), Cfloat, (ImVec2, Cfloat), pos, wrap_pos_x)
end

function igPushMultiItemsWidths(components, width_full)
    ccall((:igPushMultiItemsWidths, libcimplot), Cvoid, (Cint, Cfloat), components, width_full)
end

function igPushItemFlag(option, enabled)
    ccall((:igPushItemFlag, libcimplot), Cvoid, (ImGuiItemFlags, Cint), option, enabled)
end

function igPopItemFlag()
    ccall((:igPopItemFlag, libcimplot), Cvoid, ())
end

function igIsItemToggledSelection()
    ccall((:igIsItemToggledSelection, libcimplot), Cint, ())
end

function igGetContentRegionMaxAbs(pOut)
    ccall((:igGetContentRegionMaxAbs, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function igShrinkWidths(items, count, width_excess)
    ccall((:igShrinkWidths, libcimplot), Cvoid, (Ptr{ImGuiShrinkWidthItem}, Cint, Cfloat), items, count, width_excess)
end

function igLogBegin(type, auto_open_depth)
    ccall((:igLogBegin, libcimplot), Cvoid, (ImGuiLogType, Cint), type, auto_open_depth)
end

function igLogToBuffer(auto_open_depth)
    ccall((:igLogToBuffer, libcimplot), Cvoid, (Cint,), auto_open_depth)
end

function igLogRenderedText(ref_pos, text, text_end)
    ccall((:igLogRenderedText, libcimplot), Cvoid, (Ptr{ImVec2}, Cstring, Cstring), ref_pos, text, text_end)
end

function igLogSetNextTextDecoration(prefix, suffix)
    ccall((:igLogSetNextTextDecoration, libcimplot), Cvoid, (Cstring, Cstring), prefix, suffix)
end

function igBeginChildEx()
    ccall((:igBeginChildEx, libcimplot), Cint, ())
end

function igOpenPopupEx(id, popup_flags)
    ccall((:igOpenPopupEx, libcimplot), Cvoid, (ImGuiID, ImGuiPopupFlags), id, popup_flags)
end

function igClosePopupToLevel(remaining, restore_focus_to_window_under_popup)
    ccall((:igClosePopupToLevel, libcimplot), Cvoid, (Cint, Cint), remaining, restore_focus_to_window_under_popup)
end

function igClosePopupsOverWindow(ref_window, restore_focus_to_window_under_popup)
    ccall((:igClosePopupsOverWindow, libcimplot), Cvoid, (Ptr{ImGuiWindow}, Cint), ref_window, restore_focus_to_window_under_popup)
end

function igIsPopupOpenID()
    ccall((:igIsPopupOpenID, libcimplot), Cint, ())
end

function igBeginPopupEx()
    ccall((:igBeginPopupEx, libcimplot), Cint, ())
end

function igBeginTooltipEx(extra_flags, tooltip_flags)
    ccall((:igBeginTooltipEx, libcimplot), Cvoid, (ImGuiWindowFlags, ImGuiTooltipFlags), extra_flags, tooltip_flags)
end

function igGetTopMostPopupModal()
    ccall((:igGetTopMostPopupModal, libcimplot), Ptr{ImGuiWindow}, ())
end

function igFindBestWindowPosForPopup(pOut, window)
    ccall((:igFindBestWindowPosForPopup, libcimplot), Cvoid, (Ptr{ImVec2}, Ptr{ImGuiWindow}), pOut, window)
end

function igFindBestWindowPosForPopupEx(pOut, ref_pos, size, last_dir, r_outer, r_avoid, policy)
    ccall((:igFindBestWindowPosForPopupEx, libcimplot), Cvoid, (Ptr{ImVec2}, ImVec2, ImVec2, Ptr{ImGuiDir}, ImRect, ImRect, ImGuiPopupPositionPolicy), pOut, ref_pos, size, last_dir, r_outer, r_avoid, policy)
end

function igNavInitWindow(window, force_reinit)
    ccall((:igNavInitWindow, libcimplot), Cvoid, (Ptr{ImGuiWindow}, Cint), window, force_reinit)
end

function igNavMoveRequestButNoResultYet()
    ccall((:igNavMoveRequestButNoResultYet, libcimplot), Cint, ())
end

function igNavMoveRequestCancel()
    ccall((:igNavMoveRequestCancel, libcimplot), Cvoid, ())
end

function igNavMoveRequestForward(move_dir, clip_dir, bb_rel, move_flags)
    ccall((:igNavMoveRequestForward, libcimplot), Cvoid, (ImGuiDir, ImGuiDir, ImRect, ImGuiNavMoveFlags), move_dir, clip_dir, bb_rel, move_flags)
end

function igNavMoveRequestTryWrapping(window, move_flags)
    ccall((:igNavMoveRequestTryWrapping, libcimplot), Cvoid, (Ptr{ImGuiWindow}, ImGuiNavMoveFlags), window, move_flags)
end

function igGetNavInputAmount(n, mode)
    ccall((:igGetNavInputAmount, libcimplot), Cfloat, (ImGuiNavInput, ImGuiInputReadMode), n, mode)
end

function igGetNavInputAmount2d(pOut, dir_sources, mode, slow_factor, fast_factor)
    ccall((:igGetNavInputAmount2d, libcimplot), Cvoid, (Ptr{ImVec2}, ImGuiNavDirSourceFlags, ImGuiInputReadMode, Cfloat, Cfloat), pOut, dir_sources, mode, slow_factor, fast_factor)
end

function igCalcTypematicRepeatAmount(t0, t1, repeat_delay, repeat_rate)
    ccall((:igCalcTypematicRepeatAmount, libcimplot), Cint, (Cfloat, Cfloat, Cfloat, Cfloat), t0, t1, repeat_delay, repeat_rate)
end

function igActivateItem(id)
    ccall((:igActivateItem, libcimplot), Cvoid, (ImGuiID,), id)
end

function igSetNavID(id, nav_layer, focus_scope_id, rect_rel)
    ccall((:igSetNavID, libcimplot), Cvoid, (ImGuiID, Cint, ImGuiID, ImRect), id, nav_layer, focus_scope_id, rect_rel)
end

function igPushFocusScope(id)
    ccall((:igPushFocusScope, libcimplot), Cvoid, (ImGuiID,), id)
end

function igPopFocusScope()
    ccall((:igPopFocusScope, libcimplot), Cvoid, ())
end

function igGetFocusedFocusScope()
    ccall((:igGetFocusedFocusScope, libcimplot), ImGuiID, ())
end

function igGetFocusScope()
    ccall((:igGetFocusScope, libcimplot), ImGuiID, ())
end

function igSetItemUsingMouseWheel()
    ccall((:igSetItemUsingMouseWheel, libcimplot), Cvoid, ())
end

function igIsActiveIdUsingNavDir()
    ccall((:igIsActiveIdUsingNavDir, libcimplot), Cint, ())
end

function igIsActiveIdUsingNavInput()
    ccall((:igIsActiveIdUsingNavInput, libcimplot), Cint, ())
end

function igIsActiveIdUsingKey()
    ccall((:igIsActiveIdUsingKey, libcimplot), Cint, ())
end

function igIsMouseDragPastThreshold()
    ccall((:igIsMouseDragPastThreshold, libcimplot), Cint, ())
end

function igIsKeyPressedMap()
    ccall((:igIsKeyPressedMap, libcimplot), Cint, ())
end

function igIsNavInputDown()
    ccall((:igIsNavInputDown, libcimplot), Cint, ())
end

function igIsNavInputTest()
    ccall((:igIsNavInputTest, libcimplot), Cint, ())
end

function igGetMergedKeyModFlags()
    ccall((:igGetMergedKeyModFlags, libcimplot), ImGuiKeyModFlags, ())
end

function igBeginDragDropTargetCustom()
    ccall((:igBeginDragDropTargetCustom, libcimplot), Cint, ())
end

function igClearDragDrop()
    ccall((:igClearDragDrop, libcimplot), Cvoid, ())
end

function igIsDragDropPayloadBeingAccepted()
    ccall((:igIsDragDropPayloadBeingAccepted, libcimplot), Cint, ())
end

function igSetWindowClipRectBeforeSetChannel(window, clip_rect)
    ccall((:igSetWindowClipRectBeforeSetChannel, libcimplot), Cvoid, (Ptr{ImGuiWindow}, ImRect), window, clip_rect)
end

function igBeginColumns(str_id, count, flags)
    ccall((:igBeginColumns, libcimplot), Cvoid, (Cstring, Cint, ImGuiOldColumnFlags), str_id, count, flags)
end

function igEndColumns()
    ccall((:igEndColumns, libcimplot), Cvoid, ())
end

function igPushColumnClipRect(column_index)
    ccall((:igPushColumnClipRect, libcimplot), Cvoid, (Cint,), column_index)
end

function igPushColumnsBackground()
    ccall((:igPushColumnsBackground, libcimplot), Cvoid, ())
end

function igPopColumnsBackground()
    ccall((:igPopColumnsBackground, libcimplot), Cvoid, ())
end

function igGetColumnsID(str_id, count)
    ccall((:igGetColumnsID, libcimplot), ImGuiID, (Cstring, Cint), str_id, count)
end

function igFindOrCreateColumns(window, id)
    ccall((:igFindOrCreateColumns, libcimplot), Ptr{ImGuiOldColumns}, (Ptr{ImGuiWindow}, ImGuiID), window, id)
end

function igGetColumnOffsetFromNorm(columns, offset_norm)
    ccall((:igGetColumnOffsetFromNorm, libcimplot), Cfloat, (Ptr{ImGuiOldColumns}, Cfloat), columns, offset_norm)
end

function igGetColumnNormFromOffset(columns, offset)
    ccall((:igGetColumnNormFromOffset, libcimplot), Cfloat, (Ptr{ImGuiOldColumns}, Cfloat), columns, offset)
end

function igTableOpenContextMenu(column_n)
    ccall((:igTableOpenContextMenu, libcimplot), Cvoid, (Cint,), column_n)
end

function igTableSetColumnEnabled(column_n, enabled)
    ccall((:igTableSetColumnEnabled, libcimplot), Cvoid, (Cint, Cint), column_n, enabled)
end

function igTableSetColumnWidth(column_n, width)
    ccall((:igTableSetColumnWidth, libcimplot), Cvoid, (Cint, Cfloat), column_n, width)
end

function igTableSetColumnSortDirection(column_n, sort_direction, append_to_sort_specs)
    ccall((:igTableSetColumnSortDirection, libcimplot), Cvoid, (Cint, ImGuiSortDirection, Cint), column_n, sort_direction, append_to_sort_specs)
end

function igTableGetHoveredColumn()
    ccall((:igTableGetHoveredColumn, libcimplot), Cint, ())
end

function igTableGetHeaderRowHeight()
    ccall((:igTableGetHeaderRowHeight, libcimplot), Cfloat, ())
end

function igTablePushBackgroundChannel()
    ccall((:igTablePushBackgroundChannel, libcimplot), Cvoid, ())
end

function igTablePopBackgroundChannel()
    ccall((:igTablePopBackgroundChannel, libcimplot), Cvoid, ())
end

function igGetCurrentTable()
    ccall((:igGetCurrentTable, libcimplot), Ptr{ImGuiTable}, ())
end

function igTableFindByID(id)
    ccall((:igTableFindByID, libcimplot), Ptr{ImGuiTable}, (ImGuiID,), id)
end

function igBeginTableEx()
    ccall((:igBeginTableEx, libcimplot), Cint, ())
end

function igTableBeginInitMemory(table, columns_count)
    ccall((:igTableBeginInitMemory, libcimplot), Cvoid, (Ptr{ImGuiTable}, Cint), table, columns_count)
end

function igTableBeginApplyRequests(table)
    ccall((:igTableBeginApplyRequests, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableSetupDrawChannels(table)
    ccall((:igTableSetupDrawChannels, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableUpdateLayout(table)
    ccall((:igTableUpdateLayout, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableUpdateBorders(table)
    ccall((:igTableUpdateBorders, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableUpdateColumnsWeightFromWidth(table)
    ccall((:igTableUpdateColumnsWeightFromWidth, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableDrawBorders(table)
    ccall((:igTableDrawBorders, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableDrawContextMenu(table)
    ccall((:igTableDrawContextMenu, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableMergeDrawChannels(table)
    ccall((:igTableMergeDrawChannels, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableSortSpecsSanitize(table)
    ccall((:igTableSortSpecsSanitize, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableSortSpecsBuild(table)
    ccall((:igTableSortSpecsBuild, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableGetColumnNextSortDirection(column)
    ccall((:igTableGetColumnNextSortDirection, libcimplot), ImGuiSortDirection, (Ptr{ImGuiTableColumn},), column)
end

function igTableFixColumnSortDirection(table, column)
    ccall((:igTableFixColumnSortDirection, libcimplot), Cvoid, (Ptr{ImGuiTable}, Ptr{ImGuiTableColumn}), table, column)
end

function igTableGetColumnWidthAuto(table, column)
    ccall((:igTableGetColumnWidthAuto, libcimplot), Cfloat, (Ptr{ImGuiTable}, Ptr{ImGuiTableColumn}), table, column)
end

function igTableBeginRow(table)
    ccall((:igTableBeginRow, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableEndRow(table)
    ccall((:igTableEndRow, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableBeginCell(table, column_n)
    ccall((:igTableBeginCell, libcimplot), Cvoid, (Ptr{ImGuiTable}, Cint), table, column_n)
end

function igTableEndCell(table)
    ccall((:igTableEndCell, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableGetCellBgRect(pOut, table, column_n)
    ccall((:igTableGetCellBgRect, libcimplot), Cvoid, (Ptr{ImRect}, Ptr{ImGuiTable}, Cint), pOut, table, column_n)
end

function igTableGetColumnNameTablePtr(table, column_n)
    ccall((:igTableGetColumnNameTablePtr, libcimplot), Cstring, (Ptr{ImGuiTable}, Cint), table, column_n)
end

function igTableGetColumnResizeID(table, column_n, instance_no)
    ccall((:igTableGetColumnResizeID, libcimplot), ImGuiID, (Ptr{ImGuiTable}, Cint, Cint), table, column_n, instance_no)
end

function igTableGetMaxColumnWidth(table, column_n)
    ccall((:igTableGetMaxColumnWidth, libcimplot), Cfloat, (Ptr{ImGuiTable}, Cint), table, column_n)
end

function igTableSetColumnWidthAutoSingle(table, column_n)
    ccall((:igTableSetColumnWidthAutoSingle, libcimplot), Cvoid, (Ptr{ImGuiTable}, Cint), table, column_n)
end

function igTableSetColumnWidthAutoAll(table)
    ccall((:igTableSetColumnWidthAutoAll, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableRemove(table)
    ccall((:igTableRemove, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableGcCompactTransientBuffers(table)
    ccall((:igTableGcCompactTransientBuffers, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableGcCompactSettings()
    ccall((:igTableGcCompactSettings, libcimplot), Cvoid, ())
end

function igTableLoadSettings(table)
    ccall((:igTableLoadSettings, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableSaveSettings(table)
    ccall((:igTableSaveSettings, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableResetSettings(table)
    ccall((:igTableResetSettings, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igTableGetBoundSettings(table)
    ccall((:igTableGetBoundSettings, libcimplot), Ptr{ImGuiTableSettings}, (Ptr{ImGuiTable},), table)
end

function igTableSettingsInstallHandler(context)
    ccall((:igTableSettingsInstallHandler, libcimplot), Cvoid, (Ptr{ImGuiContext},), context)
end

function igTableSettingsCreate(id, columns_count)
    ccall((:igTableSettingsCreate, libcimplot), Ptr{ImGuiTableSettings}, (ImGuiID, Cint), id, columns_count)
end

function igTableSettingsFindByID(id)
    ccall((:igTableSettingsFindByID, libcimplot), Ptr{ImGuiTableSettings}, (ImGuiID,), id)
end

function igBeginTabBarEx()
    ccall((:igBeginTabBarEx, libcimplot), Cint, ())
end

function igTabBarFindTabByID(tab_bar, tab_id)
    ccall((:igTabBarFindTabByID, libcimplot), Ptr{ImGuiTabItem}, (Ptr{ImGuiTabBar}, ImGuiID), tab_bar, tab_id)
end

function igTabBarRemoveTab(tab_bar, tab_id)
    ccall((:igTabBarRemoveTab, libcimplot), Cvoid, (Ptr{ImGuiTabBar}, ImGuiID), tab_bar, tab_id)
end

function igTabBarCloseTab(tab_bar, tab)
    ccall((:igTabBarCloseTab, libcimplot), Cvoid, (Ptr{ImGuiTabBar}, Ptr{ImGuiTabItem}), tab_bar, tab)
end

function igTabBarQueueReorder(tab_bar, tab, dir)
    ccall((:igTabBarQueueReorder, libcimplot), Cvoid, (Ptr{ImGuiTabBar}, Ptr{ImGuiTabItem}, Cint), tab_bar, tab, dir)
end

function igTabBarProcessReorder()
    ccall((:igTabBarProcessReorder, libcimplot), Cint, ())
end

function igTabItemEx()
    ccall((:igTabItemEx, libcimplot), Cint, ())
end

function igTabItemCalcSize(pOut, label, has_close_button)
    ccall((:igTabItemCalcSize, libcimplot), Cvoid, (Ptr{ImVec2}, Cstring, Cint), pOut, label, has_close_button)
end

function igTabItemBackground(draw_list, bb, flags, col)
    ccall((:igTabItemBackground, libcimplot), Cvoid, (Ptr{ImDrawList}, ImRect, ImGuiTabItemFlags, ImU32), draw_list, bb, flags, col)
end

function igTabItemLabelAndCloseButton(draw_list, bb, flags, frame_padding, label, tab_id, close_button_id, is_contents_visible, out_just_closed, out_text_clipped)
    ccall((:igTabItemLabelAndCloseButton, libcimplot), Cvoid, (Ptr{ImDrawList}, ImRect, ImGuiTabItemFlags, ImVec2, Cstring, ImGuiID, ImGuiID, Cint, Ptr{Cint}, Ptr{Cint}), draw_list, bb, flags, frame_padding, label, tab_id, close_button_id, is_contents_visible, out_just_closed, out_text_clipped)
end

function igRenderText(pos, text, text_end, hide_text_after_hash)
    ccall((:igRenderText, libcimplot), Cvoid, (ImVec2, Cstring, Cstring, Cint), pos, text, text_end, hide_text_after_hash)
end

function igRenderTextWrapped(pos, text, text_end, wrap_width)
    ccall((:igRenderTextWrapped, libcimplot), Cvoid, (ImVec2, Cstring, Cstring, Cfloat), pos, text, text_end, wrap_width)
end

function igRenderTextClipped(pos_min, pos_max, text, text_end, text_size_if_known, align, clip_rect)
    ccall((:igRenderTextClipped, libcimplot), Cvoid, (ImVec2, ImVec2, Cstring, Cstring, Ptr{ImVec2}, ImVec2, Ptr{ImRect}), pos_min, pos_max, text, text_end, text_size_if_known, align, clip_rect)
end

function igRenderTextClippedEx(draw_list, pos_min, pos_max, text, text_end, text_size_if_known, align, clip_rect)
    ccall((:igRenderTextClippedEx, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, Cstring, Cstring, Ptr{ImVec2}, ImVec2, Ptr{ImRect}), draw_list, pos_min, pos_max, text, text_end, text_size_if_known, align, clip_rect)
end

function igRenderTextEllipsis(draw_list, pos_min, pos_max, clip_max_x, ellipsis_max_x, text, text_end, text_size_if_known)
    ccall((:igRenderTextEllipsis, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, Cfloat, Cfloat, Cstring, Cstring, Ptr{ImVec2}), draw_list, pos_min, pos_max, clip_max_x, ellipsis_max_x, text, text_end, text_size_if_known)
end

function igRenderFrame(p_min, p_max, fill_col, border, rounding)
    ccall((:igRenderFrame, libcimplot), Cvoid, (ImVec2, ImVec2, ImU32, Cint, Cfloat), p_min, p_max, fill_col, border, rounding)
end

function igRenderFrameBorder(p_min, p_max, rounding)
    ccall((:igRenderFrameBorder, libcimplot), Cvoid, (ImVec2, ImVec2, Cfloat), p_min, p_max, rounding)
end

function igRenderColorRectWithAlphaCheckerboard(draw_list, p_min, p_max, fill_col, grid_step, grid_off, rounding, flags)
    ccall((:igRenderColorRectWithAlphaCheckerboard, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImU32, Cfloat, ImVec2, Cfloat, ImDrawFlags), draw_list, p_min, p_max, fill_col, grid_step, grid_off, rounding, flags)
end

function igRenderNavHighlight(bb, id, flags)
    ccall((:igRenderNavHighlight, libcimplot), Cvoid, (ImRect, ImGuiID, ImGuiNavHighlightFlags), bb, id, flags)
end

function igFindRenderedTextEnd(text, text_end)
    ccall((:igFindRenderedTextEnd, libcimplot), Cstring, (Cstring, Cstring), text, text_end)
end

function igRenderArrow(draw_list, pos, col, dir, scale)
    ccall((:igRenderArrow, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImU32, ImGuiDir, Cfloat), draw_list, pos, col, dir, scale)
end

function igRenderBullet(draw_list, pos, col)
    ccall((:igRenderBullet, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImU32), draw_list, pos, col)
end

function igRenderCheckMark(draw_list, pos, col, sz)
    ccall((:igRenderCheckMark, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImU32, Cfloat), draw_list, pos, col, sz)
end

function igRenderMouseCursor(draw_list, pos, scale, mouse_cursor, col_fill, col_border, col_shadow)
    ccall((:igRenderMouseCursor, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, Cfloat, ImGuiMouseCursor, ImU32, ImU32, ImU32), draw_list, pos, scale, mouse_cursor, col_fill, col_border, col_shadow)
end

function igRenderArrowPointingAt(draw_list, pos, half_sz, direction, col)
    ccall((:igRenderArrowPointingAt, libcimplot), Cvoid, (Ptr{ImDrawList}, ImVec2, ImVec2, ImGuiDir, ImU32), draw_list, pos, half_sz, direction, col)
end

function igRenderRectFilledRangeH(draw_list, rect, col, x_start_norm, x_end_norm, rounding)
    ccall((:igRenderRectFilledRangeH, libcimplot), Cvoid, (Ptr{ImDrawList}, ImRect, ImU32, Cfloat, Cfloat, Cfloat), draw_list, rect, col, x_start_norm, x_end_norm, rounding)
end

function igRenderRectFilledWithHole(draw_list, outer, inner, col, rounding)
    ccall((:igRenderRectFilledWithHole, libcimplot), Cvoid, (Ptr{ImDrawList}, ImRect, ImRect, ImU32, Cfloat), draw_list, outer, inner, col, rounding)
end

function igTextEx(text, text_end, flags)
    ccall((:igTextEx, libcimplot), Cvoid, (Cstring, Cstring, ImGuiTextFlags), text, text_end, flags)
end

function igButtonEx()
    ccall((:igButtonEx, libcimplot), Cint, ())
end

function igCloseButton()
    ccall((:igCloseButton, libcimplot), Cint, ())
end

function igCollapseButton()
    ccall((:igCollapseButton, libcimplot), Cint, ())
end

function igArrowButtonEx()
    ccall((:igArrowButtonEx, libcimplot), Cint, ())
end

function igScrollbar(axis)
    ccall((:igScrollbar, libcimplot), Cvoid, (ImGuiAxis,), axis)
end

function igScrollbarEx()
    ccall((:igScrollbarEx, libcimplot), Cint, ())
end

function igImageButtonEx()
    ccall((:igImageButtonEx, libcimplot), Cint, ())
end

function igGetWindowScrollbarRect(pOut, window, axis)
    ccall((:igGetWindowScrollbarRect, libcimplot), Cvoid, (Ptr{ImRect}, Ptr{ImGuiWindow}, ImGuiAxis), pOut, window, axis)
end

function igGetWindowScrollbarID(window, axis)
    ccall((:igGetWindowScrollbarID, libcimplot), ImGuiID, (Ptr{ImGuiWindow}, ImGuiAxis), window, axis)
end

function igGetWindowResizeID(window, n)
    ccall((:igGetWindowResizeID, libcimplot), ImGuiID, (Ptr{ImGuiWindow}, Cint), window, n)
end

function igSeparatorEx(flags)
    ccall((:igSeparatorEx, libcimplot), Cvoid, (ImGuiSeparatorFlags,), flags)
end

function igCheckboxFlagsS64Ptr()
    ccall((:igCheckboxFlagsS64Ptr, libcimplot), Cint, ())
end

function igCheckboxFlagsU64Ptr()
    ccall((:igCheckboxFlagsU64Ptr, libcimplot), Cint, ())
end

function igButtonBehavior()
    ccall((:igButtonBehavior, libcimplot), Cint, ())
end

function igDragBehavior()
    ccall((:igDragBehavior, libcimplot), Cint, ())
end

function igSliderBehavior()
    ccall((:igSliderBehavior, libcimplot), Cint, ())
end

function igSplitterBehavior()
    ccall((:igSplitterBehavior, libcimplot), Cint, ())
end

function igTreeNodeBehavior()
    ccall((:igTreeNodeBehavior, libcimplot), Cint, ())
end

function igTreeNodeBehaviorIsOpen()
    ccall((:igTreeNodeBehaviorIsOpen, libcimplot), Cint, ())
end

function igTreePushOverrideID(id)
    ccall((:igTreePushOverrideID, libcimplot), Cvoid, (ImGuiID,), id)
end

function igDataTypeGetInfo(data_type)
    ccall((:igDataTypeGetInfo, libcimplot), Ptr{ImGuiDataTypeInfo}, (ImGuiDataType,), data_type)
end

function igDataTypeFormatString(buf, buf_size, data_type, p_data, format)
    ccall((:igDataTypeFormatString, libcimplot), Cint, (Cstring, Cint, ImGuiDataType, Ptr{Cvoid}, Cstring), buf, buf_size, data_type, p_data, format)
end

function igDataTypeApplyOp(data_type, op, output, arg_1, arg_2)
    ccall((:igDataTypeApplyOp, libcimplot), Cvoid, (ImGuiDataType, Cint, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), data_type, op, output, arg_1, arg_2)
end

function igDataTypeApplyOpFromText()
    ccall((:igDataTypeApplyOpFromText, libcimplot), Cint, ())
end

function igDataTypeCompare(data_type, arg_1, arg_2)
    ccall((:igDataTypeCompare, libcimplot), Cint, (ImGuiDataType, Ptr{Cvoid}, Ptr{Cvoid}), data_type, arg_1, arg_2)
end

function igDataTypeClamp()
    ccall((:igDataTypeClamp, libcimplot), Cint, ())
end

function igInputTextEx()
    ccall((:igInputTextEx, libcimplot), Cint, ())
end

function igTempInputText()
    ccall((:igTempInputText, libcimplot), Cint, ())
end

function igTempInputScalar()
    ccall((:igTempInputScalar, libcimplot), Cint, ())
end

function igTempInputIsActive()
    ccall((:igTempInputIsActive, libcimplot), Cint, ())
end

function igGetInputTextState(id)
    ccall((:igGetInputTextState, libcimplot), Ptr{ImGuiInputTextState}, (ImGuiID,), id)
end

function igColorTooltip(text, col, flags)
    ccall((:igColorTooltip, libcimplot), Cvoid, (Cstring, Ptr{Cfloat}, ImGuiColorEditFlags), text, col, flags)
end

function igColorEditOptionsPopup(col, flags)
    ccall((:igColorEditOptionsPopup, libcimplot), Cvoid, (Ptr{Cfloat}, ImGuiColorEditFlags), col, flags)
end

function igColorPickerOptionsPopup(ref_col, flags)
    ccall((:igColorPickerOptionsPopup, libcimplot), Cvoid, (Ptr{Cfloat}, ImGuiColorEditFlags), ref_col, flags)
end

function igPlotEx(plot_type, label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, frame_size)
    ccall((:igPlotEx, libcimplot), Cint, (ImGuiPlotType, Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Cint, Cint, Cstring, Cfloat, Cfloat, ImVec2), plot_type, label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, frame_size)
end

function igShadeVertsLinearColorGradientKeepAlpha(draw_list, vert_start_idx, vert_end_idx, gradient_p0, gradient_p1, col0, col1)
    ccall((:igShadeVertsLinearColorGradientKeepAlpha, libcimplot), Cvoid, (Ptr{ImDrawList}, Cint, Cint, ImVec2, ImVec2, ImU32, ImU32), draw_list, vert_start_idx, vert_end_idx, gradient_p0, gradient_p1, col0, col1)
end

function igShadeVertsLinearUV(draw_list, vert_start_idx, vert_end_idx, a, b, uv_a, uv_b, clamp)
    ccall((:igShadeVertsLinearUV, libcimplot), Cvoid, (Ptr{ImDrawList}, Cint, Cint, ImVec2, ImVec2, ImVec2, ImVec2, Cint), draw_list, vert_start_idx, vert_end_idx, a, b, uv_a, uv_b, clamp)
end

function igGcCompactTransientMiscBuffers()
    ccall((:igGcCompactTransientMiscBuffers, libcimplot), Cvoid, ())
end

function igGcCompactTransientWindowBuffers(window)
    ccall((:igGcCompactTransientWindowBuffers, libcimplot), Cvoid, (Ptr{ImGuiWindow},), window)
end

function igGcAwakeTransientWindowBuffers(window)
    ccall((:igGcAwakeTransientWindowBuffers, libcimplot), Cvoid, (Ptr{ImGuiWindow},), window)
end

function igErrorCheckEndFrameRecover(log_callback, user_data)
    ccall((:igErrorCheckEndFrameRecover, libcimplot), Cvoid, (ImGuiErrorLogCallback, Ptr{Cvoid}), log_callback, user_data)
end

function igDebugDrawItemRect(col)
    ccall((:igDebugDrawItemRect, libcimplot), Cvoid, (ImU32,), col)
end

function igDebugStartItemPicker()
    ccall((:igDebugStartItemPicker, libcimplot), Cvoid, ())
end

function igDebugNodeColumns(columns)
    ccall((:igDebugNodeColumns, libcimplot), Cvoid, (Ptr{ImGuiOldColumns},), columns)
end

function igDebugNodeDrawList(window, draw_list, label)
    ccall((:igDebugNodeDrawList, libcimplot), Cvoid, (Ptr{ImGuiWindow}, Ptr{ImDrawList}, Cstring), window, draw_list, label)
end

function igDebugNodeDrawCmdShowMeshAndBoundingBox(out_draw_list, draw_list, draw_cmd, show_mesh, show_aabb)
    ccall((:igDebugNodeDrawCmdShowMeshAndBoundingBox, libcimplot), Cvoid, (Ptr{ImDrawList}, Ptr{ImDrawList}, Ptr{ImDrawCmd}, Cint, Cint), out_draw_list, draw_list, draw_cmd, show_mesh, show_aabb)
end

function igDebugNodeStorage(storage, label)
    ccall((:igDebugNodeStorage, libcimplot), Cvoid, (Ptr{ImGuiStorage}, Cstring), storage, label)
end

function igDebugNodeTabBar(tab_bar, label)
    ccall((:igDebugNodeTabBar, libcimplot), Cvoid, (Ptr{ImGuiTabBar}, Cstring), tab_bar, label)
end

function igDebugNodeTable(table)
    ccall((:igDebugNodeTable, libcimplot), Cvoid, (Ptr{ImGuiTable},), table)
end

function igDebugNodeTableSettings(settings)
    ccall((:igDebugNodeTableSettings, libcimplot), Cvoid, (Ptr{ImGuiTableSettings},), settings)
end

function igDebugNodeWindow(window, label)
    ccall((:igDebugNodeWindow, libcimplot), Cvoid, (Ptr{ImGuiWindow}, Cstring), window, label)
end

function igDebugNodeWindowSettings(settings)
    ccall((:igDebugNodeWindowSettings, libcimplot), Cvoid, (Ptr{ImGuiWindowSettings},), settings)
end

function igDebugNodeWindowsList(windows, label)
    ccall((:igDebugNodeWindowsList, libcimplot), Cvoid, (Ptr{ImVector_ImGuiWindowPtr}, Cstring), windows, label)
end

function igDebugNodeViewport(viewport)
    ccall((:igDebugNodeViewport, libcimplot), Cvoid, (Ptr{ImGuiViewportP},), viewport)
end

function igDebugRenderViewportThumbnail(draw_list, viewport, bb)
    ccall((:igDebugRenderViewportThumbnail, libcimplot), Cvoid, (Ptr{ImDrawList}, Ptr{ImGuiViewportP}, ImRect), draw_list, viewport, bb)
end

function igImFontAtlasGetBuilderForStbTruetype()
    ccall((:igImFontAtlasGetBuilderForStbTruetype, libcimplot), Ptr{ImFontBuilderIO}, ())
end

function igImFontAtlasBuildInit(atlas)
    ccall((:igImFontAtlasBuildInit, libcimplot), Cvoid, (Ptr{ImFontAtlas},), atlas)
end

function igImFontAtlasBuildSetupFont(atlas, font, font_config, ascent, descent)
    ccall((:igImFontAtlasBuildSetupFont, libcimplot), Cvoid, (Ptr{ImFontAtlas}, Ptr{ImFont}, Ptr{ImFontConfig}, Cfloat, Cfloat), atlas, font, font_config, ascent, descent)
end

function igImFontAtlasBuildPackCustomRects(atlas, stbrp_context_opaque)
    ccall((:igImFontAtlasBuildPackCustomRects, libcimplot), Cvoid, (Ptr{ImFontAtlas}, Ptr{Cvoid}), atlas, stbrp_context_opaque)
end

function igImFontAtlasBuildFinish(atlas)
    ccall((:igImFontAtlasBuildFinish, libcimplot), Cvoid, (Ptr{ImFontAtlas},), atlas)
end

function igImFontAtlasBuildRender8bppRectFromString(atlas, x, y, w, h, in_str, in_marker_char, in_marker_pixel_value)
    ccall((:igImFontAtlasBuildRender8bppRectFromString, libcimplot), Cvoid, (Ptr{ImFontAtlas}, Cint, Cint, Cint, Cint, Cstring, Cchar, Cuchar), atlas, x, y, w, h, in_str, in_marker_char, in_marker_pixel_value)
end

function igImFontAtlasBuildRender32bppRectFromString(atlas, x, y, w, h, in_str, in_marker_char, in_marker_pixel_value)
    ccall((:igImFontAtlasBuildRender32bppRectFromString, libcimplot), Cvoid, (Ptr{ImFontAtlas}, Cint, Cint, Cint, Cint, Cstring, Cchar, Cuint), atlas, x, y, w, h, in_str, in_marker_char, in_marker_pixel_value)
end

function igImFontAtlasBuildMultiplyCalcLookupTable(out_table, in_multiply_factor)
    ccall((:igImFontAtlasBuildMultiplyCalcLookupTable, libcimplot), Cvoid, (Ptr{Cuchar}, Cfloat), out_table, in_multiply_factor)
end

function igImFontAtlasBuildMultiplyRectAlpha8(table, pixels, x, y, w, h, stride)
    ccall((:igImFontAtlasBuildMultiplyRectAlpha8, libcimplot), Cvoid, (Ptr{Cuchar}, Ptr{Cuchar}, Cint, Cint, Cint, Cint, Cint), table, pixels, x, y, w, h, stride)
end

# no prototype is found for this function at cimgui.h:3385:18, please use with caution
function igGET_FLT_MAX()
    ccall((:igGET_FLT_MAX, libcimplot), Cfloat, ())
end

# no prototype is found for this function at cimgui.h:3387:18, please use with caution
function igGET_FLT_MIN()
    ccall((:igGET_FLT_MIN, libcimplot), Cfloat, ())
end

# no prototype is found for this function at cimgui.h:3390:30, please use with caution
function ImVector_ImWchar_create()
    ccall((:ImVector_ImWchar_create, libcimplot), Ptr{ImVector_ImWchar}, ())
end

function ImVector_ImWchar_destroy(self)
    ccall((:ImVector_ImWchar_destroy, libcimplot), Cvoid, (Ptr{ImVector_ImWchar},), self)
end

function ImVector_ImWchar_Init(p)
    ccall((:ImVector_ImWchar_Init, libcimplot), Cvoid, (Ptr{ImVector_ImWchar},), p)
end

function ImVector_ImWchar_UnInit(p)
    ccall((:ImVector_ImWchar_UnInit, libcimplot), Cvoid, (Ptr{ImVector_ImWchar},), p)
end

mutable struct ImPlotInputMap
    PanButton::ImGuiMouseButton
    PanMod::ImGuiKeyModFlags
    FitButton::ImGuiMouseButton
    ContextMenuButton::ImGuiMouseButton
    BoxSelectButton::ImGuiMouseButton
    BoxSelectMod::ImGuiKeyModFlags
    BoxSelectCancelButton::ImGuiMouseButton
    QueryButton::ImGuiMouseButton
    QueryMod::ImGuiKeyModFlags
    QueryToggleMod::ImGuiKeyModFlags
    HorizontalMod::ImGuiKeyModFlags
    VerticalMod::ImGuiKeyModFlags
end

mutable struct ImPlotStyle
    LineWeight::Cfloat
    Marker::Cint
    MarkerSize::Cfloat
    MarkerWeight::Cfloat
    FillAlpha::Cfloat
    ErrorBarSize::Cfloat
    ErrorBarWeight::Cfloat
    DigitalBitHeight::Cfloat
    DigitalBitGap::Cfloat
    PlotBorderSize::Cfloat
    MinorAlpha::Cfloat
    MajorTickLen::ImVec2
    MinorTickLen::ImVec2
    MajorTickSize::ImVec2
    MinorTickSize::ImVec2
    MajorGridSize::ImVec2
    MinorGridSize::ImVec2
    PlotPadding::ImVec2
    LabelPadding::ImVec2
    LegendPadding::ImVec2
    LegendInnerPadding::ImVec2
    LegendSpacing::ImVec2
    MousePosPadding::ImVec2
    AnnotationPadding::ImVec2
    FitPadding::ImVec2
    PlotDefaultSize::ImVec2
    PlotMinSize::ImVec2
    Colors::NTuple{24, ImVec4}
    AntiAliasedLines::Cint
    UseLocalTime::Cint
    UseISO8601::Cint
    Use24HourClock::Cint
end

struct ImPlotRange
    Min::Cdouble
    Max::Cdouble
end

mutable struct ImPlotLimits
    X::ImPlotRange
    Y::ImPlotRange
end

mutable struct ImPlotPoint
    x::Cdouble
    y::Cdouble
end

mutable struct ImPlotContext end

const ImPlotFlags = Cint

const ImPlotAxisFlags = Cint

const ImPlotCol = Cint

const ImPlotStyleVar = Cint

const ImPlotMarker = Cint

const ImPlotColormap = Cint

const ImPlotLocation = Cint

const ImPlotOrientation = Cint

const ImPlotYAxis = Cint

@cenum ImPlotFlags_::UInt32 begin
    ImPlotFlags_None = 0
    ImPlotFlags_NoTitle = 1
    ImPlotFlags_NoLegend = 2
    ImPlotFlags_NoMenus = 4
    ImPlotFlags_NoBoxSelect = 8
    ImPlotFlags_NoMousePos = 16
    ImPlotFlags_NoHighlight = 32
    ImPlotFlags_NoChild = 64
    ImPlotFlags_Equal = 128
    ImPlotFlags_YAxis2 = 256
    ImPlotFlags_YAxis3 = 512
    ImPlotFlags_Query = 1024
    ImPlotFlags_Crosshairs = 2048
    ImPlotFlags_AntiAliased = 4096
    ImPlotFlags_CanvasOnly = 31
end

@cenum ImPlotAxisFlags_::UInt32 begin
    ImPlotAxisFlags_None = 0
    ImPlotAxisFlags_NoGridLines = 1
    ImPlotAxisFlags_NoTickMarks = 2
    ImPlotAxisFlags_NoTickLabels = 4
    ImPlotAxisFlags_LogScale = 8
    ImPlotAxisFlags_Time = 16
    ImPlotAxisFlags_Invert = 32
    ImPlotAxisFlags_LockMin = 64
    ImPlotAxisFlags_LockMax = 128
    ImPlotAxisFlags_Lock = 192
    ImPlotAxisFlags_NoDecorations = 7
end

@cenum ImPlotCol_::UInt32 begin
    ImPlotCol_Line = 0
    ImPlotCol_Fill = 1
    ImPlotCol_MarkerOutline = 2
    ImPlotCol_MarkerFill = 3
    ImPlotCol_ErrorBar = 4
    ImPlotCol_FrameBg = 5
    ImPlotCol_PlotBg = 6
    ImPlotCol_PlotBorder = 7
    ImPlotCol_LegendBg = 8
    ImPlotCol_LegendBorder = 9
    ImPlotCol_LegendText = 10
    ImPlotCol_TitleText = 11
    ImPlotCol_InlayText = 12
    ImPlotCol_XAxis = 13
    ImPlotCol_XAxisGrid = 14
    ImPlotCol_YAxis = 15
    ImPlotCol_YAxisGrid = 16
    ImPlotCol_YAxis2 = 17
    ImPlotCol_YAxisGrid2 = 18
    ImPlotCol_YAxis3 = 19
    ImPlotCol_YAxisGrid3 = 20
    ImPlotCol_Selection = 21
    ImPlotCol_Query = 22
    ImPlotCol_Crosshairs = 23
    ImPlotCol_COUNT = 24
end

@cenum ImPlotStyleVar_::UInt32 begin
    ImPlotStyleVar_LineWeight = 0
    ImPlotStyleVar_Marker = 1
    ImPlotStyleVar_MarkerSize = 2
    ImPlotStyleVar_MarkerWeight = 3
    ImPlotStyleVar_FillAlpha = 4
    ImPlotStyleVar_ErrorBarSize = 5
    ImPlotStyleVar_ErrorBarWeight = 6
    ImPlotStyleVar_DigitalBitHeight = 7
    ImPlotStyleVar_DigitalBitGap = 8
    ImPlotStyleVar_PlotBorderSize = 9
    ImPlotStyleVar_MinorAlpha = 10
    ImPlotStyleVar_MajorTickLen = 11
    ImPlotStyleVar_MinorTickLen = 12
    ImPlotStyleVar_MajorTickSize = 13
    ImPlotStyleVar_MinorTickSize = 14
    ImPlotStyleVar_MajorGridSize = 15
    ImPlotStyleVar_MinorGridSize = 16
    ImPlotStyleVar_PlotPadding = 17
    ImPlotStyleVar_LabelPadding = 18
    ImPlotStyleVar_LegendPadding = 19
    ImPlotStyleVar_LegendInnerPadding = 20
    ImPlotStyleVar_LegendSpacing = 21
    ImPlotStyleVar_MousePosPadding = 22
    ImPlotStyleVar_AnnotationPadding = 23
    ImPlotStyleVar_FitPadding = 24
    ImPlotStyleVar_PlotDefaultSize = 25
    ImPlotStyleVar_PlotMinSize = 26
    ImPlotStyleVar_COUNT = 27
end

@cenum ImPlotMarker_::Int32 begin
    ImPlotMarker_None = -1
    ImPlotMarker_Circle = 0
    ImPlotMarker_Square = 1
    ImPlotMarker_Diamond = 2
    ImPlotMarker_Up = 3
    ImPlotMarker_Down = 4
    ImPlotMarker_Left = 5
    ImPlotMarker_Right = 6
    ImPlotMarker_Cross = 7
    ImPlotMarker_Plus = 8
    ImPlotMarker_Asterisk = 9
    ImPlotMarker_COUNT = 10
end

@cenum ImPlotColormap_::UInt32 begin
    ImPlotColormap_Default = 0
    ImPlotColormap_Deep = 1
    ImPlotColormap_Dark = 2
    ImPlotColormap_Pastel = 3
    ImPlotColormap_Paired = 4
    ImPlotColormap_Viridis = 5
    ImPlotColormap_Plasma = 6
    ImPlotColormap_Hot = 7
    ImPlotColormap_Cool = 8
    ImPlotColormap_Pink = 9
    ImPlotColormap_Jet = 10
    ImPlotColormap_COUNT = 11
end

@cenum ImPlotLocation_::UInt32 begin
    ImPlotLocation_Center = 0
    ImPlotLocation_North = 1
    ImPlotLocation_South = 2
    ImPlotLocation_West = 4
    ImPlotLocation_East = 8
    ImPlotLocation_NorthWest = 5
    ImPlotLocation_NorthEast = 9
    ImPlotLocation_SouthWest = 6
    ImPlotLocation_SouthEast = 10
end

@cenum ImPlotOrientation_::UInt32 begin
    ImPlotOrientation_Horizontal = 0
    ImPlotOrientation_Vertical = 1
end

@cenum ImPlotYAxis_::UInt32 begin
    ImPlotYAxis_1 = 0
    ImPlotYAxis_2 = 1
    ImPlotYAxis_3 = 2
end

function ImPlotPoint_ImPlotPointNil()
    ccall((:ImPlotPoint_ImPlotPointNil, libcimplot), Ptr{ImPlotPoint}, ())
end

function ImPlotPoint_destroy(self)
    ccall((:ImPlotPoint_destroy, libcimplot), Cvoid, (Ptr{ImPlotPoint},), self)
end

function ImPlotPoint_ImPlotPointdouble(_x, _y)
    ccall((:ImPlotPoint_ImPlotPointdouble, libcimplot), Ptr{ImPlotPoint}, (Cdouble, Cdouble), _x, _y)
end

function ImPlotPoint_ImPlotPointVec2(p)
    ccall((:ImPlotPoint_ImPlotPointVec2, libcimplot), Ptr{ImPlotPoint}, (ImVec2,), p)
end

function ImPlotRange_ImPlotRangeNil()
    ccall((:ImPlotRange_ImPlotRangeNil, libcimplot), Ptr{ImPlotRange}, ())
end

function ImPlotRange_destroy(self)
    ccall((:ImPlotRange_destroy, libcimplot), Cvoid, (Ptr{ImPlotRange},), self)
end

function ImPlotRange_ImPlotRangedouble(_min, _max)
    ccall((:ImPlotRange_ImPlotRangedouble, libcimplot), Ptr{ImPlotRange}, (Cdouble, Cdouble), _min, _max)
end

function ImPlotRange_Contains()
    ccall((:ImPlotRange_Contains, libcimplot), Cint, ())
end

function ImPlotRange_Size(self)
    ccall((:ImPlotRange_Size, libcimplot), Cdouble, (Ptr{ImPlotRange},), self)
end

function ImPlotLimits_ContainsPlotPoInt()
    ccall((:ImPlotLimits_ContainsPlotPoInt, libcimplot), Cint, ())
end

function ImPlotLimits_Containsdouble()
    ccall((:ImPlotLimits_Containsdouble, libcimplot), Cint, ())
end

function ImPlotStyle_ImPlotStyle()
    ccall((:ImPlotStyle_ImPlotStyle, libcimplot), Ptr{ImPlotStyle}, ())
end

function ImPlotStyle_destroy(self)
    ccall((:ImPlotStyle_destroy, libcimplot), Cvoid, (Ptr{ImPlotStyle},), self)
end

function ImPlotInputMap_ImPlotInputMap()
    ccall((:ImPlotInputMap_ImPlotInputMap, libcimplot), Ptr{ImPlotInputMap}, ())
end

function ImPlotInputMap_destroy(self)
    ccall((:ImPlotInputMap_destroy, libcimplot), Cvoid, (Ptr{ImPlotInputMap},), self)
end

function CreateContext()
    ccall((:ImPlot_CreateContext, libcimplot), Ptr{ImPlotContext}, ())
end

function DestroyContext(ctx)
    ccall((:ImPlot_DestroyContext, libcimplot), Cvoid, (Ptr{ImPlotContext},), ctx)
end

function GetCurrentContext()
    ccall((:ImPlot_GetCurrentContext, libcimplot), Ptr{ImPlotContext}, ())
end

function SetCurrentContext(ctx)
    ccall((:ImPlot_SetCurrentContext, libcimplot), Cvoid, (Ptr{ImPlotContext},), ctx)
end

function BeginPlot()
    ccall((:ImPlot_BeginPlot, libcimplot), Cint, ())
end

function EndPlot()
    ccall((:ImPlot_EndPlot, libcimplot), Cvoid, ())
end

function PlotLine(label_id, values::AbstractArray{Cfloat}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineFloatPtrInt, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotLine(label_id, values::AbstractArray{Cdouble}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLinedoublePtrInt, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotLine(label_id, values::AbstractArray{ImS8}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineS8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotLine(label_id, values::AbstractArray{ImU8}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineU8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotLine(label_id, values::AbstractArray{ImS16}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineS16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotLine(label_id, values::AbstractArray{ImU16}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineU16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotLine(label_id, values::AbstractArray{ImS32}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineS32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotLine(label_id, values::AbstractArray{ImU32}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineU32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotLine(label_id, values::AbstractArray{ImS64}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineS64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotLine(label_id, values::AbstractArray{ImU64}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineU64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotLine(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineFloatPtrFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotLine(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLinedoublePtrdoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotLine(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineS8PtrS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotLine(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineU8PtrU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotLine(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineS16PtrS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotLine(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineU16PtrU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotLine(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineS32PtrS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotLine(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineU32PtrU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotLine(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineS64PtrS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotLine(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotLineU64PtrU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotScatter(label_id, values::AbstractArray{Cfloat}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterFloatPtrInt, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotScatter(label_id, values::AbstractArray{Cdouble}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterdoublePtrInt, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotScatter(label_id, values::AbstractArray{ImS8}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterS8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotScatter(label_id, values::AbstractArray{ImU8}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterU8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotScatter(label_id, values::AbstractArray{ImS16}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterS16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotScatter(label_id, values::AbstractArray{ImU16}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterU16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotScatter(label_id, values::AbstractArray{ImS32}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterS32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotScatter(label_id, values::AbstractArray{ImU32}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterU32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotScatter(label_id, values::AbstractArray{ImS64}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterS64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotScatter(label_id, values::AbstractArray{ImU64}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterU64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotScatter(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterFloatPtrFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotScatter(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterdoublePtrdoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotScatter(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterS8PtrS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotScatter(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterU8PtrU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotScatter(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterS16PtrS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotScatter(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterU16PtrU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotScatter(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterS32PtrS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotScatter(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterU32PtrU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotScatter(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterS64PtrS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotScatter(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotScatterU64PtrU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairs(label_id, values::AbstractArray{Cfloat}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsFloatPtrInt, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotStairs(label_id, values::AbstractArray{Cdouble}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsdoublePtrInt, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotStairs(label_id, values::AbstractArray{ImS8}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsS8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotStairs(label_id, values::AbstractArray{ImU8}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsU8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotStairs(label_id, values::AbstractArray{ImS16}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsS16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotStairs(label_id, values::AbstractArray{ImU16}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsU16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotStairs(label_id, values::AbstractArray{ImS32}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsS32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotStairs(label_id, values::AbstractArray{ImU32}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsU32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotStairs(label_id, values::AbstractArray{ImS64}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsS64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotStairs(label_id, values::AbstractArray{ImU64}, count::Integer, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsU64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, xscale, x0, offset, stride)
end

function PlotStairs(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsFloatPtrFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairs(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsdoublePtrdoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairs(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsS8PtrS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairs(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsU8PtrU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairs(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsS16PtrS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairs(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsU16PtrU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairs(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsS32PtrS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairs(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsU32PtrU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairs(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsS64PtrS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairs(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStairsU64PtrU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotStairsG(label_id, getter, data, count::Integer, offset::Integer)
    ccall((:ImPlot_PlotStairsG, libcimplot), Cvoid, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Cint, Cint), label_id, getter, data, count, offset)
end

function PlotShaded(label_id, values::AbstractArray{Cfloat}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedFloatPtrIntdoubledoubleInt, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotShaded(label_id, values::AbstractArray{Cdouble}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadeddoublePtrIntdoubledoubleInt, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotShaded(label_id, values::AbstractArray{ImS8}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS8PtrIntdoubledoubleInt, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotShaded(label_id, values::AbstractArray{ImU8}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU8PtrIntdoubledoubleInt, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotShaded(label_id, values::AbstractArray{ImS16}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS16PtrIntdoubledoubleInt, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotShaded(label_id, values::AbstractArray{ImU16}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU16PtrIntdoubledoubleInt, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotShaded(label_id, values::AbstractArray{ImS32}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS32PtrIntdoubledoubleInt, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotShaded(label_id, values::AbstractArray{ImU32}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU32PtrIntdoubledoubleInt, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotShaded(label_id, values::AbstractArray{ImS64}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS64PtrIntdoubledoubleInt, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotShaded(label_id, values::AbstractArray{ImU64}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU64PtrIntdoubledoubleInt, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedFloatPtrFloatPtrIntInt, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadeddoublePtrdoublePtrIntInt, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS8PtrS8PtrIntInt, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU8PtrU8PtrIntInt, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS16PtrS16PtrIntInt, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU16PtrU16PtrIntInt, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS32PtrS32PtrIntInt, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU32PtrU32PtrIntInt, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS64PtrS64PtrIntInt, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU64PtrU64PtrIntInt, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{Cfloat}, ys1::AbstractArray{Cfloat}, ys2::AbstractArray{Cfloat}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedFloatPtrFloatPtrFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Ref{Cfloat}, Cint, Cint, Cint), label_id, xs, ys1, ys2, count, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{Cdouble}, ys1::AbstractArray{Cdouble}, ys2::AbstractArray{Cdouble}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadeddoublePtrdoublePtrdoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Cint, Cint, Cint), label_id, xs, ys1, ys2, count, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImS8}, ys1::AbstractArray{ImS8}, ys2::AbstractArray{ImS8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS8PtrS8PtrS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Ref{ImS8}, Cint, Cint, Cint), label_id, xs, ys1, ys2, count, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImU8}, ys1::AbstractArray{ImU8}, ys2::AbstractArray{ImU8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU8PtrU8PtrU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Ref{ImU8}, Cint, Cint, Cint), label_id, xs, ys1, ys2, count, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImS16}, ys1::AbstractArray{ImS16}, ys2::AbstractArray{ImS16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS16PtrS16PtrS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Ref{ImS16}, Cint, Cint, Cint), label_id, xs, ys1, ys2, count, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImU16}, ys1::AbstractArray{ImU16}, ys2::AbstractArray{ImU16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU16PtrU16PtrU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Ref{ImU16}, Cint, Cint, Cint), label_id, xs, ys1, ys2, count, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImS32}, ys1::AbstractArray{ImS32}, ys2::AbstractArray{ImS32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS32PtrS32PtrS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Ref{ImS32}, Cint, Cint, Cint), label_id, xs, ys1, ys2, count, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImU32}, ys1::AbstractArray{ImU32}, ys2::AbstractArray{ImU32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU32PtrU32PtrU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Ref{ImU32}, Cint, Cint, Cint), label_id, xs, ys1, ys2, count, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImS64}, ys1::AbstractArray{ImS64}, ys2::AbstractArray{ImS64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedS64PtrS64PtrS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Ref{ImS64}, Cint, Cint, Cint), label_id, xs, ys1, ys2, count, offset, stride)
end

function PlotShaded(label_id, xs::AbstractArray{ImU64}, ys1::AbstractArray{ImU64}, ys2::AbstractArray{ImU64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotShadedU64PtrU64PtrU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Ref{ImU64}, Cint, Cint, Cint), label_id, xs, ys1, ys2, count, offset, stride)
end

function PlotBars(label_id, values::AbstractArray{Cfloat}, count::Integer, width::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsFloatPtrInt, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, width, shift, offset, stride)
end

function PlotBars(label_id, values::AbstractArray{Cdouble}, count::Integer, width::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsdoublePtrInt, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, width, shift, offset, stride)
end

function PlotBars(label_id, values::AbstractArray{ImS8}, count::Integer, width::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsS8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, width, shift, offset, stride)
end

function PlotBars(label_id, values::AbstractArray{ImU8}, count::Integer, width::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsU8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, width, shift, offset, stride)
end

function PlotBars(label_id, values::AbstractArray{ImS16}, count::Integer, width::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsS16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, width, shift, offset, stride)
end

function PlotBars(label_id, values::AbstractArray{ImU16}, count::Integer, width::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsU16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, width, shift, offset, stride)
end

function PlotBars(label_id, values::AbstractArray{ImS32}, count::Integer, width::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsS32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, width, shift, offset, stride)
end

function PlotBars(label_id, values::AbstractArray{ImU32}, count::Integer, width::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsU32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, width, shift, offset, stride)
end

function PlotBars(label_id, values::AbstractArray{ImS64}, count::Integer, width::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsS64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, width, shift, offset, stride)
end

function PlotBars(label_id, values::AbstractArray{ImU64}, count::Integer, width::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsU64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, width, shift, offset, stride)
end

function PlotBars(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, count::Integer, width::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsFloatPtrFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, width, offset, stride)
end

function PlotBars(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, count::Integer, width::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsdoublePtrdoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, width, offset, stride)
end

function PlotBars(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, count::Integer, width::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsS8PtrS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, width, offset, stride)
end

function PlotBars(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, count::Integer, width::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsU8PtrU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, width, offset, stride)
end

function PlotBars(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, count::Integer, width::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsS16PtrS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, width, offset, stride)
end

function PlotBars(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, count::Integer, width::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsU16PtrU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, width, offset, stride)
end

function PlotBars(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, count::Integer, width::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsS32PtrS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, width, offset, stride)
end

function PlotBars(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, count::Integer, width::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsU32PtrU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, width, offset, stride)
end

function PlotBars(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, count::Integer, width::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsS64PtrS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, width, offset, stride)
end

function PlotBars(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, count::Integer, width::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsU64PtrU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, width, offset, stride)
end

function PlotBarsH(label_id, values::AbstractArray{Cfloat}, count::Integer, height::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHFloatPtrInt, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, height, shift, offset, stride)
end

function PlotBarsH(label_id, values::AbstractArray{Cdouble}, count::Integer, height::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHdoublePtrInt, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, height, shift, offset, stride)
end

function PlotBarsH(label_id, values::AbstractArray{ImS8}, count::Integer, height::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHS8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, height, shift, offset, stride)
end

function PlotBarsH(label_id, values::AbstractArray{ImU8}, count::Integer, height::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHU8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, height, shift, offset, stride)
end

function PlotBarsH(label_id, values::AbstractArray{ImS16}, count::Integer, height::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHS16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, height, shift, offset, stride)
end

function PlotBarsH(label_id, values::AbstractArray{ImU16}, count::Integer, height::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHU16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, height, shift, offset, stride)
end

function PlotBarsH(label_id, values::AbstractArray{ImS32}, count::Integer, height::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHS32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, height, shift, offset, stride)
end

function PlotBarsH(label_id, values::AbstractArray{ImU32}, count::Integer, height::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHU32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, height, shift, offset, stride)
end

function PlotBarsH(label_id, values::AbstractArray{ImS64}, count::Integer, height::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHS64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, height, shift, offset, stride)
end

function PlotBarsH(label_id, values::AbstractArray{ImU64}, count::Integer, height::Real, shift::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHU64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Cint, Cdouble, Cdouble, Cint, Cint), label_id, values, count, height, shift, offset, stride)
end

function PlotBarsH(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, count::Integer, height::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHFloatPtrFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, height, offset, stride)
end

function PlotBarsH(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, count::Integer, height::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHdoublePtrdoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, height, offset, stride)
end

function PlotBarsH(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, count::Integer, height::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHS8PtrS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, height, offset, stride)
end

function PlotBarsH(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, count::Integer, height::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHU8PtrU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, height, offset, stride)
end

function PlotBarsH(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, count::Integer, height::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHS16PtrS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, height, offset, stride)
end

function PlotBarsH(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, count::Integer, height::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHU16PtrU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, height, offset, stride)
end

function PlotBarsH(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, count::Integer, height::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHS32PtrS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, height, offset, stride)
end

function PlotBarsH(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, count::Integer, height::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHU32PtrU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, height, offset, stride)
end

function PlotBarsH(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, count::Integer, height::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHS64PtrS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, height, offset, stride)
end

function PlotBarsH(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, count::Integer, height::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotBarsHU64PtrU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, height, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, err::AbstractArray{Cfloat}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsFloatPtrFloatPtrFloatPtrInt, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Ref{Cfloat}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, err::AbstractArray{Cdouble}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsdoublePtrdoublePtrdoublePtrInt, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, err::AbstractArray{ImS8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsS8PtrS8PtrS8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Ref{ImS8}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, err::AbstractArray{ImU8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsU8PtrU8PtrU8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Ref{ImU8}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, err::AbstractArray{ImS16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsS16PtrS16PtrS16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Ref{ImS16}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, err::AbstractArray{ImU16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsU16PtrU16PtrU16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Ref{ImU16}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, err::AbstractArray{ImS32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsS32PtrS32PtrS32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Ref{ImS32}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, err::AbstractArray{ImU32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsU32PtrU32PtrU32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Ref{ImU32}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, err::AbstractArray{ImS64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsS64PtrS64PtrS64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Ref{ImS64}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, err::AbstractArray{ImU64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsU64PtrU64PtrU64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Ref{ImU64}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, neg::AbstractArray{Cfloat}, pos::AbstractArray{Cfloat}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsFloatPtrFloatPtrFloatPtrFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Ref{Cfloat}, Ref{Cfloat}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, neg::AbstractArray{Cdouble}, pos::AbstractArray{Cdouble}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsdoublePtrdoublePtrdoublePtrdoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, neg::AbstractArray{ImS8}, pos::AbstractArray{ImS8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsS8PtrS8PtrS8PtrS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Ref{ImS8}, Ref{ImS8}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, neg::AbstractArray{ImU8}, pos::AbstractArray{ImU8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsU8PtrU8PtrU8PtrU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Ref{ImU8}, Ref{ImU8}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, neg::AbstractArray{ImS16}, pos::AbstractArray{ImS16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsS16PtrS16PtrS16PtrS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Ref{ImS16}, Ref{ImS16}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, neg::AbstractArray{ImU16}, pos::AbstractArray{ImU16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsU16PtrU16PtrU16PtrU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Ref{ImU16}, Ref{ImU16}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, neg::AbstractArray{ImS32}, pos::AbstractArray{ImS32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsS32PtrS32PtrS32PtrS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Ref{ImS32}, Ref{ImS32}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, neg::AbstractArray{ImU32}, pos::AbstractArray{ImU32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsU32PtrU32PtrU32PtrU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Ref{ImU32}, Ref{ImU32}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, neg::AbstractArray{ImS64}, pos::AbstractArray{ImS64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsS64PtrS64PtrS64PtrS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Ref{ImS64}, Ref{ImS64}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBars(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, neg::AbstractArray{ImU64}, pos::AbstractArray{ImU64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsU64PtrU64PtrU64PtrU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Ref{ImU64}, Ref{ImU64}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, err::AbstractArray{Cfloat}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHFloatPtrFloatPtrFloatPtrInt, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Ref{Cfloat}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, err::AbstractArray{Cdouble}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHdoublePtrdoublePtrdoublePtrInt, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, err::AbstractArray{ImS8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHS8PtrS8PtrS8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Ref{ImS8}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, err::AbstractArray{ImU8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHU8PtrU8PtrU8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Ref{ImU8}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, err::AbstractArray{ImS16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHS16PtrS16PtrS16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Ref{ImS16}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, err::AbstractArray{ImU16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHU16PtrU16PtrU16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Ref{ImU16}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, err::AbstractArray{ImS32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHS32PtrS32PtrS32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Ref{ImS32}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, err::AbstractArray{ImU32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHU32PtrU32PtrU32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Ref{ImU32}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, err::AbstractArray{ImS64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHS64PtrS64PtrS64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Ref{ImS64}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, err::AbstractArray{ImU64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHU64PtrU64PtrU64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Ref{ImU64}, Cint, Cint, Cint), label_id, xs, ys, err, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, neg::AbstractArray{Cfloat}, pos::AbstractArray{Cfloat}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHFloatPtrFloatPtrFloatPtrFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Ref{Cfloat}, Ref{Cfloat}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, neg::AbstractArray{Cdouble}, pos::AbstractArray{Cdouble}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHdoublePtrdoublePtrdoublePtrdoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, neg::AbstractArray{ImS8}, pos::AbstractArray{ImS8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHS8PtrS8PtrS8PtrS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Ref{ImS8}, Ref{ImS8}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, neg::AbstractArray{ImU8}, pos::AbstractArray{ImU8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHU8PtrU8PtrU8PtrU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Ref{ImU8}, Ref{ImU8}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, neg::AbstractArray{ImS16}, pos::AbstractArray{ImS16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHS16PtrS16PtrS16PtrS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Ref{ImS16}, Ref{ImS16}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, neg::AbstractArray{ImU16}, pos::AbstractArray{ImU16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHU16PtrU16PtrU16PtrU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Ref{ImU16}, Ref{ImU16}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, neg::AbstractArray{ImS32}, pos::AbstractArray{ImS32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHS32PtrS32PtrS32PtrS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Ref{ImS32}, Ref{ImS32}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, neg::AbstractArray{ImU32}, pos::AbstractArray{ImU32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHU32PtrU32PtrU32PtrU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Ref{ImU32}, Ref{ImU32}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, neg::AbstractArray{ImS64}, pos::AbstractArray{ImS64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHS64PtrS64PtrS64PtrS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Ref{ImS64}, Ref{ImS64}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotErrorBarsH(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, neg::AbstractArray{ImU64}, pos::AbstractArray{ImU64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotErrorBarsHU64PtrU64PtrU64PtrU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Ref{ImU64}, Ref{ImU64}, Cint, Cint, Cint), label_id, xs, ys, neg, pos, count, offset, stride)
end

function PlotStems(label_id, values::AbstractArray{Cfloat}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsFloatPtrInt, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotStems(label_id, values::AbstractArray{Cdouble}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsdoublePtrInt, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotStems(label_id, values::AbstractArray{ImS8}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsS8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotStems(label_id, values::AbstractArray{ImU8}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsU8PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotStems(label_id, values::AbstractArray{ImS16}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsS16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotStems(label_id, values::AbstractArray{ImU16}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsU16PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotStems(label_id, values::AbstractArray{ImS32}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsS32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotStems(label_id, values::AbstractArray{ImU32}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsU32PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotStems(label_id, values::AbstractArray{ImS64}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsS64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotStems(label_id, values::AbstractArray{ImU64}, count::Integer, y_ref::Real, xscale::Real, x0::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsU64PtrInt, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cint), label_id, values, count, y_ref, xscale, x0, offset, stride)
end

function PlotStems(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsFloatPtrFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotStems(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsdoublePtrdoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotStems(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsS8PtrS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotStems(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsU8PtrU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotStems(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsS16PtrS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotStems(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsU16PtrU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotStems(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsS32PtrS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotStems(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsU32PtrU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotStems(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsS64PtrS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotStems(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, count::Integer, y_ref::Real, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotStemsU64PtrU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Cint, Cdouble, Cint, Cint), label_id, xs, ys, count, y_ref, offset, stride)
end

function PlotPieChart(label_ids, values::AbstractArray{Cfloat}, count::Integer, x::Real, y::Real, radius::Real, normalize::Integer, label_fmt, angle0::Real)
    ccall((:ImPlot_PlotPieChartFloatPtr, libcimplot), Cvoid, (Ptr{Cstring}, Ref{Cfloat}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cstring, Cdouble), label_ids, values, count, x, y, radius, normalize, label_fmt, angle0)
end

function PlotPieChart(label_ids, values::AbstractArray{Cdouble}, count::Integer, x::Real, y::Real, radius::Real, normalize::Integer, label_fmt, angle0::Real)
    ccall((:ImPlot_PlotPieChartdoublePtr, libcimplot), Cvoid, (Ptr{Cstring}, Ref{Cdouble}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cstring, Cdouble), label_ids, values, count, x, y, radius, normalize, label_fmt, angle0)
end

function PlotPieChart(label_ids, values::AbstractArray{ImS8}, count::Integer, x::Real, y::Real, radius::Real, normalize::Integer, label_fmt, angle0::Real)
    ccall((:ImPlot_PlotPieChartS8Ptr, libcimplot), Cvoid, (Ptr{Cstring}, Ref{ImS8}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cstring, Cdouble), label_ids, values, count, x, y, radius, normalize, label_fmt, angle0)
end

function PlotPieChart(label_ids, values::AbstractArray{ImU8}, count::Integer, x::Real, y::Real, radius::Real, normalize::Integer, label_fmt, angle0::Real)
    ccall((:ImPlot_PlotPieChartU8Ptr, libcimplot), Cvoid, (Ptr{Cstring}, Ref{ImU8}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cstring, Cdouble), label_ids, values, count, x, y, radius, normalize, label_fmt, angle0)
end

function PlotPieChart(label_ids, values::AbstractArray{ImS16}, count::Integer, x::Real, y::Real, radius::Real, normalize::Integer, label_fmt, angle0::Real)
    ccall((:ImPlot_PlotPieChartS16Ptr, libcimplot), Cvoid, (Ptr{Cstring}, Ref{ImS16}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cstring, Cdouble), label_ids, values, count, x, y, radius, normalize, label_fmt, angle0)
end

function PlotPieChart(label_ids, values::AbstractArray{ImU16}, count::Integer, x::Real, y::Real, radius::Real, normalize::Integer, label_fmt, angle0::Real)
    ccall((:ImPlot_PlotPieChartU16Ptr, libcimplot), Cvoid, (Ptr{Cstring}, Ref{ImU16}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cstring, Cdouble), label_ids, values, count, x, y, radius, normalize, label_fmt, angle0)
end

function PlotPieChart(label_ids, values::AbstractArray{ImS32}, count::Integer, x::Real, y::Real, radius::Real, normalize::Integer, label_fmt, angle0::Real)
    ccall((:ImPlot_PlotPieChartS32Ptr, libcimplot), Cvoid, (Ptr{Cstring}, Ref{ImS32}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cstring, Cdouble), label_ids, values, count, x, y, radius, normalize, label_fmt, angle0)
end

function PlotPieChart(label_ids, values::AbstractArray{ImU32}, count::Integer, x::Real, y::Real, radius::Real, normalize::Integer, label_fmt, angle0::Real)
    ccall((:ImPlot_PlotPieChartU32Ptr, libcimplot), Cvoid, (Ptr{Cstring}, Ref{ImU32}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cstring, Cdouble), label_ids, values, count, x, y, radius, normalize, label_fmt, angle0)
end

function PlotPieChart(label_ids, values::AbstractArray{ImS64}, count::Integer, x::Real, y::Real, radius::Real, normalize::Integer, label_fmt, angle0::Real)
    ccall((:ImPlot_PlotPieChartS64Ptr, libcimplot), Cvoid, (Ptr{Cstring}, Ref{ImS64}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cstring, Cdouble), label_ids, values, count, x, y, radius, normalize, label_fmt, angle0)
end

function PlotPieChart(label_ids, values::AbstractArray{ImU64}, count::Integer, x::Real, y::Real, radius::Real, normalize::Integer, label_fmt, angle0::Real)
    ccall((:ImPlot_PlotPieChartU64Ptr, libcimplot), Cvoid, (Ptr{Cstring}, Ref{ImU64}, Cint, Cdouble, Cdouble, Cdouble, Cint, Cstring, Cdouble), label_ids, values, count, x, y, radius, normalize, label_fmt, angle0)
end

function PlotHeatmap(label_id, values::AbstractArray{Cfloat}, rows::Integer, cols::Integer, scale_min::Real, scale_max::Real, label_fmt, bounds_min, bounds_max)
    ccall((:ImPlot_PlotHeatmapFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Cint, Cint, Cdouble, Cdouble, Cstring, ImPlotPoint, ImPlotPoint), label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max)
end

function PlotHeatmap(label_id, values::AbstractArray{Cdouble}, rows::Integer, cols::Integer, scale_min::Real, scale_max::Real, label_fmt, bounds_min, bounds_max)
    ccall((:ImPlot_PlotHeatmapdoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Cint, Cint, Cdouble, Cdouble, Cstring, ImPlotPoint, ImPlotPoint), label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max)
end

function PlotHeatmap(label_id, values::AbstractArray{ImS8}, rows::Integer, cols::Integer, scale_min::Real, scale_max::Real, label_fmt, bounds_min, bounds_max)
    ccall((:ImPlot_PlotHeatmapS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Cint, Cint, Cdouble, Cdouble, Cstring, ImPlotPoint, ImPlotPoint), label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max)
end

function PlotHeatmap(label_id, values::AbstractArray{ImU8}, rows::Integer, cols::Integer, scale_min::Real, scale_max::Real, label_fmt, bounds_min, bounds_max)
    ccall((:ImPlot_PlotHeatmapU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Cint, Cint, Cdouble, Cdouble, Cstring, ImPlotPoint, ImPlotPoint), label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max)
end

function PlotHeatmap(label_id, values::AbstractArray{ImS16}, rows::Integer, cols::Integer, scale_min::Real, scale_max::Real, label_fmt, bounds_min, bounds_max)
    ccall((:ImPlot_PlotHeatmapS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Cint, Cint, Cdouble, Cdouble, Cstring, ImPlotPoint, ImPlotPoint), label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max)
end

function PlotHeatmap(label_id, values::AbstractArray{ImU16}, rows::Integer, cols::Integer, scale_min::Real, scale_max::Real, label_fmt, bounds_min, bounds_max)
    ccall((:ImPlot_PlotHeatmapU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Cint, Cint, Cdouble, Cdouble, Cstring, ImPlotPoint, ImPlotPoint), label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max)
end

function PlotHeatmap(label_id, values::AbstractArray{ImS32}, rows::Integer, cols::Integer, scale_min::Real, scale_max::Real, label_fmt, bounds_min, bounds_max)
    ccall((:ImPlot_PlotHeatmapS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Cint, Cint, Cdouble, Cdouble, Cstring, ImPlotPoint, ImPlotPoint), label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max)
end

function PlotHeatmap(label_id, values::AbstractArray{ImU32}, rows::Integer, cols::Integer, scale_min::Real, scale_max::Real, label_fmt, bounds_min, bounds_max)
    ccall((:ImPlot_PlotHeatmapU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Cint, Cint, Cdouble, Cdouble, Cstring, ImPlotPoint, ImPlotPoint), label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max)
end

function PlotHeatmap(label_id, values::AbstractArray{ImS64}, rows::Integer, cols::Integer, scale_min::Real, scale_max::Real, label_fmt, bounds_min, bounds_max)
    ccall((:ImPlot_PlotHeatmapS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Cint, Cint, Cdouble, Cdouble, Cstring, ImPlotPoint, ImPlotPoint), label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max)
end

function PlotHeatmap(label_id, values::AbstractArray{ImU64}, rows::Integer, cols::Integer, scale_min::Real, scale_max::Real, label_fmt, bounds_min, bounds_max)
    ccall((:ImPlot_PlotHeatmapU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Cint, Cint, Cdouble, Cdouble, Cstring, ImPlotPoint, ImPlotPoint), label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max)
end

function PlotDigital(label_id, xs::AbstractArray{Cfloat}, ys::AbstractArray{Cfloat}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotDigitalFloatPtr, libcimplot), Cvoid, (Cstring, Ref{Cfloat}, Ref{Cfloat}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotDigital(label_id, xs::AbstractArray{Cdouble}, ys::AbstractArray{Cdouble}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotDigitaldoublePtr, libcimplot), Cvoid, (Cstring, Ref{Cdouble}, Ref{Cdouble}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotDigital(label_id, xs::AbstractArray{ImS8}, ys::AbstractArray{ImS8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotDigitalS8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS8}, Ref{ImS8}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotDigital(label_id, xs::AbstractArray{ImU8}, ys::AbstractArray{ImU8}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotDigitalU8Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU8}, Ref{ImU8}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotDigital(label_id, xs::AbstractArray{ImS16}, ys::AbstractArray{ImS16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotDigitalS16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS16}, Ref{ImS16}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotDigital(label_id, xs::AbstractArray{ImU16}, ys::AbstractArray{ImU16}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotDigitalU16Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU16}, Ref{ImU16}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotDigital(label_id, xs::AbstractArray{ImS32}, ys::AbstractArray{ImS32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotDigitalS32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS32}, Ref{ImS32}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotDigital(label_id, xs::AbstractArray{ImU32}, ys::AbstractArray{ImU32}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotDigitalU32Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU32}, Ref{ImU32}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotDigital(label_id, xs::AbstractArray{ImS64}, ys::AbstractArray{ImS64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotDigitalS64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImS64}, Ref{ImS64}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotDigital(label_id, xs::AbstractArray{ImU64}, ys::AbstractArray{ImU64}, count::Integer, offset::Integer, stride::Integer)
    ccall((:ImPlot_PlotDigitalU64Ptr, libcimplot), Cvoid, (Cstring, Ref{ImU64}, Ref{ImU64}, Cint, Cint, Cint), label_id, xs, ys, count, offset, stride)
end

function PlotImage(label_id, user_texture_id, bounds_min, bounds_max, uv0, uv1, tint_col)
    ccall((:ImPlot_PlotImage, libcimplot), Cvoid, (Cstring, ImTextureID, ImPlotPoint, ImPlotPoint, ImVec2, ImVec2, ImVec4), label_id, user_texture_id, bounds_min, bounds_max, uv0, uv1, tint_col)
end

function PlotText(text, x::Real, y::Real, vertical::Integer, pix_offset)
    ccall((:ImPlot_PlotText, libcimplot), Cvoid, (Cstring, Cdouble, Cdouble, Cint, ImVec2), text, x, y, vertical, pix_offset)
end

function PlotDummy(label_id)
    ccall((:ImPlot_PlotDummy, libcimplot), Cvoid, (Cstring,), label_id)
end

function SetNextPlotLimits(xmin, xmax, ymin, ymax, cond)
    ccall((:ImPlot_SetNextPlotLimits, libcimplot), Cvoid, (Cdouble, Cdouble, Cdouble, Cdouble, ImGuiCond), xmin, xmax, ymin, ymax, cond)
end

function SetNextPlotLimitsX(xmin, xmax, cond)
    ccall((:ImPlot_SetNextPlotLimitsX, libcimplot), Cvoid, (Cdouble, Cdouble, ImGuiCond), xmin, xmax, cond)
end

function SetNextPlotLimitsY(ymin, ymax, cond, y_axis)
    ccall((:ImPlot_SetNextPlotLimitsY, libcimplot), Cvoid, (Cdouble, Cdouble, ImGuiCond, ImPlotYAxis), ymin, ymax, cond, y_axis)
end

function LinkNextPlotLimits(xmin, xmax, ymin, ymax, ymin2, ymax2, ymin3, ymax3)
    ccall((:ImPlot_LinkNextPlotLimits, libcimplot), Cvoid, (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), xmin, xmax, ymin, ymax, ymin2, ymax2, ymin3, ymax3)
end

function FitNextPlotAxes(x, y, y2, y3)
    ccall((:ImPlot_FitNextPlotAxes, libcimplot), Cvoid, (Cint, Cint, Cint, Cint), x, y, y2, y3)
end

function SetNextPlotTicksXdoublePtr(values, n_ticks, labels, show_default)
    ccall((:ImPlot_SetNextPlotTicksXdoublePtr, libcimplot), Cvoid, (Ptr{Cdouble}, Cint, Ptr{Cstring}, Cint), values, n_ticks, labels, show_default)
end

function SetNextPlotTicksXdouble(x_min, x_max, n_ticks, labels, show_default)
    ccall((:ImPlot_SetNextPlotTicksXdouble, libcimplot), Cvoid, (Cdouble, Cdouble, Cint, Ptr{Cstring}, Cint), x_min, x_max, n_ticks, labels, show_default)
end

function SetNextPlotTicksYdoublePtr(values, n_ticks, labels, show_default, y_axis)
    ccall((:ImPlot_SetNextPlotTicksYdoublePtr, libcimplot), Cvoid, (Ptr{Cdouble}, Cint, Ptr{Cstring}, Cint, ImPlotYAxis), values, n_ticks, labels, show_default, y_axis)
end

function SetNextPlotTicksYdouble(y_min, y_max, n_ticks, labels, show_default, y_axis)
    ccall((:ImPlot_SetNextPlotTicksYdouble, libcimplot), Cvoid, (Cdouble, Cdouble, Cint, Ptr{Cstring}, Cint, ImPlotYAxis), y_min, y_max, n_ticks, labels, show_default, y_axis)
end

function SetPlotYAxis(y_axis)
    ccall((:ImPlot_SetPlotYAxis, libcimplot), Cvoid, (ImPlotYAxis,), y_axis)
end

function HideNextItem(hidden, cond)
    ccall((:ImPlot_HideNextItem, libcimplot), Cvoid, (Cint, ImGuiCond), hidden, cond)
end

function PixelsToPlotVec2(pOut, pix, y_axis)
    ccall((:ImPlot_PixelsToPlotVec2, libcimplot), Cvoid, (Ptr{ImPlotPoint}, ImVec2, ImPlotYAxis), pOut, pix, y_axis)
end

function PixelsToPlotFloat(pOut, x, y, y_axis)
    ccall((:ImPlot_PixelsToPlotFloat, libcimplot), Cvoid, (Ptr{ImPlotPoint}, Cfloat, Cfloat, ImPlotYAxis), pOut, x, y, y_axis)
end

function PlotToPixelsPlotPoInt(pOut, plt, y_axis)
    ccall((:ImPlot_PlotToPixelsPlotPoInt, libcimplot), Cvoid, (Ptr{ImVec2}, ImPlotPoint, ImPlotYAxis), pOut, plt, y_axis)
end

function PlotToPixelsdouble(pOut, x::Real, y::Real, y_axis)
    ccall((:ImPlot_PlotToPixelsdouble, libcimplot), Cvoid, (Ptr{ImVec2}, Cdouble, Cdouble, ImPlotYAxis), pOut, x, y, y_axis)
end

function GetPlotPos(pOut)
    ccall((:ImPlot_GetPlotPos, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function GetPlotSize(pOut)
    ccall((:ImPlot_GetPlotSize, libcimplot), Cvoid, (Ptr{ImVec2},), pOut)
end

function IsPlotHovered()
    ccall((:ImPlot_IsPlotHovered, libcimplot), Cint, ())
end

function IsPlotXAxisHovered()
    ccall((:ImPlot_IsPlotXAxisHovered, libcimplot), Cint, ())
end

function IsPlotYAxisHovered()
    ccall((:ImPlot_IsPlotYAxisHovered, libcimplot), Cint, ())
end

function GetPlotMousePos(pOut, y_axis)
    ccall((:ImPlot_GetPlotMousePos, libcimplot), Cvoid, (Ptr{ImPlotPoint}, ImPlotYAxis), pOut, y_axis)
end

function GetPlotLimits(pOut, y_axis)
    ccall((:ImPlot_GetPlotLimits, libcimplot), Cvoid, (Ptr{ImPlotLimits}, ImPlotYAxis), pOut, y_axis)
end

function IsPlotQueried()
    ccall((:ImPlot_IsPlotQueried, libcimplot), Cint, ())
end

function GetPlotQuery(pOut, y_axis)
    ccall((:ImPlot_GetPlotQuery, libcimplot), Cvoid, (Ptr{ImPlotLimits}, ImPlotYAxis), pOut, y_axis)
end

function AnnotateVStr(x, y, pix_offset, fmt, args)
    ccall((:ImPlot_AnnotateVStr, libcimplot), Cvoid, (Cdouble, Cdouble, ImVec2, Cstring, Cint), x, y, pix_offset, fmt, args)
end

function AnnotateVVec4(x, y, pix_offset, color, fmt, args)
    ccall((:ImPlot_AnnotateVVec4, libcimplot), Cvoid, (Cdouble, Cdouble, ImVec2, ImVec4, Cstring, Cint), x, y, pix_offset, color, fmt, args)
end

function AnnotateClampedVStr(x, y, pix_offset, fmt, args)
    ccall((:ImPlot_AnnotateClampedVStr, libcimplot), Cvoid, (Cdouble, Cdouble, ImVec2, Cstring, Cint), x, y, pix_offset, fmt, args)
end

function AnnotateClampedVVec4(x, y, pix_offset, color, fmt, args)
    ccall((:ImPlot_AnnotateClampedVVec4, libcimplot), Cvoid, (Cdouble, Cdouble, ImVec2, ImVec4, Cstring, Cint), x, y, pix_offset, color, fmt, args)
end

function DragLineX()
    ccall((:ImPlot_DragLineX, libcimplot), Cint, ())
end

function DragLineY()
    ccall((:ImPlot_DragLineY, libcimplot), Cint, ())
end

function DragPoint()
    ccall((:ImPlot_DragPoint, libcimplot), Cint, ())
end

function SetLegendLocation(location, orientation, outside)
    ccall((:ImPlot_SetLegendLocation, libcimplot), Cvoid, (ImPlotLocation, ImPlotOrientation, Cint), location, orientation, outside)
end

function SetMousePosLocation(location)
    ccall((:ImPlot_SetMousePosLocation, libcimplot), Cvoid, (ImPlotLocation,), location)
end

function IsLegendEntryHovered()
    ccall((:ImPlot_IsLegendEntryHovered, libcimplot), Cint, ())
end

function BeginLegendDragDropSource()
    ccall((:ImPlot_BeginLegendDragDropSource, libcimplot), Cint, ())
end

function EndLegendDragDropSource()
    ccall((:ImPlot_EndLegendDragDropSource, libcimplot), Cvoid, ())
end

function BeginLegendPopup()
    ccall((:ImPlot_BeginLegendPopup, libcimplot), Cint, ())
end

function EndLegendPopup()
    ccall((:ImPlot_EndLegendPopup, libcimplot), Cvoid, ())
end

function GetStyle()
    ccall((:ImPlot_GetStyle, libcimplot), Ptr{ImPlotStyle}, ())
end

function StyleColorsAuto(dst)
    ccall((:ImPlot_StyleColorsAuto, libcimplot), Cvoid, (Ptr{ImPlotStyle},), dst)
end

function StyleColorsClassic(dst)
    ccall((:ImPlot_StyleColorsClassic, libcimplot), Cvoid, (Ptr{ImPlotStyle},), dst)
end

function StyleColorsDark(dst)
    ccall((:ImPlot_StyleColorsDark, libcimplot), Cvoid, (Ptr{ImPlotStyle},), dst)
end

function StyleColorsLight(dst)
    ccall((:ImPlot_StyleColorsLight, libcimplot), Cvoid, (Ptr{ImPlotStyle},), dst)
end

function PushStyleColorU32(idx, col)
    ccall((:ImPlot_PushStyleColorU32, libcimplot), Cvoid, (ImPlotCol, ImU32), idx, col)
end

function PushStyleColorVec4(idx, col)
    ccall((:ImPlot_PushStyleColorVec4, libcimplot), Cvoid, (ImPlotCol, ImVec4), idx, col)
end

function PopStyleColor(count)
    ccall((:ImPlot_PopStyleColor, libcimplot), Cvoid, (Cint,), count)
end

function PushStyleVarFloat(idx, val)
    ccall((:ImPlot_PushStyleVarFloat, libcimplot), Cvoid, (ImPlotStyleVar, Cfloat), idx, val)
end

function PushStyleVarInt(idx, val)
    ccall((:ImPlot_PushStyleVarInt, libcimplot), Cvoid, (ImPlotStyleVar, Cint), idx, val)
end

function PushStyleVarVec2(idx, val)
    ccall((:ImPlot_PushStyleVarVec2, libcimplot), Cvoid, (ImPlotStyleVar, ImVec2), idx, val)
end

function PopStyleVar(count)
    ccall((:ImPlot_PopStyleVar, libcimplot), Cvoid, (Cint,), count)
end

function SetNextLineStyle(col, weight)
    ccall((:ImPlot_SetNextLineStyle, libcimplot), Cvoid, (ImVec4, Cfloat), col, weight)
end

function SetNextFillStyle(col, alpha_mod)
    ccall((:ImPlot_SetNextFillStyle, libcimplot), Cvoid, (ImVec4, Cfloat), col, alpha_mod)
end

function SetNextMarkerStyle(marker, size, fill, weight, outline)
    ccall((:ImPlot_SetNextMarkerStyle, libcimplot), Cvoid, (ImPlotMarker, Cfloat, ImVec4, Cfloat, ImVec4), marker, size, fill, weight, outline)
end

function SetNextErrorBarStyle(col, size, weight)
    ccall((:ImPlot_SetNextErrorBarStyle, libcimplot), Cvoid, (ImVec4, Cfloat, Cfloat), col, size, weight)
end

function GetLastItemColor(pOut)
    ccall((:ImPlot_GetLastItemColor, libcimplot), Cvoid, (Ptr{ImVec4},), pOut)
end

function GetStyleColorName(idx)
    ccall((:ImPlot_GetStyleColorName, libcimplot), Cstring, (ImPlotCol,), idx)
end

function GetMarkerName(idx)
    ccall((:ImPlot_GetMarkerName, libcimplot), Cstring, (ImPlotMarker,), idx)
end

function PushColormapPlotColormap(colormap)
    ccall((:ImPlot_PushColormapPlotColormap, libcimplot), Cvoid, (ImPlotColormap,), colormap)
end

function PushColormapVec4Ptr(colormap, size)
    ccall((:ImPlot_PushColormapVec4Ptr, libcimplot), Cvoid, (Ptr{ImVec4}, Cint), colormap, size)
end

function PopColormap(count)
    ccall((:ImPlot_PopColormap, libcimplot), Cvoid, (Cint,), count)
end

function SetColormapVec4Ptr(colormap, size)
    ccall((:ImPlot_SetColormapVec4Ptr, libcimplot), Cvoid, (Ptr{ImVec4}, Cint), colormap, size)
end

function SetColormapPlotColormap(colormap, samples)
    ccall((:ImPlot_SetColormapPlotColormap, libcimplot), Cvoid, (ImPlotColormap, Cint), colormap, samples)
end

function GetColormapSize()
    ccall((:ImPlot_GetColormapSize, libcimplot), Cint, ())
end

function GetColormapColor(pOut, index)
    ccall((:ImPlot_GetColormapColor, libcimplot), Cvoid, (Ptr{ImVec4}, Cint), pOut, index)
end

function LerpColormap(pOut, t)
    ccall((:ImPlot_LerpColormap, libcimplot), Cvoid, (Ptr{ImVec4}, Cfloat), pOut, t)
end

function NextColormapColor(pOut)
    ccall((:ImPlot_NextColormapColor, libcimplot), Cvoid, (Ptr{ImVec4},), pOut)
end

function ShowColormapScale(scale_min, scale_max, height)
    ccall((:ImPlot_ShowColormapScale, libcimplot), Cvoid, (Cdouble, Cdouble, Cfloat), scale_min, scale_max, height)
end

function GetColormapName(colormap)
    ccall((:ImPlot_GetColormapName, libcimplot), Cstring, (ImPlotColormap,), colormap)
end

function GetInputMap()
    ccall((:ImPlot_GetInputMap, libcimplot), Ptr{ImPlotInputMap}, ())
end

function GetPlotDrawList()
    ccall((:ImPlot_GetPlotDrawList, libcimplot), Ptr{ImDrawList}, ())
end

function PushPlotClipRect()
    ccall((:ImPlot_PushPlotClipRect, libcimplot), Cvoid, ())
end

function PopPlotClipRect()
    ccall((:ImPlot_PopPlotClipRect, libcimplot), Cvoid, ())
end

function ShowStyleSelector()
    ccall((:ImPlot_ShowStyleSelector, libcimplot), Cint, ())
end

function ShowColormapSelector()
    ccall((:ImPlot_ShowColormapSelector, libcimplot), Cint, ())
end

function ShowStyleEditor(ref)
    ccall((:ImPlot_ShowStyleEditor, libcimplot), Cvoid, (Ptr{ImPlotStyle},), ref)
end

function ShowUserGuide()
    ccall((:ImPlot_ShowUserGuide, libcimplot), Cvoid, ())
end

function ShowMetricsWindow(p_popen)
    ccall((:ImPlot_ShowMetricsWindow, libcimplot), Cvoid, (Ptr{Cint},), p_popen)
end

function SetImGuiContext(ctx)
    ccall((:ImPlot_SetImGuiContext, libcimplot), Cvoid, (Ptr{ImGuiContext},), ctx)
end

function ShowDemoWindow(p_open)
    ccall((:ImPlot_ShowDemoWindow, libcimplot), Cvoid, (Ptr{Cint},), p_open)
end

function PlotLineG(label_id, getter, data, count::Integer, offset::Integer)
    ccall((:ImPlot_PlotLineG, libcimplot), Cvoid, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Cint, Cint), label_id, getter, data, count, offset)
end

function PlotScatterG(label_id, getter, data, count::Integer, offset::Integer)
    ccall((:ImPlot_PlotScatterG, libcimplot), Cvoid, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Cint, Cint), label_id, getter, data, count, offset)
end

function PlotShadedG(label_id, getter1, data1, getter2, data2, count::Integer, offset::Integer)
    ccall((:ImPlot_PlotShadedG, libcimplot), Cvoid, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Cint, Cint), label_id, getter1, data1, getter2, data2, count, offset)
end

function PlotBarsG(label_id, getter, data, count::Integer, width::Real, offset::Integer)
    ccall((:ImPlot_PlotBarsG, libcimplot), Cvoid, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Cint, Cdouble, Cint), label_id, getter, data, count, width, offset)
end

function PlotBarsH(label_id, getter, data, count::Integer, height::Real, offset::Integer)
    ccall((:ImPlot_PlotBarsHG, libcimplot), Cvoid, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Cint, Cdouble, Cint), label_id, getter, data, count, height, offset)
end

function PlotDigitalG(label_id, getter, data, count::Integer, offset::Integer)
    ccall((:ImPlot_PlotDigitalG, libcimplot), Cvoid, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}, Cint, Cint), label_id, getter, data, count, offset)
end

# Skipping MacroDefinition: API __attribute__ ( ( __visibility__ ( "default" ) ) )

# Skipping MacroDefinition: EXTERN extern

const CIMGUI_API = EXTERN(API)

const CONST = $(Expr(:incomplete, "incomplete: premature end of input"))

export ImPlotPoint, ImPlotRange, ImPlotLimits, ImPlotStyle, ImPlotInputMap, ImPlotContext
export CreateContext, DestroyContext, GetCurrentContext, SetCurrentContext, SetImGuiContext
export EndPlot
export SetNextPlotLimits, SetNextPlotLimitsX, SetNextPlotLimitsY, LinkNextPlotLimits, FitNextPlotAxes
export SetPlotYAxis, HideNextItem, IsPlotHovered, IsPlotXAxisHovered, IsPlotYAxisHoevered, IsPlotQueried
export DragLineX, DragLineY, DragPoint
export SetLegendLocation, SetMousePosLocation, IsLegendEntryHovered
export BeginLegendDragDropSource, EndLegendDragDropSource, BeginLegendPopup, EndLegendPopup
export PopStyleColor, PopStyleVar
export SetNextLineStyle, SetNextFillStyle, SetNextMarkerStyle, SetNextErrorBarStyle
export GetStyleColorName, GetMarkerName, PopColormap, GetColormapSize, ShowColormapScale
export GetColormapName, PushPlotClipRect, PopPlotClipRect
export ShowStyleSelector, ShowColormapSelector, ShowUserGuide, ShowDemoWindow

# exports
const PREFIXES = ["ImPlotFlags_", "ImPlotAxisFlags_", "ImPlotCol_", "ImPlotStyleVar_", "ImPlotMarker_", "ImPlotColormap_", "ImPlotLocation_", "ImPlotOrientation_", "ImPlotYAxis_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
