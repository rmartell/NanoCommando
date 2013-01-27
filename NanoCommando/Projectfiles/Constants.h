

typedef enum {
    kBackgroundZ,
    kGameZ,
    kGameObjectsZ,
    kBatchNodeZ,
    kTurretZ,
    kEffectsZ,
    kBulletZ,
    kPowerUpZ,
    kLightZ,
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

// this is correct for the ship; all art should have had same rotation.
#define REAL_THETA_TO_COCOS_DEGREES(x) ((360-RADIANS_TO_DEGREES(x)) - 90)
#define SGN(x) (((x)==0)?0:((x)<0)?-1:1)

#define ARRAY_SIZE(x) ((int)(sizeof(x)/sizeof(x[0])))

// standard c; defined in Turret.m for now.
float cc_radians_between_points(CGPoint center, CGPoint target);
float distance_between_points(CGPoint center, CGPoint target);