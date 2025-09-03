#include "RNOH/PackageProvider.h"
#include "generated/RNOHGeneratedPackage.h"
#include "FastImagePackage.h"
#include "GestureHandlerPackage.h"
#include "ReanimatedPackage.h"
#include "SafeAreaViewPackage.h"
#include "SVGPackage.h"
#include "ViewPagerPackage.h"

using namespace rnoh;

std::vector<std::shared_ptr<Package>> PackageProvider::getPackages(Package::Context ctx) {
    return {
        std::make_shared<RNOHGeneratedPackage>(ctx),
        std::make_shared<FastImagePackage>(ctx),
        std::make_shared<GestureHandlerPackage>(ctx),
        std::make_shared<ReanimatedPackage>(ctx),
        std::make_shared<SafeAreaViewPackage>(ctx),
        std::make_shared<SVGPackage>(ctx),
        std::make_shared<ViewPagerPackage>(ctx)
    };
}
