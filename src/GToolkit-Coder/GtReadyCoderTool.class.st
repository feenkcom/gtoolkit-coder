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
GtReadyCoderTool >> asElementDo: aOneArgBlock [
	"Create a tool element and execute the block."

	aOneArgBlock cull: self coder asMainCoder asPagerPageElement
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
