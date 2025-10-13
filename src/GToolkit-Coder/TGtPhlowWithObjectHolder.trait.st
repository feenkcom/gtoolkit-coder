Trait {
	#name : #TGtPhlowWithObjectHolder,
	#instVars : [
		'objectHolder'
	],
	#category : #'GToolkit-Phlow-Object Holder'
}

{ #category : #'api - object' }
TGtPhlowWithObjectHolder >> hasObject [
	^ self ifObject: [ :anObject | true ] ifNone: [ false ]
]

{ #category : #'api - object' }
TGtPhlowWithObjectHolder >> ifObject: definedBlock ifNone: noneBlock [
	^ self objectHolder ifDefined: definedBlock ifNone: noneBlock
]

{ #category : #'api - object' }
TGtPhlowWithObjectHolder >> object [
	"Return an assigned object.
	Favor using #ifObject:ifNone: to distinguish between defined 
	objects and nil values."

	^ self objectHolder ifDefined: [ :anObject | anObject ] ifNone: [ nil ]
]

{ #category : #'api - object' }
TGtPhlowWithObjectHolder >> object: anObject [
	self objectHolder: (GtPhlowObject forValue: anObject)
]

{ #category : #'api - object' }
TGtPhlowWithObjectHolder >> objectHolder [
	<return: #TGtPhlowObject>
	^ objectHolder ifNil: [ 
		objectHolder := GtPhlowUndefinedObject default ]
]

{ #category : #'api - object' }
TGtPhlowWithObjectHolder >> objectHolder: aTGtCoderObject [
	self
		assert: [ aTGtCoderObject isNotNil ]
		description: [ 'object holder must not be nil.' ].
	
	self objectHolder = aTGtCoderObject ifTrue: [ ^ self ].
	
	objectHolder := aTGtCoderObject.
	self onObjectHolderChanged
]

{ #category : #'api - object' }
TGtPhlowWithObjectHolder >> objectIfNone: noneBlock [
	^ self ifObject: [ :anObject | anObject ] ifNone: noneBlock
]

{ #category : #'api - object' }
TGtPhlowWithObjectHolder >> onObjectHolderChanged [
	"Trait users can perform other actions using this hook."

	
]
