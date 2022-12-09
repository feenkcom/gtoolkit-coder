Class {
	#name : #GtCoderTool,
	#superclass : #GtPhlowTool,
	#category : #'GToolkit-Coder-UI-Tools'
}

{ #category : #converting }
GtCoderTool >> asElementDo: aOneArgBlock [
	"Create a tool element and execute the block."

	| anElement |
	anElement := (GtPhlowCoderView new coder: self newCoder) asElement.
	anElement phlow beView.
	^ aOneArgBlock cull: anElement asPagerPageElement
]

{ #category : #'api - converting' }
GtCoderTool >> icon [
	^ BrGlamorousVectorIcons browse
]

{ #category : #'api - accessing' }
GtCoderTool >> name [
	^ 'coder'
]

{ #category : #converting }
GtCoderTool >> newCoder [
	^ self subclassResponsibility
]

{ #category : #'private - accessing' }
GtCoderTool >> tabLook [
	^ BrGlamorousTabSwitcherWithIconAptitude
]
