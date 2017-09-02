// ======================================================================
// \name Value.cpp 
// \author AUTO-GENERATED: DO NOT EDIT
// \brief Implementation file for Example::Value
// ======================================================================

#include "Example.hpp"

namespace Namespace {

  namespace {

    //! The identity function for Value.cpp
    int identity(
      int x //!< The int argument
    ) {
      return x;
    }

  }

  int Example::Value ::
    getIntValue(void) const
  {
    return identity(this->intValue);
  }

  void Example::Value ::
    setIntvalue(int intValue)
  {
    this->intValue = intValue;
  }

}
