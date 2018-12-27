//
//  RAMacro.h
//  RouteAction
//
//  Created by GuangYu on 2018/2/24.
//

#ifndef RAMacro_h
#define RAMacro_h

#define ra_exeBlock(block, ...)\
if (block) {\
    block(__VA_ARGS__);\
}

#ifdef DEBUG
#define RALog(...) NSLog(__VA_ARGS__)
#define RADEBUG(...) __VA_ARGS__
#else
#define RALog(...)
#define RADEBUG(...)
#endif

#endif /* RAMacro_h */
