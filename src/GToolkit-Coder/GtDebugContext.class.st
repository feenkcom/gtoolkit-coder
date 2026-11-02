Class {
	#name : #GtDebugContext,
	#superclass : #DebugContext,
	#category : #'GToolkit-Coder'
}

{ #category : #private }
GtDebugContext >> blockNotFoundDialog: aMethod with: aText [
	aMethod selector isDoIt
		ifTrue: [ "shouldn't edit doits" ^ self ].
	self recompileCurrentMethodTo: aText notifying: nil
]

{ #category : #private }
GtDebugContext >> checkSelectorUnchanged: aSelector [
	^ aSelector == self selectedMessageName
		or: [ self selectedMessageName isDoIt
				and: [ aSelector numArgs = self selectedMessageName numArgs ] ]
]

{ #category : #private }
GtDebugContext >> confirmOnTraitOverwrite: aSelector inClass: aClass [
	| method |
	method := aClass methodNamed: aSelector.
	^ method origin
]

{ #category : #accessing }
GtDebugContext >> locateClosureHomeWithContent: aText [
	context isBlockContext
		ifTrue: [ ^ context activeHome
				ifNil: [ self blockNotFoundDialog: context method with: aText.
					nil ] ].
	^ context
]

{ #category : #'evaluating actions' }
GtDebugContext >> recompileCurrentMethodTo: aText notifying: aNotifyer [
	"Compile the method through a recorded change, as the method coder does,
	so that saving in the debugger can be undone and keeps the undo history.
	Answer the new method, to which the debugger restarts the context"

	| aSelector aBehavior |
	self context method isDoIt
		ifTrue: [ ^ super recompileCurrentMethodTo: aText notifying: aNotifyer ].

	aSelector := self selectedClass compiler parseSelector: aText.
	(self checkSelectorUnchanged: aSelector) ifFalse: [ ^ nil ].

	aBehavior := (self selectedClass includesSelector: aSelector)
			ifTrue: [ self confirmOnTraitOverwrite: aSelector inClass: self selectedClass ]
			ifFalse: [ self selectedClass ].
	aBehavior ifNil: [ ^ nil ].

	GtRefactoryChangeManager instance
		performChange: (RBAddMethodChange
				compile: aText asString
				in: aBehavior
				classified: self selectedMessageCategoryName).
	^ aBehavior >> aSelector
]
