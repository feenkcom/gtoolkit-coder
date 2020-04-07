Trait {
	#name : #TGtBehaviorCoderDummyTrait,
	#instVars : [
		'slotA',
		'slotB',
		'slotC'
	],
	#category : #'GToolkit-Coder-Examples-Dummies'
}

{ #category : #'command line' }
TGtBehaviorCoderDummyTrait >> hello [
	^ Hello
]

{ #category : #'command line' }
TGtBehaviorCoderDummyTrait >> hello: anObject [
	Hello := anObject
]
