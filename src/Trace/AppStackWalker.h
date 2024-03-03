#pragma once

#include "StackWalker.h"

class AppStackWalker : public StackWalker
{
public:
  AppStackWalker() {}

  void OnOutput( LPCSTR szText ) override;
};