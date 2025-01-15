Trait {
	#name : #TGtWithFilterModelParameters,
	#instVars : [
		'parameters'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #parameters }
TGtWithFilterModelParameters >> addParameter: aFilterModelParameter [
	self parameters add: aFilterModelParameter.
	self subscribeToParameter: aFilterModelParameter.
]

{ #category : #converting }
TGtWithFilterModelParameters >> asSearchFilter [
	| aFilter |
	aFilter := super asSearchFilter.
	self parameters do: [ :eachParameter |
		eachParameter onCreateFilter: aFilter ].
	^ aFilter
]

{ #category : #'event handling' }
TGtWithFilterModelParameters >> onParameterModelAnnouncement: anAnnouncement [
	anAnnouncement changesFilteredResult ifFalse: [ ^ self ].
	
	self announce: (GtFilterModelParameterUpdated new
		model: self;
		originalAnnouncement: anAnnouncement)
]

{ #category : #parameters }
TGtWithFilterModelParameters >> parameter: aFilterModelParameter [
	self parameters add: aFilterModelParameter.
	self subscribeToParameter: aFilterModelParameter.
]

{ #category : #parameters }
TGtWithFilterModelParameters >> parameterAt: anIndex do: aBlock [
	| aParameter |
	aParameter := self parameters at: anIndex ifAbsent: [ nil ].
	aParameter ifNotNil: aBlock
]

{ #category : #accessing }
TGtWithFilterModelParameters >> parameters [
	<return: #Collection of: #GtFilterModelParameter>
	^ parameters ifNil: [ parameters := OrderedCollection new: 1 ]
]

{ #category : #accessing }
TGtWithFilterModelParameters >> parameters: aCollection [
	parameters := aCollection.
	aCollection do: [ :eachParameter | 
		self subscribeToParameter: eachParameter ]
]

{ #category : #'private - subscriptions' }
TGtWithFilterModelParameters >> subscribeToParameter: aFilterModelParameter [ 
	aFilterModelParameter weak
		when: GtFilterModelAnnouncement
		send: #onParameterModelAnnouncement:
		to: self
]
