# Print variables by python

import gdb
class PyPrintCommand (gdb.Command):
  "A command for printing variables via python"

  def __init__ (self):
    super(PyPrintCommand, self).__init__ ("pyp",
                                          gdb.COMMAND_SUPPORT,
                                          gdb.COMPLETE_NONE, True)

  def invoke(self, arg, from_tty):
    args = arg.split(' ')
    argp = 0
    do_compact = False
    while args[argp][0]=='-':
      S_ = args[argp]
      argp+=1
      if S_=='-help':
        print "pyp - Print gdb variables via python"
        print ""
        print "Syntax:"
        print "  pyp [-c] v1 v2"
        print ""
        print "Options:"
        print "  -c  Compact output"
        return
      if S_=='-c':
        do_compact = True
        continue
      print "Unknown option '%s'!"%S_
      return

    for v in args[argp:]:
      try:
        if do_compact:
          print gdb.selected_frame().read_var(v),
        else:
          print "%s=%s"%(v,gdb.selected_frame().read_var(v))
      except ValueError:
        print "%s not found!"%v
    if do_compact:
      print ""

PyPrintCommand()