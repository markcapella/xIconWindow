
/**
 * Minimally create and display an x11 window
 * with an Icon from a locally defined PNG file.
 */

// Std C and c++.
#include <iostream>
#include <string>
#include <string.h>
#include <vector>

using namespace std;

// X11.
#include <X11/extensions/Xrender.h>
#include <X11/Xatom.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

// Application.
#include "xIconWindow.h"
#include "xPngWrapper.h"


/**
 * Module Consts.
 */
const string WINDOW_TITLE =
    "xIconWindow";

const XRectangle WINDOW_RECT = {
    .x = 500, .y = 500,
    .width = 700, .height = 200
};


/**
 * Module globals.
 */
Display* mDisplay;
Window mIconWindow;
xPngWrapper* mIconWrapper;


/**
 * Module Entry.
 */
int main(int argCount, char** argValues) {
    // Check for input file.
    if (argCount < 2) {
        cout << COLOR_RED << endl << "xIconWindow: " <<
            "Please specify an input PNG on the " <<
            "command line." << COLOR_NORMAL << endl;
        return true;
    }
    char* INPUT_PNGFILE = argValues[1];

    // char* INPUT_PNGFILE =
    //     strdup(INPUT_PNGFILE.c_str());
    mIconWrapper = new xPngWrapper(INPUT_PNGFILE);
    if (mIconWrapper->hasErrorStatus()) {
        cout << COLOR_RED << endl << "xIconWindow: " <<
            mIconWrapper->errorStatus() <<
            COLOR_NORMAL << endl;
        return true;
    }


    // Open X11 display, ensure it's available.
    mDisplay = XOpenDisplay(NULL);
    if (mDisplay == NULL) {
        cout << COLOR_RED << "xIconWindow: X11 Windows are "
            "unavailable with this desktop. - FATAL" <<
            COLOR_NORMAL << endl;
        return true;
    }

    // Create empty X11 window.
    mIconWindow = XCreateSimpleWindow(mDisplay,
        DefaultRootWindow(mDisplay), 0, 0,
        WINDOW_RECT.width, WINDOW_RECT.height, 1,
        BlackPixel(mDisplay, 0), WhitePixel(mDisplay, 0));

    // Set title string.
    XTextProperty properties;
    properties.value = (unsigned char*) WINDOW_TITLE.c_str();
    properties.encoding = XA_STRING;
    properties.format = 8;
    properties.nitems = WINDOW_TITLE.length();
    XSetWMName(mDisplay, mIconWindow, &properties);

    // Set icon name strings.
    XClassHint* classHint = XAllocClassHint();
    if (classHint) {
        classHint->res_class = INPUT_PNGFILE;
        classHint->res_name = INPUT_PNGFILE;
        XSetClassHint(mDisplay, mIconWindow, classHint);
        XFree(classHint);
    }
    XTextProperty iconProperty;
    XStringListToTextProperty(&INPUT_PNGFILE, 1, &iconProperty);
    XSetWMIconName(mDisplay, mIconWindow, &iconProperty);

    // Set the _NET_WM_ICON property from the vector.
    const Atom net_wm_icon = XInternAtom(mDisplay,
        "_NET_WM_ICON", False);
    XChangeProperty(mDisplay, mIconWindow, net_wm_icon,
        XA_CARDINAL, 32, PropModeReplace,
        reinterpret_cast<unsigned char*>
            (mIconWrapper->getPngData().data()),
             mIconWrapper->getPngData().size());

    // Map (show) window.
    XMapWindow(mDisplay, mIconWindow);
    XMoveWindow(mDisplay, mIconWindow,
        WINDOW_RECT.x, WINDOW_RECT.y);

    // Select observable x11 events & client messages.
    XSelectInput(mDisplay, mIconWindow, ExposureMask);
    Atom mDeleteMessage = XInternAtom(mDisplay,
        "WM_DELETE_WINDOW", False);
    XSetWMProtocols(mDisplay, mIconWindow,
        &mDeleteMessage, 1);

    // Loop until close event frees us.
    bool msgboxActive = true;
    while (msgboxActive) {
        XEvent event;
        XNextEvent(mDisplay, &event);
        if (event.type == ClientMessage) {
            if (event.xclient.data.l[0] ==
                mDeleteMessage) {
                msgboxActive = false;
            }
            break;
        }
    }

    // Close display & done.
    XUnmapWindow(mDisplay, mIconWindow);
    XDestroyWindow(mDisplay, mIconWindow);
    XCloseDisplay(mDisplay);
}

/**
 * Helper method to debug PngWrapper.
 */
void debugPngFile(xPngWrapper* pngWrapper) {
    cout << endl << COLOR_BLUE << "xIconWindow: " <<
        "size: ( " << pngWrapper->getWidth() <<
        " x " << pngWrapper->getHeight() <<
        " )." << COLOR_NORMAL << endl;

    cout << COLOR_BLUE << "xIconWindow: " <<
        "color type: ( " <<
        pngWrapper->getColorType() <<
        " )." << COLOR_NORMAL << endl;

    cout << COLOR_BLUE << "xIconWindow: " <<
        "color depth/bits: ( " <<
        pngWrapper->getBitDepth() <<
        " )." << COLOR_NORMAL << endl;
}
