// ======================================================================
// \name Example.cpp
// \author AUTO-GENERATED: DO NOT EDIT
// \brief Example class implementation
// ======================================================================

#include "Example.hpp"

namespace Namespace {

  // ----------------------------------------------------------------------
  // Public helper functions
  // ----------------------------------------------------------------------

  int sampleFunction(void) {
    return 0;
  }

  // ----------------------------------------------------------------------
  // Private helper functions
  // ----------------------------------------------------------------------

  namespace {

    //! The identity function
    Example::Value identity(
      Example::Value v //!< The Value argument
    ) {
      return v;
    }

  }

  // ----------------------------------------------------------------------
  // Public member functions
  // ----------------------------------------------------------------------

  Example::Value Example ::
    getValue(void) const
  {
    return identity(this->value);
  }

  void Example ::
    setValue(const Value& value)
  {
    this->value = value;
  }

}
