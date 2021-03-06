-------------------------------------------------------------------------------
-- @file GSession.lua
--
-- @ author xzben 2014/05/16
--
-- 本文见存放整个游戏的控制逻辑
-------------------------------------------------------------------------------

Session = Session or class("Session", VBase)
local scheduler = cc.Director:getInstance():getScheduler()
local director = cc.Director:getInstance()
--------------------- scene tags ------------------------------
local TAG_SCENE = 1


--------------------- scene zorders ---------------------------
local ZORDER_SCENE = 1


---------------------------------------------------
function Session.create()
	return Session.extend(cc.Scene:create())	
end

function Session:ctor()
    self._needRemoveUnusedCached = false
    self._nowRemoveUnusedCached = false
	self._curRunningScene = nil

	self._network = Network.create()
	self:init()
end

function Session:initFileUtils()
    
end

function Session:initDirector()
    -- initialize director
    local glview = director:getOpenGLView()
    
    local mySize = cc.size(960, 640)
    if nil == glview then
        glview = cc.GLViewImpl:createWithRect("GameClient", cc.rect(0, 0, mySize.width, mySize.height))
        director:setOpenGLView(glview)
    end

    local screenSize = cc.Director:getInstance():getWinSize()
    local resolutionSize = {};
    
    --保证适配各种尺寸的屏幕的时候总是能够保证至少有我们的设计尺寸的大小
    if screenSize.width/screenSize.height > mySize.width/mySize.height then
        resolutionSize.height = mySize.height
        resolutionSize.width = resolutionSize.height * screenSize.width / screenSize.height
    else
        resolutionSize.width = mySize.width
        resolutionSize.height = resolutionSize.width * screenSize.height / screenSize.width
    end
    cclog(string.format(" screen size [ %f | %f ] resolutionSize [ %f | %f ]", screenSize.width, screenSize.height, resolutionSize.width, resolutionSize.height))
    glview:setDesignResolutionSize(resolutionSize.width, resolutionSize.height, cc.ResolutionPolicy.SHOW_ALL)

    --turn on display FPS
    director:setDisplayStats(true)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)
end

function Session:replaceScene( newScene )
	if self._curRunningScene then
		self._curRunningScene:removeFromParent()
		self._curRunningScene = nil
	end

	self._curRunningScene = newScene
	self:addChild(newScene, ZORDER_SCENE, TAG_SCENE)

	self:setNeedToRemoveUnusedCached(true)
end

function Session:runWithScene( newScene )
	self:replaceScene(newScene)
end

function Session:init()
	self:initFileUtils();
	self:initDirector();

    local function update(dt)
        self:update(dt)
    end
    scheduler:scheduleScriptFunc(update, 0, false)
end

function Session:exitGame()
    cc.Director:getInstance():endToLua()
end

function Session:lauchScene()
	if director:getRunningScene() then
        director:replaceScene(self)
    else
        director:runWithScene(self)
    end
    
    ProtoRegister.registe_all();
    local scene = LauchScene.create()
    if scene then
    	self:replaceScene( scene )
    end
end

function Session:setNeedToRemoveUnusedCached( isNeedRemove )
    self._needRemoveUnusedCached = isNeedRemove
end

function Session:update(dt)
    --延迟一针移除 cached 资源使场景切换的时候更加快速
    if self._nowRemoveUnusedCached then
        self._nowRemoveUnusedCached = false

        director:purgeCachedData()
    end

    if self._needRemoveUnusedCached then
        self._nowRemoveUnusedCached = true
        self._needRemoveUnusedCached = false
    end
end

GSession = GSession or Session.create()

