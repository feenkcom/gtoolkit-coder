Trait {
	#name : #TGtCoderWithSelfObjectHolder,
	#instVars : [
		'selfObjectHolder'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #'api - self object' }
TGtCoderWithSelfObjectHolder >> hasSelfObject [
	^ self ifSelfObject: [ :anObject | true ] ifNone: [ false ]
]

{ #category : #'api - self object' }
TGtCoderWithSelfObjectHolder >> ifSelfObject: definedBlock ifNone: noneBlock [
	^ self selfObjectHolder ifDefined: definedBlock ifNone: noneBlock
]

{ #category : #'api - self object' }
TGtCoderWithSelfObjectHolder >> onSelfObjectHolderChanged [
	"Trait users can perform other actions using this hook."

	
]

{ #category : #'api - self object' }
TGtCoderWithSelfObjectHolder >> selfObject [
	"Return an object that should be bound to `self` during code evaluation.
	Favor using #ifSelfObject:ifNone: to distinguish between defined 
	self-objects and nil values."

	^ self selfObjectHolder ifDefined: [ :anObject | anObject ] ifNone: [ nil ]
]

{ #category : #'api - self object' }
TGtCoderWithSelfObjectHolder >> selfObject: anObject [
	"Assign an object that should be bound to `self` during code evaluation"
	
	self selfObjectHolder: (GtPhlowObject forValue: anObject)
]

{ #category : #'api - self object' }
TGtCoderWithSelfObjectHolder >> selfObjectHolder [
	<return: #TGtPhlowObject>
	^ selfObjectHolder ifNil: [ 
		selfObjectHolder := GtPhlowUndefinedObject default ]
]

{ #category : #'api - self object' }
TGtCoderWithSelfObjectHolder >> selfObjectHolder: aTGtCoderObject [
	self
		assert: [ aTGtCoderObject isNotNil ]
		description: [ 'selfObject holder must not be nil.' ].
	
	self selfObjectHolder = aTGtCoderObject ifTrue: [ ^ self ].
	
	selfObjectHolder := aTGtCoderObject.
	self onSelfObjectHolderChanged
]

{ #category : #'api - self object' }
TGtCoderWithSelfObjectHolder >> selfObjectIfNone: noneBlock [
	^ self ifSelfObject: #yourself ifNone: noneBlock
]
