Class {
	#name : #GtCoderTool,
	#superclass : #GtPhlowTool,
	#category : #'GToolkit-Coder-Adaptors'
}

{ #category : #converting }
GtCoderTool >> asElementDo: aOneArgBlock [
	"Create a tool element and execute the block."

	^ aOneArgBlock cull: self newCoder asPagerPageElement
]

{ #category : #'api - converting' }
GtCoderTool >> asTabDo: aBlock [
	| aTab |
	aTab := BrTab new
		look: BrGlamorousTabSwitcherWithIconLook;
		label: self name;
		icon: BrGlamorousVectorIcons browse;
		stencil: [ self asElementDo: [ :anElement | anElement ] ].
	aBlock cull: aTab.
]

{ #category : #'api - accessing' }
GtCoderTool >> name [
	^ 'coder'
]

{ #category : #converting }
GtCoderTool >> newCoder [
	^ self subclassResponsibility
]
