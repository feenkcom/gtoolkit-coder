Class {
	#name : #GtDebugContext,
	#superclass : #DebugContext,
	#category : 'GToolkit-Coder'
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
