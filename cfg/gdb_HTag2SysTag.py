import gdb
import types
from collections import deque


class HTag2SysTag(gdb.Function):
	"""Convert 	"""
	tag_dict = None
	def __init__ (self):
		super (HTag2SysTag, self).__init__ ("HTag2SysTag")
	def update(self):
		self.tag_dict = dict()
		d = dict()
# build htag -> systag[] map
		for i in range(1216+1):
			htag = gdb.parse_and_eval("gHdpContext.systagTable[%d].hosttag" % i)
			htag = int(htag)
			if htag == 0:
				continue
			if False == d.has_key(htag):
				#d[htag] = list()
				d[htag]=deque()
			d[htag].append(i)
		self.tag_dict = d

	def invoke (self, name, flag=False):
		htag = int(name)
		if flag == 1 or self.tag_dict == None or len(self.tag_dict) == 0:
			self.update()
			if flag == 1:
#				print "key length ", len(self.tag_dict.keys())
#				for h in self.tag_dict.keys():
#					print "%4d -> %d" % (h, len(self.tag_dict[h]))
				return -1;
		if self.tag_dict != None:
			#if self.tag_dict.has_key(htag):
			if htag in self.tag_dict.keys():
				if len(self.tag_dict[htag]):
					return self.tag_dict[htag].popleft()
				else:
					return -1;
			else:
				print "no key for %d" % htag
		return -1
HTag2SysTag()
