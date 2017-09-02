// ======================================================================
// \name Example.hpp 
// \author AUTO-GENERATED: DO NOT EDIT
// \brief Example class interface
// ======================================================================

#ifndef Namespace_Example_HPP
#define Namespace_Example_HPP

namespace Namespace {

  int sampleFunction(void);
  
  class Example {

      // ----------------------------------------------------------------------
      // Types 
      // ----------------------------------------------------------------------

    public:

      //! The type of a value
      class Value {

        public:

          //! Get the int value
          int getIntValue(void) const;

          //! Set the int value
          void setIntvalue(
              int intValue //!< The int value
          );

        private:

          //! The int value
          int intValue;

      };

      // ----------------------------------------------------------------------
      // Public member functions 
      // ----------------------------------------------------------------------

    public:

      //! Get the value
      Example::Value getValue(void) const;

      //! Set the value
      void setValue(
          const Value& value
      );

      // ----------------------------------------------------------------------
      // Private member variables 
      // ----------------------------------------------------------------------

    private:

      //! The value
      Value value;

  };

}

#endif
