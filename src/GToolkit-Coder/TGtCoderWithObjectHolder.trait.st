Trait {
	#name : #TGtCoderWithObjectHolder,
	#instVars : [
		'objectHolder'
	],
	#category : #'GToolkit-Coder-Object Holder'
}

{ #category : #'api - object' }
TGtCoderWithObjectHolder >> hasObject [
	^ self ifObject: [ :anObject | true ] ifNone: [ false ]
]

{ #category : #'api - object' }
TGtCoderWithObjectHolder >> ifObject: definedBlock ifNone: noneBlock [
	^ self objectHolder ifDefined: definedBlock ifNone: noneBlock
]

{ #category : #'api - object' }
TGtCoderWithObjectHolder >> object [
	"Return an assigned object.
	Favor using #ifObject:ifNone: to distinguish between defined 
	objects and nil values."

	^ self objectHolder ifDefined: [ :anObject | anObject ] ifNone: [ nil ]
]

{ #category : #'api - object' }
TGtCoderWithObjectHolder >> object: anObject [
	self objectHolder: (GtCoderObject forValue: anObject)
]

{ #category : #'api - object' }
TGtCoderWithObjectHolder >> objectHolder [
	<return: #TGtCoderObject>
	^ objectHolder ifNil: [ 
		objectHolder := GtCoderUndefinedObject default ]
]

{ #category : #'api - object' }
TGtCoderWithObjectHolder >> objectHolder: aTGtCoderObject [
	self
		assert: [ aTGtCoderObject isNotNil ]
		description: [ 'object holder must not be nil.' ].
	
	self objectHolder = aTGtCoderObject ifTrue: [ ^ self ].
	
	objectHolder := aTGtCoderObject.
	self onObjectHolderChanged
]

{ #category : #'api - object' }
TGtCoderWithObjectHolder >> objectIfNone: noneBlock [
	^ self ifObject: #yourself ifNone: noneBlock
]

{ #category : #'api - object' }
TGtCoderWithObjectHolder >> onObjectHolderChanged [
	"Trait users can perform other actions using this hook."

	
]
