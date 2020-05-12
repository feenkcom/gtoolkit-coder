Class {
	#name : #GtCoderTool,
	#superclass : #GtPhlowTool,
	#category : #'GToolkit-Coder-Adaptors'
}

{ #category : #converting }
GtCoderTool >> asElementDo: aOneArgBlock context: aContext [
	"Create a tool element and execute the block.
	A context can be passed to build the tool element."
	| anElement |
	anElement := GtPagerWrapperElement new
		tool: (GtClassCoder forClass: aContext object);
		model: aContext object;
		asElement.
	aOneArgBlock cull: anElement.
]
