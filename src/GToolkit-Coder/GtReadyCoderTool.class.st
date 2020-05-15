Class {
	#name : #GtReadyCoderTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Adaptors'
}

{ #category : #accessing }
GtReadyCoderTool class >> coder: aCoder [
	^ self new coder: aCoder
]

{ #category : #converting }
GtReadyCoderTool >> asElementDo: aOneArgBlock context: aContext [
	"Create a tool element and execute the block.
	A context can be passed to build the tool element."

	| anElement |
	anElement := GtPagerWrapperElement new
		tool: self coder;
		asElement.
	aOneArgBlock cull: anElement
]

{ #category : #accessing }
GtReadyCoderTool >> coder [
	^ coder
]

{ #category : #accessing }
GtReadyCoderTool >> coder: aCoder [
	self 
		assert: [ aCoder isNotNil ] 
		description: [ 'Coder must be non-nil' ].
	coder := aCoder
]
