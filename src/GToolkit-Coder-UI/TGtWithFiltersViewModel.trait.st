Trait {
	#name : #TGtWithFiltersViewModel,
	#instVars : [
		'filtersViewModel'
	],
	#category : 'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #'api - filter view model' }
TGtWithFiltersViewModel >> filtersViewModel [
	self
		assert: [ filtersViewModel isNotNil ]
		description: [ 'Filters view model must be defined' ].
	^ filtersViewModel
]

{ #category : #'api - filter view model' }
TGtWithFiltersViewModel >> filtersViewModel: aFiltersModel [
	filtersViewModel = aFiltersModel ifTrue: [ ^ self ].

	filtersViewModel ifNotNil: [ self unsubscribeFromFiltersViewModel ].
	filtersViewModel := aFiltersModel.
	self onFiltersViewModelChanged.
	self subscribeToFiltersViewModel
]

{ #category : #'api - filter view model' }
TGtWithFiltersViewModel >> filtersViewModelDo: aBlock [
	self hasFiltersViewModel ifTrue: [ 
		aBlock cull: self filtersViewModel ]
]

{ #category : #'api - filter view model' }
TGtWithFiltersViewModel >> hasFiltersViewModel [
	^ filtersViewModel isNotNil
]

{ #category : #'api - filter view model' }
TGtWithFiltersViewModel >> onFiltersViewModelChanged [
]

{ #category : #'api - filter view model' }
TGtWithFiltersViewModel >> subscribeToFiltersViewModel [
]

{ #category : #'api - filter view model' }
TGtWithFiltersViewModel >> unsubscribeFromFiltersViewModel [
]
