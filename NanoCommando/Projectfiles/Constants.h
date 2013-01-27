

typedef enum {
    kBackgroundZ,
    kGameZ,
    kGameObjectsZ,
    kBatchNodeZ,
    kTurretZ,
    kEffectsZ,
    kHudZ
} metaZOrders;

typedef enum {
    kHeartZ,
    kCancerZ,
    kPlayerShipZ,
} batchOrders;

#define MAP_WIDTH (4096)
#define MAP_HEIGHT (3072)

#define PI 3.14159265
#define DEGREES_TO_RADIANS(x) ((x)*PI/180.0)
#define RADIANS_TO_DEGREES(x) (((x)*180.0)/PI)

