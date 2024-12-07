Trait {
	#name : #TGtCoderWithBehaviorHolder,
	#instVars : [
		'behaviorHolder'
	],
	#category : #'GToolkit-Coder-Object Holder'
}

{ #category : #'api - object' }
TGtCoderWithBehaviorHolder >> behavior [
	"Return an assigned object.
	Favor using #ifBehavior:ifNone: to distinguish between defined 
	behaviors and UndeclaredVariable."

	^ self behaviorHolder ifDefined: [ :anObject | anObject ] ifNone: [ UndeclaredVariable ]
]

{ #category : #'api - object' }
TGtCoderWithBehaviorHolder >> behavior: aBehavior [
	"Assign a behavior"

	self
		assert: [ (aBehavior = nil) not ]
		description: [ 'Behavior must be non-nil' ].
	
	self behaviorHolder: (GtCoderObject forValue: aBehavior)
]

{ #category : #'api - object' }
TGtCoderWithBehaviorHolder >> behaviorHolder [
	<return: #TGtCoderObject>
	^ behaviorHolder ifNil: [ 
		behaviorHolder := GtCoderUndefinedObject default ]
]

{ #category : #'api - object' }
TGtCoderWithBehaviorHolder >> behaviorHolder: aTGtCoderObject [
	self
		assert: [ aTGtCoderObject isNotNil ]
		description: [ 'behavior holder must not be nil.' ].
	
	self behaviorHolder = aTGtCoderObject ifTrue: [ ^ self ].
	
	behaviorHolder := aTGtCoderObject.
	self onBehaviorHolderChanged
]

{ #category : #'api - object' }
TGtCoderWithBehaviorHolder >> behaviorIfNone: noneBlock [
	^ self ifBehavior: #yourself ifNone: noneBlock
]

{ #category : #'api - object' }
TGtCoderWithBehaviorHolder >> hasBehavior [
	^ self ifBehavior: [ :aBehavior | true ] ifNone: [ false ]
]

{ #category : #'api - object' }
TGtCoderWithBehaviorHolder >> ifBehavior: definedBlock ifNone: noneBlock [
	^ self behaviorHolder ifDefined: definedBlock ifNone: noneBlock
]

{ #category : #'api - object' }
TGtCoderWithBehaviorHolder >> onBehaviorHolderChanged [
	"Trait users can perform other actions using this hook."

	
]
