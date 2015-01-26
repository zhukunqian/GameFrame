#include "main.h"
#include "AppDelegate.h"
#include "cocos2d.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)  
#include "vld.h"  
#endif 

USING_NS_CC;

// uncomment below line, open debug console
#define USE_WIN32_CONSOLE

int APIENTRY _tWinMain(HINSTANCE hInstance,
                       HINSTANCE hPrevInstance,
                       LPTSTR    lpCmdLine,
                       int       nCmdShow)
{
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

#ifdef USE_WIN32_CONSOLE
    AllocConsole();
    freopen("CONIN$", "r", stdin);
    freopen("CONOUT$", "w", stdout);
    freopen("CONOUT$", "w", stderr);
#endif

    // create the application instance
    AppDelegate app;
    int ret = Application::getInstance()->run();

#ifdef USE_WIN32_CONSOLE
    if (!ret)
    {
        system("pause");
    }
    FreeConsole();
#endif

    return ret;
}
