Trait {
	#name : #TGtWithFilterViewModel,
	#instVars : [
		'filterViewModel'
	],
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #'api - filter view model' }
TGtWithFilterViewModel >> filterViewModel [
	self
		assert: [ filterViewModel isNotNil ]
		description: [ 'Filter view model must be defined' ].
	^ filterViewModel
]

{ #category : #'api - filter view model' }
TGtWithFilterViewModel >> filterViewModel: aFilterModel [
	filterViewModel = aFilterModel ifTrue: [ ^ self ].

	filterViewModel ifNotNil: [ self unsubscribeFromFilterViewModel ].
	filterViewModel := aFilterModel.
	self onFilterViewModelChanged.
	self subscribeToFilterViewModel
]

{ #category : #'api - filter view model' }
TGtWithFilterViewModel >> filterViewModelDo: aBlock [
	self hasFilterViewModel ifTrue: [ 
		aBlock cull: self filterViewModel ]
]

{ #category : #'api - filter view model' }
TGtWithFilterViewModel >> hasFilterViewModel [
	^ filterViewModel isNotNil
]

{ #category : #'api - filter view model' }
TGtWithFilterViewModel >> onFilterViewModelChanged [
]

{ #category : #'api - filter view model' }
TGtWithFilterViewModel >> subscribeToFilterViewModel [
]

{ #category : #'api - filter view model' }
TGtWithFilterViewModel >> unsubscribeFromFilterViewModel [
]
