Class {
	#name : #GtReadyCoderTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-UI-Tools'
}

{ #category : #accessing }
GtReadyCoderTool class >> coder: aCoder [
	^ self new coder: aCoder
]

{ #category : #converting }
GtReadyCoderTool >> asElementDo: aOneArgBlock [
	"Create a tool element and execute the block."

	^ aOneArgBlock cull: (GtCoder forCoder: self coder) asPagerPageElement
]

{ #category : #accessing }
GtReadyCoderTool >> assertCoder: aCoder [
	self
		assert: [ aCoder isNotNil ]
		description: [ 'Coder must be non-nil' ].
	self 
		assert: [ (aCoder isKindOf: BlElement) not ] 
		description: [ 'Coder cannot be an element because it may be added to a space graph several times' ]
]

{ #category : #accessing }
GtReadyCoderTool >> coder [
	^ coder
]

{ #category : #accessing }
GtReadyCoderTool >> coder: aCoder [
	self assertCoder: aCoder.
	coder := aCoder
]

{ #category : #'api - converting' }
GtReadyCoderTool >> icon [ 
	^ BrGlamorousVectorIcons browse
]

{ #category : #'api - accessing' }
GtReadyCoderTool >> name [
	^ 'coder'
]

{ #category : #'private - accessing' }
GtReadyCoderTool >> tabLook [
	^ BrGlamorousTabSwitcherWithIconLook
]
