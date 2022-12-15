Class {
	#name : #GtCoderTool,
	#superclass : #GtPhlowTool,
	#category : #'GToolkit-Coder-UI-Tools'
}

{ #category : #converting }
GtCoderTool >> asElementDo: aOneArgBlock [
	"Create a tool element and execute the block."

	^ aOneArgBlock cull: self newCoder asPagerPageElement
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
