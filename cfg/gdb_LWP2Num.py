import gdb
import re
import types

DEBUG=False

def debug(message):
	if DEBUG:
		print message

class LWP2Num(gdb.Function):
	"""Convert LWP of a thread to Number defined in GDB
	LWP2Num( lwp_value, update=False)
	If update is True, update an internal dict storing current threads information. If not and the previous dict is valid, use previous dict, otherwise update the dict.
	"""
	thread_dict = None
	def __init__ (self):
		super (LWP2Num, self).__init__ ("LWP2Num")
	def update(self):
		self.thread_dict = dict()
		d = dict()
		for inf in gdb.inferiors():
			for th in inf.threads():
				d[ th.ptid[1] ] = th.num
				debug( "%d -- %d" % ( th.ptid[1],th.num))
				debug("type %s"% type(th.ptid[1]))
		debug( "dic len: %d" %  len(d))
		self.thread_dict = d
	def invoke (self, name, flag=False):
		val = int(name)
		if flag == 1 or self.thread_dict == None or len(self.thread_dict) == 0:
			self.update()
		if self.thread_dict != None:
			if self.thread_dict.has_key(val):
				return self.thread_dict[val]
			else:
				print "no key for %d" % val
		return -1
LWP2Num()
