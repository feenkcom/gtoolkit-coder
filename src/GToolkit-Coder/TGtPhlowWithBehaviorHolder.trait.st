Trait {
	#name : #TGtPhlowWithBehaviorHolder,
	#instVars : [
		'behaviorHolder'
	],
	#category : #'GToolkit-Phlow-Object Holder'
}

{ #category : #'api - object' }
TGtPhlowWithBehaviorHolder >> behavior [
	"Return an assigned object.
	Favor using #ifBehavior:ifNone: to distinguish between defined 
	behaviors and UndeclaredVariable."

	^ self behaviorHolder ifDefined: [ :anObject | anObject ] ifNone: [ UndeclaredVariable ]
]

{ #category : #'api - object' }
TGtPhlowWithBehaviorHolder >> behavior: aBehavior [
	"Assign a behavior"

	self
		assert: [ (aBehavior = nil) not ]
		description: [ 'Behavior must be non-nil' ].
	
	self behaviorHolder: (GtPhlowObject forValue: aBehavior)
]

{ #category : #'api - object' }
TGtPhlowWithBehaviorHolder >> behaviorHolder [
	<return: #TGtPhlowObject>
	^ behaviorHolder ifNil: [ 
		behaviorHolder := GtPhlowUndefinedObject default ]
]

{ #category : #'api - object' }
TGtPhlowWithBehaviorHolder >> behaviorHolder: aTGtCoderObject [
	self
		assert: [ aTGtCoderObject isNotNil ]
		description: [ 'behavior holder must not be nil.' ].
	
	self behaviorHolder = aTGtCoderObject ifTrue: [ ^ self ].
	
	behaviorHolder := aTGtCoderObject.
	self onBehaviorHolderChanged
]

{ #category : #'api - object' }
TGtPhlowWithBehaviorHolder >> behaviorIfNone: noneBlock [
	^ self ifBehavior: [ :anObject | anObject ] ifNone: noneBlock
]

{ #category : #'api - object' }
TGtPhlowWithBehaviorHolder >> hasBehavior [
	^ self ifBehavior: [ :aBehavior | true ] ifNone: [ false ]
]

{ #category : #'api - object' }
TGtPhlowWithBehaviorHolder >> ifBehavior: definedBlock ifNone: noneBlock [
	^ self behaviorHolder ifDefined: definedBlock ifNone: noneBlock
]

{ #category : #'api - object' }
TGtPhlowWithBehaviorHolder >> onBehaviorHolderChanged [
	"Trait users can perform other actions using this hook."

	
]
