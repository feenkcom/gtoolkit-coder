Trait {
	#name : #TGtWithFilterModel,
	#instVars : [
		'filterModel'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'api - filter model' }
TGtWithFilterModel >> filterModel [
	self
		assert: [ filterModel isNotNil ]
		description: [ 'Filter model must be defined' ].
	^ filterModel
]

{ #category : #'api - filter model' }
TGtWithFilterModel >> filterModel: aFilterModel [
	filterModel = aFilterModel ifTrue: [ ^ self ].

	filterModel ifNotNil: [ self unsubscribeFromFilterModel ].
	filterModel := aFilterModel.
	self onFilterModelChanged.
	self subscribeToFilterModel
]

{ #category : #'api - filter model' }
TGtWithFilterModel >> hasFilterModel [
	^ filterModel isNotNil
]

{ #category : #'api - filter model' }
TGtWithFilterModel >> onFilterModelChanged [
]

{ #category : #'api - filter model' }
TGtWithFilterModel >> subscribeToFilterModel [
]

{ #category : #'api - filter model' }
TGtWithFilterModel >> unsubscribeFromFilterModel [
]
